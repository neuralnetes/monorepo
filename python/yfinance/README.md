# yfinance

#### commands

```
curl -X POST "TRIGGER_GOES_HERE"   -H "Content-Type:application/json"   -H "Authorization: bearer $(gcloud auth print-identity-token)"   --data '{"ticker":"YOUR_TICKER","start":"2020-01-01","end":"2021-01-01","interval":"1d","bucket":"YOUR_BUCKET" }'
```
 
