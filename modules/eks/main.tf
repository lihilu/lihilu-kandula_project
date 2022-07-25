data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
}

resource "kubernetes_service_account" "opsschool_sa" {
  metadata {
    name      = local.k8s_service_account_name
    namespace = local.k8s_service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin.iam_role_arn
    }
  }
  depends_on = [module.eks]
}
resource "kubernetes_service_account" "lihi_kandula_sa" {
  metadata {
    name      = local.k8s_service_account_name_lihi
    namespace = local.k8s_service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_kandula.iam_role_arn
    }
  }
  depends_on = [module.eks]
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.20"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.private_subnet_ids_list
  vpc_id = var.my_vpc_id
  enable_irsa = true

  eks_managed_node_group_defaults = {
      ami_type               = "AL2_x86_64"
      instance_types         = ["t3.micro"]
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    eks_group_1 = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
      instance_types = ["t2.medium"]
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
      tags = {
        purpose = var.default_tags
        k8s         = "true"
        consul_join = var.consul_join_tag_value
      }
    }

    eks_group_2 = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
      instance_types = ["t2.medium"]
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
      tags = {
        purpose = var.default_tags
        k8s         = "true"
        consul_join = var.consul_join_tag_value
      }
    }
  }
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::314452776120:user/Administrator"
      username = "Administrator"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::314452776120:role/ansible-server-aws-iam-role"
      username = "ansible-server-aws-iam-role"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::314452776120:role/jenkins_server_iam_role"
      username = "jenkins_server_iam_role"
      groups   = ["system:masters"]
    },
        {
      rolearn  = "arn:aws:iam::314452776120:role/opsschool_kandula_role"
      username = "opsschool_kandula_role"
      groups   = ["system:masters"]
    },

  ]
  tags = {
    purpose    = var.default_tags
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
    consul_join = var.consul_join_tag_value
  }

}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.7.0"
  create_role                   = true
  role_name                     = "opsschool-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
}

module "iam_assumable_role_kandula" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.7.0"
  create_role                   = true
  role_name                     = "opsschool_kandula_role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess",
                                    var.jenkins_agent_role_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name_lihi}"]
}


resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = var.my_vpc_id
  ingress {
    from_port = 22
    to_port   = 100
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    protocol  = "tcp"
    to_port   = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port = 9090
    to_port   = 9099
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "Node exporter port"
    from_port   = 8000
    to_port     = 8900
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description = "Node exporter port"
    from_port   = 9100
    to_port     = 15000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
   }
}

