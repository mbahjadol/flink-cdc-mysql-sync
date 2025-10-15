#!/bin/bash
# check if flink-jobmanager is running
if [ "$(docker inspect -f '{{.State.Running}}' flink-jobmanager 2>/dev/null)" != "true" ]; then
  echo "❌ Flink JobManager is not running. Please start the environment first by running ./init.sh"
  exit 1
fi
docker exec -it flink-jobmanager /opt/flink/bin/sql-client.sh


# CREATE TABLE mysql_source_users (
#   id INT,
#   name STRING,
#   ts TIMESTAMP(3),
#   PRIMARY KEY (id) NOT ENFORCED
# ) WITH (
#   'connector' = 'mysql-cdc',
#   'hostname' = 'mysql-source',
#   'port' = '3306',
#   'username' = 'repl',
#   'password' = 'replpwd',
#   'database-name' = 'testdb',
#   'table-name' = 'users',
#   'scan.startup.mode' = 'initial'
# );

# CREATE TABLE mysql_target_users (
#   id INT,
#   name STRING,
#   ts TIMESTAMP(3),
#   PRIMARY KEY (id) NOT ENFORCED
# ) WITH (
#   'connector' = 'jdbc',
#   'url' = 'jdbc:mysql://mysql-target:3306/testdb',
#   'table-name' = 'users',
#   'username' = 'root',
#   'password' = 'rootpwd'
# );

# INSERT INTO mysql_target_users
# SELECT * FROM mysql_source_users;
