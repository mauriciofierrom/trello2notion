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

variable "redis_url" {
  type = string
  description = "Upstash redis url to set in function's environment variable"
}

variable "redis_token" {
  type = string
  description = "Upstash redis token to set in function's environment variable"
}
