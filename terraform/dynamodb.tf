resource "aws_dynamodb_table" "iot-table" {
  name           = "myIoTTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }
}