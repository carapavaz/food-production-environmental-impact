-- ---------------------------------------------------------
-- PASO 1: CREACIÓN DE LA BASE DE DATOS Y TABLA STAGING  
-- ---------------------------------------------------------
-- La tabla staging almacena el CSV original sin modificar.
-- Posteriormente sus datos se utilizarán para probar las tablas de dimensiones y la tabla de hechos

-- 1. FACT TABLE: impacto ambiental asociado a un alimento

DROP TABLE IF EXISTS staging_food;
DROP TABLE IF EXISTS fact_environmental_impact;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_category;
DROP TABLE IF EXISTS dim_origin;
DROP TABLE IF EXISTS dim_system;
DROP TABLE IF EXISTS dim_sustainability;

-- Hacemos ese DROP al principio para garantizar que el proyecto pueda ejecutarse desde cero y así al ejeccutar de nuevo el script no dará error.

CREATE TABLE IF NOT EXISTS staging_food (

    food_product TEXT,
    land_use_change REAL,
    animal_feed REAL,
    farm REAL,
    processing REAL,
    transport REAL,
    packaging REAL,
    retail REAL,
    total_emissions REAL,
    eutrophying_emissions REAL,
    freshwater_withdrawals REAL,
    greenhouse_gas_emissions REAL,
    land_use REAL,
    water_use REAL
);

SELECT * FROM staging_food;
-- ---------------------------------------------------------
-- PASO 2: CREACIÓN DE LAS 5 TABLAS DE DIMENSIONES
-- ---------------------------------------------------------
-- Dimensión 1: Alimento (producto)
CREATE TABLE IF NOT EXISTS dim_product (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name VARCHAR(100) NOT NULL UNIQUE
);

-- Dimensión 2: Categoría del producto (Carne; Lácteo; Cereal; Frutas; Fruto seco)
CREATE TABLE IF NOT EXISTS dim_category (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Dimensión 3: Origen (Animal; Vegetal)
CREATE TABLE IF NOT EXISTS dim_origin (
    origin_id INTEGER PRIMARY KEY AUTOINCREMENT,
    origin_name VARCHAR(20) NOT NULL UNIQUE
);

-- Dimensión 4: Sistema de prooducción (Convencional; Sostenible)
CREATE TABLE IF NOT EXISTS dim_system (
    system_id INTEGER PRIMARY KEY AUTOINCREMENT,
    system_name VARCHAR(50) NOT NULL UNIQUE
);

-- Dimensión 5: Nivel de sostenibilidad (clasificación ambiental calculada a partir de las emisiones)
CREATE TABLE IF NOT EXISTS dim_sustainability (
    sustainability_id INTEGER PRIMARY KEY AUTOINCREMENT,
    sustainability_level VARCHAR(30) NOT NULL UNIQUE
);

-- ---------------------------------------------------------
-- PASO 3: CREACIÓN DE LA TABLA DE HECHOS (FACT TABLE)
-- ---------------------------------------------------------
-- =========================================================
-- Granularidad:
-- Cada fila representa el impacto ambiental asociado a la producción de un alimento.
-- =========================================================

DROP TABLE IF EXISTS fact_environmental_impact;

CREATE TABLE fact_environmental_impact(

    fact_id INTEGER PRIMARY KEY AUTOINCREMENT,

    -- Claves foráneas
    product_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    origin_id INTEGER NOT NULL,
    sustainability_id INTEGER NOT NULL,
    system_id INTEGER NOT NULL,

    -- Indicadores ambientales
    land_use_change REAL,
    animal_feed REAL,
    farm REAL,
    processing REAL,
    transport REAL,
    packaging REAL,
    retail REAL,
    total_emissions REAL CHECK(total_emissions >=0),
    land_use REAL CHECK(land_use>=0),
    water_use REAL CHECK(water_use>=0),

    FOREIGN KEY(product_id)
        REFERENCES dim_product(product_id),

    FOREIGN KEY(category_id)
        REFERENCES dim_category(category_id),

    FOREIGN KEY(origin_id)
        REFERENCES dim_origin(origin_id),

    FOREIGN KEY(sustainability_id)
        REFERENCES dim_sustainability(sustainability_id),

    FOREIGN KEY(system_id)
        REFERENCES dim_system(system_id)
);

SELECT * FROM fact_environmental_impact;

