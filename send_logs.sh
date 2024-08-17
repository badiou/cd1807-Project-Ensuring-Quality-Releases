#!/bin/bash

# Variables
workspaceId="b7def82e-8f8a-4f30-ae2d-19fbca38427e"
primaryKey="/c+muE6qnt2jB70X6R5OF9LlrXIIGzo9LWR0BpFKRky54BP0RjJL1EHXtbxoO4+EjIp0tsLgfV80PXL8OXDt3w==" 
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
