-- =====================================================================
-- Projet   : Base de données du restaurant de Street-Food "Tifosi"
-- Auteur   : Thomas VACHER
-- Fichier  : 01_creation_schema.sql
-- Rôle     : création de la base `tifosi`, de l'utilisateur `tifosi`
--            et de toutes les tables (schéma physique).
-- SGBD     : MySQL 8.0.16 ou supérieur (les contraintes CHECK ne sont
--            appliquées qu'à partir de cette version).
-- Exécution: mysql -u root -p < 01_creation_schema.sql
-- =====================================================================
--
-- Passage du modèle conceptuel (MCD) au modèle physique :
--
--   Association  Entités reliées         Cardinalités          Traduction
--   -----------  ----------------------  --------------------  ------------------------------
--   appartient   marque - boisson        0,n - 1,1             clé étrangère boisson.id_marque
--   est constitué foccacia - menu        0,n - 1,1             clé étrangère menu.id_foccacia
--   comprend     foccacia - ingredient   1,n - 0,n             table `comprend` (+ quantite)
--   contient     menu - boisson          1,n - 0,n             table `contient`
--   achete       client - menu           0,n - 0,n             table `achete` (+ date_achat)
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Base de données
-- ---------------------------------------------------------------------
-- Attention : supprime la base si elle existe déjà (script rejouable
-- en environnement de développement uniquement).
DROP DATABASE IF EXISTS tifosi;

-- utf8mb4 : prend en charge les accents et les caractères comme « œ ».
CREATE DATABASE tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;


-- ---------------------------------------------------------------------
-- 2. Utilisateur applicatif
-- ---------------------------------------------------------------------
-- Compte dédié, limité à la base `tifosi` : pas de droits globaux.
-- /!\ Mot de passe de développement : à remplacer en production.
CREATE USER IF NOT EXISTS 'tifosi'@'localhost' IDENTIFIED BY 'Tifosi!Dev#2026';

-- Tous les droits d'administration, mais uniquement sur cette base.
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
FLUSH PRIVILEGES;

USE tifosi;


-- ---------------------------------------------------------------------
-- 3. Tables « référentiel » (sans clé étrangère)
-- ---------------------------------------------------------------------

-- Marques de boissons (Coca-cola, Pepsico, ...)
CREATE TABLE marque (
    id_marque   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_marque     PRIMARY KEY (id_marque),
    CONSTRAINT uq_marque_nom UNIQUE (nom)               -- une marque = un nom
) ENGINE = InnoDB;

-- Ingrédients disponibles (Ail, Cresson, Mozarella, ...)
CREATE TABLE ingredient (
    id_ingredient INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom           VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_ingredient     PRIMARY KEY (id_ingredient),
    CONSTRAINT uq_ingredient_nom UNIQUE (nom)           -- pas de doublon
) ENGINE = InnoDB;

-- foccacias proposées à la carte
CREATE TABLE foccacia (
    id_foccacia INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)   NOT NULL,
    prix        DECIMAL(5,2)  NOT NULL,                 -- prix en euros, 2 décimales
    CONSTRAINT pk_foccacia      PRIMARY KEY (id_foccacia),
    CONSTRAINT uq_foccacia_nom  UNIQUE (nom),
    CONSTRAINT ck_foccacia_prix CHECK (prix >= 0)       -- pas de prix négatif
) ENGINE = InnoDB;

-- Clients du restaurant
CREATE TABLE client (
    id_client   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)  NOT NULL,
    email       VARCHAR(150) NOT NULL,
    code_postal INT UNSIGNED NOT NULL,                  -- type INT conforme au modèle
    CONSTRAINT pk_client      PRIMARY KEY (id_client),
    CONSTRAINT uq_client_email UNIQUE (email),          -- un e-mail = un client
    CONSTRAINT ck_client_cp   CHECK (code_postal BETWEEN 1000 AND 99999)
) ENGINE = InnoDB;


-- ---------------------------------------------------------------------
-- 4. Tables dépendantes (clés étrangères 1,1)
-- ---------------------------------------------------------------------

-- Boissons : chaque boisson appartient à UNE marque (cardinalité 1,1).
CREATE TABLE boisson (
    id_boisson  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)  NOT NULL,
    id_marque   INT UNSIGNED NOT NULL,
    CONSTRAINT pk_boisson        PRIMARY KEY (id_boisson),
    CONSTRAINT uq_boisson_nom    UNIQUE (nom),
    CONSTRAINT fk_boisson_marque FOREIGN KEY (id_marque)
        REFERENCES marque (id_marque)
        ON DELETE RESTRICT          -- interdit de supprimer une marque encore utilisée
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Menus : chaque menu est constitué d'UNE foccacia (cardinalité 1,1).
CREATE TABLE menu (
    id_menu     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(50)   NOT NULL,
    prix        DECIMAL(5,2)  NOT NULL,
    id_foccacia INT UNSIGNED  NOT NULL,
    CONSTRAINT pk_menu          PRIMARY KEY (id_menu),
    CONSTRAINT uq_menu_nom      UNIQUE (nom),
    CONSTRAINT ck_menu_prix     CHECK (prix >= 0),
    CONSTRAINT fk_menu_foccacia FOREIGN KEY (id_foccacia)
        REFERENCES foccacia (id_foccacia)
        ON DELETE RESTRICT          -- une foccacia présente dans un menu ne peut pas disparaître
        ON UPDATE CASCADE
) ENGINE = InnoDB;


-- ---------------------------------------------------------------------
-- 5. Tables associatives (relations N,N)
-- ---------------------------------------------------------------------

-- comprend : composition d'une foccacia (quantité d'ingrédient en grammes).
-- Une foccacia a au moins un ingrédient (1,n) : règle à respecter à
-- l'insertion, MySQL ne sait pas l'imposer dans le schéma.
CREATE TABLE comprend (
    id_foccacia   INT UNSIGNED NOT NULL,
    id_ingredient INT UNSIGNED NOT NULL,
    quantite      INT UNSIGNED NOT NULL,
    CONSTRAINT pk_comprend PRIMARY KEY (id_foccacia, id_ingredient),  -- 1 ligne par couple
    CONSTRAINT ck_comprend_quantite CHECK (quantite > 0),
    CONSTRAINT fk_comprend_foccacia FOREIGN KEY (id_foccacia)
        REFERENCES foccacia (id_foccacia)
        ON DELETE CASCADE           -- supprimer une foccacia supprime sa composition
        ON UPDATE CASCADE,
    CONSTRAINT fk_comprend_ingredient FOREIGN KEY (id_ingredient)
        REFERENCES ingredient (id_ingredient)
        ON DELETE RESTRICT          -- impossible de supprimer un ingrédient utilisé
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- contient : boissons proposées dans un menu.
-- Un menu contient au moins une boisson (1,n) : règle à respecter à
-- l'insertion.
CREATE TABLE contient (
    id_menu    INT UNSIGNED NOT NULL,
    id_boisson INT UNSIGNED NOT NULL,
    CONSTRAINT pk_contient PRIMARY KEY (id_menu, id_boisson),
    CONSTRAINT fk_contient_menu FOREIGN KEY (id_menu)
        REFERENCES menu (id_menu)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_contient_boisson FOREIGN KEY (id_boisson)
        REFERENCES boisson (id_boisson)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- achete : achats de menus par les clients, avec la date d'achat.
-- La date fait partie de la clé : un client peut racheter le même menu
-- un autre jour.
CREATE TABLE achete (
    id_client  INT UNSIGNED NOT NULL,
    id_menu    INT UNSIGNED NOT NULL,
    date_achat DATE         NOT NULL,
    CONSTRAINT pk_achete PRIMARY KEY (id_client, id_menu, date_achat),
    CONSTRAINT fk_achete_client FOREIGN KEY (id_client)
        REFERENCES client (id_client)
        ON DELETE CASCADE           -- suppression d'un client : son historique part avec lui
        ON UPDATE CASCADE,
    CONSTRAINT fk_achete_menu FOREIGN KEY (id_menu)
        REFERENCES menu (id_menu)
        ON DELETE RESTRICT          -- on conserve l'historique des ventes d'un menu
        ON UPDATE CASCADE
) ENGINE = InnoDB;


-- ---------------------------------------------------------------------
-- 6. Vérification rapide
-- ---------------------------------------------------------------------
SHOW TABLES;
