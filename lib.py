import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(host="localhost"))
channel = connection.channel()

channel.queue_declare(
    queue="task_queue", durable=True, exclusive=False, auto_delete=False
)
