variable "bucket_name" {
  type    = string
  default = "ipgame2bucket"
}



variable "email_addresses" {
  type    = list(string)
  default = [""]
}


/*
variable "bucket_name" {
  type = map(string)
  default = {}
}
*/
