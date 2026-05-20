# ─── AWS account and region context ──────────────────────────────────────────

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
