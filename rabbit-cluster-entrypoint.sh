#!/bin/bash
set -eu 
IFS=$'\n\t'

if [ "$1" = 'rabbitmq-server' ]; then
	(
		sleep 10
		  
		if [ -z "${RABBITMQ_CLUSTER_NODES-}" ]; then
		  echo "Starting Single Server Instance"
		else
		  echo "Starting Clustered Server Instance"

		  #Wait for server startup
		  #rabbitmqctl wait /var/run/rabbitmq/pid

		  echo "Stopping App with /usr/sbin/rabbitmqctl stop_app"
		  rabbitmqctl stop_app

		  IFS=','; read -ra xs <<< "$RABBITMQ_CLUSTER_NODES"
		  for i in "${xs[@]}"; do
			echo "<< Joining cluster with [$i] ... >>"
			rabbitmqctl join_cluster "$i"
			echo "<< Joining cluster with [$i] DONE >>"
		  done

		  echo "Starting App in Cluster mode"
		  rabbitmqctl start_app
		fi

		rabbitmqctl set_policy \
			HA \
			'.*' \
			'{"ha-mode":"all","ha-sync-mode":"automatic"}' \
			--priority 0 \
			--apply-to queues

	) & docker-entrypoint.sh rabbitmq-server
else 
	docker-entrypoint.sh "$@"
fi
