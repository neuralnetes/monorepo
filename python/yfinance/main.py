import pandas as pd
import yfinance as yf
import os

ticker = os.environ["YFINANCE_TICKER"]
start = os.environ["YFINANCE_START"]
end = os.environ["YFINANCE_END"]
csv_path = os.environ["YFINANCE_CSV_PATH"]

def entry(a, b):
    df = yf.download(ticker, start = start, end = end)
    df.to_csv(csv_path)
