resource "aws_iam_policy" "iot_all_access" {
  name = "myAllAccessIoTPolicy"
  description = "My all access IoT policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "iot:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iot_policy" "pubsub" {
  name = "PubSubToAnyTopic"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iot:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iot_certificate" "cert" {
  csr    = "${file("eric.csr")}"
  active = true
}

resource "aws_iot_policy_attachment" "att" {
  policy = "${aws_iot_policy.pubsub.name}"
  target = "${aws_iot_certificate.cert.arn}"
}


resource "aws_iam_policy" "iot-dynamodb-write" {
  name = "iot-dynamodb-write"
  path = "/service-role/"
  description = "Write data to dynamodb"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "dynamodb:PutItem",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "iot-dynamodb-write" {
  name               = "iot-dynamodb-write"
  path               = "/service-role/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": "iot.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iot-dynamodb-write-attach" {
  role       = "${aws_iam_role.iot-dynamodb-write.name}"
  policy_arn = "${aws_iam_policy.iot-dynamodb-write.arn}"
}

resource "aws_iot_topic_rule" "to_dynamodb" {
  name = "toDynamoDB"
  description = "Write data to DynamoDB"
  enabled = true
  sql = "SELECT * FROM 'topic/${local.iot_topic}'"
  sql_version = "2016-03-23"

  dynamodb {
    table_name = "${aws_dynamodb_table.iot-table.name}"
    role_arn = "${aws_iam_role.iot-dynamodb-write.arn}"
    hash_key_field = "${aws_dynamodb_table.iot-table.hash_key}"
    hash_key_value = "$${${aws_dynamodb_table.iot-table.hash_key}}"
  }
}