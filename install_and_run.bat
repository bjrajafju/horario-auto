@echo off
title Horário Automático ISPGAYA - Instalação
echo ==============================================
echo   Horário Automático ISPGAYA - Instalação
echo ==============================================
echo.

REM Verifica se o Node.js está instalado
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo Node.js não encontrado. A instalar localmente...
    REM Cria pasta temporária para Node
    mkdir "%cd%\node_temp" >nul 2>nul
    cd node_temp

    REM Faz download da versão portátil do Node.js (Windows x64)
    powershell -Command "Invoke-WebRequest -Uri https://nodejs.org/dist/v22.9.0/node-v22.9.0-win-x64.zip -OutFile node.zip"
    powershell -Command "Expand-Archive node.zip -DestinationPath ."
    set PATH=%cd%\node-v22.9.0-win-x64;%PATH%
    cd ..
) else (
    echo Node.js já está instalado no sistema.
)

echo.
echo Instalando dependências...
call npm install

echo.
echo Iniciando o servidor...
start "" http://localhost:3000
node server.js
pause
