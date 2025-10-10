#!/bin/bash

PATH_TO_FLINK_LIB="./flink/usrlib"
download_if_not_exists() {
    local url="$1"
    local filename="$2"
    if [ ! -f "$PATH_TO_FLINK_LIB/$filename" ]; then
        wget -O "$PATH_TO_FLINK_LIB/$filename" "$url"
    fi
}

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
    



