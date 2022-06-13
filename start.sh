#!/bin/bash
set -m
set -x
set -e

rabbitmq-server &

sleep 5
rabbitmqctl add_user full_access test
rabbitmqctl set_user_tags full_access "administrator"
rabbitmqctl set_permissions -p "/" full_access ".*" ".*" ".*"
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins enable rabbitmq_event_exchange
rabbitmq-plugins enable rabbitmq_tracing
rabbitmqctl trace_on

if [[ "$SECONDARY_NODE" == "true" ]]
then
  echo "############# JOINING CLUSTER rabbit@rabbitmq-training-server-1"
  rabbitmqctl stop_app
  rabbitmqctl reset
  rabbitmqctl join_cluster rabbit@rabbitmq-training-server-1
  rabbitmqctl start_app
else
  echo "############# MAIN NODE STARTING rabbit@rabbitmq-training-server-1"
fi

fg %1
