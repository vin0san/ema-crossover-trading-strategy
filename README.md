# EMA 10 / EMA 50 Crossover Trading Strategy

This repository contains a simple implementation of an EMA crossover
trading strategy with a trailing stop loss.

The strategy is implemented in:
- Python (for backtesting and research)
- MQL5 (as a MetaTrader 5 Expert Advisor)

The objective of this project is to understand the full workflow of
research → validation → execution in algorithmic trading.

---

## Strategy Logic

- Buy when EMA(10) crosses above EMA(50)
- Sell when EMA(10) crosses below EMA(50)
- Use a trailing stop loss to protect profits

This is a trend-following strategy and performs best in trending markets.

---

## Project Structure

```bash
ema-crossover-trading-strategy/
│
├── mql5/       # MetaTrader 5 Expert Advisor
│   └── ema_crossover_trailing_stop.mq5
│
├── python/     # Backtesting and analysis code
│   ├── ema_crossover_backtest.py
│   └── sample_price_data.csv
│
├── results/    # Notes and observations from testing
│   └── backtest_notes.md
│
├── README.md
└── requirements.txt
```

---

## Disclaimer

This project is for educational and research purposes only.
It is not financial advice and should not be used with real
funds without extensive testing and proper risk management.
