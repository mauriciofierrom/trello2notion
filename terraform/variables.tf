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

variable "notion_oauth_client_id" {
  type = string
  description = "The client ID of the public Notion integration"
}

variable "notion_oauth_client_secret" {
  type = string
  description = "The secret of the public Notion integration"
}

variable "notion_oauth_redirect_uri" {
  type = string
  description = "The redirect uri for the public Notion integration"
}

variable "authgear_app_url" {
  type = string
  description = "The Authgear's configured application URL"
}
