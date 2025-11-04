# Script de connexion interactive à Azure et Microsoft Graph
# ----------------------------------------------------------

# Extraire le tenant ID de l'erreur précédente
$tenantId = "a130441c-0f54-45fb-901c-b2033dbecc5c"

# Connexion à Azure avec authentification interactive et tenant ID spécifique
Write-Host "Connexion à Azure avec le tenant ID: $tenantId..." -ForegroundColor Green
try {
    Connect-AzAccount -TenantId $tenantId -UseDeviceAuthentication
    Write-Host "Connexion à Azure réussie!" -ForegroundColor Green
}
catch {
    Write-Host "Erreur lors de la connexion à Azure: $_" -ForegroundColor Red
    exit
}

# Connexion à Microsoft Graph avec une portée minimale
Write-Host "Connexion à Microsoft Graph..." -ForegroundColor Green
try {
    Connect-MgGraph -TenantId $tenantId -Scopes "User.Read" -UseDeviceAuthentication
    Write-Host "Connexion à Microsoft Graph réussie!" -ForegroundColor Green
}
catch {
    Write-Host "Erreur lors de la connexion à Microsoft Graph: $_" -ForegroundColor Red
    exit
}

# Vérifier le contexte et afficher des informations utiles
$azContext = Get-AzContext
$mgContext = Get-MgContext

Write-Host "`nInformations sur la connexion:" -ForegroundColor Cyan
Write-Host "Compte Azure: $($azContext.Account)" -ForegroundColor Cyan
Write-Host "Tenant Azure: $($azContext.Tenant.Id)" -ForegroundColor Cyan
Write-Host "Compte Microsoft Graph: $($mgContext.Account)" -ForegroundColor Cyan
Write-Host "Tenant Microsoft Graph: $($mgContext.TenantId)" -ForegroundColor Cyan

Write-Host "`nVous êtes maintenant connecté et prêt à travailler avec Azure et Entra ID!" -ForegroundColor Green
