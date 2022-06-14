#!/bin/bash
set -m
set -x
set -e

cp /run/secrets/shared-cookie /var/lib/rabbitmq/.erlang.cookie
chmod 400 /var/lib/rabbitmq/.erlang.cookie

rabbitmq-server &

sleep 10
if [[ "$RUN_CMDS" == "true" ]]
then
  rabbitmqctl await_startup
  rabbitmq-plugins enable rabbitmq_event_exchange
  rabbitmq-plugins enable rabbitmq_tracing
  rabbitmqctl trace_on
fi

fg %1
