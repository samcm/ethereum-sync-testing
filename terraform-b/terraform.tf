terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.11.1"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.4.1"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.13.1"
    }

    external = {
      source = "hashicorp/external"
      version = "2.2.2"
    }
  }

  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "https://ams3.digitaloceanspaces.com"
    region                      = "us-east-1" // needed
    bucket                      = "efdevops-terraform-remote-state"
    key                         = "ibm-sync-testing/terraform.tfstate"
  }
}


variable "spaces_access_id" {
  sensitive = true
}

variable "spaces_secret_key" {
  sensitive = true
}