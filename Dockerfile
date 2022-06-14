FROM rabbitmq:3.10.5-management
EXPOSE 5672
ADD start.sh "/start.sh"
RUN chmod +x /start.sh
ADD rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
ADD enabled_plugins /etc/rabbitmq/enabled_plugins

CMD "/start.sh"
