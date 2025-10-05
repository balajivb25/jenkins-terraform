output "image_url" {
  value = "https://${aws_s3_bucket.public_bucket.bucket}.s3.amazonaws.com/${aws_s3_object.image.key}"
}


