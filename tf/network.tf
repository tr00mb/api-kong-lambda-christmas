resource "aws_vpc" "kong_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "kong"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.kong_vpc.id}"

  tags {
    Name = "kong"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = "${aws_vpc.kong_vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

#####

resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.kong_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

####

resource "aws_security_group" "sg" {
  name        = "kong-traffic-rules"
  description = "Allow traffic to Kong"
  vpc_id      = "${aws_vpc.kong_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
