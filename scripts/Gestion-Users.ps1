# Script d'automatisation pour la gestion des utilisateurs dans l'USS Enterprise
# ---------------------------------------------------------------------
# Ce script permet d'automatiser l'ajout, la modification et la suppression
# des utilisateurs (membres d'équipage) dans Entra ID.

# Paramètres du script
param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("Add", "Update", "Remove", "List")]
    [string]$Action = "List",
    
    [Parameter(Mandatory = $false)]
    [string]$UserPrincipalName,
    
    [Parameter(Mandatory = $false)]
    [string]$DisplayName,
    
    [Parameter(Mandatory = $false)]
    [string]$Department,
    
    [Parameter(Mandatory = $false)]
    [string]$JobTitle,
    
    [Parameter(Mandatory = $false)]
    [string]$Password
)

# Vérifier que nous sommes connectés à Microsoft Graph
if (-not (Get-MgContext)) {
    Write-Host "Vous n'êtes pas connecté à Microsoft Graph. Exécutez d'abord Connect-AzureInteractive.ps1" -ForegroundColor Red
    exit
}

# Fonction pour générer un mot de passe aléatoire sécurisé
function Get-RandomPassword {
    $length = 16
    $nonAlphaChars = 5
    $password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
    return $password
}

# Fonction pour ajouter un nouvel utilisateur (membre d'équipage)
function Add-CrewMember {
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserPrincipalName,
        
        [Parameter(Mandatory = $true)]
        [string]$DisplayName,
        
        [Parameter(Mandatory = $false)]
        [string]$Department = "Operations",
        
        [Parameter(Mandatory = $false)]
        [string]$JobTitle = "Crew Member",
        
        [Parameter(Mandatory = $false)]
        [string]$Password = (Get-RandomPassword)
    )
    
    # Extraire le domaine du UPN
    $domain = $UserPrincipalName.Split('@')[1]
    if (-not $domain) {
        $defaultDomain = (Get-MgDomain | Where-Object { $_.IsDefault -eq $true }).Id
        $UserPrincipalName = "$UserPrincipalName@$defaultDomain"
    }
    
    # Extraire le mailNickname du UPN
    $mailNickname = $UserPrincipalName.Split('@')[0]
    
    # Préparer l'objet utilisateur
    $userParams = @{
        DisplayName = $DisplayName
        UserPrincipalName = $UserPrincipalName
        MailNickname = $mailNickname
        AccountEnabled = $true
        Department = $Department
        JobTitle = $JobTitle
        PasswordProfile = @{
            Password = $Password
            ForceChangePasswordNextSignIn = $true
        }
    }
    
    # Créer l'utilisateur
    try {
        $newUser = New-MgUser -BodyParameter $userParams
        Write-Host "Membre d'équipage ajouté avec succès: $DisplayName ($UserPrincipalName)" -ForegroundColor Green
        Write-Host "Mot de passe initial: $Password" -ForegroundColor Yellow
        return $newUser
    }
    catch {
        Write-Host "Erreur lors de l'ajout du membre d'équipage: $_" -ForegroundColor Red
    }
}

# Fonction pour mettre à jour un utilisateur existant
function Update-CrewMember {
        [string]$DisplayName,
        
        [Parameter(Mandatory = $false)]
        [Parameter(Mandatory = $false)]
        [string]$JobTitle
    )
    
    # Trouver l'utilisateur existant
    try {
        $user = Get-MgUser -Filter "userPrincipalName eq '$UserPrincipalName'"
        if (-not $user) {
            Write-Host "Utilisateur non trouvé: $UserPrincipalName" -ForegroundColor Red
            return
        }
        
        # Préparer les paramètres de mise à jour
        $updateParams = @{}
        
        if ($DisplayName) { $updateParams.DisplayName = $DisplayName }
        if ($Department) { $updateParams.Department = $Department }
        if ($JobTitle) { $updateParams.JobTitle = $JobTitle }
        
        # Mettre à jour l'utilisateur
        Update-MgUser -UserId $user.Id -BodyParameter $updateParams
        Write-Host "Membre d'équipage mis à jour avec succès: $UserPrincipalName" -ForegroundColor Green
# Fonction pour supprimer un utilisateur
    )
    try {
        $user = Get-MgUser -Filter "userPrincipalName eq '$UserPrincipalName'"
        if (-not $user) {
            Write-Host "Utilisateur non trouvé: $UserPrincipalName" -ForegroundColor Red
            return
        }
        
        # Demander confirmation
        $confirmation = Read-Host "Êtes-vous sûr de vouloir supprimer le membre d'équipage $($user.DisplayName) ($UserPrincipalName)? (O/N)"
        if ($confirmation -ne "O" -and $confirmation -ne "o") {
            Write-Host "Opération annulée" -ForegroundColor Yellow
            return
        }
        
        # Supprimer l'utilisateur
        [string]$Department,
        
    )
    
    # Construire le filtre
    $filter = ""
    if ($Department) { 
        $filter += "department eq '$Department'"
    }
    
    if ($JobTitle) {
        if ($filter) { $filter += " and " }
        $filter += "jobTitle eq '$JobTitle'"
    }
    
    # Récupérer les utilisateurs
    try {
        if ($filter) {
            $users = Get-MgUser -Filter $filter -Property "Id,DisplayName,UserPrincipalName,Department,JobTitle"
        }
        else {
            $users = Get-MgUser -Property "Id,DisplayName,UserPrincipalName,Department,JobTitle"
        }
        
        # Afficher les utilisateurs
        Write-Host "Membres d'équipage:" -ForegroundColor Cyan
        $users | Format-Table -Property DisplayName, UserPrincipalName, Department, JobTitle -AutoSize
        
        return $users
    }
    catch {
        Write-Host "Erreur lors de la récupération des membres d'équipage: $_" -ForegroundColor Red
    }
}

# Exécuter l'action demandée
switch ($Action) {
    "Add" {
        if (-not $UserPrincipalName -or -not $DisplayName) {
            Write-Host "Pour ajouter un utilisateur, spécifiez au moins UserPrincipalName et DisplayName" -ForegroundColor Red
            exit
        }
        Add-CrewMember -UserPrincipalName $UserPrincipalName -DisplayName $DisplayName -Department $Department -JobTitle $JobTitle -Password $Password
    }
    "Update" {
        if (-not $UserPrincipalName) {
            Write-Host "Pour mettre à jour un utilisateur, spécifiez au moins UserPrincipalName" -ForegroundColor Red
            exit
        }
        Update-CrewMember -UserPrincipalName $UserPrincipalName -DisplayName $DisplayName -Department $Department -JobTitle $JobTitle
    }
    "Remove" {
        if (-not $UserPrincipalName) {
            Write-Host "Pour supprimer un utilisateur, spécifiez UserPrincipalName" -ForegroundColor Red
            exit
        }
        Remove-CrewMember -UserPrincipalName $UserPrincipalName
    }
    "List" {
        List-CrewMembers -Department $Department -JobTitle $JobTitle
    }
}

# Exemples d'utilisation (en commentaire)
<#
# Ajouter un nouvel officier
.\Manage-Users.ps1 -Action Add -UserPrincipalName "worf@enterprise.starfleet" -DisplayName "Worf" -Department "Security" -JobTitle "Security Chief"

# Mettre à jour un membre d'équipage
.\Manage-Users.ps1 -Action Update -UserPrincipalName "data@enterprise.starfleet" -JobTitle "Operations Officer"

# Supprimer un membre d'équipage
.\Manage-Users.ps1 -Action Remove -UserPrincipalName "wesley.crusher@enterprise.starfleet"

# Lister tous les membres d'équipage
.\Manage-Users.ps1

# Lister tous les officiers de sécurité
.\Manage-Users.ps1 -Department "Security"
#>        [Parameter(Mandatory = $false)]
        [string]$JobTitle
# Fonction pour lister les utilisateurs
        [Parameter(Mandatory = $false)]
function List-CrewMembers {
    param (
        Remove-MgUser -UserId $user.Id

    }
}
        Write-Host "Membre d'équipage supprimé avec succès: $($user.DisplayName) ($UserPrincipalName)" -ForegroundColor Green
        Write-Host "Erreur lors de la suppression du membre d'équipage: $_" -ForegroundColor Red
    }
    catch {
    
    # Trouver l'utilisateur existant
        [Parameter(Mandatory = $true)]
        [string]$UserPrincipalName
function Remove-CrewMember {
    param (
}

        Write-Host "Erreur lors de la mise à jour du membre d'équipage: $_" -ForegroundColor Red
    }
    }
    catch {
        [string]$Department,
        
    param (
        [string]$UserPrincipalName,
        
        [Parameter(Mandatory = $false)]

