# Create an IAM role for the auto-join
resource "aws_iam_role" "jenkins" {
  name               = "jenkins_server_iam_role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_instance_role.json
}

# defines JSON for instance role base IAM policy
data "aws_iam_policy_document" "jenkins_instance_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create the policy
resource "aws_iam_policy" "jenkins" {
  name        = "jenkins_server_iam_policy"
  description = "Allows jenkins instances to describe instances for joining consul DC."
  policy      = data.aws_iam_policy_document.jenkins_policy.json
}

data "aws_iam_policy_document" "jenkins_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "s3:GetObject",
      "s3:PutObject",
      "eks:*",
      "s3:ListBucket"
    ]
    resources = ["*"]
  }
}

# Attach the policy
resource "aws_iam_policy_attachment" "jenkins" {
  name       = format("jenkins-%s", var.default_tags)
  roles      = [aws_iam_role.jenkins.name]
  policy_arn = aws_iam_policy.jenkins.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "jenkins" {
  name = format("jenkins-%s", var.default_tags)
  role = aws_iam_role.jenkins.name
}


resource "aws_iam_role" "jenkins_agents" {
  name               = "jenkins_agents_iam_role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_instance_role.json
}

resource "aws_iam_policy" "jenkins_agents" {
  name        = "jenkins_agents_ian_policy"
  description = "Allows jenkins agents instances to describe instances for joining consul DC. And deploy to EKS"
  policy      = data.aws_iam_policy_document.jenkins_agent_policy.json
}

data "aws_iam_policy_document" "jenkins_agent_policy" {
  statement {
    effect = "Allow"
    actions = [
      "eks:AccessKubernetesApi",
      "eks:DescribeCluster",
      "eks:DescribeIdentityProviderConfig",
      "eks:DescribeNodegroup",
      "eks:ListClusters",
      "eks:ListNodegroups",
      "acm:ListCertificates"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy_attachment" "jenkins_agents" {
  name       = format("jenkins-agents-%s", var.default_tags)
  roles      = [aws_iam_role.jenkins_agents.name]
  policy_arn = aws_iam_policy.jenkins_agents.arn
}

resource "aws_iam_instance_profile" "jenkins_agents" {
  name = format("jenkins-agents-%s", var.default_tags)
  role = aws_iam_role.jenkins_agents.name
}
