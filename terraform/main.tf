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

module "trello2notion-function" {
  source = "./modules/function"

  source_bucket = google_storage_bucket.source-bucket.name
  dependencies = [
    google_project_iam_member.event-receiving,
    google_project_iam_member.artifactregistry-reader,
  ]
  account_email = google_service_account.account.email
  trigger_bucket = google_storage_bucket.trigger-bucket.name
}

module "rate-limiter-function" {
  source = "./modules/rate-limiter"

  source_bucket = google_storage_bucket.source-bucket.name
  dependencies = [
    google_project_iam_member.object-creation
  ]
  account_email = google_service_account.account.email
  trigger_bucket = google_storage_bucket.trigger-bucket.name
}
