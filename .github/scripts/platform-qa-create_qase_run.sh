#!/bin/bash
set -e

QASE_PROJECT="${RM_QASE_PROJECT_ID:-}"
QASE_AUTOMATION_TOKEN="${QASE_AUTOMATION_TOKEN:-}"
RANCHER_VERSION="${RANCHER_SHORT_VERSION:-unknown}"
TITLE="${1:-Automated Test Run ${RANCHER_VERSION} $(date +%F_%H-%M-%S)}"
DESCRIPTION="${2:-Created from CI pipeline}"

if [ -z "$QASE_PROJECT" ] || [ -z "$QASE_AUTOMATION_TOKEN" ]; then
  echo "❌ RM_QASE_PROJECT_ID and QASE_AUTOMATION_TOKEN must be set as environment variables"
  exit 1
fi

BASE_URL="https://api.qase.io/v1/run/${QASE_PROJECT}"

echo "📌 Creating new Qase test run in project: $QASE_PROJECT"

response=$(curl -s -X POST "$BASE_URL" \
  -H "Content-Type: application/json" \
  -H "Token: $QASE_AUTOMATION_TOKEN" \
  -d "{
        \"title\": \"$TITLE\",
        \"description\": \"$DESCRIPTION\",
        \"environment\": \"CI\",
        \"is_autotest\": true
      }")

# Extract run ID
run_id=$(echo "$response" | jq -r '.result.id // empty')

if [ -z "$run_id" ]; then
  echo "❌ Failed to create test run. Response was: $response"
  exit 1
fi

echo "✅ Created Qase Test Run with ID: $run_id"
echo "$run_id"
