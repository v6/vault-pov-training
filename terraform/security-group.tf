module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "vpc_${var.my_name}_training"
  cidr = "10.0.0.0/16"

  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.50.0/24"]
  azs = ["${element(data.aws_availability_zones.available.names,0)}"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "development"
    Owner = "${var.my_name}"
  }
}

resource "aws_security_group" "vault_training" {
  name = "training_${var.my_name}_${random_id.training.hex}"
  description = "Very insecure Vault and Consul SG - for training purposes only"
  vpc_id = "${module.vpc.vpc_id}"

  tags {
    Name    = "vault_training_${var.my_name}_${random_id.training.hex}"
    TTL = "24"
  }

  // Ultimately we're allowing everything. Calling out specific
  // ports for clarity and documentation purposes.

  // SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Vault Client Traffic
  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Vault Cluster Traffic
  ingress {
    from_port = 8201
    to_port   = 8201
    protocol  = "tcp"
    self      = true
  }

  // DNS (TCP)
  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // DNS (UDP)
  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // HTTP Consul
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Serf (TCP)
  ingress {
    from_port   = 8301
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Serf (UDP)
  ingress {
    from_port   = 8301
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Consul Server RPC
  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // RPC Consul
  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // UDP All outbound traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // All Traffic - Egress
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

// Open up the shop!
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}
