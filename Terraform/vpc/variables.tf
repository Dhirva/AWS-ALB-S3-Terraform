variable "regions" {
  type = map(any)
}
variable "product" {
  default = "poc"
}
variable "environment" {
  type = any
}
