# This block refers to the location Terraform will store its state.
# When using this method, terraform needs to be able to access the source (read & write).
# First, change the project ID (4103) for your own project ID.
# Then make an access token with API access and save it as a variable under "GITLAB_ACCESS_TOKEN".
# Make sure it is masked and hidden, and enable Protected.
# Finally, pass the GITLAB_ACCESS_TOKEN as an argument '-backend-config=password=${GITLAB_ACCESS_TOKEN}'
# when running 'terraform init'.
# In this project that is already included in the gitlab-ci.yml file.
terraform {
  backend "http" {
    address         = "https://git.sogyo.nl/api/v4/projects/4103/terraform/state/default"
    lock_address    = "https://git.sogyo.nl/api/v4/projects/4103/terraform/state/default/lock"
    unlock_address  = "https://git.sogyo.nl/api/v4/projects/4103/terraform/state/default/lock"
    lock_method     = "POST"
    unlock_method   = "DELETE"
    retry_wait_min  = "5"
    username        = "abaars"
  }
}
