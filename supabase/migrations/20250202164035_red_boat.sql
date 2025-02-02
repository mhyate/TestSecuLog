/*
  # Correction des politiques RLS pour les profils

  1. Modifications
    - Mise à jour des politiques RLS pour permettre la création de profil lors de l'inscription
    - Ajout d'une politique pour permettre aux utilisateurs de créer leur propre profil
    - Correction de la politique de mise à jour des profils

  2. Sécurité
    - Maintien de la sécurité en limitant les actions aux propriétaires des profils
    - Protection des données sensibles
*/

-- Supprimer les anciennes politiques
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Only admins can insert profiles" ON profiles;

-- Nouvelles politiques
CREATE POLICY "Users can create their own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view their own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Politique pour vérifier l'unicité du matricule
CREATE OR REPLACE FUNCTION check_id_number_unique()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM profiles
    WHERE id_number = NEW.id_number
    AND id != NEW.id
  ) THEN
    RAISE EXCEPTION 'Ce matricule est déjà utilisé';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_id_number_unique_trigger ON profiles;
CREATE TRIGGER check_id_number_unique_trigger
  BEFORE INSERT OR UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION check_id_number_unique();