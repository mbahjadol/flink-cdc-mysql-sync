#!/bin/bash
# check if flink-jobmanager is running
if [ "$(docker inspect -f '{{.State.Running}}' flink-jobmanager 2>/dev/null)" != "true" ]; then
  echo "❌ Flink JobManager is not running. Please start the environment first by running ./init.sh"
  exit 1
fi
docker exec -it flink-jobmanager /opt/flink/bin/sql-client.sh \
    -j /opt/flink/usrlib/flink-sql-connector-mysql-cdc-3.5.0.jar \
    -j /opt/flink/usrlib/flink-connector-jdbc-3.3.0-1.20.jar \
    -j /opt/flink/usrlib/mysql-connector-j-8.3.0.jar
