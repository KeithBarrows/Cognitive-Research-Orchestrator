@echo off
rem Starts every CRO infra setup, in numbered order.
cd /d "%~dp0"

rem Base folder for all CRO container data (one subfolder per setup).
set CRO_DATA=D:/Data/CRO

rem Read secrets from .NET User Secrets (src\CRO).
rem Set for this cmd session only; never saved anywhere.
call :secret CRO:DbPassword CRO_DB_PASSWORD

docker compose -f 02-cro-index-postgres\docker-compose.yml up -d
docker compose -f 03a-ob1-local-brain\docker-compose.yml up -d

rem Plane uses generic variable names (POSTGRES_PASSWORD, SECRET_KEY, ...)
rem that would override the OB1 stack's own values, so they are set in a
rem local scope and only for the Plane line. Keep this section last.
setlocal
call :secret Plane:DbPassword POSTGRES_PASSWORD
call :secret Plane:MqPassword RABBITMQ_PASSWORD
call :secret Plane:MinioAccessKey AWS_ACCESS_KEY_ID
call :secret Plane:MinioSecretKey AWS_SECRET_ACCESS_KEY
call :secret Plane:SecretKey SECRET_KEY
call :secret Plane:LiveSecretKey LIVE_SERVER_SECRET_KEY
set DATABASE_URL=postgresql://plane:%POSTGRES_PASSWORD%@plane-db/plane
set AMQP_URL=amqp://plane:%RABBITMQ_PASSWORD%@plane-mq:5672/plane
docker compose -f 04-plane\docker-compose.yml --env-file 04-plane\plane.env up -d
endlocal
exit /b

:secret
rem usage: call :secret <UserSecretsKey> <EnvVarName>
for /f "tokens=3" %%a in ('dotnet user-secrets list --project ..\CRO ^| findstr "%~1"') do set %~2=%%a
exit /b
