#Creates S3 Bucket for Backend 

terraform {
  backend "s3" {
    bucket = var.bucket_id   
    key    =  var.bucket_key
    region = var.region
  }
}
