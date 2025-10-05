provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-image-bucket"
  acl    = "public-read"   # Allows public objects

  tags = {
    Name = "PublicImageBucket"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.public_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "image" {
  bucket       = aws_s3_bucket.public_bucket.id
  key          = "my-image.gif"        # filename in S3
  source       = "${path.module}/my-image.gif"   # picks up file from current module
  acl          = "public-read"         # make it public
  content_type = "image/gif"
}
