@echo off
title Horário Automático ISPGAYA
echo ==============================================
echo   Horário Automático ISPGAYA - Servidor Local
echo ==============================================
echo.

setlocal enabledelayedexpansion

REM Define variáveis de caminho
set NODE_DIR=%cd%\node_temp\node-v22.9.0-win-x64
set NODE_EXE=%NODE_DIR%\node.exe

REM Verifica se o Node.js já está instalado
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo Node.js não encontrado. A instalar localmente...
    if not exist "%NODE_EXE%" (
        mkdir "%cd%\node_temp" >nul 2>nul
        cd node_temp
        powershell -Command "Invoke-WebRequest -Uri https://nodejs.org/dist/v22.9.0/node-v22.9.0-win-x64.zip -OutFile node.zip"
        powershell -Command "Expand-Archive node.zip -DestinationPath ."
        cd ..
    )
    echo Node.js portátil pronto.
    set NODE_CMD="%NODE_EXE%"
) else (
    echo Node.js já está instalado no sistema.
    set NODE_CMD=node
)

echo.
echo Instalando dependências (isto pode demorar alguns segundos)...
call %NODE_CMD% node_modules\.bin\npm install 2>nul || call npm install

echo.
echo A iniciar o servidor...
start "" http://localhost:3000
echo.

%NODE_CMD% proxy.js

echo.
pause
