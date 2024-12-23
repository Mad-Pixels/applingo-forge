module "ecr-repository-api" {
  source = "../../modules/ecr"

  project         = local.project
  repository_name = "images"
}

module "s3-promts-bucket" {
  source = "../../modules/s3"

  project     = local.project
  bucket_name = "promts"
}
