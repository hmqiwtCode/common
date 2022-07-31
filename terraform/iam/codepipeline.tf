resource "aws_codepipeline" "codepipeline" {
  name     = "dev-test-pipeline"
  role_arn = aws_iam_role.dev_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.dev_codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.connect_github.arn
        FullRepositoryId = "hmqiwtCode/docker-react"
        BranchName       = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.dev-sample-build.id
      }
    }
  }
}