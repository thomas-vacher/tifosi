-- =====================================================================
-- Projet   : Base de données du restaurant de Street-Food "Tifosi"
-- Auteur   : Thomas VACHER
-- Fichier  : 03_requetes_test.sql
-- Rôle     : 10 requêtes de vérification de la base `tifosi`.
-- Prérequis: 01_creation_schema.sql puis 02_insertion_donnees.sql exécutés.
-- Exécution: mysql -u tifosi -p tifosi < 03_requetes_test.sql
-- =====================================================================
--
-- Pour chaque requête : numéro et but, code SQL, résultat attendu
-- (déterminé à la main à partir des fichiers Excel), résultat obtenu
-- (relevé à l'exécution) et commentaire sur les éventuels écarts.
-- =====================================================================

USE tifosi;
SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Requête n°1
-- But : Lister les noms des foccacias par ordre alphabétique croissant.
-- ---------------------------------------------------------------------
SELECT nom AS nom_foccacia
FROM foccacia
ORDER BY nom ASC;

-- Résultat attendu :
--     +-----------------+
--     | nom_foccacia    |
--     +-----------------+
--     | Américaine      |
--     | Emmentalaccia   |
--     | Gorgonzollaccia |
--     | Hawaienne       |
--     | Mozaccia        |
--     | Paysanne        |
--     | Raclaccia       |
--     | Tradizione      |
--     +-----------------+
-- Résultat obtenu :
--     +-----------------+
--     | nom_foccacia    |
--     +-----------------+
--     | Américaine      |
--     | Emmentalaccia   |
--     | Gorgonzollaccia |
--     | Hawaienne       |
--     | Mozaccia        |
--     | Paysanne        |
--     | Raclaccia       |
--     | Tradizione      |
--     +-----------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.
--   Remarque : Tri alphabétique insensible à la casse et aux accents (collation utf8mb4_unicode_ci) : « Américaine » est donc classée avec les « A ».

-- ---------------------------------------------------------------------
-- Requête n°2
-- But : Afficher le nombre total d'ingrédients.
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS nombre_ingredients
FROM ingredient;

-- Résultat attendu :
--     +--------------------+
--     | nombre_ingredients |
--     +--------------------+
--     |                 25 |
--     +--------------------+
-- Résultat obtenu :
--     +--------------------+
--     | nombre_ingredients |
--     +--------------------+
--     |                 25 |
--     +--------------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.

-- ---------------------------------------------------------------------
-- Requête n°3
-- But : Afficher le prix moyen des foccacias.
-- ---------------------------------------------------------------------
SELECT ROUND(AVG(prix), 2) AS prix_moyen
FROM foccacia;

-- Résultat attendu :
--     +------------+
--     | prix_moyen |
--     +------------+
--     | 10.38      |
--     +------------+
-- Résultat obtenu :
--     +------------+
--     | prix_moyen |
--     +------------+
--     | 10.38      |
--     +------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.
--   Remarque : La moyenne exacte est 10,375 € ; elle est arrondie au centime (10,38 €) avec ROUND(..., 2). Sans ROUND, MySQL afficherait 10.375000.

-- ---------------------------------------------------------------------
-- Requête n°4
-- But : Afficher la liste des boissons avec leur marque, triée par nom de boisson.
-- ---------------------------------------------------------------------
SELECT b.nom AS nom_boisson,
       m.nom AS nom_marque
FROM boisson AS b
INNER JOIN marque AS m ON m.id_marque = b.id_marque
ORDER BY b.nom ASC;

-- Résultat attendu :
--     +---------------------------+-------------+
--     | nom_boisson               | nom_marque  |
--     +---------------------------+-------------+
--     | Capri-sun                 | Coca-cola   |
--     | Coca-cola original        | Coca-cola   |
--     | Coca-cola zéro            | Coca-cola   |
--     | Eau de source             | Cristalline |
--     | Fanta citron              | Coca-cola   |
--     | Fanta orange              | Coca-cola   |
--     | Lipton Peach              | Pepsico     |
--     | Lipton zéro citron        | Pepsico     |
--     | Monster energy ultra blue | Monster     |
--     | Monster energy ultra gold | Monster     |
--     | Pepsi                     | Pepsico     |
--     | Pepsi Max Zéro            | Pepsico     |
--     +---------------------------+-------------+
-- Résultat obtenu :
--     +---------------------------+-------------+
--     | nom_boisson               | nom_marque  |
--     +---------------------------+-------------+
--     | Capri-sun                 | Coca-cola   |
--     | Coca-cola original        | Coca-cola   |
--     | Coca-cola zéro            | Coca-cola   |
--     | Eau de source             | Cristalline |
--     | Fanta citron              | Coca-cola   |
--     | Fanta orange              | Coca-cola   |
--     | Lipton Peach              | Pepsico     |
--     | Lipton zéro citron        | Pepsico     |
--     | Monster energy ultra blue | Monster     |
--     | Monster energy ultra gold | Monster     |
--     | Pepsi                     | Pepsico     |
--     | Pepsi Max Zéro            | Pepsico     |
--     +---------------------------+-------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.

-- ---------------------------------------------------------------------
-- Requête n°5
-- But : Afficher la liste des ingrédients (avec leur quantité en grammes) de la foccacia « Raclaccia ».
-- ---------------------------------------------------------------------
SELECT i.nom AS nom_ingredient,
       c.quantite AS quantite_g
FROM foccacia AS f
INNER JOIN comprend   AS c ON c.id_foccacia   = f.id_foccacia
INNER JOIN ingredient AS i ON i.id_ingredient = c.id_ingredient
WHERE f.nom = 'Raclaccia'
ORDER BY i.nom ASC;

-- Résultat attendu :
--     +----------------+------------+
--     | nom_ingredient | quantite_g |
--     +----------------+------------+
--     | Ail            |          2 |
--     | Base Tomate    |        200 |
--     | Champignon     |         40 |
--     | Cresson        |         20 |
--     | Parmesan       |         50 |
--     | Poivre         |          1 |
--     | Raclette       |         50 |
--     +----------------+------------+
-- Résultat obtenu :
--     +----------------+------------+
--     | nom_ingredient | quantite_g |
--     +----------------+------------+
--     | Ail            |          2 |
--     | Base Tomate    |        200 |
--     | Champignon     |         40 |
--     | Cresson        |         20 |
--     | Parmesan       |         50 |
--     | Poivre         |          1 |
--     | Raclette       |         50 |
--     +----------------+------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.

-- ---------------------------------------------------------------------
-- Requête n°6
-- But : Afficher le nom et le nombre d'ingrédients de chaque foccacia.
-- ---------------------------------------------------------------------
SELECT f.nom AS nom_foccacia,
       COUNT(c.id_ingredient) AS nombre_ingredients
FROM foccacia AS f
INNER JOIN comprend AS c ON c.id_foccacia = f.id_foccacia
GROUP BY f.id_foccacia, f.nom
ORDER BY nombre_ingredients DESC, f.nom ASC;

-- Résultat attendu :
--     +-----------------+--------------------+
--     | nom_foccacia    | nombre_ingredients |
--     +-----------------+--------------------+
--     | Paysanne        |                 12 |
--     | Mozaccia        |                 10 |
--     | Hawaienne       |                  9 |
--     | Tradizione      |                  9 |
--     | Américaine      |                  8 |
--     | Gorgonzollaccia |                  8 |
--     | Emmentalaccia   |                  7 |
--     | Raclaccia       |                  7 |
--     +-----------------+--------------------+
-- Résultat obtenu :
--     +-----------------+--------------------+
--     | nom_foccacia    | nombre_ingredients |
--     +-----------------+--------------------+
--     | Paysanne        |                 12 |
--     | Mozaccia        |                 10 |
--     | Hawaienne       |                  9 |
--     | Tradizione      |                  9 |
--     | Américaine      |                  8 |
--     | Gorgonzollaccia |                  8 |
--     | Emmentalaccia   |                  7 |
--     | Raclaccia       |                  7 |
--     +-----------------+--------------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.
--   Remarque : Tri sur le nombre d'ingrédients décroissant, puis sur le nom pour départager les égalités.

-- ---------------------------------------------------------------------
-- Requête n°7
-- But : Afficher le nom de la foccacia qui a le plus d'ingrédients.
-- ---------------------------------------------------------------------
SELECT f.nom AS nom_foccacia,
       COUNT(*)  AS nombre_ingredients
FROM foccacia AS f
INNER JOIN comprend AS c ON c.id_foccacia = f.id_foccacia
GROUP BY f.id_foccacia, f.nom
HAVING COUNT(*) = (
    -- maximum du nombre d'ingrédients, toutes foccacias confondues
    SELECT MAX(t.nb)
    FROM (SELECT COUNT(*) AS nb FROM comprend GROUP BY id_foccacia) AS t
);

-- Résultat attendu :
--     +--------------+--------------------+
--     | nom_foccacia | nombre_ingredients |
--     +--------------+--------------------+
--     | Paysanne     |                 12 |
--     +--------------+--------------------+
-- Résultat obtenu :
--     +--------------+--------------------+
--     | nom_foccacia | nombre_ingredients |
--     +--------------+--------------------+
--     | Paysanne     |                 12 |
--     +--------------+--------------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.
--   Remarque : La comparaison avec le MAX (plutôt qu'un ORDER BY ... LIMIT 1) renvoie toutes les foccacias en cas d'égalité ; ici il n'y en a qu'une.

-- ---------------------------------------------------------------------
-- Requête n°8
-- But : Afficher la liste des foccacias qui contiennent de l'ail.
-- ---------------------------------------------------------------------
SELECT f.nom AS nom_foccacia
FROM foccacia AS f
INNER JOIN comprend   AS c ON c.id_foccacia   = f.id_foccacia
INNER JOIN ingredient AS i ON i.id_ingredient = c.id_ingredient
WHERE i.nom = 'Ail'
ORDER BY f.nom ASC;

-- Résultat attendu :
--     +-----------------+
--     | nom_foccacia    |
--     +-----------------+
--     | Gorgonzollaccia |
--     | Mozaccia        |
--     | Paysanne        |
--     | Raclaccia       |
--     +-----------------+
-- Résultat obtenu :
--     +-----------------+
--     | nom_foccacia    |
--     +-----------------+
--     | Gorgonzollaccia |
--     | Mozaccia        |
--     | Paysanne        |
--     | Raclaccia       |
--     +-----------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.

-- ---------------------------------------------------------------------
-- Requête n°9
-- But : Afficher la liste des ingrédients inutilisés (présents dans aucune foccacia).
-- ---------------------------------------------------------------------
SELECT i.nom AS nom_ingredient
FROM ingredient AS i
LEFT JOIN comprend AS c ON c.id_ingredient = i.id_ingredient
WHERE c.id_ingredient IS NULL
ORDER BY i.nom ASC;

-- Résultat attendu :
--     +----------------+
--     | nom_ingredient |
--     +----------------+
--     | Salami         |
--     | Tomate cerise  |
--     +----------------+
-- Résultat obtenu :
--     +----------------+
--     | nom_ingredient |
--     +----------------+
--     | Salami         |
--     | Tomate cerise  |
--     +----------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.
--   Remarque : Ces deux ingrédients figurent dans la liste du fichier ingredient.xlsx mais dans aucune recette de foccacia.xlsx.

-- ---------------------------------------------------------------------
-- Requête n°10
-- But : Afficher la liste des foccacias qui n'ont pas de champignons.
-- ---------------------------------------------------------------------
SELECT f.nom AS nom_foccacia
FROM foccacia AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM comprend   AS c
    INNER JOIN ingredient AS i ON i.id_ingredient = c.id_ingredient
    WHERE c.id_foccacia = f.id_foccacia
      AND i.nom = 'Champignon'
)
ORDER BY f.nom ASC;

-- Résultat attendu :
--     +--------------+
--     | nom_foccacia |
--     +--------------+
--     | Américaine   |
--     | Hawaienne    |
--     +--------------+
-- Résultat obtenu :
--     +--------------+
--     | nom_foccacia |
--     +--------------+
--     | Américaine   |
--     | Hawaienne    |
--     +--------------+
-- Commentaire : Aucun écart : le résultat obtenu est identique au résultat attendu.
