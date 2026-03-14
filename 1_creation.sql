CREATE DATABASE projet_salle;
USE projet_salle;

CREATE TABLE Salle_de_sport(
   s_ID VARCHAR(50),
   s_Entreprise_ VARCHAR(50),
   s_Adresse VARCHAR(50),
   s_Surface_ DOUBLE,
   s_Nombre_Machine INT,
   s_Num_Tel VARCHAR(15),
   s_Capacité_Max INT,
   PRIMARY KEY(s_ID)
) ENGINE=InnoDB;

CREATE TABLE Client(
   c_Num INT AUTO_INCREMENT,
   c_Nom VARCHAR(50) NOT NULL,
   c_Prenom VARCHAR(50),
   c_Mail VARCHAR(50),
   c_Date_Naissance DATE,
   c_Num_Tel VARCHAR(15),
   c_Adresse VARCHAR(50),
   c_Montant_Offre_ DECIMAL(10,2), -- Changé en DECIMAL pour les calculs
   c_Libellé_Offre VARCHAR(50),
   c_Num_Parrain INT, -- Renommé pour plus de clarté
   PRIMARY KEY(c_Num),
   FOREIGN KEY(c_Num_Parrain) REFERENCES Client(c_Num) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE Entraineur(
   e_ID INT AUTO_INCREMENT,
   e_Nom VARCHAR(50),
   e_Prenom VARCHAR(50),
   e_Num_Tel VARCHAR(15), -- Changé en VARCHAR
   e_Specialité VARCHAR(50),
   PRIMARY KEY(e_ID)
) ENGINE=InnoDB;

CREATE TABLE Casier(
   s_ID VARCHAR(50),
   casier_Num INT,
   C_volume VARCHAR(50),
   PRIMARY KEY(s_ID, casier_Num),
   FOREIGN KEY(s_ID) REFERENCES Salle_de_sport(s_ID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Activité(
   a_nom VARCHAR(50),
   a_Capacité_Max INT,
   PRIMARY KEY(a_nom)
) ENGINE=InnoDB;

CREATE TABLE Inscription(
   i_Num SMALLINT AUTO_INCREMENT,
   i_Date DATE,
   i_Date_Expiration DATE,
   i_Prix DECIMAL(15,2),
   s_ID VARCHAR(50) NOT NULL,
   PRIMARY KEY(i_Num),
   FOREIGN KEY(s_ID) REFERENCES Salle_de_sport(s_ID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Faire(
   c_Num INT,
   i_Num SMALLINT,
   PRIMARY KEY(c_Num, i_Num),
   FOREIGN KEY(c_Num) REFERENCES Client(c_Num) ON DELETE CASCADE,
   FOREIGN KEY(i_Num) REFERENCES Inscription(i_Num) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Seance_Coaching(
   c_Num INT,
   e_ID INT,
   Date_séance DATE,
   Heure_séance TIME,
   PRIMARY KEY(c_Num, e_ID, Date_séance, Heure_séance), -- PK étendue
   FOREIGN KEY(c_Num) REFERENCES Client(c_Num) ON DELETE CASCADE,
   FOREIGN KEY(e_ID) REFERENCES Entraineur(e_ID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Planifier(
   c_Num INT,
   e_ID INT,
   s_ID VARCHAR(50),
   a_nom VARCHAR(50),
   Date_ DATE,
   Heure TIME,
   Duree INT,
   PRIMARY KEY(c_Num, e_ID, s_ID, a_nom, Date_, Heure), -- PK étendue
   FOREIGN KEY(c_Num) REFERENCES Client(c_Num) ON DELETE CASCADE,
   FOREIGN KEY(e_ID) REFERENCES Entraineur(e_ID) ON DELETE CASCADE,
   FOREIGN KEY(s_ID) REFERENCES Salle_de_sport(s_ID) ON DELETE CASCADE,
   FOREIGN KEY(a_nom) REFERENCES Activité(a_nom) ON DELETE CASCADE
) ENGINE=InnoDB;