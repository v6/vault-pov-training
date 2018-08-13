variable "my_name" {
  default = "training-user-deleteme"
}

variable "vpc_id" {
  // SE Default VPC for us-east-1
  default = "vpc-972d08ec"
}

variable "public_key" {
  // Hint: export TF_VAR_private_key=$(cat private_key.pem)
  description = "Public portion of key pair to create in order to access hosts. Sensitive variable."
}

resource "random_id" "training" {
  keepers = {
    # Generate a new id for each student
    my_name = "${var.my_name}"
  }
  byte_length = 8
}

variable "training_ami" {
  default = "ami-6871a115"
}

variable "region" {
  default = "us-east-1"
}
