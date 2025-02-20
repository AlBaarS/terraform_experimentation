# -[Define providers]----------------------------------------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
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
provider "random" {}

provider "infisical" {
  # host is only required if using self hosted instance of Infisical, default is https://app.infisical.com
  host = "https://app.infisical.com" 
  auth = {
    universal = {
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}
