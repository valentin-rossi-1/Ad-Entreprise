# Script de connexion à Azure et Microsoft Graph (Entra ID)
# ---------------------------------------------------

# Connexion à Azure
Connect-AzAccount

# Connexion à Microsoft Graph avec les autorisations nécessaires
Connect-MgGraph -Scopes "Directory.ReadWrite.All", "User.ReadWrite.All", "Group.ReadWrite.All", "Application.ReadWrite.All", "Policy.ReadWrite.All"

# Afficher les informations du tenant connecté
Get-MgOrganization | Select-Object DisplayName, Id
