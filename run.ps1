# App Leonardo 2 - PowerShell Launcher
param(
    [switch]$NoPrompt = $false
)

# Configuração
$ErrorActionPreference = "Stop"
$Host.UI.RawUI.WindowTitle = "App Leonardo 2 - Flask Dashboard"

# Função para escrever mensagens coloridas
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

# Banner
Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   App Leonardo 2 - Flask Dashboard" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Verifica Python
    Write-Host "[1/4] Verificando Python..." -ForegroundColor Green
    $pythonVersion = python --version 2>$null
    if (-not $pythonVersion) {
        throw "Python não encontrado! Instale o Python primeiro."
    }
    Write-Host "✓ $pythonVersion" -ForegroundColor Gray

    # Cria ambiente virtual
    if (-not (Test-Path "venv")) {
        Write-Host "[2/4] Criando ambiente virtual..." -ForegroundColor Green
        python -m venv venv
        Write-Host "✓ Ambiente virtual criado" -ForegroundColor Gray
    } else {
        Write-Host "[2/4] Ambiente virtual já existe" -ForegroundColor Green
    }

    # Ativa ambiente virtual
    Write-Host "[3/4] Ativando ambiente virtual..." -ForegroundColor Green
    & ".\venv\Scripts\Activate.ps1"
    Write-Host "✓ Ambiente ativado" -ForegroundColor Gray

    # Instala dependências
    Write-Host "[4/4] Instalando dependências..." -ForegroundColor Green
    pip install -r requirements.txt --quiet --no-warn-script-location
    Write-Host "✓ Dependências instaladas" -ForegroundColor Gray

    # Limpa e inicia
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "   🚀 INICIANDO FLASK DASHBOARD" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  📊 Home:   http://localhost:5000" -ForegroundColor White
    Write-Host "  📈 Charts: http://localhost:5000/charts" -ForegroundColor White
    Write-Host ""
    Write-Host "  ⚠️  Pressione Ctrl+C para parar o servidor" -ForegroundColor Red
    Write-Host ""

    # Inicia aplicação
    python app.py

} catch {
    Write-Host ""
    Write-Host "❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
    if (-not $NoPrompt) {
        Write-Host ""
        Write-Host "Pressione qualquer tecla para continuar..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    exit 1
}