output "prefix" {
  value = local.prefix
}
output "message" {
  value = "Hola Mundo"
}

output "logs_bucket_arn" {
  value = aws_s3_bucket.logs.arn
}