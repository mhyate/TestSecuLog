-- Supprimer les anciennes politiques
DROP POLICY IF EXISTS "enable_insert_for_registration" ON profiles;
DROP POLICY IF EXISTS "enable_select_for_user" ON profiles;
DROP POLICY IF EXISTS "enable_update_for_user" ON profiles;

-- Créer les nouvelles politiques
CREATE POLICY "enable_insert_for_registration" ON profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "enable_select_for_user" ON profiles
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "enable_update_for_user" ON profiles
  FOR UPDATE
  USING (auth.uid() = id);

-- Ajouter une politique pour permettre aux administrateurs de voir tous les profils
CREATE POLICY "enable_select_for_admin" ON profiles
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  );