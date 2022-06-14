import pika

from lib import channel, connection


def on_message_callback(_channel, method_frame, header_frame, body):
    print(f"Message received: {method_frame.delivery_tag} {body}")
    _channel.basic_ack(delivery_tag=method_frame.delivery_tag)


channel.basic_consume(queue="task_queue", on_message_callback=on_message_callback)

try:
    channel.start_consuming()
except KeyboardInterrupt:
    channel.stop_consuming()
    connection.close()
