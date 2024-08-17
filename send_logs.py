import requests
import hmac
import hashlib
import base64
from datetime import datetime

# Configuration
workspaceId="b7def82e-8f8a-4f30-ae2d-19fbca38427e"
primaryKey="/c+muE6qnt2jB70X6R5OF9LlrXIIGzo9LWR0BpFKRky54BP0RjJL1EHXtbxoO4+EjIp0tsLgfV80PXL8OXDt3w==" # Clé primaire
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
