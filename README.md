# Tifosi — base de données MySQL

Base de données du restaurant de Street-Food italien **Tifosi** (focaccias, ingrédients, boissons, marques, menus, clients).

## Contenu du dépôt

| Fichier | Rôle |
|---|---|
| `sql/01_creation_schema.sql` | Crée la base `tifosi`, l'utilisateur `tifosi` et toutes les tables (clés, contraintes, valeurs uniques) |
| `sql/02_insertion_donnees.sql` | Insère les données de test issues des fichiers Excel fournis |
| `sql/03_requetes_test.sql` | 10 requêtes de vérification, avec résultat attendu / obtenu / commentaire |

## Exécution

Prérequis : MySQL **8.0.16 ou supérieur** (les contraintes `CHECK` sont ignorées avant).

```bash
mysql -u root -p < sql/01_creation_schema.sql
mysql -u tifosi -p tifosi < sql/02_insertion_donnees.sql
mysql -u tifosi -p tifosi < sql/03_requetes_test.sql
```

Le mot de passe de l'utilisateur `tifosi` est défini dans `01_creation_schema.sql` (mot de passe de développement, à changer en production).

## Modèle de données

- `marque` 1—n `boisson` (une boisson appartient à une seule marque)
- `foccacia` n—n `ingredient` via `comprend` (avec la quantité en grammes)
- `foccacia` 1—n `menu` (un menu est constitué d'une foccacia)
- `menu` n—n `boisson` via `contient`
- `client` n—n `menu` via `achete` (avec la date d'achat)

## Choix de conception

- **Intégrité** : clés primaires, clés étrangères (`RESTRICT` pour protéger les données référencées, `CASCADE` sur les tables d'association), `NOT NULL` partout, `UNIQUE` sur les noms et sur l'e-mail client, `CHECK` sur les prix, quantités et codes postaux.
- **Nom de table** : `foccacia`.
- **Cardinalités minimales 1,n** (une foccacia a au moins un ingrédient, un menu au moins une boisson) : non exprimables en SQL, à respecter à l'insertion.
- **Données** : les variantes d'orthographe de `focaccia.xlsx` (« Chèvre », « œuf ») sont rattachées aux ingrédients de `ingredient.xlsx` ; les quantités entre parenthèses (ex. `champignon(80)`) remplacent la quantité par défaut. Les tables `client`, `menu`, `contient` et `achete` restent vides, aucune donnée n'étant fournie.
