# -[Variables upon initialization]---------------------------------------------
variable "hosts" {
  default = 2
}

variable "PUBLIC_KEY" {
  type = string
}

# -[Variables filled in later]-------------------------------------------------
locals {
    password = random_password.password.result
}