resource "aws_s3_bucket" "tfcf_templates" {
  bucket_prefix = "tfcf-templates-"
}

resource "aws_s3_object" "cdktoolkit_template" {
  bucket = aws_s3_bucket.tfcf_templates.id
  key    = "CDKToolkit.yaml"
  source = "${path.module}/templates/CDKToolkit.yaml"
  etag   = filemd5("${path.module}/templates/CDKToolkit.yaml")
}

# https://github.com/aws/aws-cdk-cli/blob/main/packages/aws-cdk/lib/api/bootstrap/bootstrap-template.yaml
resource "aws_cloudformation_stack" "cdk_toolkit" {
  for_each = toset([
    "ap-southeast-2",
    "us-east-1",
  ])

  name         = "CDKToolkit"
  region       = each.value
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSCloudFormationStackSetExecutionRole"
  capabilities = ["CAPABILITY_NAMED_IAM"]

  template_url = "https://${aws_s3_bucket.tfcf_templates.bucket_regional_domain_name}/${aws_s3_object.cdktoolkit_template.key}"
  parameters = {
    FileAssetsBucketKmsKeyId      = "AWS_MANAGED_KEY"
    UseExamplePermissionsBoundary = "true"
  }

  lifecycle {
    prevent_destroy = true
  }
}
