# -[Variables upon initialization]---------------------------------------------
variable "hosts" {
  default = 2
}

variable "public_key" {
  type = string
  sensitive = true
}

variable "vsphere_user" {
  type = string
  sensitive = true
}

variable "vsphere_pw" {
  type = string
  sensitive = true
}

variable "gitlab_token" {
  type = string
  sensitive = true
}

# -[Variables filled in later]-------------------------------------------------
locals {
  password = random_password.password.result
}