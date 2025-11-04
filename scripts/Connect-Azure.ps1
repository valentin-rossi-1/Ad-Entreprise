# Script de connexion à Azure et Microsoft Graph (Entra ID)
# ---------------------------------------------------

# Connexion à Azure avec authentification par code d'appareil
Write-Host "Connexion à Azure..." -ForegroundColor Green
Connect-AzAccount -UseDeviceAuthentication

# Récupérer l'ID du tenant
$context = Get-AzContext
$tenantId = $context.Tenant.Id
Write-Host "Tenant ID: $tenantId" -ForegroundColor Yellow

# Connexion à Microsoft Graph avec authentification interactive
Write-Host "Connexion à Microsoft Graph..." -ForegroundColor Green
Connect-MgGraph -TenantId $tenantId -Scopes @("Directory.ReadWrite.All", "User.ReadWrite.All", "Group.ReadWrite.All", "Application.ReadWrite.All", "Policy.ReadWrite.All") -UseDeviceAuthentication

# Afficher les informations du tenant connecté
Write-Host "Récupération des informations du tenant..." -ForegroundColor Green
try {
    $org = Get-MgOrganization
    Write-Host "Connexion réussie!" -ForegroundColor Green
    Write-Host "Tenant Name: $($org.DisplayName)" -ForegroundColor Green
    Write-Host "Tenant ID: $($org.Id)" -ForegroundColor Green
} catch {
    Write-Host "Erreur lors de la récupération des informations du tenant: $_" -ForegroundColor Red

