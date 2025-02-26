# -[Resources]-----------------------------------------------------------------

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
      # password = data.infisical_secrets.common_secrets.secrets["MANCALA_PW"].value
      # ^ use an SSH key instead

      # Instance ID and hostname are autogenerated and match the VM name in vSphere
      instance-id = format("mancala%02d", count.index + 1)
      hostname    = format("mancala%02d", count.index + 1)

      # Contains a newline seperated string containing an SSH public key that is allowed
      # to login into the 'ubuntu' user. Format matches authorized_keys files.
      public-keys = data.infisical_secrets.common_secrets.secrets[format("SSHKEY_%02d", count.index + 1)].value


      # User data contains a cloud-init configuration file. This file is passed to the template
      # where cloud-init runs at first boot and can modify default users/software etc
      # for now we only use it to not let the default passwords expire so we can instantly
      # login to the VMs
      user-data = base64encode(file("cloud_init.cfg"))
    }
  }
}

resource "infisical_secret" "store-ip-secret" {
  count        = var.hosts
  name         = format("VM_IP_%02d", count.index + 1)
  value        = vsphere_virtual_machine.vm[count.index].default_ip_address
  env_slug     = "dev"
  workspace_id = var.infisical_workspace_id
  folder_path  = "/"
}
