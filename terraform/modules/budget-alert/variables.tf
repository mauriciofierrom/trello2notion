variable "source_bucket" {
  type = string
  description = "The bucket to store the function in"
}

variable "account_email" {
  type = string
  description = "The email for the service account that manages the function"
}

variable "billing_account_id" {
  type = string
  description = "The id for the Billing Account to disable via the function"
  sensitive = true
}

variable "service_account" {
  description = "Some thing that might not work"
}
