#
# Copyright (c) 2021-present Aaron Delasy
# Licensed under the MIT License
#

resource "aws_codepipeline" "api" {
  name       = "the-api"
  role_arn   = aws_iam_role.code_pipeline.arn
  depends_on = [aws_iam_role_policy_attachment.code_pipeline_full]

  artifact_store {
    location = data.aws_s3_bucket.private.bucket
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
        ConnectionArn        = data.aws_codestarconnections_connection.langthe.arn
        FullRepositoryId     = "langthe/api"
        BranchName           = "main"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }
}