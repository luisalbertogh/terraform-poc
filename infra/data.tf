# ─── AWS account and region context ──────────────────────────────────────────

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# ─── Lambda deployment package ────────────────────────────────────────────────
# Packages all files under src/ into a ZIP archive for Lambda deployment.
# The resulting lambda_function.zip is auto-generated and should not be
# committed to source control.

data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/lambda_function.zip"
}
