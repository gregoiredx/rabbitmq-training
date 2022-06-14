FROM rabbitmq:latest
EXPOSE 5672
EXPOSE 15671 15672
ADD start.sh "/start.sh"
RUN chmod +x /start.sh
ADD rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
CMD "/start.sh"
