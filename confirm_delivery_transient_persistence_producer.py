"""
https://pika.readthedocs.io/en/stable/examples/blocking_delivery_confirmations.html
"""
import uuid

import pika

from lib import channel, connection

# # Open a connection to RabbitMQ on localhost using all default parameters
# connection = pika.BlockingConnection()
#
# # Open the channel
# channel = connection.channel()
#
# # Declare the queue
# channel.queue_declare(queue="test", durable=True, exclusive=False, auto_delete=False)

# Turn on delivery confirmations
channel.confirm_delivery()

# Send a message
try:
    body = f"Hello World! {uuid.uuid4()}"
    channel.basic_publish(
        exchange="",
        routing_key="task_queue",
        body=body,
        properties=pika.BasicProperties(delivery_mode=pika.DeliveryMode.Transient),
    )
    print(f"Message {body} publish was confirmed")
except pika.exceptions.UnroutableError:
    print("Message could not be confirmed")

connection.close()
