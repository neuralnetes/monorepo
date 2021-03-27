import pandas as pd
import yfinance as yf
import os

ticker = os.environ["YFINANCE_TICKER"]
start = os.environ["YFINANCE_START"]
end = os.environ["YFINANCE_END"]
interval = os.environ["YFINANCE_INTERVAL"]


def entry(request):
    df = yf.download(ticker, start = start, end = end, interval = interval)
    return df.to_json()
