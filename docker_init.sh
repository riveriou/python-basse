#!/bin/bash

#docker run -d --name flask-mssql -p 8000:8000 -p 8022:22 -e ACCEPT_EULA:Y -e MSSQL_PID:standard -e MSSQL_SA_PASSWORD:!Qazxsw2 -e MSSQL_TCP_PORT:1433 riou/python-base:test

docker run -d --name flask-mssql -p 8080:8000 -p 8022:22 -v /dataout:/dataout riou/flask-mssql-base:test

docker run -d --name flask-nginx -p 8080:8000 -p 8022:22 -v /dataout:/dataout riou/flask-nginx-base:test
