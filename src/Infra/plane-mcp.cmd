@echo off
rem Starts the official Plane MCP server (stdio) against the LOCAL
rem Plane only. Used by the "plane-cro" entry in .mcp.json.
rem Secrets come from .NET User Secrets; set for this process only.
setlocal
set PLANE_BASE_URL=http://localhost:8090
set PLANE_WORKSPACE_SLUG=cro
for /f "tokens=3" %%a in ('dotnet user-secrets list --project "%~dp0..\CRO" ^| findstr "Plane:ApiToken"') do set PLANE_API_KEY=%%a
python -m uv tool run plane-mcp-server stdio
