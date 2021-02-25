provider "aws" {
  region = var.aws_region
}

// The domain certificate needs to be created in us-east-1
// We create a provider with `use1` alias just for this purpose
provider "aws" {
  region = "us-east-1"
  alias = "use1"
}

locals {
  domain = "react-aws-terraform-github-actions.andyjones.co"
  s3_origin_id = "s3-react-aws-terraform-github-actions"
}

resource "aws_s3_bucket" "react-aws-terraform-github-actions-s3-bucket" {
  bucket = var.bucket_name
  acl = "public-read"
  policy = data.aws_iam_policy_document.s3-website-policy.json

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "react-aws-terraform-github-actions-s3-access-control" {
  bucket = aws_s3_bucket.react-aws-terraform-github-actions-s3-bucket.id

  block_public_acls   = true
  ignore_public_acls = true
}

resource "aws_acm_certificate" "react-aws-terraform-github-actions-cert" {
  provider = aws.use1
  domain_name = local.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_distribution" "react-aws-terraform-github-actions" {
  enabled = true
  is_ipv6_enabled = true
  comment = "The cloudfront distribution for react-aws-terraform-github-actions.andyjones.co"
  default_root_object = "index.html"

  aliases = [local.domain]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.react-aws-terraform-github-actions-s3-bucket.bucket_regional_domain_name
    origin_id = local.s3_origin_id
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.react-aws-terraform-github-actions-cert.arn
    ssl_support_method = "sni-only"
  }
  custom_error_response {
    error_code = 404
    error_caching_min_ttl = 86400
    response_page_path = "/index.html"
    response_code = 200
  }
}

resource "aws_iam_policy" "cloudfront-invalidate-paths" {
  name = "cloudfront-invalidate-paths"
  description = "Used by CI pipelines to delete cached paths"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "VisualEditor0",
        Effect = "Allow",
        Action = "cloudfront:CreateInvalidation",
        Resource = "*"
      }
    ]
  })
}