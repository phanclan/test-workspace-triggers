terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
  backend "remote" {
    organization = "pphan"

    workspaces {
      name = "sub-1"
    }
  }
}
output "workspace" {
  value = "sub-1"
}
