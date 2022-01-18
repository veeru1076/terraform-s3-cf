variable "bucket_prefix" { 
 type        = string 
 description = "Name of the s3 bucket to be created"
 default = "sampleFilmInfo.com"
}

variable "region" { 
 type        = string 
 default     = "ap-south-1" 
 description = "Name of the s3 bucket to be created"
}
