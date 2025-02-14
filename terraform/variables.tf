# -[Variables upon initialization]---------------------------------------------
variable "hosts" {
  default = 2
}

# -[Variables filled in later]-------------------------------------------------
locals {
    password = random_password.password.result
}