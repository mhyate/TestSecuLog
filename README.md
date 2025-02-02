# LocaMat - Système de Gestion de Matériel

LocaMat est une application web moderne pour la gestion de matériel informatique, permettant aux utilisateurs de réserver et gérer des équipements de manière efficace et intuitive.

## Guide d'Installation

Pour installer et exécuter ce projet localement, suivez ces étapes :

1. **Prérequis**
   - Node.js (version 18 ou supérieure)
   - npm (installé avec Node.js)
   - Git

2. **Cloner le projet**
   ```bash
   git clone https://github.com/mhyate/TestSecuLog.git
   cd TestSecuLog
   ```

3. **Installation des dépendances**
   ```bash
   npm install
   ```

4. **Configuration de l'environnement**
   - Créez un fichier `.env` à la racine du projet
   - Récupérer les variables d'environnement envoyées par email :
     - VITE_SUPABASE_URL
     - VITE_SUPABASE_ANON_KEY

5. **Lancer l'application en mode développement**
   ```bash
   npm run dev
   ```
   L'application sera accessible à l'adresse indiquée dans le terminal

6. **Exécuter les tests (optionnel)**
   ```bash
   npm run test:e2e
   ```

> **Note importante** : Les informations de connexion à la base de données et les clés d'API nécessaires vous seront envoyées par email séparément pour des raisons de sécurité.

## Technologies Utilisées


### Frontend
- **Vue.js 3** - Framework JavaScript progressif
- **TypeScript** - Typage statique pour JavaScript
- **Vite** - Outil de build ultra-rapide
- **Tailwind CSS** - Framework CSS utilitaire
- **HeadlessUI** - Composants UI accessibles et sans style
- **Lucide Icons** - Bibliothèque d'icônes moderne
- **Vue Router** - Routage officiel pour Vue.js
- **Pinia** - Gestionnaire d'état pour Vue.js
- **VueUse** - Collection de composables Vue
- **Vue Toastification** - Système de notifications
- **Zod** - Validation de schémas TypeScript


### Backend
- **Supabase** - Plateforme backend-as-a-service
  - Base de données PostgreSQL
  - Authentification
  - Row Level Security (RLS)
  - Politiques de sécurité
  - API RESTful

### Tests
- **Cypress** - Framework de test end-to-end
  - Support TypeScript
  - Tests d'interface utilisateur
  - Tests d'intégration
  - Commandes personnalisées

## Architecture du Projet

```
locamat/
├── src/
│   ├── components/     # Composants réutilisables
│   ├── layouts/        # Layouts de l'application
│   ├── lib/           # Utilitaires et configurations
│   ├── pages/         # Pages de l'application
│   ├── router/        # Configuration du routeur
│   ├── stores/        # Stores Pinia
│   └── types/         # Types TypeScript
├── cypress/
│   ├── e2e/           # Tests end-to-end
│   └── support/       # Support et commandes Cypress
└── supabase/
    └── migrations/    # Migrations de la base de données
```

## Fonctionnalités de Sécurité

- Authentification complète (inscription/connexion)
- Row Level Security (RLS) pour la protection des données
- Validation des données avec Zod
- Gestion des rôles (admin/utilisateur)
- Protection des routes sensibles

## Tests

### Tests d'Authentification (`auth.cy.ts`)
- Navigation vers les pages de connexion/inscription
- Validation des formulaires
- Messages d'erreur
- Flux de connexion/déconnexion

### Tests de Navigation (`navigation.cy.ts`)
- Affichage de la page d'accueil
- Navigation entre les pages
- Vérification des liens de navigation
- État des liens actifs

### Tests de Gestion des Équipements (`equipment.cy.ts`)
- Affichage de la liste des équipements
- Filtrage des équipements
- Tri des équipements
- Détails des équipements
- Processus de réservation

### Commandes Personnalisées
```typescript
// Commande de connexion réutilisable
Cypress.Commands.add('login', (email: string, password: string) => {
  cy.visit('/login')
  cy.get('input[type="email"]').type(email)
  cy.get('input[type="password"]').type(password)
  cy.get('button[type="submit"]').click()
})
```

## Exécution des Tests

```bash
# Lancer les tests en mode interactif
npm run test:e2e

# Lancer les tests en mode CI
npm run test:e2e:ci
```

## Scripts Disponibles

```bash
# Développement
npm run dev

# Build de production
npm run build

# Preview de la build
npm run preview

# Tests Cypress
npm run test:e2e
npm run test:e2e:ci
```

##  Structure de la Base de Données

### Tables Principales

#### `profiles`
- Informations utilisateur
- Données personnelles
- Gestion des rôles

#### `equipment`
- Catalogue d'équipements
- Détails techniques
- Disponibilité

#### `reservations`
- Gestion des réservations
- États des réservations
- Relations utilisateur-équipement

### Politiques de Sécurité

- Accès restreint aux profils personnels
- Protection des données sensibles
- Contrôle d'accès basé sur les rôles
- Validation des opérations CRUD


## Équipe

- **Chef de projet** : Ayimane BARA _(Vini Jr from wish)_
- **Développeurs Front End et Back End** : Mhammed BAROUDI et Kenza AIT-OUAZZOU _(les DZ)_
- **Testeur et valideur** : Mouhamadou YATE _(L'ancien)_
- **Rédacteur technique** : Enes YILDIZ _(Le plus beau, Le plus fort)_

_Tous en 5ème année Informatique et Systèmes Intelligents Embarqués à Polytech TOURS_