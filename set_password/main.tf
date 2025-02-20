# This script's only purpose is to set a password for the vm's to use.
# Clear the secret in your Infisical vault before running this script!

# -[Resources]-----------------------------------------------------------------

# Generate a random password to be used for the default 'ubuntu' user
# on the provisioned machines
resource "random_password" "password" {
  length  = 24
  special = true
}

# Store the password in the infiscal cloud
resource "infisical_secret" "store-mancala-secret" {
  name         = "MANCALA_PW"
  value        = random_password.password.result
  env_slug     = "dev"
  workspace_id = var.infisical_workspace_id
  folder_path  = "/"
}
# ^ The secret is retrieved using a data source
