terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  
}
provider "aws" {
    region=var.region
}

resource "aws_instance" "web" {
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.micro"
  vpc_security_group_ids =  aws_security_group.maingroup.id
  iam_instance_profile= aws_iam_instance_profile.test_profile.name


  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = var.private_key
    timeout = "40"
  }

  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_key_pair" "keypai" {
  key_name   = var.key_name
  public_key = var.public_key
}
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = EC2-ECR-Auth
}

resource "aws_security_group" "maingroup" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress=[ 
    {
    description      = "to allow ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  },
  {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "http"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

output "instance_public_ip" {
    value = aws_instance.web.public_ip
    sensitive = true
  
}
