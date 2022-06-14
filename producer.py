import time
import uuid

from lib import channel, connection

try:
    while True:
        message = f"Hello {uuid.uuid4()}"
        print(f"sending '{message}'")
        channel.basic_publish(
            exchange="",
            routing_key="task_queue",
            body=message.encode("ASCII"),
        )
        time.sleep(1)
except KeyboardInterrupt:
    connection.close()
