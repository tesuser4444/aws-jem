# Bucket creado manualmente desde la consola de AWS.
# Un data source solo LEE el recurso: Terraform no lo crea, modifica ni destruye.
data "aws_s3_bucket" "consola" {
  bucket = "datop-patito-sex-095289934019-us-east-1-an"
}

output "bucket_consola" {
  value = {
    nombre      = data.aws_s3_bucket.consola.id
    arn         = data.aws_s3_bucket.consola.arn
    region      = data.aws_s3_bucket.consola.region
    dominio     = data.aws_s3_bucket.consola.bucket_domain_name
    hosted_zone = data.aws_s3_bucket.consola.hosted_zone_id
  }
}

data "aws_caller_identity" "current" {}
