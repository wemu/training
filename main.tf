#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-e613ac89
#
# Your subnet ID is:
#
#     subnet-67d7090c
#
# Your security group ID is:
#
#     sg-1cbf1176
#
# Your Identity is:
#
#     terraform-training-bison
#
variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type = "string"

  default = "eu-central-1"
}

variable "aws_web_count" {
  type = "string"

  default = "3"
}

#module "example-module" {
#  source = "./example-module"
#  command = "echo 'Hello Module!!!!'"
#}

terraform {
  backend "atlas" {
    name = "wemu/training"
  }
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  # ...
  ami           = "ami-e613ac89"
  instance_type = "t2.micro"
  count = "${var.aws_web_count}"

  subnet_id              = "subnet-67d7090c"
  vpc_security_group_ids = ["sg-1cbf1176"]

  tags {
    Identity                       = "terraform-training-bison"
    Purpose                        = "ECS Training"
    CreationByUserAndDateAndReason = "wemu on 30. Oct 2017 for tagging"
    MachineNumber                  = "Da Machine: ${count.index + 1} of ${var.aws_web_count}"
  }
}

output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}
output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}
