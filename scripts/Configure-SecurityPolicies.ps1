# Configuration des politiques de sécurité pour l'USS Enterprise
# -------------------------------------------------------------

# Vérifier que nous sommes bien connectés à Microsoft Graph
if (-not (Get-MgContext)) {
    Write-Host "Vous n'êtes pas connecté à Microsoft Graph. Exécutez d'abord Connect-AzureInteractive.ps1" -ForegroundColor Red
    exit
}

Write-Host "Configuration des politiques de sécurité pour l'USS Enterprise..." -ForegroundColor Green

# 1. Créer un groupe pour les officiers supérieurs
Write-Host "Création du groupe pour les officiers supérieurs..." -ForegroundColor Green

$seniorOfficersGroup = @{
    DisplayName = "USS Enterprise - Officiers Supérieurs"
    Description = "Groupe contenant tous les officiers supérieurs de l'USS Enterprise"
    SecurityEnabled = $true
    MailEnabled = $false
    MailNickname = "uss-enterprise-senior-officers"
}

try {
    $group = New-MgGroup -BodyParameter $seniorOfficersGroup
    Write-Host "Groupe créé avec l'ID: $($group.Id)" -ForegroundColor Green
}
catch {
    Write-Host "Erreur lors de la création du groupe: $_" -ForegroundColor Red
    Write-Host "Vérification si le groupe existe déjà..." -ForegroundColor Yellow
    $existingGroup = Get-MgGroup -Filter "DisplayName eq 'USS Enterprise - Officiers Supérieurs'"
    if ($existingGroup) {
        $group = $existingGroup
        Write-Host "Groupe existant trouvé avec l'ID: $($group.Id)" -ForegroundColor Yellow
    }
    else {
        Write-Host "Impossible de créer ou trouver le groupe. Vérifiez vos permissions." -ForegroundColor Red
        exit
    }
}

# 2. Configuration de l'authentification multifactorielle
# Note: Dans Entra ID, MFA est généralement configuré via des politiques d'accès conditionnel

Write-Host "Configuration de l'authentification multifactorielle via l'accès conditionnel..." -ForegroundColor Green

try {
    $mfaPolicy = @{
        DisplayName = "USS Enterprise - MFA pour officiers supérieurs"
        State = "enabled"
        Conditions = @{
            Users = @{
                IncludeGroups = @($group.Id)
            }
            Applications = @{
                IncludeApplications = @("All")
            }
        }
        GrantControls = @{
            Operator = "OR"
            BuiltInControls = @("mfa")
        }
    }

    New-MgIdentityConditionalAccessPolicy -BodyParameter $mfaPolicy
    Write-Host "Politique MFA créée avec succès" -ForegroundColor Green
}
catch {
    Write-Host "Erreur lors de la création de la politique MFA: $_" -ForegroundColor Red
    Write-Host "Cette opération peut nécessiter des autorisations supplémentaires ou une licence premium" -ForegroundColor Yellow
}


