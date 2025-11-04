# Script de connexion à Azure et Microsoft Graph (Entra ID) - Version simplifiée
# ---------------------------------------------------

# Connexion à Azure
Write-Host "Connexion à Azure..." -ForegroundColor Green
Connect-AzAccount

# Connexion à Microsoft Graph
Write-Host "Connexion à Microsoft Graph..." -ForegroundColor Green
Connect-MgGraph -Scopes "User.Read.All" -NoWelcome

# Vérification de la connexion
if (Get-MgContext) {
    Write-Host "Connexion réussie à Microsoft Graph" -ForegroundColor Green
}
else {
    Write-Host "Échec de la connexion à Microsoft Graph" -ForegroundColor Red
}

Write-Host "Connexion terminée" -ForegroundColor Green
