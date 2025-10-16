#!/usr/bin/env bash
set -e

echo "🚀 Starting Apache Flink CDC simulation environment..."
echo "====================================================="

# Step 1: Start all containers
echo "🔧 Starting Docker Compose services..."
docker compose up -d

# Step 2: Wait until MySQL source is ready
source ./mysql-source/env.list
echo "⏳ Waiting for MySQL source to initialize..."
until docker exec mysql-source mysqladmin ping -h localhost -p$MYSQL_ROOT_PASSWORD --silent; do
  sleep 2
done
echo "✅ MySQL source is up!"

# Step 3: Wait until MySQL target is ready
source ./mysql-target/env.list
echo "⏳ Waiting for MySQL target to initialize..."
until docker exec mysql-target mysqladmin ping -h localhost -p$MYSQL_ROOT_PASSWORD --silent; do
  sleep 2
done
echo "✅ MySQL target is up!"

# Step 3.1: Wait until mysql-source is ready to accept connections
echo "⏳ Waiting for MySQL source to accept connections..."
until docker exec mysql-source mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SELECT 1;" &> /dev/null; do
  sleep 2
done
echo "✅ MySQL source is ready to accept connections!"

# Step 3.2: Wait until mysql-target is ready to accept connections
echo "⏳ Waiting for MySQL target to accept connections..."
until docker exec mysql-target mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SELECT 1;" &> /dev/null; do
  sleep 2
done
echo "✅ MySQL target is ready to accept connections!"

# Step 4: Create replication user
source ./mysql-source/env.list
echo "👤 Creating replication user..."
docker exec mysql-source mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "
CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED BY 'replpwd';
GRANT REPLICATION SLAVE, REPLICATION CLIENT, SELECT ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
"

# Step 5: Prepare test database and table
source ./mysql-source/env.list
echo "🧱 Creating test database and users table..."
docker exec mysql-source mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
"

source ./mysql-target/env.list
docker exec mysql-target mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
"

# Step 6: Run Flink SQL pipeline automatically
echo "⚙️ Submitting pipeline.sql to Flink SQL Client..."
docker exec -i flink-jobmanager /opt/flink/bin/sql-client.sh  \
    -j /opt/flink/usrlib/flink-sql-connector-mysql-cdc-3.5.0.jar \
    -j /opt/flink/usrlib/flink-connector-jdbc-3.3.0-1.20.jar \
    -j /opt/flink/usrlib/mysql-connector-j-8.3.0.jar \
    -f /opt/flink/usrlib/pipeline.sql

# Step 7: Display summary
echo "🎯 Environment ready!"
echo ""
echo "MySQL Source: localhost:3307 (root/rootpwd)"
echo "MySQL Target: localhost:3308 (root/rootpwd)"
echo "Flink UI:       http://localhost:8081   job graph & basic metrics"
echo "Prometheus:     http://localhost:9090   raw query metrics"
echo "Grafana:        http://localhost:3000   Dashboard visual (login: admin/admin)"
echo "📊 Flink metrics exposed at:"
echo "  - JobManager: http://localhost:9249/metrics"
echo "  - TaskManager: http://localhost:9250/metrics"
echo ""
echo "🎨 Grafana Dashboard (Flink Overview): http://localhost:3000"
echo ""
echo "✅ Flink SQL pipeline has been automatically executed!"
echo "You can verify the running job in the Flink UI."
echo ""
echo "To start the data producer:"
echo "    python producer/producer.py"
echo ""
echo "====================================================="


# # Step 6: Display summary
# echo "🎯 Environment ready!"
# echo ""
# echo "MySQL Source: localhost:3307 (root/rootpwd)"
# echo "MySQL Target: localhost:3308 (root/rootpwd)"
# echo "Flink UI:     http://localhost:8081"
# echo ""
# echo "Next steps:"
# echo "1️⃣ Open Flink SQL client:"
# echo "    docker exec -it flink-jobmanager /bin/bash"
# echo "    /opt/flink/bin/sql-client.sh"
# echo ""
# echo "2️⃣ Run the following SQL (copy-paste into Flink SQL):"
# echo ""
# cat <<'EOF'
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
# EOF
# echo ""
# echo "3️⃣ Run the data producer:"
# echo "    python producer/producer.py"
# echo ""
# echo "✅ All systems are ready to stream!"
# echo "====================================================="