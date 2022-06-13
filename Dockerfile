FROM rabbitmq:latest
RUN apt update && apt install -y vim
EXPOSE 5672
EXPOSE 15671 15672
ADD start.sh "/start.sh"

CMD "/start.sh"
