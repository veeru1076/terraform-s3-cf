provider "aws" {
     region = var.region
 }
resource "aws_s3_bucket" "prod_website" { 
 bucket_prefix = var.bucket_prefix 
 acl    = "public-read"   
 website {   
   index_document = "upload.html"   
   error_document = "error.html" 
 }
}
resource "aws_s3_bucket_policy" "prod_website_policy" { 
   bucket = aws_s3_bucket.prod_website.id
   policy = <<POLICY
   {   
       "Version": "2012-10-17",   
       "Statement": [       
       {           
           "Sid": "PublicReadGetObject",           
           "Effect": "Allow",           
           "Principal": "*",           
           "Action": [               
               "s3:GetObject"           
           ],           
           "Resource": [
               "arn:aws:s3:::${aws_s3_bucket.prod_website.id}/*"           
           ]       
       }   
       ]
   }
   POLICY
}
 
# Cloudfront distribution for main s3 site.
resource "aws_cloudfront_distribution" "sample_s3_distribution" {
 origin {
   domain_name = aws_s3_bucket.prod_website.bucket_regional_domain_name
   origin_id = "${var.bucket_prefix}-origin"
 }
 
 enabled = true
 is_ipv6_enabled = true
 default_root_object = "upload.html"
 
 #aliases = ["${var.bucket_prefix}"]
 
 default_cache_behavior {
   allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH","POST", "PUT"]
   cached_methods = ["GET", "HEAD"]
   target_origin_id = "${var.bucket_prefix}-origin"
   forwarded_values {
     query_string = false
     cookies {
       forward = "none"
     }
   }
   viewer_protocol_policy = "allow-all"
   min_ttl = 0
   default_ttl = 1000
   max_ttl = 86400
 }
 restrictions {
   geo_restriction {
     restriction_type = "none"
   }
 }
 viewer_certificate {
    cloudfront_default_certificate = true
  }
}
