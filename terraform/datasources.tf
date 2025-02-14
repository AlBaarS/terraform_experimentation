# Our only vSphere Datacenter registered
data "vsphere_datacenter" "boerderij" {
  name = "Boerderij"
}

# For now the cluster only goes to the vs1 host
data "vsphere_host" "vs1" {
  name          = "vs1.sogyo.nl"
  datacenter_id = data.vsphere_datacenter.boerderij.id
}

# VS1 datastores, we only use the RAID10
data "vsphere_datastore" "vs1_hpe_raid10" {
  name          = "HPE RAID 10"
  datacenter_id = data.vsphere_datacenter.boerderij.id
}

# Our only network, VLAN 0 connected
data "vsphere_network" "vm_network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.boerderij.id
}

# The Resource Pool we will deploy to
data "vsphere_resource_pool" "on-prem-kubernetes" {
  name          = "Kubernetes On-Prem"
  datacenter_id = data.vsphere_datacenter.boerderij.id
}

# The already prepared Ubuntu 22.04 LTS Cloud Image Template we will use to
# create new VMs from
data "vsphere_virtual_machine" "ubuntu-2204-cloudimg-template" {
  name          = "ubuntu-jammy-22.04-cloudimg-vs1"
  datacenter_id = data.vsphere_datacenter.boerderij.id
}
# ^ will be exchanged for a self-created Ubuntu 24.04 image when we have a working setup
