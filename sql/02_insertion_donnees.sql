-- =====================================================================
-- Projet   : Base de données du restaurant de Street-Food "Tifosi"
-- Auteur   : Thomas VACHER
-- Fichier  : 02_insertion_donnees.sql
-- Rôle     : insertion des données de test (marques, ingrédients,
--            boissons, foccacias et composition des foccacias).
-- Sources  : marque.xlsx, ingredient.xlsx, boisson.xlsx, focaccia.xlsx
-- Prérequis: 01_creation_schema.sql exécuté.
-- Exécution: mysql -u tifosi -p tifosi < 02_insertion_donnees.sql
-- =====================================================================
--
-- Remarques sur les données sources :
--  * Les identifiants des fichiers Excel sont conservés tels quels.
--  * Les espaces superflus ont été supprimés (ex. « Eau de source »).
--  * Dans focaccia.xlsx, les ingrédients sont écrits à la main : les
--    variantes d'orthographe (« Chèvre » / « Chevre », « œuf » / « Oeuf »,
--    « Base tomate » / « Base Tomate ») sont rattachées à l'ingrédient
--    correspondant de ingredient.xlsx.
--  * Quantité d'un ingrédient : la valeur indiquée entre parenthèses
--    dans le fichier si elle existe (ex. « champignon(80) »), sinon la
--    quantité par défaut de la liste en bas du fichier (en grammes).
--  * Aucune donnée n'est fournie pour les clients, les menus et les
--    achats : ces tables restent vides.
-- =====================================================================

USE tifosi;
SET NAMES utf8mb4;

START TRANSACTION;

-- ---------------------------------------------------------------------
-- Marques
-- ---------------------------------------------------------------------
INSERT INTO marque (id_marque, nom) VALUES
    (1, 'Coca-cola'),
    (2, 'Cristalline'),
    (3, 'Monster'),
    (4, 'Pepsico');

-- ---------------------------------------------------------------------
-- Ingrédients
-- ---------------------------------------------------------------------
INSERT INTO ingredient (id_ingredient, nom) VALUES
    (1, 'Ail'),
    (2, 'Ananas'),
    (3, 'Artichaut'),
    (4, 'Bacon'),
    (5, 'Base Tomate'),
    (6, 'Base crème'),
    (7, 'Champignon'),
    (8, 'Chevre'),
    (9, 'Cresson'),
    (10, 'Emmental'),
    (11, 'Gorgonzola'),
    (12, 'Jambon cuit'),
    (13, 'Jambon fumé'),
    (14, 'Oeuf'),
    (15, 'Oignon'),
    (16, 'Olive noire'),
    (17, 'Olive verte'),
    (18, 'Parmesan'),
    (19, 'Piment'),
    (20, 'Poivre'),
    (21, 'Pomme de terre'),
    (22, 'Raclette'),
    (23, 'Salami'),
    (24, 'Tomate cerise'),
    (25, 'Mozarella');

-- ---------------------------------------------------------------------
-- Boissons (la marque est retrouvée par son nom)
-- ---------------------------------------------------------------------
INSERT INTO boisson (id_boisson, nom, id_marque) VALUES
    (1, 'Coca-cola zéro', (SELECT id_marque FROM marque WHERE nom = 'Coca-cola')),
    (2, 'Coca-cola original', (SELECT id_marque FROM marque WHERE nom = 'Coca-cola')),
    (3, 'Fanta citron', (SELECT id_marque FROM marque WHERE nom = 'Coca-cola')),
    (4, 'Fanta orange', (SELECT id_marque FROM marque WHERE nom = 'Coca-cola')),
    (5, 'Capri-sun', (SELECT id_marque FROM marque WHERE nom = 'Coca-cola')),
    (6, 'Pepsi', (SELECT id_marque FROM marque WHERE nom = 'Pepsico')),
    (7, 'Pepsi Max Zéro', (SELECT id_marque FROM marque WHERE nom = 'Pepsico')),
    (8, 'Lipton zéro citron', (SELECT id_marque FROM marque WHERE nom = 'Pepsico')),
    (9, 'Lipton Peach', (SELECT id_marque FROM marque WHERE nom = 'Pepsico')),
    (10, 'Monster energy ultra gold', (SELECT id_marque FROM marque WHERE nom = 'Monster')),
    (11, 'Monster energy ultra blue', (SELECT id_marque FROM marque WHERE nom = 'Monster')),
    (12, 'Eau de source', (SELECT id_marque FROM marque WHERE nom = 'Cristalline'));

-- ---------------------------------------------------------------------
-- foccacias
-- ---------------------------------------------------------------------
INSERT INTO foccacia (id_foccacia, nom, prix) VALUES
    (1, 'Mozaccia', 9.80),
    (2, 'Gorgonzollaccia', 10.80),
    (3, 'Raclaccia', 8.90),
    (4, 'Emmentalaccia', 9.80),
    (5, 'Tradizione', 8.90),
    (6, 'Hawaienne', 11.20),
    (7, 'Américaine', 10.80),
    (8, 'Paysanne', 12.80);

-- ---------------------------------------------------------------------
-- Composition des foccacias : (id_foccacia, id_ingredient, quantité en g)
-- ---------------------------------------------------------------------
INSERT INTO comprend (id_foccacia, id_ingredient, quantite) VALUES
    (1, 5, 200),  -- Mozaccia : Base Tomate
    (1, 25, 50),  -- Mozaccia : Mozarella
    (1, 9, 20),   -- Mozaccia : Cresson
    (1, 13, 80),  -- Mozaccia : Jambon fumé
    (1, 1, 2),    -- Mozaccia : Ail
    (1, 3, 20),   -- Mozaccia : Artichaut
    (1, 7, 40),   -- Mozaccia : Champignon
    (1, 18, 50),  -- Mozaccia : Parmesan
    (1, 20, 1),   -- Mozaccia : Poivre
    (1, 16, 20),  -- Mozaccia : Olive noire
    (2, 5, 200),  -- Gorgonzollaccia : Base Tomate
    (2, 11, 50),  -- Gorgonzollaccia : Gorgonzola
    (2, 9, 20),   -- Gorgonzollaccia : Cresson
    (2, 1, 2),    -- Gorgonzollaccia : Ail
    (2, 7, 40),   -- Gorgonzollaccia : Champignon
    (2, 18, 50),  -- Gorgonzollaccia : Parmesan
    (2, 20, 1),   -- Gorgonzollaccia : Poivre
    (2, 16, 20),  -- Gorgonzollaccia : Olive noire
    (3, 5, 200),  -- Raclaccia : Base Tomate
    (3, 22, 50),  -- Raclaccia : Raclette
    (3, 9, 20),   -- Raclaccia : Cresson
    (3, 1, 2),    -- Raclaccia : Ail
    (3, 7, 40),   -- Raclaccia : Champignon
    (3, 18, 50),  -- Raclaccia : Parmesan
    (3, 20, 1),   -- Raclaccia : Poivre
    (4, 6, 200),  -- Emmentalaccia : Base crème
    (4, 10, 50),  -- Emmentalaccia : Emmental
    (4, 9, 20),   -- Emmentalaccia : Cresson
    (4, 7, 40),   -- Emmentalaccia : Champignon
    (4, 18, 50),  -- Emmentalaccia : Parmesan
    (4, 20, 1),   -- Emmentalaccia : Poivre
    (4, 15, 20),  -- Emmentalaccia : Oignon
    (5, 5, 200),  -- Tradizione : Base Tomate
    (5, 25, 50),  -- Tradizione : Mozarella
    (5, 9, 20),   -- Tradizione : Cresson
    (5, 12, 80),  -- Tradizione : Jambon cuit
    (5, 7, 80),   -- Tradizione : Champignon
    (5, 18, 50),  -- Tradizione : Parmesan
    (5, 20, 1),   -- Tradizione : Poivre
    (5, 16, 10),  -- Tradizione : Olive noire
    (5, 17, 10),  -- Tradizione : Olive verte
    (6, 5, 200),  -- Hawaienne : Base Tomate
    (6, 25, 50),  -- Hawaienne : Mozarella
    (6, 9, 20),   -- Hawaienne : Cresson
    (6, 4, 80),   -- Hawaienne : Bacon
    (6, 2, 40),   -- Hawaienne : Ananas
    (6, 19, 2),   -- Hawaienne : Piment
    (6, 18, 50),  -- Hawaienne : Parmesan
    (6, 20, 1),   -- Hawaienne : Poivre
    (6, 16, 20),  -- Hawaienne : Olive noire
    (7, 5, 200),  -- Américaine : Base Tomate
    (7, 25, 50),  -- Américaine : Mozarella
    (7, 9, 20),   -- Américaine : Cresson
    (7, 4, 80),   -- Américaine : Bacon
    (7, 21, 40),  -- Américaine : Pomme de terre
    (7, 18, 50),  -- Américaine : Parmesan
    (7, 20, 1),   -- Américaine : Poivre
    (7, 16, 20),  -- Américaine : Olive noire
    (8, 6, 200),  -- Paysanne : Base crème
    (8, 8, 50),   -- Paysanne : Chevre
    (8, 9, 20),   -- Paysanne : Cresson
    (8, 21, 80),  -- Paysanne : Pomme de terre
    (8, 13, 80),  -- Paysanne : Jambon fumé
    (8, 1, 2),    -- Paysanne : Ail
    (8, 3, 20),   -- Paysanne : Artichaut
    (8, 7, 40),   -- Paysanne : Champignon
    (8, 18, 50),  -- Paysanne : Parmesan
    (8, 20, 1),   -- Paysanne : Poivre
    (8, 16, 20),  -- Paysanne : Olive noire
    (8, 14, 50);  -- Paysanne : Oeuf

COMMIT;

-- Contrôle rapide du nombre de lignes insérées
SELECT 'marque' AS table_nom, COUNT(*) AS nb_lignes FROM marque
UNION ALL SELECT 'ingredient', COUNT(*) FROM ingredient
UNION ALL SELECT 'boisson',    COUNT(*) FROM boisson
UNION ALL SELECT 'foccacia',   COUNT(*) FROM foccacia
UNION ALL SELECT 'comprend',   COUNT(*) FROM comprend;
