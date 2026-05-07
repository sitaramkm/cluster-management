# Additional security group attached to the EKS control plane.
# The API endpoint IP restriction is handled via public_access_cidrs in eks.tf.
# This group exists so we have a Terraform-managed SG to attach custom ingress/egress
# rules to in the future (e.g. allow-port).

resource "aws_security_group" "cluster_additional" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Additional rules for EKS cluster control plane"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.aws_tags, {
    Name = "${var.cluster_name}-cluster-sg"
  })
}
