# yfinance

#### commands

```
curl -X POST "TRIGGER_GOES_HERE"   -H "Content-Type:application/json"   -H "Authorization: bearer $(gcloud auth print-identity-token)"   --data '{"ticker":"YOUR_TICKER","start":"2020-01-01","end":"2021-01-01","interval":"1d","bucket":"YOUR_BUCKET" }'
```

```
ARTIFACT_REGISTRY_REPOSITORY_URL=us-central1-docker.pkg.dev/artifact-ptlp/cluster-ptlp
docker build -t "${ARTIFACT_REGISTRY_REPOSITORY_URL}/yfinance" .
docker push "${ARTIFACT_REGISTRY_REPOSITORY_URL}/yfinance"
```
