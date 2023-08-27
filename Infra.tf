provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web-server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "jenkins03"
  //security_groups = [ "web-sg" ]
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  subnet_id              = aws_subnet.web-public-subnet-01.id
  for_each               = toset(["jenkins-master", "build-slave","Ansible-server"])
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "SSH Access"
  vpc_id      = aws_vpc.web-vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "localhost"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}

resource "aws_vpc" "web-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "web-vpc"
  }

}

resource "aws_subnet" "web-public-subnet-01" {
  vpc_id                  = aws_vpc.web-vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "web-public-subent-01"
  }
}

resource "aws_subnet" "web-public-subnet-02" {
  vpc_id                  = aws_vpc.web-vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "web-public-subent-02"
  }
}

resource "aws_internet_gateway" "web-igw" {
  vpc_id = aws_vpc.web-vpc.id
  tags = {
    Name = "web-igw"
  }
}

resource "aws_route_table" "web-public-rt" {
  vpc_id = aws_vpc.web-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-igw.id
  }
}

resource "aws_route_table_association" "web-rta-public-subnet-01" {
  subnet_id      = aws_subnet.web-public-subnet-01.id
  route_table_id = aws_route_table.web-public-rt.id
}

resource "aws_route_table_association" "web-rta-public-subnet-02" {
  subnet_id      = aws_subnet.web-public-subnet-02.id
  route_table_id = aws_route_table.web-public-rt.id
}