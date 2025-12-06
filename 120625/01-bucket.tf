resource "aws_s3_bucket" "website" {
  bucket_prefix = "samba-saturday-"
  force_destroy = true

  tags = {
    Name        = "Rob loves brisket tacos"
  }
}