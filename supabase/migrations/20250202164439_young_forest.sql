/*
  # Correction finale des politiques RLS

  1. Modifications
    - Suppression des anciennes politiques
    - Ajout de nouvelles politiques simplifiées
    - Suppression de la dépendance aux claims JWT

  2. Sécurité
    - Maintien de la RLS sur la table profiles
    - Utilisation de politiques simples et efficaces
*/

-- Supprimer les anciennes politiques et triggers
DROP POLICY IF EXISTS "Users can create their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP TRIGGER IF EXISTS sync_user_role_trigger ON profiles;
DROP FUNCTION IF EXISTS sync_user_role();

-- Nouvelles politiques simplifiées
CREATE POLICY "Users can create their own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Politique pour les administrateurs basée sur une sous-requête simple
CREATE POLICY "Admins can view all profiles" ON profiles
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  );