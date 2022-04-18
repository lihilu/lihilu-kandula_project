resource "aws_iam_role" "web_admin" {
  name        = "web_admin"
  assume_role_policy =<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action":"sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect":"Allow",
        "Sid": ""
      }
    ]
  }
EOF
}

resource "aws_iam_instance_profile" "web_admin" {
    name = "web_admin"
    role = "${aws_iam_role.web_admin.name}" 
}

resource "aws_iam_role_policy" "adminrolepo" {
    name = "adminrolepo"
    role = "${aws_iam_role.web_admin.id}"
    policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
           "s3:*"
        ],
        "Resource": [
            "arn:aws:s3:::lihi-opsschool-mid-project-state",
            "arn:aws:s3:::lihi-opsschool-mid-project-state/*"
        ]
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::*"
    }
  ]
}
EOT
}