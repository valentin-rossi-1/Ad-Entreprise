# Script d'automatisation pour la gestion des groupes dans l'USS Enterprise
# ---------------------------------------------------------------------
# Ce script permet d'automatiser la création, la gestion et la suppression
# des groupes (équipes) dans Entra ID.

# Paramètres du script
param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("Create", "Update", "Remove", "List", "AddMember", "RemoveMember", "ListMembers")]
    [string]$Action = "List",
    
    [Parameter(Mandatory = $false)]
    [string]$GroupName,
    
    [Parameter(Mandatory = $false)]
    [string]$Description,
    
    [Parameter(Mandatory = $false)]
    [string]$MemberUPN
)

# Vérifier que nous sommes connectés à Microsoft Graph
if (-not (Get-MgContext)) {
    Write-Host "Vous n'êtes pas connecté à Microsoft Graph. Exécutez d'abord Connect-AzureInteractive.ps1" -ForegroundColor Red
    exit
}

# Fonction pour créer un nouveau groupe
function Create-Team {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GroupName,
        
        [Parameter(Mandatory = $false)]
        [string]$Description = "Équipe de l'USS Enterprise"
    )
    
    # Créer un mailNickname à partir du nom du groupe
    $mailNickname = $GroupName.Replace(" ", "").ToLower()
    
    # Préparer l'objet groupe
    $groupParams = @{
        DisplayName = $GroupName
        Description = $Description
        MailNickname = $mailNickname
        SecurityEnabled = $true
        MailEnabled = $false
    }
    
    # Créer le groupe
    try {
        $newGroup = New-MgGroup -BodyParameter $groupParams
        Write-Host "Équipe créée avec succès: $GroupName" -ForegroundColor Green
        return $newGroup
    }
    catch {
        Write-Host "Erreur lors de la création de l'équipe: $_" -ForegroundColor Red
    }
}

# Fonction pour mettre à jour un groupe existant
function Update-Team {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GroupName,
        
        [Parameter(Mandatory = $true)]
