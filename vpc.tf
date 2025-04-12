resource "aws_vpc" "chrisy-main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-public-vpc"
  }
}

resource "aws_subnet" "chrisy-public_a" {
  vpc_id            = aws_vpc.chrisy-main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Replace with your desired Availability Zone (e.g., us-east-1a)

  map_public_ip_on_launch = true # Important for public subnets

  tags = {
    Name = "my-public-subnet-a"
  }
}

resource "aws_subnet" "chrisy-public_b" {
  vpc_id            = aws_vpc.chrisy-main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Replace with your desired Availability Zone (e.g., us-east-1b)

  map_public_ip_on_launch = true # Important for public subnets

  tags = {
    Name = "my-public-subnet-b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.chrisy-main.id

  tags = {
    Name = "my-internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.chrisy-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.chrisy-public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.chrisy-public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ecs_tasks" {
  vpc_id = aws_vpc.chrisy-main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust as needed for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-tasks-sg"
  }
}