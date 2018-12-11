resource "aws_instance" "instance" {
  ami                         = "ami-0fde5bdbf377cb447"
  source_dest_check           = false
  instance_type               = "t2.medium"
  subnet_id                   = "${aws_subnet.subnet.id}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]

  tags {
    Name = "kong"
  }
}
