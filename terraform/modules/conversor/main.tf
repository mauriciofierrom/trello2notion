resource "google_storage_bucket_object" "conversor-function-file" {
  name   = "conversor-function.zip"
  bucket = var.source_bucket
  source = "conversor-function.zip"  # Add path to the zipped function source code
}

# Bucket to upload resulting Markdown files.
resource "google_storage_bucket" "result-bucket" {
  name     = "t2n-result-bucket"
  location = "us-central1" # The trigger must be in the same location as the bucket
  uniform_bucket_level_access = true
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}

# Make the bucket publicly accesible to users.
resource "google_storage_bucket_iam_binding" "public_access" {
  bucket   = var.trigger_bucket
  role     = "roles/storage.objectViewer"
  members  = ["allUsers"]
}

resource "google_cloudfunctions2_function" "conversor" {
  name = "conversor"
  location = "us-central1"
  description = "Performs the conversion from Trello JSON export files"

  build_config {
    runtime     = "ruby32"
    entry_point = "trello2notion" # Set the entry point in the code
    source {
      storage_source {
        bucket = var.source_bucket
        object = google_storage_bucket_object.conversor-function-file.name
      }
    }
  }

  service_config {
    max_instance_count  = 3
    available_memory    = "256M"
    timeout_seconds     = 60
    environment_variables = {
      GOOGLE_CLOUD_PROJECT = "trello2notion"
      SENDGRID_API_KEY = var.sendgrid_api_key
    }
    ingress_settings = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email = var.account_email
  }

  event_trigger {
    trigger_region = "us-central1"
    event_type = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY_POLICY_DO_NOT_RETRY"
    service_account_email = var.account_email
    event_filters {
      attribute = "bucket"
      value = var.trigger_bucket
    }
  }
}
