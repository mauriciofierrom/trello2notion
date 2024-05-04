variable "source_bucket" {
  type = string
  description = "The bucket to store the function in"
}

variable "account_email" {
  type = string
  description = "The email for the service account that manages the function"
}

variable "trigger_bucket" {
  type = string
  description = "The bucket where file upload triggers the function"
}
