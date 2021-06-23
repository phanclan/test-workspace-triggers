resource "random_pet" "server" {
  length = var.pet_name_length
  prefix = var.prefix
}

# variables.tf

variable "pet_name_length" {
  type    = string
  default = "1"
}

variable "prefix" {
  default = "test-151646"
}

# output.tf
output "server" {
  value = random_pet.server.id
}
