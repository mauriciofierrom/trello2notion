variable "source_bucket" {
  type = string
  description = "The bucket to store the function in"
}

variable "trigger_bucket" {
  type = string
  description = "The bucket where file upload triggers the function"
}

variable "account_email" {
  type = string
  description = "The email for the service account that manages the function"
}

variable "sendgrid_api_key" {
  type = string
  description = "Sendgrid api token to set in the function's environment variable"
}
