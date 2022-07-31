locals {
  s3_origin_id = "myS3Origin"
}


resource "aws_cloudfront_origin_access_identity" "cloudfront-oai" {
  comment = "oai-for-test"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.dev_codebuild_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront-oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    compress = true
    

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.dev_codebuild_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront-oai.iam_arn]
    }
  }
}


// Allow codebuild put objects

data "aws_iam_policy_document" "s3_policy_put" {
  source_policy_documents = [data.aws_iam_policy_document.s3_policy.json]
  statement {
    actions   = ["s3:PutObject", "s3:PutObjectAcl"]
    resources = ["${aws_s3_bucket.dev_codebuild_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.dev_codebuild_role.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "codebuild_put_policy" {
  bucket = aws_s3_bucket.dev_codebuild_bucket.id
  policy = data.aws_iam_policy_document.s3_policy_put.json
}