# -[Variables upon initialization]---------------------------------------------
variable "hosts" {
  default = 2
}

variable "public_key" {
  type = string
}

# -[Variables filled in later]-------------------------------------------------
locals {
  password = random_password.password.result
}