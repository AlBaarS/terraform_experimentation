# This block refers to the location Terraform will store its state.
# When using this method, terraform needs to be able to access the source (read & write)
# Make an access token with API access and save it as a variable under "GITLAB_ACCESS_TOKEN"
# Make sure it is masked and hidden, but not protected (otherwise it may not always trigger)
# See https://stackoverflow.com/questions/69591195/why-is-tf-build-failing-with-error-refreshing-state-http-remote-state-endpoint
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
