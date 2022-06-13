"""
This requires the following server conf:

rabbitmq-plugins enable rabbitmq_event_exchange
rabbitmq-plugins enable rabbitmq_tracing
rabbitmqctl trace_on
"""
from lib import channel, connection

channel.queue_declare(
    queue="events_queue", durable=True, exclusive=False, auto_delete=False
)

channel.queue_declare(
    queue="traces_queue", durable=True, exclusive=False, auto_delete=False
)

channel.queue_declare(
    queue="events_user_auth_queue", durable=True, exclusive=False, auto_delete=False
)

# Show all system events (binding, connection, authentication, ...)
channel.queue_bind(exchange="amq.rabbitmq.event", queue="events_queue", routing_key="#")
# Show all published messages
channel.queue_bind(exchange="amq.rabbitmq.trace", queue="traces_queue", routing_key="#")
# Show only user authentication events
channel.queue_bind(
    exchange="amq.rabbitmq.event",
    queue="events_user_auth_queue",
    routing_key="user.authentication.*",
)

connection.close()
