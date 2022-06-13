#!/bin/bash
set -m
rabbitmq-server &
rabbitmqctl await_startup
rabbitmqctl add_user full_access test
rabbitmqctl set_user_tags full_access "administrator"
rabbitmqctl set_permissions -p "/" full_access ".*" ".*" ".*"
rabbitmq-plugins enable rabbitmq_management
fg %1
