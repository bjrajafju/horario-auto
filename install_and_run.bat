@echo off
title Horário Automático ISPGAYA
echo ==============================================
echo   Horário Automático ISPGAYA - Servidor Local
echo ==============================================
echo.

REM Caminho base
setlocal
set BASE_DIR=%~dp0

REM Verifica se o Node.js está instalado
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo Node.js não encontrado. A instalar localmente...
    mkdir "%BASE_DIR%node_temp" >nul 2>nul
    cd "%BASE_DIR%node_temp"

    REM Faz download da versão portátil do Node.js
    powershell -Command "Invoke-WebRequest -Uri https://nodejs.org/dist/v22.9.0/node-v22.9.0-win-x64.zip -OutFile node.zip"
    powershell -Command "Expand-Archive node.zip -DestinationPath ."
    del node.zip

    echo Node.js portátil pronto.
    set NODE_DIR=%BASE_DIR%node_temp\node-v22.9.0-win-x64
    set NODE_EXE=%NODE_DIR%\node.exe
    set NPM_CLI=%NODE_DIR%\node_modules\npm\bin\npm-cli.js
) else (
    echo Node.js já está instalado no sistema.
    set NODE_EXE=node
)

cd "%BASE_DIR%"
echo.
echo Instalando dependências (isto pode demorar alguns segundos)...

if exist "%NODE_EXE%" (
    "%NODE_EXE%" "%NPM_CLI%" install
) else (
    call npm install
)

echo.
echo A iniciar o servidor...
start "" http://localhost:3000
echo.

"%NODE_EXE%" proxy.js

echo.
pause
