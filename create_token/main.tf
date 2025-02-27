# -[Resources/Datasources]-----------------------------------------------------

# Generate an ssh keypair
resource "tls_private_key" "rsa-4096-private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the generated ssh keypair to Infisical
resource "infisical_secret" "store-public-key-secret" {
  name         = "VM_KEY_PUBLIC"
  value        = tls_private_key.rsa-4096-private.public_key_openssh
  env_slug     = "dev"
  workspace_id = var.infisical_workspace_id
  folder_path  = "/"
}

resource "infisical_secret" "store-private-key-secret" {
  name         = "VM_KEY_PRIVATE"
  value        = tls_private_key.rsa-4096-private.private_key_openssh
  env_slug     = "dev"
  workspace_id = var.infisical_workspace_id
  folder_path  = "/"
}