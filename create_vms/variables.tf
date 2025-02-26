# -[Variables upon initialization]---------------------------------------------
variable "hosts" {
  default = 2
}

# -[Input variables]-----------------------------------------------------------
variable "vsphere_user" {
  type = string
  sensitive = true
  ephemeral = true
}

variable "vsphere_pw" {
  type = string
  sensitive = true
  ephemeral = true
}

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

variable "ssh_authorized_keys" {
  type = list
  default = [
    data.infisical_secrets.common_secrets.secrets["SSHKEY_01"].value,
    data.infisical_secrets.common_secrets.secrets["SSHKEY_02"].value
  ]
}
