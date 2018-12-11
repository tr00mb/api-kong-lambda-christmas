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

resource "aws_dynamodb_table_item" "table-items"{
  table_name = "${aws_dynamodb_table.kong-dynamodb-table.name}"
  hash_key   = "${aws_dynamodb_table.kong-dynamodb-table.hash_key}"
  item       = <<ITEM
 {
"id": { "N" : "1" },
"nom": {"S" : "Horse" },
"libelle": {"S" :"Wooden Rocking Horse" },
"prix": { "N" : "150" },
"image_url": {"S" : "woodenHorse.png" }
}
ITEM
}

resource "aws_dynamodb_table_item" "table-items4"{
  table_name = "${aws_dynamodb_table.kong-dynamodb-table.name}"
  hash_key   = "${aws_dynamodb_table.kong-dynamodb-table.hash_key}"
  item       = <<ITEM
 {
"id": { "N" : "2" },
"nom" : {"S" : "Doll" },
"libelle": {"S" : "Rag Doll" },
 "prix": { "N" : "75" },
 "image_url": {"S" : "ragDoll.png" }
 }
ITEM
}

resource "aws_dynamodb_table_item" "table-items3"{
  table_name = "${aws_dynamodb_table.kong-dynamodb-table.name}"
  hash_key   = "${aws_dynamodb_table.kong-dynamodb-table.hash_key}"
  item       = <<ITEM
 {
"id": { "N" : "3" },
"nom": {"S" : "Gingerbread" },
"libelle": { "S" :"Gingerbread man" },
"prix": { "N" : "30" },
"image_url": { "S" : "GingerbreadManTransparent.png" }
}
ITEM
}

resource "aws_dynamodb_table_item" "table-items2"{
  table_name = "${aws_dynamodb_table.kong-dynamodb-table.name}"
  hash_key   = "${aws_dynamodb_table.kong-dynamodb-table.hash_key}"
  item       = <<ITEM
 {
"id": { "N" : "4" },
"nom" : {"S" : "Train" },
"libelle" : { "S" : "Electric train set" },
"prix": { "N" : "100" },
"image_url": {"S" : "electricTrain.png" }
}
ITEM
}


