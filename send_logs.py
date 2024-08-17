import requests
import hmac
import hashlib
import base64
from datetime import datetime

# Configuration
workspace_id = 'aee36f6d-42ce-412a-9d4a-d58910526bae'  # ID du workspace
primary_key = 'uLrjWHFM8kc09WXFnQbhOpIBwTFhRmj0hnSv424clAEgB3m3bXDHAXL3zJ7e5KhcH4HqF7S4jbPx3JHVJC3/nQ=='  # Clé primaire
log_type = 'SeleniumLogs'
api_version = '2016-04-01'

# Obtenir la date et l'heure en format requis
time_generated = datetime.utcnow().strftime('%a, %d %b %Y %H:%M:%S GMT')

# Exemple de données de log JSON
log_data = '{"time":"2024-08-17T17:56:21Z","message":"Test message"}'
content_length = len(log_data)

# Construire la chaîne à signer
string_to_sign = f"POST\n{content_length}\napplication/json\nx-ms-date:{time_generated}\n/api/logs"

# Calculer la signature
signature = base64.b64encode(
    hmac.new(
        base64.b64decode(primary_key), 
        string_to_sign.encode('utf-8'), 
        hashlib.sha256
    ).digest()
).decode()

# Envoyer les logs à Azure Monitor
url = f"https://{workspace_id}.ods.opinsights.azure.com/api/logs?api-version={api_version}"
headers = {
    'Content-Type': 'application/json',
    'Log-Type': log_type,
    'x-ms-date': time_generated,
    'Authorization': f'SharedKey {workspace_id}:{signature}'
}

response = requests.post(url, headers=headers, data=log_data)

# Afficher la réponse pour débogage
print("Response Status Code:", response.status_code)
print("Response Content:", response.text)
