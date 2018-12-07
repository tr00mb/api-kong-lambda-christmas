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

resource "aws_vpc" "default_vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "default"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = "${aws_vpc.default_vpc.id}"
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "instance" {
  ami                         = "ami-0ba311fb4d24e43b1"
  source_dest_check           = false
  instance_type               = "t2.large"
  subnet_id                   = "${aws_subnet.subnet.id}"
  associate_public_ip_address = true

  tags {
    Name = "kong"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default_vpc.id}"

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

    # prefix_list_ids = ["pl-12c4e678"]
  }
}
