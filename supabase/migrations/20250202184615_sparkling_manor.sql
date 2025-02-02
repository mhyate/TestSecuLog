/*
  # Fix authentication policies

  1. Changes
    - Reset all policies for profiles table
    - Add policies for registration and authentication
    - Enable public access for profile creation during registration
    - Allow users to read and update their own profiles

  2. Security
    - Enable RLS on profiles table
    - Add specific policies for registration flow
*/

-- Reset policies for profiles table
DROP POLICY IF EXISTS "enable_insert_for_registration" ON profiles;
DROP POLICY IF EXISTS "enable_select_for_user" ON profiles;
DROP POLICY IF EXISTS "enable_update_for_user" ON profiles;

-- Create new policies
CREATE POLICY "enable_insert_for_registration" ON profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "enable_select_for_user" ON profiles
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "enable_update_for_user" ON profiles
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Make sure RLS is enabled
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;