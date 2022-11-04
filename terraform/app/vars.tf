variable "moonfire_url" {
  type        = string
  description = "The url to be smoke tested by this project app."
}

variable "repository_url" {
  type        = string
  description = "The ECR url built from the ecr terraform module."
}

output "repository_url" {
  value = var.repository_url
}
