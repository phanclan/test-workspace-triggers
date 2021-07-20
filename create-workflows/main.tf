## main.tf
resource "local_file" "dynamic" {
  for_each   = local.path_to_workspace_map
  content    = templatefile("${path.module}/templates/workspace_workflow.tpl", each.value)
  filename       = "${local.local_filepath}/${each.key}.yml"
}

## variables.tf
#variable "path_to_workspace_map" {}
#variable "local_filepath" {}
## terraform.tfvars

locals {
    path_to_workspace_map = {
      "root"  = {
          path = "*", uses = "./.github/actions/terraform-workflow", working_directory = "." },
      "sub-1"  = {
          path = "sub-1/*", uses = "./.github/actions/terraform-workflow", working_directory = "sub-1" },
      "sub-2a" = {
          path = "sub-1/sub-2a/*", uses = "./.github/actions/terraform-workflow", working_directory = "sub-1/sub-2a" },
      "sub-2b" = { path = "sub-1/sub-2b/*", uses = "./.github/actions/terraform-workflow", working_directory = "sub-1/sub-2b" },
    }
    local_filepath = "../.github/workflows"
}
