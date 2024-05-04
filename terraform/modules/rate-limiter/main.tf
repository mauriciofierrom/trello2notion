resource "google_storage_bucket_object" "rate-limiter-function-file" {
  name   = "rate-limiter-function.zip"
  bucket = var.source_bucket
  source = "rate-limiter-function.zip"  # Add path to the zipped function source code
}

resource "google_cloudfunctions2_function" "rate-limiter" {
  depends_on = var.dependencies
  name = "rate-limiter"
  location = "us-central1"
  description = "The rate limiter based on upstash's library"

  build_config {
    runtime = "nodejs20"
    entry_point = "rate-limiter"  # Set the entry point
    source {
      storage_source {
        bucket = var.source_bucket
        object = var.source_file
      }
    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
  }
}
