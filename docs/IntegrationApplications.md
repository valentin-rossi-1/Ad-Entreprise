# Intégration et sécurisation des applications avec Entra ID

Ce document explique comment intégrer des applications SaaS et des applications personnalisées avec Entra ID pour l'USS Enterprise, et comment configurer le Single Sign-On (SSO) et les rôles.

## 1. Intégration d'applications SaaS

Les applications SaaS (Software as a Service) peuvent être intégrées facilement avec Entra ID grâce à la galerie d'applications.

### Processus d'intégration

1. **Sélection de l'application dans la galerie** : Entra ID propose une galerie de milliers d'applications pré-configurées.
2. **Configuration du SSO** : Configuration de l'authentification unique pour permettre aux membres d'équipage de se connecter avec leurs identifiants Entra ID.
3. **Attribution des accès** : Déterminer quels utilisateurs ou groupes auront accès à l'application.

### Applications SaaS intégrées pour l'USS Enterprise

#### Journal de Bord (Captain's Log)

Application permettant aux capitaines et officiers de tenir leur journal de bord officiel.
```powershell
# Intégration de l'application Captain's Log
.\Integration-AppSaaS.ps1 -Action Add -AppName "Captain's Log"

# Attribution de l'accès aux officiers supérieurs
.\Integration-AppSaaS.ps1 -Action AssignUsers -AppName "Captain's Log" -GroupName "USS Enterprise - Officiers Supérieurs"
```

#### Centre de Commandement (Command Center)

Application centralisée pour la gestion des opérations du vaisseau.
```powershell
# Intégration de l'application Command Center
.\Integration-AppSaaS.ps1 -Action Add -AppName "Command Center"

# Attribution d'accès au capitaine
.\Integration-AppSaaS.ps1 -Action AssignUsers -AppName "Command Center" -UserPrincipalName "picard@enterprise.starfleet"
```

## 2. Intégration d'applications personnalisées

Pour les applications développées spécifiquement pour l'USS Enterprise, une intégration personnalisée est nécessaire.

### Processus d'enregistrement

1. **Enregistrement de l'application** : Création d'une identité pour l'application dans Entra ID.
2. **Configuration de l'authentification** : Définition des URI de redirection et des méthodes d'authentification.
3. **Définition des rôles** : Création des rôles spécifiques à l'application.
4. **Attribution des rôles** : Association des utilisateurs et groupes aux rôles appropriés.

### Applications personnalisées pour l'USS Enterprise

#### Gestion des Réparations (Repair Management)

Application utilisée par l'ingénierie pour gérer les réparations du vaisseau.
```powershell
# Enregistrement de l'application
.\Integration-AppPerso.ps1 -Action Register -AppName "Repair Management" -AppURI "https://enterprise.starfleet/repair"

# Ajout des rôles
.\Integration-AppPerso.ps1 -Action AddRoles -AppName "Repair Management" -RoleName "Engineer" -RoleDescription "Peut modifier les données de réparation"
.\Integration-AppPerso.ps1 -Action AddRoles -AppName "Repair Management" -RoleName "Viewer" -RoleDescription "Peut visualiser les données de réparation"

# Attribution des rôles
.\Integration-AppPerso.ps1 -Action AssignRoles -AppName "Repair Management" -RoleName "Engineer" -UserPrincipalName "geordi.laforge@enterprise.starfleet"
.\Integration-AppPerso.ps1 -Action AssignRoles -AppName "Repair Management" -RoleName "Viewer" -GroupName "USS Enterprise - Officiers Supérieurs"
```

## 3. Configuration du Single Sign-On (SSO)

Le Single Sign-On permet aux membres d'équipage d'utiliser leurs identifiants Entra ID pour se connecter à toutes les applications intégrées sans avoir à s'authentifier à nouveau.

### Types de SSO supportés

- **SAML** : Security Assertion Markup Language, utilisé pour les applications web.
- **OAuth/OpenID Connect** : Utilisé pour les applications modernes et les API.
- **Authentification intégrée Windows** : Pour les applications sur site.

## 4. Bonnes pratiques de sécurité

Pour garantir la sécurité des applications intégrées avec Entra ID, suivez ces bonnes pratiques :

1. **Accès basé sur les rôles** : Attribuez uniquement les permissions nécessaires à chaque rôle.
2. **Principe du moindre privilège** : Limitez les accès au minimum requis pour chaque fonction.
3. **Revue régulière des accès** : Auditez périodiquement qui a accès à quelles applications.
4. **Authentification multifactorielle** : Exigez le MFA pour l'accès aux applications critiques.
5. **Surveillance des activités** : Configurez la journalisation et l'alerte pour les comportements suspects.

## 5. Test des configurations

Après avoir intégré une application, il est important de tester l'accès :

1. Connectez-vous au portail [https://myapplications.microsoft.com](https://myapplications.microsoft.com) avec un compte de test.
2. Vérifiez que les applications attribuées sont visibles.
3. Cliquez sur chaque application pour tester le SSO.
4. Vérifiez que les rôles et permissions sont correctement appliqués.
