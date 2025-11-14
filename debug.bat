@echo off
cd /d "%~dp0"
echo ====== DEBUG HORARIO ======
echo.
echo Diretório atual: %cd%
echo.
echo A correr script original...
echo -----------------------------
call "install_and_run.bat"
echo -----------------------------
echo.
echo Script terminou com errolevel %errorlevel%.
pause