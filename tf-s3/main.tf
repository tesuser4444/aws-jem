resource "aws_s3_bucket" "my_bucket" {
  bucket = "${local.prefix}-my-bucket-empresa-falsa-bucket-${local.sufix}"
}

resource "aws_s3_bucket" "backup" {
  bucket = "${local.prefix}-backup-empresa-falsa-curso-${local.is_critical_environment}"
}

resource "aws_s3_bucket" "logs" {
  bucket     = "${local.prefix}-my-bucket-empresa-falsa-bucket-secundario-12345-logs"
  depends_on = [aws_s3_bucket.backup]
}

resource "aws_s3_bucket" "test_bucket_bool" {
  count         = var.environment == "prod" ? 1 : 0
  bucket        = "my-test-bucket-${count.index}"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "backup_policies" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket" "image_bucket" {
  for_each = var.ambientes
  bucket   = "pasadita-image-bucket-${each.key}"
}

resource "aws_kms_key" "mi_llave" {
  description             = "Llave para cifrar el bucket del modulo"
  deletion_window_in_days = 7 # mínimo permitido; se borra 7 días después del destroy
  enable_key_rotation     = true
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket        = "${local.prefix}-module-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true # con versionado, permite destroy aunque tenga objetos

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.mi_llave.arn
      }
      bucket_key_enabled = true # menos llamadas a KMS, más barato
    }
  }

  versioning = {
    enabled = true
  }
}



