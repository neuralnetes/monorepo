#!/bin/bash
VARIABLE_NAME=$1
RAW_GITHUBUSERCONTENT_URL=$2 # https://raw.githubusercontent.com/terraform-google-modules/terraform-google-address/master/variables.tf
RAW_GITHUBUSERCONTENT=$(curl -s "${RAW_GITHUBUSERCONTENT_URL}")
VARIABLE_NAMES_JSON_LIST=($(echo "${RAW_GITHUBUSERCONTENT}" | grep -o 'variable ".*"' | cut -c10- | jq -rcs '@sh' | tr -d "'"))
cat <<EOF > generated.tf
variable "${VARIABLE_NAME}" {
  type = list(object({
EOF
for variable_name in "${VARIABLE_NAMES_JSON_LIST[@]}"; do
  cat <<EOF >> generated.tf
    ${variable_name} = ???
EOF
done
cat <<EOF >> generated.tf
  }))
}
EOF
cat generated.tf
cp generated.tf "${VARIABLE_NAME}-variables.tf"
rm -rf generated.tf