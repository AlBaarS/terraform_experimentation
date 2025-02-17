# -[Define providers]----------------------------------------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.11.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}



# -[Configure providers]-------------------------------------------------------
provider "vsphere" {
  # Configuration options
  # We expect the username and password to come from enviroment variables
  # VSPHERE_USER
  # VSPHERE_PASSWORD
  user                 = var.vmsphere_user
  password             = var.vmsphere_pw
  vsphere_server       = "photon-machine.sogyo.nl"
  allow_unverified_ssl = true
}

provider "random" {}
