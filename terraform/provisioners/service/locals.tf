locals {
  _root_dir = "${path.module}/../../../src/lambdas"
  _entries  = fileset(local._root_dir, "**")

  _lambda_functions = distinct([
    for v in local._entries : split("/", v)[0]
    if length(split("/", v)) > 1
  ])

  _lambda_configs = {
    for func in local._lambda_functions :
    func => fileexists("${local._root_dir}/${func}/.infra/config.json") ?
    jsondecode(
      templatefile("${local._root_dir}/${func}/.infra/config.json", local.template_vars)
    ) : null
  }

  lambdas      = { for func in local._lambda_functions : func => local._lambda_configs[func] }
  project      = "applingo"
  state_bucket = "tfstates-madpixels"
  tfstate_file = "applingo-forge/infra.tfstate"

  // template variables which use in ./infra/config.json of each lambda.
  template_vars = {
    promts_bucket_name      = data.terraform_remote_state.infra.outputs.s3-promts-bucket_name
    promts_bucket_arn       = data.terraform_remote_state.infra.outputs.s3-promts-bucket_arn
  }
}