# -[Variables upon initialization]---------------------------------------------
variable "hosts" {
  default = 2
}

variable "public_key" {
  type = string
  sensitive = true
}

variable "vmsphere_user" {
  type = string
  sensitive = true
}

variable "vmsphere_pw" {
  type = string
  sensitive = true
}

# -[Variables filled in later]-------------------------------------------------
locals {
  password = random_password.password.result
}