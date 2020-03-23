#!/usr/bin/env bash

set -ex

echo Setting up Microsoft SQL Server

sudo docker pull microsoft/mssql-server-linux:2017-latest
#sudo docker pull mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04
sudo docker run \
    -e 'ACCEPT_EULA=Y' \
    -e 'SA_PASSWORD=Anonymizer2018' \
    -p 127.0.0.1:1433:1433 \
    --name db \
    -d \
    microsoft/mssql-server-linux:2017-latest
    #mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04

retries=20
until (echo quit | /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -l 1 -U sa -P Anonymizer2018 &> /dev/null)
do
    if [[ "$retries" -le 0 ]]; then
        echo SQL Server did not start
        exit 1
    fi

    retries=$((retries - 1))

    echo Waiting for SQL Server to start...

    sleep 5s
done

echo SQL Server started
