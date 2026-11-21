terraform {
  required_providers {
    # 5.x: la 6.x falla con el emulador al crear buckets (S3 Control)
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

# Endpoint, credenciales y certificado vienen de emulator.env
provider "aws" {
  region                     = "us-east-1"
  s3_use_path_style          = true
  skip_requesting_account_id = true
  skip_metadata_api_check    = true
}
