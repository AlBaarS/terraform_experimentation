# -[Variables upon initialization]---------------------------------------------
variable "hosts" {
  default = 2
}

# -[Input variables]-----------------------------------------------------------
variable "public_key" {
  type = string
  sensitive = true
}

variable "email" {
  type = string
  sensitive = true
}

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

variable "infiscal_client_id" {
  type = string
  sensitive = true
  ephemeral = true
}

variable "infiscal_client_secret" {
  type = string
  sensitive = true
  ephemeral = true
}
