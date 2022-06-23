resource "aws_iam_role" "ansible" {
  name               = "ansible-server-aws-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "ansible" {
  name        = "ansibke-server-iam-policy"
  description = "Allows server to describe instances And deploy to EKS"
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_policy_attachment" "ansible" {
  name       = "ansile-ian-policy-attach"
  roles      = [aws_iam_role.ansible.name]
  policy_arn = aws_iam_policy.ansible.arn
}

resource "aws_iam_instance_profile" "ansible" {
  name = "ansible-iam-instance-profile"
  role = aws_iam_role.ansible.name
}



# assume role
data "aws_iam_policy_document" "assume_role" {
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

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"
    actions = [
        "eks:*",
        "ec2:DescribeInstances"
    ]
    resources = ["*"]
  }
}
