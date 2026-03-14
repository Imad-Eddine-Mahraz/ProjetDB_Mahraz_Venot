USE projet_salle; 
-- Pour vérifier la conformité de l'email
ALTER TABLE Client 
ADD CONSTRAINT chk_mail_format 
CHECK (c_Mail LIKE '%@%.%');

-- Pour qu'il n'y ait pas d'incohérence netre la date de début et de fin
ALTER TABLE Inscription 
ADD CONSTRAINT chk_dates_inscription 
CHECK (i_Date_Expiration > i_Date);

-- Pour le prix de l'inscription
ALTER TABLE Inscription 
ADD CONSTRAINT chk_prix_positif 
CHECK (i_Prix >= 0);

-- Pour le montant de l'offre dans la table Client
ALTER TABLE Client 
ADD CONSTRAINT chk_offre_minimum 
CHECK (c_Montant_Offre_ >= 19.99);

-- Pour vérifier si la salle est conforme
ALTER TABLE Salle_de_sport 
ADD CONSTRAINT chk_capacite_salle 
CHECK (s_Capacité_Max > 0);

ALTER TABLE Salle_de_sport 
ADD CONSTRAINT chk_surface_positive 
CHECK (s_Surface_ > 0);

-- Pour l'âge minimale du client
ALTER TABLE Client 
ADD CONSTRAINT chk_age_client 
CHECK (c_Date_Naissance <= '2008-01-01');

-- Pour la durée de la séance
ALTER TABLE Planifier 
ADD CONSTRAINT chk_duree_positive 
CHECK (Duree > 0);

-- Pour avoir la bonne donnée sur la taille
ALTER TABLE Casier 
ADD CONSTRAINT chk_volume_casier 
CHECK (C_volume IN ('Petit', 'Moyen', 'Grand'));

-- Pour la conformité du numéro de teléphone
ALTER TABLE Client 
ADD CONSTRAINT chk_tel_longueur 
CHECK (LENGTH(c_Num_Tel) >= 10);

ALTER TABLE Salle_de_sport 
ADD CONSTRAINT chk_tel_salle_longueur 
CHECK (LENGTH(s_Num_Tel) >= 10);

-- Pour que les séance soit aux heures d'ouverture
ALTER TABLE Seance_Coaching 
ADD CONSTRAINT chk_heure_coaching 
CHECK (Heure_séance BETWEEN '06:00:00' AND '23:00:00');

-- Pour éviter les séance trop nombreuses 
ALTER TABLE Activité 
ADD CONSTRAINT chk_capacité_max_activite 
CHECK (a_Capacité_Max BETWEEN 1 AND 100);

