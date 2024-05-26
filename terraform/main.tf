terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }

  backend "gcs" {
    bucket = "t2n-state-prod"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "trello2notion"
}

# Bucket that will include the functions files
resource "google_storage_bucket" "source-bucket" {
  name     = "t2n-source-bucket"
  location = "us-central1"
  uniform_bucket_level_access = true
}

# Target bucket where file upload triggers the cloud event to be
# processed by the cloud event function
resource "google_storage_bucket" "trigger-bucket" {
  name     = "t2n-trigger-bucket"
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

resource "google_service_account" "account" {
  account_id   = "gcf-sa"
  display_name = "Test Service Account - used for both the cloud function and eventarc trigger in the test"
}

resource "google_project_iam_member" "invoking" {
  project = "trello2notion"
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.account.email}"
}

resource "google_storage_bucket_iam_binding" "creator" {
  bucket = google_storage_bucket.trigger-bucket.name
  role   = "roles/storage.objectCreator"

  members = [
    "serviceAccount:${google_service_account.account.email}",
  ]
}

resource "google_storage_bucket_iam_binding" "viewer" {
  bucket = google_storage_bucket.trigger-bucket.name
  role   = "roles/storage.objectViewer"

  members = [
    "serviceAccount:${google_service_account.account.email}",
  ]
}

resource "google_pubsub_topic" "file-ready-topic" {
  name = "t2n-file-ready"
}

module "budget-alert-function" {
  source = "./modules/budget-alert"

  source_bucket = google_storage_bucket.source-bucket.name
  account_email = google_service_account.account.email
  billing_account_id = var.billing_account_id
  service_account = google_service_account.account
}

module "rate-limit-function" {
  source = "./modules/rate-limiter"

  source_bucket = google_storage_bucket.source-bucket.name
  account_email = google_service_account.account.email
  redis_url = var.redis_url
  redis_token = var.redis_token
  trigger_bucket = google_storage_bucket.trigger-bucket.name
}

module "conversor-function" {
  source = "./modules/conversor"
  depends_on = [ module.rate-limit-function ]

  source_bucket = google_storage_bucket.source-bucket.name
  trigger_bucket = google_storage_bucket.trigger-bucket.name
  account_email = google_service_account.account.email
  sendgrid_api_key = var.sendgrid_api_key
  pubsub_topic = google_pubsub_topic.file-ready-topic.id
}
