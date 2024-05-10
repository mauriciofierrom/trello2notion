# Budget and alert

data "google_billing_account" "account" {
  billing_account = var.billing_account_id
}

resource "google_billing_account_iam_member" "billing-admin" {
  billing_account_id = data.google_billing_account.account.id
  role = "roles/billing.admin"
  member = "serviceAccount:${var.account_email}"
}

data "google_project" "project" {
}

resource "google_pubsub_topic" "budget" {
  name = "budget-topic"
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name    = "Billing budget"

  budget_filter {
    projects = ["projects/${data.google_project.project.number}"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = "5"
    }
  }

  threshold_rules {
    threshold_percent = 0.5
    spend_basis       = "FORECASTED_SPEND"
  }

  # Pub/Sub topic to send budget updates to. These are periodically so the function will have to discern when it's time
  # for shutdown
  all_updates_rule {
    pubsub_topic = google_pubsub_topic.budget.id
  }
}

resource "google_storage_bucket_object" "budget-alert-function-file" {
  name   = "budget-alert-function.zip"
  bucket = var.source_bucket
  source = "budget-alert-function.zip"  # Add path to the zipped function source code
}

# Function
resource "google_cloudfunctions2_function" "budget-function" {
  # TODO: Add all the permissions required for the whole thing to work
  depends_on = [
    var.service_account,
    google_storage_bucket_object.budget-alert-function-file,
    google_billing_account_iam_member.billing-admin
  ]
  name = "budget-function"
  location = "us-central1"
  description = "Function to disable billing in response to budget alert"

  build_config {
    runtime     = "nodejs20"
    entry_point = "budget-alert" # Set the entry point in the code
    environment_variables = {
      BUILD_CONFIG_TEST = "build_test"
    }
    source {
      storage_source {
        bucket = var.source_bucket
        object = google_storage_bucket_object.budget-alert-function-file.name
      }
    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
    environment_variables = {
        GOOGLE_CLOUD_PROJECT = "trello2notion"
    }
    ingress_settings = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email = var.account_email
  }

  event_trigger {
    trigger_region = "us-central1"
    event_type = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic = google_pubsub_topic.budget.id
    retry_policy = "RETRY_POLICY_DO_NOT_RETRY"
    service_account_email = var.account_email
  }
}
