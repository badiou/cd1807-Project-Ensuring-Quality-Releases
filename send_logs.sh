#!/bin/bash

# Variables
workspaceId="aee36f6d-42ce-412a-9d4a-d58910526bae"  # Nom du workspace
primaryKey="uLrjWHFM8kc09WXFnQbhOpIBwTFhRmj0hnSv424clAEgB3m3bXDHAXL3zJ7e5KhcH4HqF7S4jbPx3JHVJC3/nQ=="  # Clé Primaire
logType="SeleniumLogs"
echo -n "$stringToSign" | openssl dgst -sha256 -hmac "$primaryKey" -binary | openssl enc -base64

timeGenerated=$(date -u +"%Y-%m-%dT%H:%M:%SZ")  # Format ISO 8601

# Afficher la date générée pour vérification
echo "Generated time: $timeGenerated"

# Exemple de données de log JSON
logData='{"time":"2024-08-17T17:56:21Z","message":"Test message"}'

# Calculer la signature d'autorisation
contentLength=$(echo -n "$logData" | wc -c)
stringToSign="POST\n$contentLength\napplication/json\nx-ms-date:$timeGenerated\n/api/logs"
authSignature=$(echo -n "$stringToSign" | openssl dgst -sha256 -hmac "$primaryKey" -binary | openssl enc -base64)

# Afficher les valeurs de débogage
echo "String to Sign: $stringToSign"
echo "Auth Signature: $authSignature"

# Envoyer les logs à Azure Monitor
response=$(curl -X POST \
  "https://$workspaceId.ods.opinsights.azure.com/api/logs?api-version=2016-04-01" \
  -H "Content-Type: application/json" \
  -H "Log-Type: $logType" \
  -H "x-ms-date: $timeGenerated" \
  -H "Authorization: SharedKey $workspaceId:$authSignature" \
  -d "$logData")

echo "Response: $response"
