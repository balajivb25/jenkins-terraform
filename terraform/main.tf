provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# 1️⃣ Create S3 bucket
resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-image-bucket-${random_id.suffix.hex}"

  tags = {
    Name = "PublicImageBucket"
  }
}

# 2️⃣ Disable public access block restrictions
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.public_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 3️⃣ Bucket policy for public read
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.public_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.public_bucket.arn}/*"]
      }
    ]
  })
}

# 4️⃣ Upload GIF
resource "aws_s3_object" "gif_image" {
  bucket       = aws_s3_bucket.public_bucket.id
  key          = "my-image.gif"
  source       = "${path.module}/my-image.gif"
  content_type = "image/gif"
}
