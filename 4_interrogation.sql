USE projet_salle;

-- ==========================================================
-- SCÉNARIO : GESTION ET OPTIMISATION DE LA SALLE "PROJET SALLE"
-- ==========================================================

-- ---------------------------------------------------------
-- I. LES 5 REQUÊTES SIMPLES (Sélection et Filtres)
-- ---------------------------------------------------------

-- 1. Liste des clients "Premium" ou "Gold" pour une campagne marketing ciblée
SELECT c_Nom, c_Prenom, c_Mail, c_Libellé_Offre 
FROM Client 
WHERE c_Libellé_Offre IN ('Premium', 'Gold') 
ORDER BY c_Nom ASC;

-- 2. Identification des grandes infrastructures (capacité > 150) pour des événements
SELECT s_Entreprise_, s_Adresse, s_Capacité_Max 
FROM Salle_de_sport 
WHERE s_Capacité_Max > 150;

-- 3. Liste des séances de coaching prévues en fin de journée (après 17h)
SELECT * FROM Seance_Coaching 
WHERE Heure_séance > '17:00:00';

-- 4. Recherche de clients habitant à Paris ou Lyon pour des statistiques régionales
SELECT c_Nom, c_Prenom, c_Adresse 
FROM Client 
WHERE c_Adresse = 'Paris' OR c_Adresse = 'Lyon';

-- 5. Vérification des inscriptions à prix élevé (plus de 300€)
SELECT i_Num, i_Prix, s_ID 
FROM Inscription 
WHERE i_Prix > 300 
ORDER BY i_Prix DESC;


-- ---------------------------------------------------------
-- II. LES 5 REQUÊTES D'AGRÉGATION (Statistiques de gestion)
-- ---------------------------------------------------------

-- 6. Chiffre d'affaires total généré par les inscriptions
SELECT SUM(i_Prix) AS Chiffre_Affaires_Total FROM Inscription;

-- 7. Nombre de clients par ville (regroupement par adresse)
SELECT c_Adresse, COUNT(*) AS Nombre_Clients 
FROM Client 
GROUP BY c_Adresse;

-- 8. Durée moyenne des séances planifiées par activité
SELECT a_nom, AVG(Duree) AS Duree_Moyenne 
FROM Planifier 
GROUP BY a_nom;

-- 9. Nombre de coachs par spécialité
SELECT e_Specialité, COUNT(*) AS Total_Entraineurs 
FROM Entraineur 
GROUP BY e_Specialité 
HAVING Total_Entraineurs >= 1;

-- 10. Capacité maximale totale de toutes les salles du réseau
SELECT SUM(s_Capacité_Max) AS Capacite_Reseau_Global FROM Salle_de_sport;


-- ---------------------------------------------------------
-- III. LES 5 REQUÊTES AVEC JOINTURES (Croisement de données)
-- ---------------------------------------------------------

-- 11. Afficher le nom du client et le nom de la salle où il est inscrit
SELECT C.c_Nom, C.c_Prenom, S.s_Entreprise_
FROM Client C
JOIN Faire F ON C.c_Num = F.c_Num
JOIN Inscription I ON F.i_Num = I.i_Num
JOIN Salle_de_sport S ON I.s_ID = S.s_ID;

-- 12. Planning détaillé : Nom du client, nom de son coach et l'heure de leur séance
SELECT C.c_Nom AS Client, E.e_Nom AS Coach, S.Date_séance, S.Heure_séance
FROM Seance_Coaching S
JOIN Client C ON S.c_Num = C.c_Num
JOIN Entraineur E ON S.e_ID = E.e_ID;

-- 13. Liste des casiers par salle avec le nom de l'entreprise
SELECT S.s_Entreprise_, C.casier_Num, C.C_volume
FROM Casier C
JOIN Salle_de_sport S ON C.s_ID = S.s_ID;

-- 14. AUTO-JOINTURE : Identifier les parrains et leurs filleuls
SELECT P.c_Nom AS Nom_Parrain, F.c_Nom AS Nom_Filleul
FROM Client F
JOIN Client P ON F.c_Num_Parrain = P.c_Num;

-- 15. Activités planifiées : Nom de l'activité, durée et nom de la salle
SELECT P.a_nom, P.Duree, S.s_Entreprise_
FROM Planifier P
JOIN Salle_de_sport S ON P.s_ID = S.s_ID;


-- ---------------------------------------------------------
-- IV. LES 5 REQUÊTES IMBRIQUÉES (Requêtes complexes)
-- ---------------------------------------------------------

-- 16. Clients qui n'ont pas encore de coach personnel (sous-requête NOT IN)
SELECT c_Nom, c_Prenom FROM Client
WHERE c_Num NOT IN (SELECT c_Num FROM Seance_Coaching);

-- 17. Salles dont la surface est supérieure à la surface moyenne de toutes les salles
SELECT s_Entreprise_, s_Surface_ FROM Salle_de_sport
WHERE s_Surface_ > (SELECT AVG(s_Surface_) FROM Salle_de_sport);

-- 18. Trouver les entraîneurs spécialisés dans les activités qui ont une capacité > 30
SELECT e_Nom, e_Prenom, e_Specialité FROM Entraineur
WHERE e_Specialité IN (SELECT a_nom FROM Activité WHERE a_Capacité_Max > 30);

-- 19. Trouver le client qui a payé l'inscription la plus chère (sous-requête MAX)
SELECT c_Nom, c_Prenom FROM Client
WHERE c_Num = (
    SELECT c_Num FROM Faire WHERE i_Num = (
        SELECT i_Num FROM Inscription WHERE i_Prix = (SELECT MAX(i_Prix) FROM Inscription)
    )
);

-- 20. Lister les activités qui sont planifiées dans la salle 'S1' (FitnessPlus)
SELECT a_nom FROM Activité
WHERE a_nom IN (SELECT a_nom FROM Planifier WHERE s_ID = 'S1');