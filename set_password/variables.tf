# -[Input variables]-----------------------------------------------------------
variable "infisical_client_id" {
  type = string
  sensitive = true
  ephemeral = true
}

variable "infisical_client_secret" {
  type = string
  sensitive = true
  ephemeral = true
}

variable "infisical_workspace_id" {
  type = string
  sensitive = true
}