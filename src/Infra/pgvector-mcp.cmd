@echo off
rem Starts mcp-server-pgvector (stdio) against the LOCAL cro_index only.
rem Used by the "pgvector-cro" entry in .mcp.json.
rem Secret comes from .NET User Secrets; set for this process only.
setlocal
for /f "tokens=3" %%a in ('dotnet user-secrets list --project "%~dp0..\CRO" ^| findstr "CRO:DbPassword"') do set CRO_DB_PASSWORD=%%a
set DATABASE_URL=postgresql://cro:%CRO_DB_PASSWORD%@127.0.0.1:5433/cro_index
set MCP_PGVECTOR_READ_ONLY=false
rem mcp is pinned below 2: version 0.1.0 declares mcp>=1.12.0 and breaks on 2.x.
python -m uv tool run --with "mcp<2" mcp-server-pgvector@0.1.0
