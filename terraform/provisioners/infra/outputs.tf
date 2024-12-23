output "ecr-repository-api_url" {
  value = module.ecr-repository-api.repository_url
}

output "s3-promts-bucket_name" {
  value = module.s3-promts-bucket.s3_name
}

output "s3-promts-bucket_arn" {
  value = module.s3-promts-bucket.s3_arn
}