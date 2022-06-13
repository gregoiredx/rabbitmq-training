#!/bin/bash
set -m
rabbitmq-server &
rabbitmqctl await_startup
sleep 5
rabbitmqctl add_user full_access test
rabbitmqctl set_user_tags full_access "administrator"
rabbitmqctl set_permissions -p "/" full_access ".*" ".*" ".*"
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins enable rabbitmq_event_exchange
rabbitmq-plugins enable rabbitmq_tracing
rabbitmqctl trace_on
fg %1
