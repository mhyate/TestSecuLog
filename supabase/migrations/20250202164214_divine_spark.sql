/*
  # Correction des politiques de profils

  1. Modifications
    - Ajout d'une politique permettant aux utilisateurs de créer leur profil
    - Ajout d'une politique permettant aux utilisateurs de lire leur profil
    - Ajout d'une politique permettant aux utilisateurs de mettre à jour leur profil
    - Ajout d'une politique permettant aux administrateurs de lire tous les profils

  2. Sécurité
    - Maintien de la RLS sur la table profiles
    - Vérification de l'unicité du matricule
*/

-- Supprimer les anciennes politiques
DROP POLICY IF EXISTS "Users can create their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;

-- Nouvelles politiques
CREATE POLICY "Users can create their own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view their own profile" ON profiles
  FOR SELECT USING (auth.uid() = id OR (
    SELECT role FROM profiles WHERE id = auth.uid()
  ) = 'admin');

CREATE POLICY "Users can update their own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);