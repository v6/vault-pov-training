provider "aws" {
  region = "${var.region}"
}

resource "aws_key_pair" "training" {
  key_name   = "vault_training_${var.my_name}_${random_id.training.hex}"
  public_key = "${var.public_key}"
}

resource "aws_instance" "vault_training_instance" {
  ami                         = "${var.training_ami}"
  instance_type               = "t2.small"
  associate_public_ip_address = "true"
  security_groups             = ["${aws_security_group.vault_training.name}"]
  key_name                    = "${aws_key_pair.training.key_name}"

  tags {
    Name = "HashiCorp_Training_August_2018_${var.my_name}_${random_id.training.hex}"
    TTL = "24"
  }
}

// Outputs
output "Access to your VM:" {
    value = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.vault_training_instance.public_dns}"
}

output "Vault UI access (after installation):" {
    value = "http://${aws_instance.vault_training_instance.public_dns}:8200"
}

output "Consul UI access (after installation):" {
    value = "http://${aws_instance.vault_training_instance.public_dns}:8300"
}

output "AWS Key Name" {
    value = "${aws_key_pair.training.key_name}"
}
