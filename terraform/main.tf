provider "aws" {
  region = "${var.region}"
}

resource "aws_key_pair" "training" {
  key_name   = "vault_training_${var.my_name}_${random_id.training.hex}"
  public_key = "${var.public_key}"
}

resource "aws_instance" "vault_training_instance" {
  ami                         = "${var.training_ami}"
  count                       = "3"
  instance_type               = "t2.small"
  associate_public_ip_address = "true"
  security_groups             = ["${aws_security_group.vault_training.id}"]
  key_name                    = "${aws_key_pair.training.key_name}"
  subnet_id = "${element(module.vpc.public_subnets,0)}"

  connection {
    user = "ec2-user"
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install unzip",
      "sudo curl -o vault.zip ${var.binaries_url}/vault/ent/0.10.4/vault-enterprise_0.10.4%2Bent_linux_amd64.zip",
      "sudo curl -o consul.zip ${var.binaries_url}/consul/ent/1.2.2/consul-enterprise_1.2.2%2Bent_linux_amd64.zip",
      "sudo unzip consul.zip -d /usr/local/bin/",
      "sudo unzip vault.zip -d /usr/local/bin/",
    ]
  }

  tags {
    Name = "HashiCorp_Training_August_2018_${var.my_name}_${random_id.training.hex}"
    TTL = "24"
  }
}

// Outputs
output "Your EC2 instances:" {
    value = "${aws_instance.vault_training_instance.*.public_dns}"
}

output "Your EC2 instance IP addresses:" {
    value = "${aws_instance.vault_training_instance.*.public_ip}"
}

output "Access to your VMs:" {
    value = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.vault_training_instance.0.public_dns}"
}

output "Vault UI access (after installation):" {
    value = "http://${aws_instance.vault_training_instance.0.public_dns}:8200"
}

output "Consul UI access (after installation):" {
    value = "http://${aws_instance.vault_training_instance.0.public_dns}:8300"
}

output "AWS Key Name" {
    value = "${aws_key_pair.training.key_name}"
}
