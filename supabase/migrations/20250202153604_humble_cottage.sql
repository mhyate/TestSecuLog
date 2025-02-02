/*
  # Ajout des informations de contact des utilisateurs

  1. Modifications
    - Ajout des colonnes pour les informations de contact dans la table `profiles`:
      - `phone` (numéro de téléphone)
      - `address` (adresse)
      - `postal_code` (code postal)
      - `city` (ville)

  2. Sécurité
    - Les politiques de sécurité existantes s'appliquent aux nouvelles colonnes
*/

ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS phone text CHECK (phone IS NULL OR phone ~ '^0[1-9][0-9]{8}$'),
ADD COLUMN IF NOT EXISTS address text,
ADD COLUMN IF NOT EXISTS postal_code text CHECK (postal_code IS NULL OR postal_code ~ '^[0-9]{5}$'),
ADD COLUMN IF NOT EXISTS city text;