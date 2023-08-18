resource "aws_s3_bucket" "bucket" {
  bucket = "main-bucket-takorukun"
  acl    = "private"

  tags = {
    Name = "My bucket"
    Environment = "Prod"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main_app_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.public_rtb.id]
  vpc_endpoint_type = "Gateway"
}
