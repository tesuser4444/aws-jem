variable "project" {
  description = "Project name used to prefix resource names."
  type        = string
  default     = "demo"
}

variable "environment" {
  description = "Deployment environment used by resource names."
  type        = string
  default     = "dev"
}

variable "force_destroy" {
  description = "Allow Terraform to delete buckets containing objects."
  type        = bool
  default     = true
}

variable "ambientes" {
  type    = set(string)
  default = ["dev", "stag", "prod"]
}
