resource "google_storage_bucket_object" "trello2notion-function-file" {
  name   = "trello2notion-function.zip"
  bucket = var.source_bucket
  source = "trello2notion-function.zip"  # Add path to the zipped function source code
}

resource "google_storage_bucket_iam_member" "object-creation" {
  bucket = var.trigger_bucket
  role    = "roles/storage.objects.create"
  member   = "serviceAccount:${var.account_email}"
}

resource "google_cloudfunctions2_function" "trello2notion-function" {
  depends_on = [
    google_storage_bucket_iam_member.object-creation
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
        bucket = var.source_bucket
        object = google_storage_bucket_object.trello2notion-function-file
      }
    }
  }

  service_config {
    max_instance_count  = 3
    available_memory    = "256M"
    timeout_seconds     = 60
    environment_variables = {
        SERVICE_CONFIG_TEST = "config_test"
    }
    ingress_settings = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email = var.account_email
  }

  event_trigger {
    event_type = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY_POLICY_RETRY"
    service_account_email = var.account_email
    event_filters {
      attribute = "bucket"
      value = var.trigger_bucket
    }
  }
}
