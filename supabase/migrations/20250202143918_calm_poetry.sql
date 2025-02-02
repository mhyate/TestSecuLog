/*
  # Initial Schema Setup for LocaMat

  1. New Tables
    - `profiles`
      - `id` (uuid, primary key)
      - `first_name` (text, 1-30 chars)
      - `last_name` (text, 1-30 chars)
      - `email` (text, unique)
      - `id_number` (text, 7 chars)
      - `role` (text, enum: 'admin' or 'borrower')
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

    - `equipment`
      - `id` (uuid, primary key)
      - `name` (text, 1-30 chars)
      - `version` (text, 3-15 chars)
      - `reference` (text, format: AN/AP/XX + 3 digits)
      - `photo_url` (text, optional)
      - `phone_number` (text, 10 digits, optional)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

    - `reservations`
      - `id` (uuid, primary key)
      - `equipment_id` (uuid, foreign key)
      - `user_id` (uuid, foreign key)
      - `start_date` (timestamp)
      - `end_date` (timestamp)
      - `status` (text, enum: 'pending', 'active', 'completed', 'cancelled')
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for role-based access control
*/

-- Create custom types
CREATE TYPE user_role AS ENUM ('admin', 'borrower');
CREATE TYPE reservation_status AS ENUM ('pending', 'active', 'completed', 'cancelled');

-- Create profiles table
CREATE TABLE profiles (
  id uuid REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  first_name text NOT NULL CHECK (char_length(first_name) BETWEEN 1 AND 30),
  last_name text NOT NULL CHECK (char_length(last_name) BETWEEN 1 AND 30),
  email text NOT NULL UNIQUE,
  id_number text NOT NULL CHECK (char_length(id_number) = 7),
  role user_role NOT NULL DEFAULT 'borrower',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create equipment table
CREATE TABLE equipment (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL CHECK (char_length(name) BETWEEN 1 AND 30),
  version text NOT NULL CHECK (char_length(version) BETWEEN 3 AND 15),
  reference text NOT NULL CHECK (reference ~ '^(AN|AP|XX)\d{3}$'),
  photo_url text,
  phone_number text CHECK (phone_number IS NULL OR phone_number ~ '^\d{10}$'),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create reservations table
CREATE TABLE reservations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  equipment_id uuid REFERENCES equipment ON DELETE CASCADE NOT NULL,
  user_id uuid REFERENCES profiles ON DELETE CASCADE NOT NULL,
  start_date timestamptz NOT NULL,
  end_date timestamptz NOT NULL CHECK (end_date > start_date),
  status reservation_status NOT NULL DEFAULT 'pending',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone" ON profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Only admins can insert profiles" ON profiles
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Equipment policies
CREATE POLICY "Equipment is viewable by everyone" ON equipment
  FOR SELECT USING (true);

CREATE POLICY "Only admins can insert equipment" ON equipment
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Only admins can update equipment" ON equipment
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Only admins can delete equipment" ON equipment
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Reservations policies
CREATE POLICY "Users can view own reservations" ON reservations
  FOR SELECT USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Users can create reservations" ON reservations
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reservations" ON reservations
  FOR UPDATE USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Functions
CREATE OR REPLACE FUNCTION check_equipment_availability(
  p_equipment_id uuid,
  p_start_date timestamptz,
  p_end_date timestamptz
) RETURNS boolean AS $$
BEGIN
  RETURN NOT EXISTS (
    SELECT 1 FROM reservations
    WHERE equipment_id = p_equipment_id
    AND status IN ('pending', 'active')
    AND (
      (start_date <= p_end_date AND end_date >= p_start_date)
      OR
      (start_date >= p_start_date AND start_date <= p_end_date)
      OR
      (end_date >= p_start_date AND end_date <= p_end_date)
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;