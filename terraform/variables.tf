variable "hosts" {
  default = 2
}

variable "password" {
    type = string
    default = random_password.password.result
}
