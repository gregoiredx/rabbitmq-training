#!/bin/bash
set -m
set -x
set -e

echo -n "$RABBIT_COOKIE" > /var/lib/rabbitmq/.erlang.cookie
chmod ag-rwx /var/lib/rabbitmq/.erlang.cookie

rabbitmq-server &

sleep 10
if [[ "$RUN_CMDS" == "true" ]]
then
  rabbitmqctl await_startup
  rabbitmqctl add_user full_access test || true
  rabbitmqctl set_user_tags full_access "administrator"
  rabbitmqctl set_permissions -p "/" full_access ".*" ".*" ".*"
  rabbitmq-plugins enable rabbitmq_management
  rabbitmq-plugins enable rabbitmq_event_exchange
  rabbitmq-plugins enable rabbitmq_tracing
  rabbitmqctl trace_on
fi

fg %1
