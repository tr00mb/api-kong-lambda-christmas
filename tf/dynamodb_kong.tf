provider "aws" {
  region = "eu-west-3"
}

resource "aws_dynamodb_table" "kong-dynamodb-table" {
  name           = "kong"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

  attribute {
    name = "nom"
    type = "S"
  }

  attribute {
    name = "prix"
    type = "N"
  }

  # ttl {
  #   attribute_name = "TimeToExist"
  #   enabled        = false
  # }

  global_secondary_index {
    name               = "nameIndex"
    hash_key           = "nom"
    range_key          = "prix"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["id"]
  }
  tags {
    Name        = "dynamodb-table-kong"
    Environment = "production"
  }
}

resource "aws_dynamodb_table_item" "table-items" {
  table_name = "${aws_dynamodb_table.kong-dynamodb-table.name}"
  hash_key   = "${aws_dynamodb_table.kong-dynamodb-table.hash_key}"

  item = <<ITEM
{
  "id": {"N": "1"},
  "nom": {"S": "verre"},
  "libelle": {"S": "verre de biere"},
  "image_name": {"S": "verredebiere.png"},
  "prix": {"N": "14"}
}
{
  "id": {"N": "2"},
  "nom": {"S": "bougie"},
  "libelle": {"S": "bougie orange"},
  "image_name": {"S": "bougie.png"},
  "prix": {"N": "5"}
}
ITEM
}

resource "random_id" "random_id" {
  byte_length = 12
}

resource "aws_s3_bucket" "kong_bucket" {
  bucket        = "kong-bucket-${random_id.random_id.hex}"
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
  }

  tags {
    Name = "Kong"
  }
}

data "template_file" "s3_template" {
  template = "${file("s3_policy.json")}"

  vars {
    bucket_arn = "${aws_s3_bucket.kong_bucket.arn}"
  }
}

resource "aws_s3_bucket_policy" "kong_bucket_policy" {
  bucket = "${aws_s3_bucket.kong_bucket.id}"
  policy = "${data.template_file.s3_template.rendered}"
}

resource "aws_vpc" "kong_vpc" {
  cidr_block = "10.0.0.0/16"

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
  vpc_id     = "${aws_vpc.kong_vpc.id}"
  cidr_block = "10.0.1.0/24"
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
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.kong_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  ami                         = "ami-0ba311fb4d24e43b1"
  source_dest_check           = false
  instance_type               = "t2.large"
  subnet_id                   = "${aws_subnet.subnet.id}"
  associate_public_ip_address = true

  # depends_on             = ["${aws_internet_gateway.igw.id}"]
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]

  tags {
    Name = "kong"
  }
}

output "ec2_global_ips" {
  value = ["${aws_instance.instance.*.public_ip}"]
}

output "s3_bucket_id" {
  value = ["${aws_s3_bucket.kong_bucket.id}"]
}

output "s3_website_url" {
  value = ["${aws_s3_bucket.kong_bucket.website_endpoint}"]
}

output "s3_arn" {
  value = ["${aws_s3_bucket.kong_bucket.arn}"]
}
