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

resource "google_service_account" "account" {
  account_id   = "gcf-sa"
  display_name = "Test Service Account - used for both the cloud function and eventarc trigger in the test"
}

resource "google_project_iam_member" "invoking" {
  project = "trello2notion"
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.account.email}"
}

module "budget-alert-function" {
  source = "./modules/budget-alert"

  source_bucket = google_storage_bucket.source-bucket.name
  account_email = google_service_account.account.email
  billing_account_id = var.billing_account_id
  service_account = google_service_account.account
}
