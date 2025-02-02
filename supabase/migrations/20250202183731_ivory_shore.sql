/*
  # Fix policies for registration and data access

  1. Changes
    - Reset all policies for profiles table
    - Add policies for registration flow
    - Add policies for equipment and reservations
  
  2. Security
    - Enable RLS on all tables
    - Add specific policies for each operation
*/

-- Réinitialiser les policies existantes
DROP POLICY IF EXISTS "create_own_profile" ON profiles;
DROP POLICY IF EXISTS "read_own_profile" ON profiles;
DROP POLICY IF EXISTS "update_own_profile" ON profiles;
DROP POLICY IF EXISTS "admin_read_all_profiles" ON profiles;

-- Policies pour la table profiles
CREATE POLICY "enable_insert_for_registration" ON profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "enable_select_for_user" ON profiles
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "enable_update_for_user" ON profiles
  FOR UPDATE
  USING (auth.uid() = id);

-- Policies pour la table equipment
CREATE POLICY "enable_select_for_authenticated" ON equipment
  FOR SELECT
  USING (true);

-- Policies pour la table reservations
CREATE POLICY "enable_insert_for_authenticated" ON reservations
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "enable_select_for_owner" ON reservations
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "enable_update_for_owner" ON reservations
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Activer RLS sur toutes les tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;