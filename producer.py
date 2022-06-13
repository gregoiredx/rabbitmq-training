from lib import channel, connection

channel.basic_publish(exchange="", routing_key="task_queue", body=b"Hello")

connection.close()
