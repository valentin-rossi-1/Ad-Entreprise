# Guide d'implémentation manuelle des politiques de sécurité

Ce document explique comment configurer manuellement les politiques de sécurité pour l'USS Enterprise via le portail Azure Entra ID.

## 1. Création du groupe des officiers supérieurs

1. Connectez-vous au [portail Azure](https://portal.azure.com)
2. Naviguez vers **Entra ID** > **Groupes**
3. Cliquez sur **+ Nouveau groupe**
4. Configurez le groupe comme suit:
   - Type de groupe: **Sécurité**
   - Nom du groupe: **USS Enterprise - Officiers Supérieurs**
   - Description: **Groupe contenant tous les officiers supérieurs de l'USS Enterprise**
   - Membres: Ajoutez les utilisateurs appropriés
5. Cliquez sur **Créer**

## 2. Configuration de l'authentification multifactorielle

### Via l'accès conditionnel:

1. Dans Entra ID, naviguez vers **Sécurité** > **Accès conditionnel**
2. Cliquez sur **+ Nouvelle politique**
3. Configurez la politique comme suit:
   - Nom: **USS Enterprise - MFA pour officiers supérieurs**
   - Utilisateurs et groupes: Sélectionnez le groupe **USS Enterprise - Officiers Supérieurs**
   - Applications cloud: **Toutes les applications cloud**
   - Contrôles d'accès: Cochez **Exiger l'authentification multifactorielle**
4. Activez la politique en sélectionnant **Activé**
5. Cliquez sur **Créer**

## 3. Configuration des restrictions d'accès par emplacement

1. Dans Entra ID, naviguez vers **Sécurité** > **Accès conditionnel**
2. Cliquez sur **+ Nouvelle politique**
3. Configurez la politique comme suit:
   - Nom: **USS Enterprise - Restriction par emplacement**
   - Utilisateurs et groupes: Sélectionnez le groupe **USS Enterprise - Officiers Supérieurs**
   - Applications cloud: **Toutes les applications cloud**
   - Conditions: Sélectionnez **Emplacements** et configurez pour exclure les emplacements approuvés
   - Contrôles d'accès: Cochez **Exiger l'authentification multifactorielle**
4. Activez la politique en sélectionnant **Activé**
5. Cliquez sur **Créer**

## 4. Tests des politiques

Pour tester les politiques:

1. Créez un utilisateur de test et ajoutez-le au groupe des officiers supérieurs
2. Connectez-vous avec cet utilisateur à une application Microsoft 365 ou Azure
3. Vérifiez que le MFA est demandé
4. Pour tester les restrictions d'emplacement, connectez-vous depuis un appareil qui n'est pas défini comme emplacement approuvé
