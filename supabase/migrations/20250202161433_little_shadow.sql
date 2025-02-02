/*
  # Ajout de la gestion des quantités

  1. Modifications
    - Ajout de la colonne `quantity` à la table `equipment`
    - Mise à jour des équipements existants avec une quantité par défaut
  
  2. Changements
    - Ajout d'une colonne `quantity` de type integer avec une valeur par défaut de 1
    - Mise à jour des équipements existants avec une quantité de 3 unités
*/

-- Ajouter la colonne quantity à la table equipment
ALTER TABLE equipment ADD COLUMN IF NOT EXISTS quantity integer NOT NULL DEFAULT 1;

-- Mettre à jour les équipements existants avec une quantité par défaut
UPDATE equipment SET quantity = 3;