$tableParams = @'
{
    "properties": {
        "schema": {
            "name": "CustomTable_CL",
            "columns": [
                {
                    "name": "TimeGenerated",
                    "type": "DateTime"
                }, 
                {
                    "name": "RawData",
                    "type": "String"
                },
                {
                    "name": "FilePath",
                    "type": "String"
                }
            ]
        }
    }
}
'@

# Utiliser l'ID de souscription mis à jour
$subscriptionId = "c6b49f87-b44b-4f50-9328-64efe17053d2"
$resourceGroup = "AzuredevopsRG"
$workspaceName = "projectws"
$tableName = "CustomTable"  # Nom de la table sans le suffixe _CL

# Construire le chemin pour l'API REST
$path = "/subscriptions/$subscriptionId/resourcegroups/$resourceGroup/providers/microsoft.operationalinsights/workspaces/$workspaceName/tables/${tableName}_CL?api-version=2021-12-01-preview"

# Appeler l'API REST pour créer ou mettre à jour la table
Invoke-AzRestMethod -Path $path -Method PUT -Payload $tableParams
