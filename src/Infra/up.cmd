@echo off
rem Starts every CRO infra setup, in numbered order.
cd /d "%~dp0"

rem Base folder for all CRO container data (one subfolder per setup).
set CRO_DATA=D:/Data/CRO

rem Read the DB password from .NET User Secrets (src\CRO).
rem Set it for this cmd session only; it is never saved anywhere.
for /f "tokens=3" %%a in ('dotnet user-secrets list --project ..\CRO ^| findstr "CRO:DbPassword"') do set CRO_DB_PASSWORD=%%a

docker compose -f 02-cro-index-postgres\docker-compose.yml up -d
docker compose -f 03a-ob1-local-brain\docker-compose.yml up -d
