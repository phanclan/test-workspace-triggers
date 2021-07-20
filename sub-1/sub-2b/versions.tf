terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
  backend "remote" {
    organization = "pphan"

    workspaces {
      name = "sub-2b"
    }
  }
}
output "workspace" {
  value = "sub-2b 202107201325"
}
