# -[Define providers]----------------------------------------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.11.1"
    }
  }
}



# -[Configure providers]-------------------------------------------------------
provider "vsphere" {
  # Configuration options
  # We expect the username and password to come from enviroment variables
  # VSPHERE_USER
  # VSPHERE_PASSWORD
  # user                 = ""
  # password             = ""
  vsphere_server       = "photon-machine.sogyo.nl"
  allow_unverified_ssl = true
}
