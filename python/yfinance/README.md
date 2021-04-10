# yfinance

#### commands

```
curl -X POST "https://us-central1-yfinance-pipe-v1.cloudfunctions.net/entry" \
  -H "Content-Type:application/json" \
  -H "Authorization: bearer $(gcloud auth print-identity-token)" \
  --data '{"name":"Keyboard Cat"}'
```
 
