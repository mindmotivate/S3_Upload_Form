variable "bucket_name" {
  type    = string
  default = "enteryourbucketnamehere"
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
