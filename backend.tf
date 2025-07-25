terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"   # You create this S3 bucket
    key            = "ec2/dev/terraform.tfstate"   # Path to the state file inside the bucket
    region         = "ap-south-1"                   # Your AWS region
    encrypt        = true
  }
}
