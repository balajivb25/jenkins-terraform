provider "aws" {
  region = "ap-south-1"
}

# 1️⃣ Create S3 bucket
resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-image-bucket"
  
  tags = {
    Name = "PublicImageBucket"
  }
}

# 2️⃣ Allow public access to bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.public_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 3️⃣ Bucket ACL resource
resource "aws_s3_bucket_acl" "public_acl" {
  bucket = aws_s3_bucket.public_bucket.id
  acl    = "public-read"
}

# 4️⃣ Upload GIF object
resource "aws_s3_object" "gif_image" {
  bucket       = aws_s3_bucket.public_bucket.id
  key          = "my-image.gif"
  source       = "${path.module}/my-image.gif"   # file in repo
  content_type = "image/gif"
}

# 5️⃣ Object ACL resource
resource "aws_s3_object_acl" "gif_acl" {
  bucket = aws_s3_bucket.public_bucket.id
  key    = aws_s3_object.gif_image.key
  acl    = "public-read"
}
