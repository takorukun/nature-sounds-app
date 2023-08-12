data "aws_ssm_parameter" "db_username" {
  name = "db_username"
}

data "aws_ssm_parameter" "db_password" {
  name = "db_password"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "mydb"
  username             = data.aws_ssm_parameter.db_username.value
  password             = data.aws_ssm_parameter.db_password.value
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.main_subnet_group.name
  vpc_security_group_ids = [aws_security_group.endpoint_sg.id]
  skip_final_snapshot  = true
}

resource "aws_vpc_endpoint" "rds" {
  vpc_id            = aws_vpc.main_app_vpc.id
  service_name      = "com.amazonaws.${var.region}.rds"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.public_web_subnet1.id, aws_subnet.public_web_subnet2.id]

  security_group_ids = [aws_security_group.endpoint_sg.id]

  private_dns_enabled = true
}

resource "aws_security_group" "endpoint_sg" {
  name        = "endpoint_sg"
  description = "Security group for RDS endpoint"
  vpc_id      = aws_vpc.main_app_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
