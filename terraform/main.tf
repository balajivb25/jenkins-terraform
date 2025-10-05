provider "aws" {
  region = "ap-south-1"
}

# 1️⃣ Create public S3 bucket
resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-image-bucket"
  
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

resource "aws_s3_bucket_acl" "public_acl" {
  bucket = aws_s3_bucket.public_bucket.id
  acl    = "public-read"
}

# 2️⃣ Upload GIF image
resource "aws_s3_object" "gif_image" {
  bucket       = aws_s3_bucket.public_bucket.id
  key          = "my-image.gif"
  source       = "${path.module}/my-image.gif"   # file in repo
  content_type = "image/gif"
  acl          = "public-read"                   # make it public
}

# 3️⃣ Output public URL
output "gif_url" {
  value = "https://${aws_s3_bucket.public_bucket.bucket}.s3.amazonaws.com/${aws_s3_object.gif_image.key}"
}
