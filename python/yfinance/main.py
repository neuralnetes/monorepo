from google.cloud import storage

import yfinance as yf

client = storage.Client()

def entry(request):
    request_json = request.get_json(silent=True)
    ticker = request_json.get('ticker')
    start = request_json.get("start")
    end = request_json.get("end")
    interval = request_json.get("interval")
    bucket_name = request_json.get("bucket")
    bucket = client.get_bucket(bucket_name)
    df = yf.download(ticker, start = start, end = end, interval = interval)
    bucket.blob(f'yfinance-dev/{ticker}.csv').upload_from_string(df.to_csv(), 'text/csv')
    return "ok"
