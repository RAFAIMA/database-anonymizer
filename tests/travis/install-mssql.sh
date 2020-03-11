#!/usr/bin/env bash

set -ex

echo Installing drivers
sudo su

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql17
# optional: for bcp and sqlcmd
sudo ACCEPT_EULA=Y apt-get install mssql-tools
sudo apt-get install unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
# optional: for unixODBC development headers



#ACCEPT_EULA=Y sudo apt-get install -qy msodbcsql17 mssql-tools unixodbc libssl1.0.0

#curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main" | sudo tee /etc/apt/sources.list.d/mssql-release.list
#sudo apt update
#sudo apt install -qy msodbcsql17 mssql-tools unixodbc libssl1.0.0

echo Setting up Microsoft SQL Server

#sudo docker pull microsoft/mssql-server-linux:2017-latest
sudo docker pull mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04
sudo docker run \
    -e 'ACCEPT_EULA=Y' \
    -e 'SA_PASSWORD=Anonymizer2018' \
    -p 127.0.0.1:1433:1433 \
    --name db \
    -d \
    #microsoft/mssql-server-linux:2017-latest
    mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04

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
