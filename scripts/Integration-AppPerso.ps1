# Script d'intégration d'applications personnalisées avec Entra ID pour l'USS Enterprise
# ---------------------------------------------------------------------------------
# Ce script permet d'intégrer des applications personnalisées avec Entra ID et de configurer
# les rôles et permissions pour ces applications.

# Paramètres du script
param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("Register", "Update", "Remove", "List", "AddRoles", "AssignRoles")]
    [string]$Action = "List",
    
    [Parameter(Mandatory = $false)]
    [string]$AppName,
    
    [Parameter(Mandatory = $false)]
    [string]$AppURI,
    
    [Parameter(Mandatory = $false)]
    [string]$RedirectURI,
    
    [Parameter(Mandatory = $false)]
    [string]$RoleName,
    
    [Parameter(Mandatory = $false)]
    [string]$RoleDescription,
    
    [Parameter(Mandatory = $false)]
    [string]$UserPrincipalName,
    
    [Parameter(Mandatory = $false)]
    [string]$GroupName
)

# Vérifier que nous sommes bien connectés à Microsoft Graph
if (-not (Get-MgContext)) {
    Write-Host "Vous n'êtes pas connecté à Microsoft Graph. Exécutez d'abord Connect-AzureInteractive.ps1" -ForegroundColor Red
    exit
}

# Fonction pour enregistrer une application personnalisée
function Register-CustomApplication {
    param (
        [Parameter(Mandatory = $true)]
        [string]$AppName,
        
        [Parameter(Mandatory = $false)]
        [string]$AppURI,
        
        [Parameter(Mandatory = $false)]
        [string]$RedirectURI
    )
    
    # Dans un environnement réel, nous utiliserions New-MgApplication
    
    # Génération d'un identifiant unique pour l'application
    $appId = [Guid]::NewGuid().ToString()
    
    if (-not $AppURI) {
        $AppURI = "https://enterprise.starfleet/$($AppName.ToLower().Replace(' ', '-'))"
    }
    
    if (-not $RedirectURI) {
        $RedirectURI = "$AppURI/auth"
    }
    
    Write-Host "Application '$AppName' enregistrée avec succès" -ForegroundColor Green
    Write-Host "ID de l'application: $appId" -ForegroundColor Green
    Write-Host "URI de l'application: $AppURI" -ForegroundColor Green
    Write-Host "URI de redirection: $RedirectURI" -ForegroundColor Green
    
    return @{
        AppName = $AppName
        AppId = $appId
        AppURI = $AppURI
        RedirectURI = $RedirectURI
    }
}

# Fonction pour ajouter des rôles à une application
function Add-ApplicationRoles {
    param (
        [Parameter(Mandatory = $true)]
        [string]$AppName,
        
        [Parameter(Mandatory = $true)]
        [string]$RoleName,
        
        [Parameter(Mandatory = $true)]
        [string]$RoleDescription
    )
    
    # Dans un environnement réel, nous utiliserions Update-MgApplication
    
    # Génération d'un identifiant unique pour le rôle
    $roleId = [Guid]::NewGuid().ToString()
    
    Write-Host "Ajout du rôle '$RoleName' à l'application '$AppName'..." -ForegroundColor Yellow
    Write-Host "ID du rôle: $roleId" -ForegroundColor Green
    Write-Host "Description: $RoleDescription" -ForegroundColor Green
    
    Write-Host "Rôle ajouté avec succès à l'application" -ForegroundColor Green
}

# Exécuter l'action demandée
switch ($Action) {
    "Register" {
        if (-not $AppName) {
            Write-Host "Pour enregistrer une application, spécifiez au moins AppName" -ForegroundColor Red
            exit
        }
        Register-CustomApplication -AppName $AppName -AppURI $AppURI -RedirectURI $RedirectURI
    }
    "AddRoles" {
        if (-not $AppName -or -not $RoleName -or -not $RoleDescription) {
            Write-Host "Pour ajouter un rôle, spécifiez AppName, RoleName et RoleDescription" -ForegroundColor Red
            exit
        }
        Add-ApplicationRoles -AppName $AppName -RoleName $RoleName -RoleDescription $RoleDescription
    }
    # Autres actions omises pour concision
}

# Exemples d'utilisation
<#
# Enregistrer une application personnalisée
.\Integration-AppPerso.ps1 -Action Register -AppName "Repair Management" -AppURI "https://enterprise.starfleet/repair"

# Ajouter un rôle à une application
.\Integration-AppPerso.ps1 -Action AddRoles -AppName "Repair Management" -RoleName "Engineer" -RoleDescription "Peut modifier les données de réparation"
#>
