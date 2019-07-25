output "ip" {
	value = "${aws_instance.control.public_ip}"
	description = "this is the AWS EC2 public ip"
}

output "ami" {
    value = "${aws_instance.control.ami}"
	description = "this is the ami"
}

output "s3" {
	value = "${terraform.workspace}"
	description = "AWS S3"
}

#more outputs would be nice here