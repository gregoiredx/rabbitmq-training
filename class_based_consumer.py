import pika
from pika import spec
from pika.adapters.blocking_connection import BlockingChannel

from lib import connection


class Consumer:
    def __init__(self, channel: BlockingChannel, queue: str):
        self.channel = channel
        self.queue = queue

    def handle_message(self, body: bytes) -> None:
        raise NotImplemented

    def start_consuming(self) -> None:
        # see https://github.com/pika/pika/blob/main/docs/examples/blocking_consumer_generator.rst
        for method_frame, properties, body in self.channel.consume(self.queue):
            self.handle_message(body)
            self.channel.basic_ack(delivery_tag=method_frame.delivery_tag)

    def stop_consuming(self) -> None:
        self.channel.cancel()


class PrintMessageConsumer(Consumer):
    def handle_message(self, body: bytes) -> None:
        print(f"Message received: {body}")


consumer = PrintMessageConsumer(connection.channel(), "task_queue")
try:
    consumer.start_consuming()
except KeyboardInterrupt:
    consumer.stop_consuming()
    connection.close()
