output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

output "bucket_info" {
    value = {
        name = aws_s3_bucket.website.bucket
        arn = aws_s3_bucket.website.arn
        }
}


output "policy" {
  value = aws_s3_bucket_policy.public_access.policy
}