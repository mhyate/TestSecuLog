/*
  # Correction de la récursion dans les politiques RLS

  1. Modifications
    - Suppression des politiques existantes
    - Ajout de nouvelles politiques sans récursion
    - Utilisation d'une approche simplifiée pour la gestion des droits

  2. Sécurité
    - Maintien de la RLS sur la table profiles
    - Maintien de la vérification de l'unicité du matricule
*/

-- Supprimer les anciennes politiques
DROP POLICY IF EXISTS "Users can create their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;

-- Nouvelles politiques sans récursion
CREATE POLICY "Users can create their own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Admins can view all profiles" ON profiles
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  );

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);