#!/bin/bash
# check if flink-jobmanager is running
if [ "$(docker inspect -f '{{.State.Running}}' flink-jobmanager 2>/dev/null)" != "true" ]; then
  echo "❌ Flink JobManager is not running. Please start the environment first by running ./init.sh"
  exit 1
fi
docker exec -it flink-jobmanager /opt/flink/bin/sql-client.sh
