@echo off
rem Starts postgres-mcp (stdio, in a throwaway container) against the
rem LOCAL cro_index only. Used by the "postgres-cro" entry in .mcp.json.
rem Joins the cro_index Docker network, so no port is published.
rem Secret comes from .NET User Secrets; set for this process only.
setlocal
for /f "tokens=3" %%a in ('dotnet user-secrets list --project "%~dp0..\CRO" ^| findstr "CRO:DbPassword"') do set POSTGRES_PASSWORD=%%a
set POSTGRES_HOST=cro-index-db
set POSTGRES_PORT=5432
set POSTGRES_USER=cro
set POSTGRES_DATABASE=cro_index
docker run --rm -i --network 02-cro-index-postgres_default -e POSTGRES_HOST -e POSTGRES_PORT -e POSTGRES_USER -e POSTGRES_PASSWORD -e POSTGRES_DATABASE writenotenow/postgres-mcp:v3.1.0 --tool-filter codemode
