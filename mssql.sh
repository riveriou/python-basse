
#匯入公開存放庫 GPG 金鑰
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg
curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc

#手動下載並註冊 SQL Server Ubuntu 存放庫
curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | tee /etc/apt/sources.list.d/mssql-server-2022.list

#執行下列命令安裝 SQL Server
apt-get update
apt-get install -y mssql-server

curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get -y install mssql-tools18 unixodbc-dev

echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc

MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD \
     MSSQL_PAID=$MSSQL_PAID \
     /opt/mssql/bin/mssql-conf -n setup accept-eula

