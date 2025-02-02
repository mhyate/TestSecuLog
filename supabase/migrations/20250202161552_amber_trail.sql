/*
  # Ajout de la gestion des quantités pour les réservations

  1. Modifications
    - Ajout de la colonne `quantity` à la table `reservations`
    - Mise à jour des réservations existantes
    - Mise à jour de la fonction de vérification de disponibilité
  
  2. Changements
    - Ajout d'une colonne `quantity` de type integer avec une valeur par défaut de 1
    - Mise à jour de la fonction check_equipment_availability pour prendre en compte les quantités
*/

-- Ajouter la colonne quantity à la table reservations
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS quantity integer NOT NULL DEFAULT 1;

-- Mettre à jour la fonction de vérification de disponibilité
CREATE OR REPLACE FUNCTION check_equipment_availability(
  p_equipment_id uuid,
  p_start_date timestamptz,
  p_end_date timestamptz
) RETURNS boolean AS $$
DECLARE
  v_total_quantity integer;
  v_reserved_quantity integer;
BEGIN
  -- Récupérer la quantité totale de l'équipement
  SELECT quantity INTO v_total_quantity
  FROM equipment
  WHERE id = p_equipment_id;

  -- Calculer la quantité totale réservée pour la période
  SELECT COALESCE(SUM(quantity), 0) INTO v_reserved_quantity
  FROM reservations
  WHERE equipment_id = p_equipment_id
  AND status IN ('pending', 'active')
  AND (
    (start_date <= p_end_date AND end_date >= p_start_date)
    OR
    (start_date >= p_start_date AND start_date <= p_end_date)
    OR
    (end_date >= p_start_date AND end_date <= p_end_date)
  );

  -- Retourner true si la quantité disponible est suffisante
  RETURN v_reserved_quantity < v_total_quantity;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;