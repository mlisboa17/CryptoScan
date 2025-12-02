"""
App Leonardo 2 - Dashboard Flask
Bot de Trading com Dashboard em Flask
"""
from flask import Flask, render_template, jsonify
import json
import os
import requests
from datetime import datetime

app = Flask(__name__)

# Configuração
BOT_STATE_FILE = '../App_Leonardo/bot_state.json'

def get_bot_state():
    """Lê estado do bot do arquivo JSON"""
    try:
        if os.path.exists(BOT_STATE_FILE):
            with open(BOT_STATE_FILE, 'r') as f:
                return json.load(f)
    except Exception as e:
        print(f"Erro ao ler bot_state: {e}")
    
    return {
        'status': 'Desconectado',
        'balance': 0,
        'daily_pnl': 0,
        'trades_count': 0,
        'last_signal': 'Aguardando...'
    }

def get_binance_data(symbol):
    """Busca dados reais da Binance API"""
    try:
        binance_symbol = symbol.replace('/', '')
        
        # Ticker 24h
        ticker_url = f'https://api.binance.com/api/v3/ticker/24hr?symbol={binance_symbol}'
        ticker = requests.get(ticker_url, timeout=5).json()
        
        # Klines (últimos 15 candles de 1 minuto)
        klines_url = f'https://api.binance.com/api/v3/klines?symbol={binance_symbol}&interval=1m&limit=15'
        klines = requests.get(klines_url, timeout=5).json()
        
        # Extrai preços para o gráfico
        price_history = [{'time': k[0], 'price': float(k[4])} for k in klines]
        prices = [p['price'] for p in price_history]
        
        # Calcula RSI simples
        rsi = calculate_rsi(prices)
        
        return {
            'symbol': symbol,
            'price': float(ticker['lastPrice']),
            'change_24h': float(ticker['priceChangePercent']),
            'volume_24h': float(ticker['quoteVolume']),
            'high_24h': float(ticker['highPrice']),
            'low_24h': float(ticker['lowPrice']),
            'rsi': rsi,
            'price_history': price_history
        }
    except Exception as e:
        print(f"Erro Binance {symbol}: {e}")
        return None

def calculate_rsi(prices):
    """Calcula RSI simples"""
    if len(prices) < 2:
        return 50
    
    gains = losses = 0
    for i in range(1, len(prices)):
        change = prices[i] - prices[i-1]
        if change > 0:
            gains += change
        else:
            losses += abs(change)
    
    avg_gain = gains / (len(prices) - 1)
    avg_loss = losses / (len(prices) - 1)
    
    if avg_loss == 0:
        return 100
    
    rs = avg_gain / avg_loss
    return round(100 - (100 / (1 + rs)))


# ==================== ROTAS ====================

@app.route('/')
def index():
    """Página principal"""
    return render_template('index.html')

@app.route('/charts')
def charts():
    """Dashboard com gráficos"""
    return render_template('charts.html')

@app.route('/api/status')
def api_status():
    """API - Status do bot"""
    state = get_bot_state()
    state['timestamp'] = datetime.now().isoformat()
    return jsonify(state)

@app.route('/api/crypto/<symbol>')
def api_crypto(symbol):
    """API - Dados de uma crypto específica"""
    symbol = symbol.replace('-', '/')
    data = get_binance_data(symbol)
    if data:
        return jsonify(data)
    return jsonify({'error': 'Falha ao buscar dados'}), 500

@app.route('/api/multi-crypto')
def api_multi_crypto():
    """API - Dados de múltiplas cryptos"""
    symbols = ['BTC/USDT', 'ETH/USDT', 'SOL/USDT', 'BNB/USDT', 'XRP/USDT', 'ADA/USDT']
    
    result = {}
    for symbol in symbols:
        data = get_binance_data(symbol)
        if data:
            result[symbol] = data
    
    return jsonify(result)


# ==================== MAIN ====================

if __name__ == '__main__':
    print("🚀 App Leonardo 2 - Flask Dashboard")
    print("📊 Acesse: http://localhost:5000")
    print("📈 Charts: http://localhost:5000/charts")
    app.run(debug=True, host='0.0.0.0', port=5000)
