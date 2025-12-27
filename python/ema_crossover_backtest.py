"""
A simple EMA crossover backtest with trailing stop simulation.

"""

import pandas as pd
import numpy as np

# Load sample historical data
df = pd.read_csv("sample_price_data.csv")

# Calculate EMAs
df["EMA_10"] = df["close"].ewm(span=10, adjust=False).mean()
df["EMA_50"] = df["close"].ewm(span=50, adjust=False).mean()

# Generate signals
df["signal"] = 0
df.loc[df["EMA_10"] > df["EMA_50"], "signal"] = 1
df.loc[df["EMA_10"] < df["EMA_50"], "signal"] = -1

# Detect position changes
df["position"] = df["signal"].diff()

# Simple trailing stop simulation
trailing_pct = 0.01
df["trailing_stop"] = np.nan

for i in range(1, len(df)):
    if df["position"].iloc[i] == 1:
        df.at[i, "trailing_stop"] = df["close"].iloc[i] * (1 - trailing_pct)
    elif df["position"].iloc[i] == -1:
        df.at[i, "trailing_stop"] = df["close"].iloc[i] * (1 + trailing_pct)

# Display the last few rows of the DataFrame to verify calculations
print(df.tail())
