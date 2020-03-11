#!/usr/bin/env bash

set -ex

echo Installing driver dependencies

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic
main" | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt update
sudo apt install msodbcsql17
#ACCEPT_EULA=Y sudo apt-get install -qy msodbcsql17 unixodbc unixodbc-dev libssl1.0.0

echo Setting up Microsoft SQL Server

sudo docker pull microsoft/mssql-server-linux:2017-latest
sudo docker run \
    -e 'ACCEPT_EULA=Y' \
    -e 'SA_PASSWORD=Anonymizer2018' \
    -p 127.0.0.1:1433:1433 \
    --name db \
    -d \
    microsoft/mssql-server-linux:2017-latest

sudo docker exec -i mssql bash <<< 'until echo quit | /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -l 1 -U sa -P Doctrine2018 > /dev/null 2>&1 ; do sleep 1; done'

echo SQL Server started