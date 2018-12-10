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

resource "aws_s3_bucket_object" "kong_bucket_objectTrain" {
  bucket = "${aws_s3_bucket.kong_bucket.id}"
  key    = "items/electricTrain.png"
  source = "items/electricTrain.png"
}

resource "aws_s3_bucket_object" "kong_bucket_objectGinger" {
  bucket = "${aws_s3_bucket.kong_bucket.id}"
  key    = "items/GingerbreadManTransparent.png"
  source = "items/GingerbreadManTransparent.png"
}

resource "aws_s3_bucket_object" "kong_bucket_objectDoll" {
  bucket = "${aws_s3_bucket.kong_bucket.id}"
  key    = "items/ragDoll.png"
  source = "items/ragDoll.png"
}

resource "aws_s3_bucket_object" "kong_bucket_objectGame" {
  bucket = "${aws_s3_bucket.kong_bucket.id}"
  key    = "items/videoGame.png"
  source = "items/videoGame.png"
}

resource "aws_s3_bucket_object" "kong_bucket_objectHorse" {
  bucket = "${aws_s3_bucket.kong_bucket.id}"
  key    = "items/woodenHorse.png"
  source = "items/woodenHorse.png"
}
