@echo off
chcp 65001 >nul
title Horário Automático ISPGAYA
echo ==============================================
echo   Horário Automático ISPGAYA - Servidor Local
echo ==============================================
echo.

set "BASE_DIR=%~dp0"
cd /d "%BASE_DIR%"

REM Node portátil
set "NODE_DIR=%BASE_DIR%node\node-v22.21.1-win-x64"
set "NODE_EXE=%NODE_DIR%\node.exe"
set "NPM_CLI=%NODE_DIR%\node_modules\npm\bin\npm-cli.js"

echo [DEBUG] Diretório atual: %BASE_DIR%
echo [DEBUG] Node portátil usado: %NODE_EXE%
echo.

REM Instalar dependências caso não existam
if not exist "%BASE_DIR%node_modules" (
    echo Instalando dependências...
    "%NODE_EXE%" "%NPM_CLI%" install
    if %errorlevel% neq 0 (
        echo ⚠️ Erro a instalar dependências.
        pause
        exit /b
    )
)

REM Iniciar servidor e redirecionar logs
echo A iniciar o servidor...
"%NODE_EXE%" "%BASE_DIR%proxy.js" > "%BASE_DIR%server_output.log" 2>&1

echo.
echo [✅] Servidor iniciado.
echo Logs gravados em: server_output.log
echo Pressiona qualquer tecla para sair...
pause
