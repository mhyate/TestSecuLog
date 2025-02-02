/*
  # Correction des politiques de sécurité des profils

  1. Changements
    - Suppression des anciennes politiques qui causaient une récursion infinie
    - Création de nouvelles politiques simplifiées sans récursion
    - Ajout d'une politique spéciale pour les administrateurs

  2. Sécurité
    - Maintien de la sécurité des données
    - Accès restreint aux profils selon le rôle
    - Protection contre les modifications non autorisées
*/

-- Supprimer toutes les anciennes politiques
DROP POLICY IF EXISTS "Users can create their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

-- Politique de création : un utilisateur ne peut créer que son propre profil
CREATE POLICY "create_own_profile" ON profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Politique de lecture : un utilisateur peut voir son propre profil
CREATE POLICY "read_own_profile" ON profiles
  FOR SELECT
  USING (auth.uid() = id);

-- Politique de mise à jour : un utilisateur peut modifier son propre profil
CREATE POLICY "update_own_profile" ON profiles
  FOR UPDATE
  USING (auth.uid() = id);

-- Politique pour les administrateurs : accès en lecture à tous les profils
-- Cette politique utilise une approche différente pour éviter la récursion
CREATE POLICY "admin_read_all_profiles" ON profiles
  FOR SELECT
  USING (
    auth.jwt() ->> 'role' = 'admin'
  );