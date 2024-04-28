terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }

  backend "gcs" {
    bucket = "tf-state-prod"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "trello2notion"
}

# Bucket that will include the functions files
resource "google_storage_bucket" "source-bucket" {
  name     = "gcf-source-bucket"
  location = "US"
  uniform_bucket_level_access = true
}

# Function file for the biz function
resource "google_storage_bucket_object" "trello2notion-function-file" {
  name   = "trello2notion-function.zip"
  bucket = google_storage_bucket.source-bucket.name
  source = "trello2notion-function.zip"  # Add path to the zipped function source code
}

# Function file for the biz function
resource "google_storage_bucket_object" "rate-limiter-function-file" {
  name   = "rate-limiter-function.zip"
  bucket = google_storage_bucket.source-bucket.name
  source = "rate-limiter-function.zip"  # Add path to the zipped function source code
}

# Target bucket where file upload triggers the cloud event to be
# processed by the cloud event function
resource "google_storage_bucket" "trigger-bucket" {
  name     = "gcf-trigger-bucket"
  location = "us-central1" # The trigger must be in the same location as the bucket
  uniform_bucket_level_access = true
}

# Get the email address of a project's unique 'automatic Google Cloud Storage service account'.
data "google_storage_project_service_account" "gcs_account" {
}

# To use GCS CloudEvent triggers, the GCS service account requires the Pub/Sub Publisher(roles/pubsub.publisher) IAM role in the specified project.
# (See https://cloud.google.com/eventarc/docs/run/quickstart-storage#before-you-begin)
resource "google_project_iam_member" "gcs-pubsub-publishing" {
  project = "trello2notion"
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

resource "google_service_account" "account" {
  account_id   = "gcf-sa"
  display_name = "Test Service Account - used for both the cloud function and eventarc trigger in the test"
}

# Permissions on the service account used by the function and Eventarc trigger
resource "google_project_iam_member" "invoking" {
  project = "trello2notion"
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.account.email}"
  depends_on = [google_project_iam_member.gcs-pubsub-publishing]
}

resource "google_project_iam_member" "event-receiving" {
  project = "trello2notion"
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.account.email}"
  depends_on = [google_project_iam_member.invoking]
}

resource "google_project_iam_member" "artifactregistry-reader" {
  project = "trello2notion"
  role     = "roles/artifactregistry.reader"
  member   = "serviceAccount:${google_service_account.account.email}"
  depends_on = [google_project_iam_member.event-receiving]
}

resource "google_storage_bucket_iam_member" "object-creation" {
  bucket = google_storage_bucket.trigger-bucket.name
  role    = "roles/storage.objects.create"
  member   = "serviceAccount:${google_service_account.account.email}"
}

resource "google_cloudfunctions2_function" "trello2notion-function" {
  depends_on = [
    google_project_iam_member.event-receiving,
    google_project_iam_member.artifactregistry-reader,
  ]
  name = "trello2notion-function"
  location = "us-central1"
  description = "Performs the conversion from Trello JSON export files"

  build_config {
    runtime     = "ruby"
    entry_point = "trello2notion" # Set the entry point in the code
    environment_variables = {
      BUILD_CONFIG_TEST = "build_test"
    }
    source {
      storage_source {
        bucket = google_storage_bucket.source-bucket.name
        object = google_storage_bucket_object.trello2notion.name
      }
    }
  }

  service_config {
    max_instance_count  = 3
    min_instance_count = 1
    available_memory    = "256M"
    timeout_seconds     = 60
    environment_variables = {
        SERVICE_CONFIG_TEST = "config_test"
    }
    ingress_settings = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email = google_service_account.account.email
  }

  event_trigger {
    event_type = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY_POLICY_RETRY"
    service_account_email = google_service_account.account.email
    event_filters {
      attribute = "bucket"
      value = google_storage_bucket.trigger-bucket.name
    }
  }
}

resource "google_cloudfunctions2_function" "rate-limiter" {
  depends_on = [
    google_storage_bucket_iam_member.object-creation,
  ]
  name = "rate-limiter"
  location = "us-central1"
  description = "The rate limiter based on upstash's library"

  build_config {
    runtime = "nodejs20"
    entry_point = "rate-limiter"  # Set the entry point
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
  }
}

output "function_uri" {
  value = google_cloudfunctions2_function.rate_limiter.service_config[0].uri
}
