#Create security group with firewall rules
resource "aws_security_group" "api" {
  name        = var.security_group
  description = "security group for API"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_key_pair" "terraform-keys" {
  key_name   = var.key_name
  public_key = file("${path.root}/terraform-keys.pub")
}

resource "aws_instance" "api_instance" {
  ami                    = var.ami_id
  key_name               = aws_key_pair.terraform-keys.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.api.id]
  tags                   = var.tags
}

# Create Elastic IP address
resource "aws_eip" "myElasticIP" {
  vpc      = true
  instance = aws_instance.api_instance.id
  tags     = var.tags
}
