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
    infisical = {
      source = "infisical/infisical"
      version = "0.14.0"
    }
  }
}



# -[Configure providers]-------------------------------------------------------
provider "vsphere" {
  # Configuration options
  # We expect the username and password to come from enviroment variables
  # VSPHERE_USER
  # VSPHERE_PASSWORD
  # Doesn't work for some reason, so I've passed them explicitly
  user                 = var.vsphere_user
  password             = var.vsphere_pw
  vsphere_server       = "photon-machine.sogyo.nl"
  allow_unverified_ssl = true
}

provider "random" {}

provider "infisical" {
  # host is only required if using self hosted instance of Infisical, default is https://app.infisical.com
  host = "https://app.infisical.com" 
  auth = {
    universal = {
      client_id     = var.infiscal_client_id
      client_secret = var.infiscal_client_secret
    }
  }
}
