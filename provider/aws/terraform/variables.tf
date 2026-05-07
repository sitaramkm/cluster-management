# ---------------------------------------------------------------------------
# Common — set in common.env or overrides.env
# ---------------------------------------------------------------------------

variable "resource_prefix" {
  type        = string
  description = "Short prefix for all resource names (e.g. 'ski-001')."
  default     = "demo"
}

variable "owner" {
  type        = string
  description = "Owner tag value; used in default tag map."
  default     = "me"
}

# ---------------------------------------------------------------------------
# AWS / EKS
# ---------------------------------------------------------------------------

variable "cluster_name" {
  type        = string
  description = "EKS cluster name. Defaults to <resource_prefix>-eks via aws.env."
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "eks_k8s_version" {
  type    = string
  default = "1.35"
}

# ---------------------------------------------------------------------------
# Node group
# ---------------------------------------------------------------------------

variable "nodegroup_name" {
  type        = string
  description = "Managed node group name. Defaults to <resource_prefix>-ng via aws.env."
}

variable "node_type" {
  type    = string
  default = "t3.medium"
}

variable "nodes" {
  type    = number
  default = 4
}

variable "nodes_min" {
  type    = number
  default = 3
}

variable "nodes_max" {
  type    = number
  default = 4
}

# ---------------------------------------------------------------------------
# Features
# ---------------------------------------------------------------------------

variable "enable_oidc" {
  type        = bool
  description = "Create an IAM OIDC provider for the cluster (required for IRSA)."
  default     = true
}

variable "managed_nodegroup" {
  type        = bool
  description = "Use managed node groups (vs self-managed). Currently only managed is implemented."
  default     = true
}

# ---------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# ---------------------------------------------------------------------------
# Access control
# ---------------------------------------------------------------------------

variable "local_public_ip" {
  type        = string
  description = "Caller's public IP in CIDR form (e.g. 1.2.3.4/32). Set automatically by eks.sh."
}

variable "allowed_additional_CIDR" {
  type        = list(string)
  description = "Extra CIDRs allowed to reach the EKS API endpoint, as a JSON array."
  default     = []
}

# ---------------------------------------------------------------------------
# Tags
# ---------------------------------------------------------------------------

variable "aws_tags" {
  type        = map(string)
  description = "Tags applied to all AWS resources. Set as JSON in aws.env or overrides.env."
  default     = {}
}
