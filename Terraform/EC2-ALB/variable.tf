variable "regions" {
  type = map(any)
}
variable "product" {
  default = "poc"
}
variable "environment" {
  type = any
}
variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}