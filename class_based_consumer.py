import pika
from pika import spec
from pika.adapters.blocking_connection import BlockingChannel

from lib import connection


class Consumer:
    def __init__(self, channel: BlockingChannel, queue: str):
        self.channel = channel
        self.queue = queue

    def on_message_callback(
        self,
        _channel: BlockingChannel,
        method: spec.Basic.Deliver,
        properties: spec.BasicProperties,
        body: bytes,
    ) -> None:
        self.handle_message(body)
        _channel.basic_ack(delivery_tag=method.delivery_tag)

    def handle_message(self, body: bytes) -> None:
        raise NotImplemented

    def start_consuming(self) -> None:
        self.channel.basic_consume(self.queue, self.on_message_callback)
        self.channel.start_consuming()

    def stop_consuming(self) -> None:
        self.channel.stop_consuming()


class PrintMessageConsumer(Consumer):
    def handle_message(self, body: bytes) -> None:
        print(f"Message received: {body}")


consumer = PrintMessageConsumer(connection.channel(), "task_queue")
try:
    consumer.start_consuming()
except KeyboardInterrupt:
    consumer.stop_consuming()
    connection.close()
