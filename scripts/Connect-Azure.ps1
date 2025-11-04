# Ouvrez le fichier Connect-Azure.ps1 dans un éditeur de texte
# Remplacez le contenu par ce qui suit

# Script de connexion à Azure et Microsoft Graph (Entra ID)
# ---------------------------------------------------

# Connexion à Azure avec authentification par code d'appareil
Write-Host "Connexion à Azure..." -ForegroundColor Green
Connect-AzAccount -UseDeviceAuthentication

# Connexion à Microsoft Graph avec authentification interactive
Write-Host "Connexion à Microsoft Graph..." -ForegroundColor Green
Connect-MgGraph -Scopes "Directory.ReadWrite.All", "User.ReadWrite.All", "Group.ReadWrite.All", "Application.ReadWrite.All", "Policy.ReadWrite.All" -UseDeviceAuthentication

# Afficher les informations du tenant connecté
Write-Host "Récupération des informations du tenant..." -ForegroundColor Green
try {
    Get-MgOrganization | Select-Object DisplayName, Id
    Write-Host "Connexion réussie!" -ForegroundColor Green
} catch {
    Write-Host "Erreur lors de la récupération des informations du tenant: $_" -ForegroundColor Red
}
