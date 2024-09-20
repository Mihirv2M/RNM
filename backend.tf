terraform {
  backend "s3" {
    bucket = "terraform-mihir-local-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

//to turn server-side encryption on by default for all data written to this S3 bucket. This ensures that your state files, and any secrets they might contain, are always encrypted on disk when stored in S3:
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = "terraform-mihir-local-state"
    rule{
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
  }
} 
