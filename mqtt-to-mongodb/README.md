# Kafka Connect with MQTT and MongoDB

This is a demo that chain MQTT broker, kafka and MongoDB. It enables user to submit message from MQTT client, the message will be send to Kafka and then stored in MongoDB.

The Kafka use [Kafka Connect MQTT](https://www.confluent.io/connector/kafka-connect-mqtt/) to connect to MQTT broker(Mosquitto), and use [Kafka Connect MongoDB Sink](https://www.confluent.io/connector/kafka-connect-mongodb-sink/) to connect to MongoDB.

## Setup the Environment

Use docker compose to setup the demo env on your local machine.

### Prepare the Connectors

We can download the connectors ([MQTT](https://www.confluent.io/connector/kafka-connect-mqtt/) as well as [MongoDB](https://www.confluent.io/connector/kafka-connect-mongodb-sink/)) from the Confluent hub. After that, we have to unpack the jars and move them into a folder(Let’s use the folder `/tmp/custom/jars` for that).

### Run docker compose file

Run command `docker-compose up` to spin up the env.

### Config the connectors

Run commands below to config connectors.

```
curl -d @connect-mqtt-source.json -H "Content-Type: application/json" -X POST http://localhost:8083/connectors
curl -d @connect-mongodb-sink.json -H "Content-Type: application/json" -X POST http://localhost:8083/connectors
```

You can also use commands to manage connectors.

```
# Delete connectors
curl -X DELETE http://localhost:8083/connectors/mqtt-source
curl -X DELETE http://localhost:8083/connectors/mongodb-sink

# Get all connectors
curl -H "Content-Type: application/json" -X GET http://localhost:8083/connectors

# Get a specific connector
curl -H "Content-Type: application/json" -X GET http://localhost:8083/connectors/<connector name>

```

### Create database and collection

We need login MongoDB web client to create a database and a collection(table) to store messages from Kafka.

Open a browser and input `http://localhost:3000/`. Click the `Connect` button in the top-right corner.

Fill the dialog `Add Connection`. `Host/Port` is `mongo-db` and `Database Name` is `test`.

Then create a collection `MyCollection` in the database `test`.

### Check the test

Run command below to submit a MQTT message:

```
docker run -it --rm --network=mqtttomongodb_default --name mqtt-publisher efrecon/mqtt-client pub -h mosquitto  -t "mqtt-topic1" -m "{\"id\":1234,\"message\":\"This is a test\"}"
```

Run command below to subscribe the message from Kafka:

```
docker run --rm --network=mqtttomongodb_default confluentinc/cp-kafka:5.1.0 kafka-console-consumer --bootstrap-server kafka:9092 --topic kafka-topic1 --from-beginning
```

Open MongoDB web clinet(http://localhost:3000/) and check whether the data written into the database.


## Note

The format of the message submitted to the MQTT client has to be `json`. Or it might breake the mongo-db sink connector.


Reference:
https://www.baeldung.com/kafka-connect-mqtt-mongodb