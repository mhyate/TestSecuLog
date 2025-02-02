/*
  # Correction finale de la récursion dans les politiques RLS

  1. Modifications
    - Suppression des politiques existantes
    - Ajout de nouvelles politiques utilisant une approche basée sur les claims
    - Ajout d'une fonction pour synchroniser le rôle avec les claims

  2. Sécurité
    - Maintien de la RLS sur la table profiles
    - Utilisation des claims JWT pour les vérifications de rôle
*/

-- Supprimer les anciennes politiques
DROP POLICY IF EXISTS "Users can create their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

-- Fonction pour synchroniser le rôle avec les claims
CREATE OR REPLACE FUNCTION sync_user_role()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR NEW.role <> OLD.role THEN
    PERFORM set_claim(NEW.id, 'role', NEW.role::text);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger pour synchroniser le rôle
DROP TRIGGER IF EXISTS sync_user_role_trigger ON profiles;
CREATE TRIGGER sync_user_role_trigger
  AFTER INSERT OR UPDATE OF role ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION sync_user_role();

-- Nouvelles politiques basées sur les claims
CREATE POLICY "Users can create their own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Admins can view all profiles" ON profiles
  FOR SELECT USING (auth.jwt()->>'role' = 'admin');

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Mettre à jour les claims pour les utilisateurs existants
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT id, role FROM profiles
  LOOP
    PERFORM set_claim(r.id, 'role', r.role::text);
  END LOOP;
END $$;