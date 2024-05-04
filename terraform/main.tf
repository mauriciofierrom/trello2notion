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
  name     = "gcf-source-bucket"
  location = "us-central1"
  uniform_bucket_level_access = true
}

# Target bucket where file upload triggers the cloud event to be
# processed by the cloud event function
resource "google_storage_bucket" "trigger-bucket" {
  name     = "gcf-trigger-bucket"
  location = "us-central1" # The trigger must be in the same location as the bucket
  uniform_bucket_level_access = true
}

resource "google_service_account" "account" {
  account_id   = "gcf-sa"
  display_name = "Test Service Account - used for both the cloud function and eventarc trigger in the test"
}

module "trello2notion-function" {
  source = "./modules/function"

  source_bucket = google_storage_bucket.source-bucket.name
  account_email = google_service_account.account.email
  trigger_bucket = google_storage_bucket.trigger-bucket.name
}

module "rate-limiter-function" {
  source = "./modules/rate-limiter"

  source_bucket = google_storage_bucket.source-bucket.name
  account_email = google_service_account.account.email
  trigger_bucket = google_storage_bucket.trigger-bucket.name
}
