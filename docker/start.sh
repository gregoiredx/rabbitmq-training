#!/bin/bash
set -mxe

cp /run/secrets/shared-cookie /var/lib/rabbitmq/.erlang.cookie
chmod 400 /var/lib/rabbitmq/.erlang.cookie

export RABBITMQ_PID_FILE=/var/run/rabbitmq/pid
rabbitmq-server &
rabbitmqctl wait /var/run/rabbitmq/pid
rabbitmqctl await_startup
rabbitmqctl trace_on

fg %1
