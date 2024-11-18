output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.aws_s3_bucket.bucket

}