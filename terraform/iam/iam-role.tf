 resource "aws_iam_role" "dev_codepipeline_role" {
  name = "dev_codepipeline_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_codestarconnections_connection" "connect_github" {
  name          = "connect_github"
  provider_type = "GitHub"
}

resource "aws_s3_bucket" "dev_codepipeline_bucket" {
  bucket = var.aws_s3_bucket_pipe_artifact
  force_destroy = true
}

resource "aws_s3_bucket_acl" "dev_codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.dev_codepipeline_bucket.id
  acl    = "private"
}


resource "aws_iam_role_policy" "dev_codepipeline_policy" {
  name = "dev_codepipeline_policy"
  role = aws_iam_role.dev_codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.dev_codepipeline_bucket.arn}",
        "${aws_s3_bucket.dev_codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${aws_codestarconnections_connection.connect_github.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

// -------------------------------- Codebuild -------------------------------- //

resource "aws_iam_role" "dev_codebuild_role" {
  name = "dev_codebuild_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_s3_bucket" "dev_codebuild_bucket" {
  bucket = var.aws_s3_bucket
  force_destroy = true
}

resource "aws_s3_bucket_acl" "dev_codebuild_bucket_acl" {
  bucket = aws_s3_bucket.dev_codebuild_bucket.id
  acl    = "private"
}


resource "aws_iam_role_policy" "dev_codebuild_policy" {
  name = "dev_codebuild_policy"
  role = aws_iam_role.dev_codebuild_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::test-bucket-quyhm/*"
      ]
    },
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "cloudfront:CreateInvalidation",
      "Resource": "arn:aws:cloudfront::774497707586:distribution/*"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:DescribeLogGroups",
        "logs:FilterLogEvents",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:774497707586:log-group:*"
    },
    {
      "Sid": "VisualEditor2",
      "Effect": "Allow",
      "Action": "logs:CreateLogDelivery",
      "Resource": "*"
    }
  ]
}
EOF
}