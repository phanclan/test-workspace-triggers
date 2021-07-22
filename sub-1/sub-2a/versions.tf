terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
  backend "remote" {
    organization = "pphan"

    workspaces {
      name = "sub-2a"
    }
  }
}
output "workspace" {
  value = "sub-2a 202107221008"
}
