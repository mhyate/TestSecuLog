-- Supprimer les anciennes politiques
DROP POLICY IF EXISTS "enable_insert_for_registration" ON profiles;
DROP POLICY IF EXISTS "enable_select_for_user" ON profiles;
DROP POLICY IF EXISTS "enable_update_for_user" ON profiles;

-- Créer une fonction pour vérifier si un utilisateur est admin
CREATE OR REPLACE FUNCTION is_admin(user_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM profiles
    WHERE id = user_id
    AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Créer les nouvelles politiques
CREATE POLICY "enable_insert_for_registration" ON profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "enable_select_for_users_and_admins" ON profiles
  FOR SELECT
  USING (
    CASE
      WHEN is_admin(auth.uid()) THEN true
      ELSE auth.uid() = id
    END
  );

CREATE POLICY "enable_update_for_user" ON profiles
  FOR UPDATE
  USING (auth.uid() = id);