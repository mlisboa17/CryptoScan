@echo off
echo ========================================
echo    App Leonardo 2 - Flask Dashboard
echo ========================================
echo.

cd /d "%~dp0"

REM Verifica se venv existe
if not exist "venv" (
    echo [1/3] Criando ambiente virtual...
    python -m venv venv
)

echo [2/3] Ativando ambiente virtual...
call venv\Scripts\activate.bat

echo [3/3] Instalando dependencias...
pip install -r requirements.txt -q --no-warn-script-location

echo.
echo ========================================
echo    Iniciando Flask Dashboard
echo ========================================
echo.
echo  Home:   http://localhost:5000
echo  Charts: http://localhost:5000/charts
echo.

python app.py
pause
