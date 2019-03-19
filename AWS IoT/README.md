# AWS IoT Test

This project is to setup an aws IoT service, and write message from MQTT client to DynamoDB.

The way to do it manually is:
https://docs.google.com/document/d/1dG3dppI_CiKPJlFIWmY0xFffCjONQlTpNOA5SJqOOqw/edit

## Setup the test env

### Config the environment variable

Setup cloud provider auth information in your environment variable.

For example, if you are using `ubuntu` os, set the AWS auth infor in the `~/.bashrc`.

```
export AWS_ACCESS_KEY_ID="xxxxxxxx"
export AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyy"
```

### Setup IoT service

run `terraform apply` to setup IoT service.

### Prepare Certificates

#### Download Client Certificate

Login AWS console and navigate to `IoT Core` service.

Click `Secure -> Certificates` to open certificate page.

Download the client certificate created by the terraform.

#### Download AWS Root CA certificate

Download AWS Root CA certificate from: https://www.amazontrust.com/repository/AmazonRootCA1.pem

#### Get Client private key

Get Client private key `eric.key` from Eric.

### Config MQTT Client

Config MQTT Client according to the chapter `2. Set up a MQTT client` in https://docs.google.com/document/d/1dG3dppI_CiKPJlFIWmY0xFffCjONQlTpNOA5SJqOOqw/edit


## Note

### Update the rule to write DynamoDB

After you setup the AWS IoT service, and find no message written into the DynamoDB, it is because the rule that to write message to DynamoDB is not updated. You have to update it manually. (Maybe it's a bug of IoT module of Terraform)

The way to update it is:

- Click `Act` in the sidebar of AWS IoT console, double click the rule created by the Terraform.

- Click the `Edit` button of the action `Insert a message into a DynamoDB table`.

- Click `Update` button at the bottom of the page.

### Message format

If you want to store the message into DynamoDB, the format of the message has to be json, and it has to contain a field `id`. For example:

```
{
    "id": 1,
    "name": "Eric",
    "Age": 22
}

```