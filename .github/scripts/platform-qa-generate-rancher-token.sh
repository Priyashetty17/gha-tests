#!/bin/bash
set -e

if [ -z "$RANCHER_HOST" ]; then
  echo "❌ RANCHER_HOST not set. Exiting."
  exit 1
fi

if [ -z "$RANCHER_ADMIN_PASSWORD" ]; then
  echo "❌ RANCHER_ADMIN_PASSWORD not set. Exiting."
  exit 1
fi

response=$(curl -s -k "https://$RANCHER_HOST/v1-public/login" \
  -H "Content-Type: application/json" \
  -d "{\"type\": \"localProvider\", \"username\": \"admin\", \"password\": \"$RANCHER_ADMIN_PASSWORD\", \"responseType\": \"json\"}")

token=$(echo "$response" | jq -r '.token')

if [ -z "$token" ] || [ "$token" == "null" ]; then
  echo "❌ Failed to get Rancher token. Response: $response"
  exit 1
fi

echo "RANCHER_ADMIN_TOKEN=$token" >> $GITHUB_ENV
echo "::add-mask::$token"
