from google.cloud import storage
from urllib import request

import pandas as pd
import yfinance as yf
import os

ticker = os.environ["YFINANCE_TICKER"]
start = os.environ["YFINANCE_START"]
end = os.environ["YFINANCE_END"]
interval = os.environ["YFINANCE_INTERVAL"]
json_path = os.environ["YFINANCE_JSON_PATH"]
bucket_name = os.environ["YFINANCE_BUCKET"]
client = storage.Client()
bucket = client.get_bucket(bucket_name)

def entry(request):
    request_json = request.get_json(silent=True)
    df = yf.download(ticker, start = start, end = end, interval = interval)
    bucket.blob(f'yfinance-dev/{ticker}.csv').upload_from_string(df.to_csv(), 'text/csv')
    print(request_json)
    return "ok"
