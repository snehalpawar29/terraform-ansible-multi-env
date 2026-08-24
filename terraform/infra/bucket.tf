resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "${var.env}-snehal-devops-bucket"
  tags = {
    Name        = "${var.env}-snehal-devops-bucket"
    Environment = var.env
  }
}



