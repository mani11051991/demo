terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id
  tags = {
    Name = "demo-igw"
  }
}

# Create a Public Subnet
resource "aws_subnet" "demo" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "demo-subnet"
  }
}

# Create a Route Table
resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }
  tags = {
    Name = "demo-rt"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "demo" {
  subnet_id      = aws_subnet.demo.id
  route_table_id = aws_route_table.demo.id
}

# Create a Security Group
resource "aws_security_group" "demo" {
  vpc_id = aws_vpc.demo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-sg"
  }
}

# Create an IAM Role
resource "aws_iam_role" "demo" {
  name = "demo-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach a Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "demo" {
  role       = aws_iam_role.demo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Create an Instance Profile
resource "aws_iam_instance_profile" "demo" {
  name = "demo-instance-profile"
  role = aws_iam_role.demo.name
}

# Define user data files for each instance
locals {
  user_data_files = {
    "jenkins" = "userdata/userdata1.sh"
    "sonar" = "userdata/userdata2.sh"
    "nexus" = "userdata/userdata3.sh"
    "develop" = "userdata/userdata4.sh"
    "test" = "userdata/userdata5.sh"
    "production" = "userdata/userdata6.sh"
    "prometheus" = "userdata/userdata7.sh"
    "grafana" = "userdata/userdata8.sh"
    "splunk" = "userdata/userdata9.sh"
  }
}

# Create 9 EC2 Instances with Different Names
resource "aws_instance" "demo" {
  for_each                = local.user_data_files
  ami                     = "ami-0195204d5dce06d99" # Replace with your desired AMI ID
  instance_type           = "t2.micro"
  subnet_id               = aws_subnet.demo.id
  security_groups         = [aws_security_group.demo.name]
  iam_instance_profile    = aws_iam_instance_profile.demo.name
  associate_public_ip_address = true

user_data = each.value

  tags = {
    Name = each.key
  }
}

output "instance_ids" {
  value = aws_instance.demo.*.id
}
