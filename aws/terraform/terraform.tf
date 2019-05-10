terraform {
 backend "s3" {
 encrypt = true
 bucket = "terraform-remote-state-storage-klarrio-apac"
 dynamodb_table = "terraform-state-lock-dynamo-klarrio-apac"
 region = "ap-southeast-2"
 key = "apac/demo/eks/terraform.tfstate"
 }
}