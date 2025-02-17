terraform {
  backend "http" {
    address        = "https://git.sogyo.nl/api/v4/projects/4103/terraform/state/default"
    lock_address   = "https://git.sogyo.nl/api/v4/projects/4103/terraform/state/default/lock"
    unlock_address = "https://git.sogyo.nl/api/v4/projects/4103/terraform/state/default/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = "5"
  }
}
