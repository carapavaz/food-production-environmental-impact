-- ==========================================================
--Este script realiza un análisis exploratorio de los datos almacenados en el modelo dimensional.
-- Cada consulta responde a una pregunta de negocio.

SELECT * FROM fact_environmental_impact;

/* ==========================================================
-- 1. ¿Cuántos alimentos contiene el dataset?
============================================================*/

SELECT COUNT(*) AS total_foods
FROM fact_environmental_impact;

--------------------------------------------------------------

/* ==========================================================
-- 2. ¿Qué alimento genera más emisiones de CO₂?
============================================================*/

SELECT
    p.product_name,
    f.total_emissions
FROM fact_environmental_impact f

INNER JOIN dim_product p ON f.product_id=p.product_id

ORDER BY f.total_emissions
DESC LIMIT 10;

--------------------------------------------------------------

/* ==========================================================
-- 3. Emisiones medias por categoría
¿Qué categoría de alimentos genera más emisiones de CO₂?
============================================================*/

SELECT
c.category_name,
ROUND(AVG(f.total_emissions),2) AS average_emissions
FROM fact_environmental_impact f
INNER JOIN dim_category c ON f.category_id=c.category_id
GROUP BY c.category_name
ORDER BY average_emissions DESC;

/*Esta consulta permite identificar los grupos de alimentos con mayor impacto ambiental 
 para orientar estrategias de consumo sostenible.*/
--------------------------------------------------------------

-- ==========================================================
-- 4. Emisiones medias de CO₂ según el origen del alimento
-- ==========================================================

SELECT
    o.origin_name,
    ROUND(AVG(f.total_emissions),2) AS average_total_emissions

FROM fact_environmental_impact f
INNER JOIN dim_origin o ON f.origin_id = o.origin_id
GROUP BY o.origin_name
ORDER BY average_total_emissions DESC;

--------------------------------------------------------------

-- ==========================================================
-- 5. Número de alimentos según nivel de sostenibilidad
-- ==========================================================

SELECT
	s.sustainability_level,
	COUNT(*) AS total_foods
FROM fact_environmental_impact f
INNER JOIN dim_sustainability s ON f.sustainability_id=s.sustainability_id
GROUP BY s.sustainability_level
ORDER BY total_foods DESC;

--------------------------------------------------------------

-- ==========================================================
-- 6. TOP 5 alimentos con mayores emisiones derivadas del transporte
-- ==========================================================

SELECT
	p.product_name,
	ROUND(f.transport,2) AS transport_emissions
FROM fact_environmental_impact f
INNER JOIN dim_product p ON f.product_id=p.product_id
ORDER BY transport_emissions DESC

LIMIT 5;

--------------------------------------------------------------

-- ==========================================================
-- 7. Alimentos con emisiones superiores a la media
-- ==========================================================

SELECT
    p.product_name,
    ROUND(f.total_emissions,2) AS total_emissions

FROM fact_environmental_impact f

INNER JOIN dim_product p ON f.product_id = p.product_id

WHERE f.total_emissions >
(
    SELECT AVG(total_emissions)
    FROM fact_environmental_impact
)

ORDER BY f.total_emissions DESC;

--------------------------------------------------------------

-- ==========================================================
-- 8. Ranking de emisiones (Función ventana)
-- ==========================================================

SELECT

    p.product_name,
    ROUND(f.total_emissions,2) AS total_emissions,
    RANK() OVER
    (
        ORDER BY f.total_emissions DESC
    ) AS ranking

FROM fact_environmental_impact f
INNER JOIN dim_product p ON f.product_id = p.product_id;

--------------------------------------------------------------

-- ==========================================================
-- 9. ¿Qué alimentos deben gran parte de su impacto ambiental al transporte y cuáles a la producción?
-- ==========================================================

SELECT
    p.product_name,
    ROUND(f.transport,2) AS transport,
    ROUND(f.total_emissions,2) AS total_emissions,
    ROUND((f.transport*100.0)/f.total_emissions,2) AS transport_percentage

FROM fact_environmental_impact f
INNER JOIN dim_product p ON f.product_id = p.product_id
WHERE f.total_emissions > 0
ORDER BY transport_percentage DESC;

--------------------------------------------------------------

-- ==========================================================
-- 10. LEFT JOIN
--
-- Verifica si existen categorías sin alimentos asociados.
-- ==========================================================

SELECT
	c.category_name,
	COUNT(f.fact_id) total_products
FROM dim_category c
LEFT JOIN fact_environmental_impact f ON c.category_id=f.category_id
GROUP BY c.category_name;

--------------------------------------------------------------

-- ==========================================================
-- 11. Top 5 alimentos con mayores emisiones del procesado
-- ==========================================================

SELECT
    p.product_name,
    ROUND(f.processing,2) AS processing_emissions

FROM fact_environmental_impact f
INNER JOIN dim_product p ON f.product_id = p.product_id
ORDER BY processing_emissions DESC
LIMIT 5;

--------------------------------------------------------------

-- ==========================================================
-- 11. ¿Qué fase de producción genera más emisiones?
-- ==========================================================

SELECT

	ROUND(AVG(land_use_change),2) AS land_use_change,
	ROUND(AVG(animal_feed),2) AS animal_feed,
	ROUND(AVG(farm),2) AS farm,
	ROUND(AVG(processing),2) AS processing,
	ROUND(AVG(transport),2) AS transport,
	ROUND(AVG(packaging),2) AS packaging,
	ROUND(AVG(retail),2) AS retail

FROM fact_environmental_impact;

-- La mayor parte de las emisiones no proviene del transporte, sino de la propia producción agrícola y ganadera.

--------------------------------------------------------------

-- ==========================================================
-- 13. Media global de emisiones
-- ==========================================================

SELECT
	ROUND(AVG(total_emissions),2) AS global_average_emissions
FROM fact_environmental_impact;


