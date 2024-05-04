resource "google_storage_bucket_object" "rate-limiter-function-file" {
  name   = "rate-limiter-function.zip"
  bucket = var.source_bucket
  source = "rate-limiter-function.zip"  # Add path to the zipped function source code
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

# Permissions on the service account used by the function and Eventarc trigger
resource "google_project_iam_member" "invoking" {
  project = "trello2notion"
  role    = "roles/run.invoker"
  member  = "serviceAccount:${var.account_email}"
  depends_on = [google_project_iam_member.gcs-pubsub-publishing]
}

resource "google_project_iam_member" "event-receiving" {
  project = "trello2notion"
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${var.account_email}"
  depends_on = [google_project_iam_member.invoking]
}

resource "google_project_iam_member" "artifactregistry-reader" {
  project = "trello2notion"
  role     = "roles/artifactregistry.reader"
  member   = "serviceAccount:${var.account_email}"
  depends_on = [google_project_iam_member.event-receiving]
}

resource "google_cloudfunctions2_function" "rate-limiter" {
  depends_on = [
    google_project_iam_member.event-receiving,
    google_project_iam_member.artifactregistry-reader,
  ]
  name = "rate-limiter"
  location = "us-central1"
  description = "The rate limiter based on upstash's library"

  build_config {
    runtime = "nodejs20"
    entry_point = "rate-limiter"  # Set the entry point
    source {
      storage_source {
        bucket = var.source_bucket
        object = google_storage_bucket_object.rate-limiter-function-file
      }
    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
  }
}
