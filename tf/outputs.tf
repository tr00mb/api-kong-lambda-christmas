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
