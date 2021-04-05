find terragrunt \
  -type d \
  -name ".terragrunt-cache" \
  -name ".terragrunt-cache" \
  -prune -exec rm -rf {} \;

find terragrunt
  -type f \
  -name "terragrunt-debug.tfvars.json" \
  -prune
