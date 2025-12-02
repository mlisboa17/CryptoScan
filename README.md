# App Leonardo 2 - Flask Dashboard

Dashboard de trading usando **Flask** ao invés de Django.

## 🚀 Como Rodar

### Windows (mais fácil):
```
start.bat
```

### Manual:
```bash
cd App_Leonardo2
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

## 📊 Acessar

- **Home:** http://localhost:5000
- **Dashboard:** http://localhost:5000/charts

## 🔧 APIs

| Rota | Descrição |
|------|-----------|
| `/api/status` | Status do bot |
| `/api/multi-crypto` | Dados de 6 cryptos |
| `/api/crypto/BTC-USDT` | Dados de uma crypto |

## ✨ Funcionalidades

- 📈 Gráficos em tempo real (Chart.js)
- 🔗 Dados da Binance API
- ⚡ Atualização a cada 3 segundos
- 🎯 RSI calculado automaticamente
- 🌙 Interface dark mode moderna

## 🆚 Diferença do App Leonardo 1

| Feature | Leonardo 1 (Django) | Leonardo 2 (Flask) |
|---------|--------------------|--------------------|
| Framework | Django | Flask |
| Complexidade | Maior | Menor |
| Arquivos | Muitos | Poucos |
| Banco de Dados | SQLite | Nenhum |
| Admin | Sim | Não |

## 📁 Estrutura

```
App_Leonardo2/
├── app.py              # Aplicação Flask
├── requirements.txt    # Dependências
├── start.bat          # Script para iniciar
├── README.md          # Este arquivo
└── templates/
    ├── index.html     # Página inicial
    └── charts.html    # Dashboard com gráficos
```
