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

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

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
