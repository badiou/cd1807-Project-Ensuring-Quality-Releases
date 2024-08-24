$tableParams = @'
{
    "properties": {
        "schema": {
            "name": "SeleniumTest_CL",
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

Invoke-AzRestMethod -Path "/subscriptions/c6b49f87-b44b-4f50-9328-64efe17053d2/resourcegroups/azuredevopsrg/providers/microsoft.operationalinsights/workspaces/SeleniumTestWS/tables/SeleniumTest_CL?api-version=2023-06-01" -Method PUT -Payload $tableParams
