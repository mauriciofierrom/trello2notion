variable "billing_account_id" {
  type = string
  description = "The id for the Billing Account to disable via the function"
  sensitive = true
}

variable "redis_url" {
  type = string
  description = "Upstash redis url to set in function's environment variable"
}

variable "redis_token" {
  type = string
  description = "Upstash redis token to set in function's environment variable"
}

variable "sendgrid_api_key" {
  type = string
  description = "Sendgrid api token to set in the function's environment variable"
}
