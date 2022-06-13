#!/bin/bash
set -m
set -x
set -e

echo -n "$RABBIT_COOKIE" > /var/lib/rabbitmq/.erlang.cookie
chmod ag-rwx /var/lib/rabbitmq/.erlang.cookie

rabbitmq-server &

sleep 5
rabbitmqctl add_user full_access test
rabbitmqctl set_user_tags full_access "administrator"
rabbitmqctl set_permissions -p "/" full_access ".*" ".*" ".*"
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins enable rabbitmq_event_exchange
rabbitmq-plugins enable rabbitmq_tracing
rabbitmqctl trace_on

if [[ "$NODE_TO_JOIN" == "" ]]
then
  echo "############# MAIN NODE STARTED $RABBITMQ_NODENAME"
else
  echo "############# NODE $RABBITMQ_NODENAME JOINING $NODE_TO_JOIN"
  rabbitmqctl stop_app
  rabbitmqctl reset
  rabbitmqctl join_cluster rabbit@server-1
  rabbitmqctl start_app
fi

fg %1
