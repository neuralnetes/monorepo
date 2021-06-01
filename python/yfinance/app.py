# from google.cloud import storage
from flask import Flask, request, jsonify

import os
import yfinance as yf

# client = storage.Client()
app = Flask(__name__)

# @app.route('/')
# def entry():
#     request_json = request.get_json(silent=True)
#     ticker = request_json.get('ticker')
#     start = request_json.get("start")
#     end = request_json.get("end")
#     interval = request_json.get("interval")
#     bucket_name = request_json.get("bucket")
#     bucket = client.get_bucket(bucket_name)
#     df = yf.download(ticker, start = start, end = end, interval = interval)
#     bucket.blob(f'yfinance-dev/{ticker}.csv').upload_from_string(df.to_csv(), 'text/csv')
#     return jsonify({
#         'type': 'success',
#         'data': {
#             'request_json': request_json
#         }
#     })

@app.route('/')
def entry():
    return jsonify({
        'type': 'success',
        'data': {
            'request_json': "hello"
        }
    })


if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))