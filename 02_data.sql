-- En este scrip importaremos el csv a "staging_food" y, posteriormente, añadiremos datos a las 5 tablas de dimensiones
-- ----------------------------------------------------------------------------
-- ESTRUCTURA data.sql

-- 1. Comprobación de datos
-- 2. BEGIN TRANSACTION
-- 3. Insertar dim_product
-- 4. Insertar dim_category
-- 5. Insertar dim_origin
-- 6. Insertar dim_sustainability
-- 7. Insertar dim_system
-- 8. FACT TABLE

-- ----------------------------------------------------------------------------

SELECT * FROM staging_food sf   ;

-- ======================================================
-- 1 COMPROBACIÓN DEL DATASET
-- ======================================================

SELECT COUNT(*)
FROM staging_food;

SELECT *
FROM staging_food 
LIMIT 5;

-- PAra evitar duplicados:
DELETE FROM fact_environmental_impact;
DELETE FROM dim_product;
DELETE FROM dim_category;
DELETE FROM dim_origin;
DELETE FROM dim_system;
DELETE FROM dim_sustainability;

-- =====================================================
-- 2 TRANSACCIÓN
-- =====================================================

BEGIN TRANSACTION;

-- =====================================================
-- 3 DIMENSIÓN PRODUCTO (sale directamente del csv)
-- =====================================================

INSERT OR IGNORE INTO dim_product (product_name)

SELECT DISTINCT food_product
FROM staging_food
WHERE food_product IS NOT NULL;

SELECT * FROM dim_product;

-- =====================================================
-- 4 DIMENSIÓN CATEGORÍA (lo hacemos manualmente)
-- =====================================================

INSERT OR IGNORE INTO dim_category(category_name)

VALUES
('Meat'),
('Fish'),
('Dairy'),
('Cereals'),
('Fruit'),
('Vegetables'),
('Oils'),
('Nuts'),
('Beverages'),
('Other');

SELECT * FROM dim_category;

-- =====================================================
-- 5 DIMENSIÓN ORIGEN (lo hacemos manualmente)
-- =====================================================

INSERT OR IGNORE INTO dim_origin(origin_name)

VALUES
('Animal'),
('Plant');

SELECT * FROM dim_origin;

-- =====================================================
-- 6 DIMENSIÓN SISTEMA (SERÁ PARA TODOS IGUAL)
-- =====================================================

INSERT OR IGNORE INTO dim_system(system_name)

VALUES
('Conventional');

SELECT * FROM dim_system;

-- =====================================================
-- 7 DIMENSIÓN SUSTAINABILITY (clasificación ambiental calculada a partir de las emisiones)
-- =====================================================

INSERT OR IGNORE INTO dim_sustainability
(sustainability_level)

VALUES
('Low'),
('Medium'),
('High'),
('Very High');

SELECT * FROM dim_sustainability;

-- Antes de escribir toda la clasificación definitiva ejecutamos esta consulta que devoloverá la lista de los 43 alimentos del dataset:
SELECT food_product
FROM staging_food
ORDER BY food_product;

-- =====================================================
-- 8 FACT TABLE
-- CARGA DE LA TABLA DE HECHOS
-- =====================================================
-- Mediante una CTE clasificamos cada alimento según:
-- • Categoría
-- • Origen
-- • Nivel de sostenibilidad

-- Después relacionamos esas clasificaciones con las tablas dimensión para obtener las claves foráneas.
-- =====================================================

WITH classified_food AS (

SELECT s.*,

----------------------------------------------------
-- CATEGORÍA
----------------------------------------------------

	CASE
		WHEN food_product IN
		('Beef (beef herd)',
		'Beef (dairy herd)',
		'Lamb & Mutton',
		'Pig Meat',
		'Poultry Meat')
		
		THEN 'Meat'
		
		WHEN food_product IN
		('Milk',
		'Cheese',
		'Eggs')
		
		THEN 'Dairy'
		
		WHEN food_product IN
		('Fish (farmed)',
		'Shrimps (farmed)')
		
		THEN 'Fish'
		
		WHEN food_product IN
		('Rice',
		'Oatmeal',
		'Maize (Meal)',
		'Wheat & Rye (Bread)',
		'Barley (Beer)')
		
		THEN 'Cereals'
		
		WHEN food_product IN
		('Apples',
		'Bananas',
		'Berries & Grapes',
		'Citrus Fruit',
		'Other Fruit')
		
		THEN 'Fruit'
		
		WHEN food_product IN
		('Tomatoes',
		'Root Vegetables',
		'Brassicas',
		'Onions & Leeks',
		'Other Vegetables',
		'Potatoes',
		'Cassava')
		
		THEN 'Vegetables'
		
		WHEN food_product IN
		('Groundnuts',
		'Nuts',
		'Peas',
		'Other Pulses')
		
		THEN 'Nuts'
		
		WHEN food_product IN
		('Olive Oil',
		'Palm Oil',
		'Rapeseed Oil',
		'Sunflower Oil',
		'Soybean Oil')
		
		THEN 'Oils'
		
		WHEN food_product IN
		('Coffee',
		'Wine')
		
		THEN 'Beverages'
		
		ELSE 'Other'
	END AS category,

----------------------------------------------------
-- ORIGEN (Animal; Vegetal)
----------------------------------------------------

CASE
	WHEN food_product IN
	('Beef (beef herd)',
	'Beef (dairy herd)',
	'Lamb & Mutton',
	'Pig Meat',
	'Poultry Meat',
	'Milk',
	'Cheese',
	'Eggs',
	'Fish (farmed)',
	'Shrimps (farmed)')
	THEN 'Animal'
	ELSE 'Plant'
END AS origin,

----------------------------------------------------
-- SOSTENIBILIDAD
	
/*El dataset no incluye una clasificación del nivel de sostenibilidad.
-- Por ello se crea una variable derivada utilizando las emisiones totales de CO₂ (kg CO₂e por kg de alimento). 
-- Los umbrales se han definido con fines analíticos para facilitar la comparación entre alimentos.

SELECT
MIN(total_emissions) AS minimo,
MAX(total_emissions) AS maximo,
AVG(total_emissions) AS media;

-- Con esto vemos el rango de valores en cuanto a emisiones de CO₂, y en bae a eso, definimos un umbral
-- (No existe un estándar internacional que diga que un alimento es "alto" o "bajo" a partir de X kg CO₂e/kg.)*/

CASE
    WHEN total_emissions < 5
    THEN 'Low'

    WHEN total_emissions >= 5
    AND total_emissions < 10
    THEN 'Medium'

    WHEN total_emissions >= 10
    AND total_emissions < 20
    THEN 'High'

    ELSE 'Very High'

END AS sustainability
FROM staging_food s
)

INSERT INTO fact_environmental_impact
(
product_id,
category_id,
origin_id,
system_id,
sustainability_id,
land_use_change,
animal_feed,
farm,
processing,
transport,
packaging,
retail,
total_emissions,
land_use,
water_use
)

SELECT
	p.product_id,
	c.category_id,
	o.origin_id,
	1,
	su.sustainability_id,
	cf.land_use_change,
	cf.animal_feed,
	cf.farm,
	cf.processing,
	cf.transport,
	cf.packaging,
	cf.retail,
	cf.total_emissions,
	cf.land_use,
	cf.water_use
FROM classified_food cf

-- Hacemos INNER JOIN con las dimensiones para obtener los IDs numéricos (Foreign Keys).

INNER JOIN dim_product p ON cf.food_product=p.product_name

INNER JOIN dim_category c ON cf.category=c.category_name

INNER JOIN dim_origin o ON cf.origin=o.origin_name

INNER JOIN dim_sustainability su ON cf.sustainability=su.sustainability_level;

-- =====================================================
-- COMPROBACIÓN FINAL
-- =====================================================

SELECT COUNT(*) FROM fact_environmental_impact;
SELECT * FROM fact_environmental_impact;
