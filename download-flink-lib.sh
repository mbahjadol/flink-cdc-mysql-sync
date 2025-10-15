#!/bin/bash

###
### Download Flink CDC connectors from this page: 
### https://github.com/apache/flink-cdc/releases/tag/release-3.5.0
###
### For Flink JDBC connectors, you can download from:
### https://github.com/apache/flink-connector-jdbc/
###
###



PATH_TO_FLINK_LIB="./flink/usrlib"
download_if_not_exists() {
    local url="$1"
    local filename="$2"
    if [ ! -f "$PATH_TO_FLINK_LIB/$filename" ]; then
        echo "⬇️ Downloading $filename ..."
        wget -O "$PATH_TO_FLINK_LIB/$filename" "$url"
    fi
}

# --- CDC Connectors ---
download_if_not_exists \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-mysql-cdc/3.5.0/flink-sql-connector-mysql-cdc-3.5.0.jar \
    flink-sql-connector-mysql-cdc-3.5.0.jar

# --- JDBC Sink Connector (for Flink 1.20) ---
download_if_not_exists \
    https://repo1.maven.org/maven2/org/apache/flink/flink-connector-jdbc/3.3.0-1.20/flink-connector-jdbc-3.3.0-1.20.jar \
    flink-connector-jdbc-3.3.0-1.20.jar

# --- MySQL JDBC Driver ---
download_if_not_exists \
    https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar \
    mysql-connector-j-8.3.0.jar




# --- CDC Connectors ---
echo "Downloading Flink CDC connectors to $PATH_TO_FLINK_LIB ..."
mkdir -p $PATH_TO_FLINK_LIB

download_if_not_exists \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-db2-cdc/3.5.0/flink-sql-connector-db2-cdc-3.5.0.jar \
    flink-sql-connector-db2-cdc-3.5.0.jar
download_if_not_exists \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-mongodb-cdc/3.5.0/flink-sql-connector-mongodb-cdc-3.5.0.jar \
    flink-sql-connector-mongodb-cdc-3.5.0.jar
download_if_not_exists \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-mysql-cdc/3.5.0/flink-sql-connector-mysql-cdc-3.5.0.jar \
    flink-sql-connector-mysql-cdc-3.5.0.jar
download_if_not_exists \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-oceanbase-cdc/3.5.0/flink-sql-connector-oceanbase-cdc-3.5.0.jar \
    flink-sql-connector-oceanbase-cdc-3.5.0.jar
download_if_not_exists \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-oracle-cdc/3.5.0/flink-sql-connector-oracle-cdc-3.5.0.jar \
    flink-sql-connector-oracle-cdc-3.5.0.jar
download_if_not_exists \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-postgres-cdc/3.5.0/flink-sql-connector-postgres-cdc-3.5.0.jar \
    flink-sql-connector-postgres-cdc-3.5.0.jar
download_if_not_exists \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-sqlserver-cdc/3.5.0/flink-sql-connector-sqlserver-cdc-3.5.0.jar \
    flink-sql-connector-sqlserver-cdc-3.5.0.jar
    



