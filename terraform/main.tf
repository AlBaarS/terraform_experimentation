# -[Resources]-----------------------------------------------------------------
# Generate a random password to be used for the default 'ubuntu' user
# on the provisioned machines
resource "random_password" "password" {
  length  = 24
  special = true
}

# Store the password in the infiscal cloud
resource "infisical_secret" "mancala-secret" {
  name         = "MANCALA_PW"
  value        = random_password.password.result
  env_slug     = "dev"
  workspace_id = "261219c8-bf78-4482-bf9f-d7c06b4d6cb0"
  folder_path  = "/"
}

# Retrieve the password from the infiscal cloud
ephemeral "infisical_secret" "ephemeral-mancala-secret" {
  name         = "MANCALA_PW"
  env_slug     = "dev"
  workspace_id = "261219c8-bf78-4482-bf9f-d7c06b4d6cb0"
  folder_path  = "/"
}

# Template for the actual virtual machine
resource "vsphere_virtual_machine" "vm" {
  # Base settings
  name             = format("mancala%02d", count.index + 1)
  resource_pool_id = data.vsphere_resource_pool.on-prem-kubernetes.id
  datastore_id     = data.vsphere_datastore.vs1_hpe_raid10.id
  num_cpus         = 2
  memory           = 2048
  guest_id         = "ubuntu64Guest"  # this cannot be changed to a different name, sadly
  count            = var.hosts

  # We want to make a clone of the Ubuntu 22.04 LTS Cloud Image Template
  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu-2204-cloudimg-template.id
  }
  # ^ this will be exchanged for a self created Ubuntu 24.04 image later

  # Number of Cores per Socket needs to be set to 0 to let
  # vSphere/ESXi decide on the best topology, default is 1
  num_cores_per_socket = 0

  sync_time_with_host = true
  enable_logging      = true
  
  # We need a CD-ROM for vApp properties to work
  cdrom {
    client_device = true
  }

  network_interface {
    network_id     = data.vsphere_network.vm_network.id
    mac_address    = format("00:50:56:3f:3e:%02x", count.index + 1)
    use_static_mac = true
  }


  disk {
    label = "Hard Disk 1"
    size  = 25
  }
  
  vapp {
    properties = {
      # Default 'ubuntu' user password
      password = ephemeral.infisical_secret.ephemeral-mancala-secret.value

      # Instance ID and hostname are autogenerated and match the VM name in vSphere
      instance-id = format("mancala%02d", count.index + 1)
      hostname    = format("mancala%02d", count.index + 1)

      # Contains a newline seperated string containing an SSH public key that is allowed
      # to login into the 'ubuntu' user. Format matches authorized_keys files.
      public-keys = "ssh-ed25519 ${var.public_key} ${var.email}"

      # User data contains a cloud-init configuration file. This file is passed to the template
      # where cloud-init runs at first boot and can modify default users/software etc
      # for now we only use it to not let the default passwords expire so we can instantly
      # login to the VMs
      user-data = base64encode(file("cloud_init.cfg"))
    }
  }

}
