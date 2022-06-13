#!/bin/bash
set -m
set -x
set -e

echo -n "$RABBIT_COOKIE" > /var/lib/rabbitmq/.erlang.cookie
chmod ag-rwx /var/lib/rabbitmq/.erlang.cookie

rabbitmq-server &

if [[ "$NODE_TO_JOIN" == "" ]]
then
  echo "############# STARTING MAIN NODE $RABBITMQ_NODENAME"
  sleep 5
  rabbitmqctl add_user full_access test
  rabbitmqctl set_user_tags full_access "administrator"
  rabbitmqctl set_permissions -p "/" full_access ".*" ".*" ".*"
  rabbitmq-plugins enable rabbitmq_management
  rabbitmq-plugins enable rabbitmq_event_exchange
  rabbitmq-plugins enable rabbitmq_tracing
  rabbitmqctl trace_on
else
  echo "############# NODE $RABBITMQ_NODENAME JOINING $NODE_TO_JOIN"
  sleep 10
  rabbitmqctl stop_app
  rabbitmqctl reset
  rabbitmqctl join_cluster "$NODE_TO_JOIN"
  rabbitmqctl start_app
fi

fg %1
