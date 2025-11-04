# Automatisation avec PowerShell pour Entra ID

Ce document explique comment utiliser les scripts PowerShell pour automatiser la gestion des utilisateurs et des groupes dans Entra ID pour l'USS Enterprise.

## Prérequis

- PowerShell 5.1 ou supérieur
- Modules Az et Microsoft.Graph installés
- Compte avec les autorisations appropriées dans Entra ID
- Connexion établie via le script Connect-AzureInteractive.ps1

## Gestion des utilisateurs (membres d'équipage)

Le script `Manage-Users.ps1` permet d'automatiser les tâches courantes de gestion des utilisateurs.

### Ajouter un nouveau membre d'équipage
```powershell
.\Manage-Users.ps1 -Action Add -UserPrincipalName "picard@enterprise.starfleet" -DisplayName "Jean-Luc Picard" -Department "Command" -JobTitle "Captain"
```

Cette commande crée un nouveau compte utilisateur avec le nom d'affichage "Jean-Luc Picard", le département "Command" et le titre "Captain". Un mot de passe aléatoire est généré et affiché.

### Mettre à jour un membre d'équipage
```powershell
.\Manage-Users.ps1 -Action Update -UserPrincipalName "worf@enterprise.starfleet" -JobTitle "Chief of Security"
```

Cette commande met à jour le titre du poste de Worf en "Chief of Security".

### Lister les membres d'équipage
```powershell

## Gestion des groupes (équipes)

Le script `Manage-Groups.ps1` permet d'automatiser la création et la gestion des groupes dans Entra ID.

### Créer une nouvelle équipe
```powershell
.\Manage-Groups.ps1 -Action Create -GroupName "Away Team" -Description "Équipe d'exploration planétaire"
```

### Ajouter un membre à une équipe
```powershell
.\Manage-Groups.ps1 -Action AddMember -GroupName "Away Team" -MemberUPN "data@enterprise.starfleet"
```

### Lister les membres d'une équipe
```powershell
.\Manage-Groups.ps1 -Action ListMembers -GroupName "Away Team"
```

### Retirer un membre d'une équipe
```powershell
.\Manage-Groups.ps1 -Action RemoveMember -GroupName "Away Team" -MemberUPN "wesley.crusher@enterprise.starfleet"
```

### Lister toutes les équipes
```powershell
.\Manage-Groups.ps1
```

### Supprimer une équipe
```powershell
.\Manage-Groups.ps1 -Action Remove -GroupName "Away Team"
```

## Scénarios d'automatisation

Ces scripts peuvent être utilisés dans plusieurs scénarios d'automatisation :

1. **Intégration de nouveaux membres d'équipage** : Lors de l'arrivée d'un nouveau membre d'équipage, créez son compte utilisateur et ajoutez-le aux groupes appropriés en une seule opération.

4. **Rapports** : Générez facilement des listes de membres d'équipage par département ou par équipe pour les rapports de Starfleet.

Ces scripts peuvent être étendus pour :

- Intégrer des flux de travail d'approbation
- Générer des rapports automatiques

## Bonnes pratiques de sécurité

Lors de l'utilisation de ces scripts :

1. Utilisez toujours des comptes avec le principe du moindre privilège
2. Ne stockez jamais de mots de passe en clair dans les scripts
3. Journalisez toutes les actions pour une piste d'audit
4. Testez les scripts dans un environnement de développement avant de les utiliser en production- S'intégrer à d'autres systèmes via des API
- Planifier des tâches récurrentes via des tâches planifiées
## Extension des scripts


3. **Départ de membres d'équipage** : Automatisez la désactivation des comptes et la suppression des appartenances aux groupes lorsqu'un membre quitte le vaisseau.
2. **Rotations d'équipes** : Mettez à jour rapidement la composition des équipes lors des changements de quart ou de missions.

.\Manage-Users.ps1 -Action Remove -UserPrincipalName "tasha.yar@enterprise.starfleet"
```

### Supprimer un membre d'équipage
```powershell
# Lister tous les membres d'équipage
.\Manage-Users.ps1 -Department "Engineering"
```
.\Manage-Users.ps1

