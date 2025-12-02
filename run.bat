@echo off
title App Leonardo 2 - Flask Dashboard
cls

echo ========================================
echo    App Leonardo 2 - Flask Dashboard
echo ========================================
echo.

REM Muda para o diretório do script
cd /d "%~dp0"

REM Verifica se Python está instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python não encontrado! Instale o Python primeiro.
    pause
    exit /b 1
)

REM Cria ambiente virtual se não existir
if not exist "venv" (
    echo [1/3] Criando ambiente virtual...
    python -m venv venv
    if errorlevel 1 (
        echo ❌ Erro ao criar ambiente virtual!
        pause
        exit /b 1
    )
)

REM Ativa ambiente virtual
echo [2/3] Ativando ambiente virtual...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ Erro ao ativar ambiente virtual!
    pause
    exit /b 1
)

REM Instala dependências
echo [3/3] Instalando dependências...
pip install -r requirements.txt --quiet --no-warn-script-location
if errorlevel 1 (
    echo ❌ Erro ao instalar dependências!
    pause
    exit /b 1
)

REM Limpa a tela
cls

echo ========================================
echo    🚀 INICIANDO FLASK DASHBOARD
echo ========================================
echo.
echo  📊 Home:   http://localhost:5000
echo  📈 Charts: http://localhost:5000/charts
echo.
echo  ⚠️  Pressione Ctrl+C para parar o servidor
echo.

REM Inicia a aplicação
python app.py