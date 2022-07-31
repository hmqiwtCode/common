resource "aws_codebuild_project" "dev-sample-build" {
  name          = "dev-sample-build"
  service_role  = aws_iam_role.dev_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "dev-codebuild"
    }
  }

  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 1
    buildspec = templatefile("./build/buildspec.yml", { bucket = "${var.aws_s3_bucket}", cloudfront_id ="${aws_cloudfront_distribution.s3_distribution.id}" })

    git_submodules_config {
      fetch_submodules = true
    }
  }
}