# 🌱 Food Production Environmental Impact | SQL Relational Database Project

Este proyecto tiene como objetivo diseñar e implementar una base de datos relacional en SQL para analizar el impacto ambiental asociado a la producción de diferentes alimentos.

A partir de un conjunto de datos público procedente de Kaggle, se construye un modelo dimensional en estrella compuesto por una tabla de hechos y varias tablas de dimensiones, permitiendo responder preguntas de negocio mediante consultas SQL. (https://www.kaggle.com/datasets/selfvivek/environment-impact-of-food-production)

---

# Descripción del conjunto de datos

El conjunto de datos utilizado recoge el impacto ambiental generado durante la producción de 43 alimentos diferentes.

Cada registro representa un alimento y contiene indicadores ambientales asociados a distintas fases de su producción.

Entre las variables más relevantes se encuentran:

* Nombre del alimento
* Cambio de uso del suelo (Land Use Change)
* Alimentación animal
* Producción agrícola (Farm)
* Procesado
* Transporte
* Envasado
* Venta minorista (Retail)
* Emisiones totales de CO₂
* Uso del suelo
* Consumo de agua

Se trata de un dataset muy adecuado para realizar análisis medioambientales porque permite estudiar qué alimentos generan un mayor impacto y qué etapas de la cadena de producción son más contaminantes.

---

# Alcance del proyecto

El análisis tiene como objetivo estudiar el impacto ambiental de la producción de alimentos mediante diferentes indicadores.

El proyecto permite analizar:

* Comparación de emisiones entre alimentos.
* Comparación entre alimentos de origen animal y vegetal.
* Clasificación por categorías alimentarias.
* Estudio del impacto del transporte y del procesado.
* Clasificación de alimentos según su nivel de sostenibilidad.

Quedan fuera del alcance:

* Información temporal real.
* País de producción.
* Sistema agrícola real (ecológico o convencional).
* Datos económicos.
* Consumo energético.

Estas limitaciones vienen dadas por la información disponible en el dataset original.

---

# Modelo de datos

Se ha implementado un modelo en estrella compuesto por:

## Tabla de hechos

**fact_environmental_impact**

Contiene todas las métricas ambientales.

## Tablas de dimensiones

* dim_product - Una fila por alimento
* dim_category - Clasifica los alimentos según tipo
* dim_origin -  Clasifica los alimentos según origen
* dim_system - Clasifica los alimentos según sistema de producción
* dim_sustainability - Clasifica cada alimento según el nivel de emisiones de CO₂

---

# Granularidad

## fact_environmental_impact

Cada fila representa el impacto ambiental asociado a la producción de un único alimento.
Contiene las métricas:

* emisiones totales
* uso del suelo
* consumo de agua
* transporte
* procesado
* alimentación animal
* retail
* packaging

Además de las claves foráneas que enlazan con las dimensiones.

---

# Carga y transformación de datos

El proyecto se divide en tres scripts:

## 01_schema.sql
Creación del modelo relacional.

## 02_data.sql
Carga de los datos desde la tabla staging.

---

# Análisis Exploratorio de Datos (EDA)

Durante el análisis se utilizaron las principales funcionalidades vistas durante el módulo de SQL.
Entre ellas:

* COUNT
* AVG
* SUM
* GROUP BY
* INNER JOIN
* LEFT JOIN
* CASE
* CTE (WITH)
* Subconsultas
* Funciones ventana (RANK)
* Índices
* Vistas

Las consultas responden a preguntas de negocio como:

1. ¿Qué alimento genera mayores emisiones de CO₂?

2. ¿Qué categoría produce un mayor impacto ambiental?

3. ¿Qué origen (animal o vegetal) genera más emisiones?

4. ¿Qué número de alimentos pertenece a cada nivel de sostenibilidad?

5. ¿Qué 5 alimentos generan más emisiones durante el transporte?

6. ¿Qué alimentos presentan emisiones superiores a la media del conjunto?

7. ¿Cuál es el ranking de alimentos según emisiones totales?

8. ¿Qué alimentos deben gran parte de su impacto ambiental al transporte y cuáles a la producción?

9. ¿Qué 5 alimentos generan más emisiones durante el procesado?

10. ¿Qué fase de producción genera más emisiones?

11. ¿Cuál es la media global de emisiones?

Estas consultas permiten obtener información útil para comprender qué alimentos tienen un mayor impacto ambiental y en qué etapas de producción se generan las mayores emisiones.

---

# Conclusiones

Los resultados muestran claramente que los alimentos de origen animal presentan, en promedio, un impacto ambiental considerablemente superior al de los alimentos de origen vegetal.

Asimismo, el análisis evidencia que las fases de producción agrícola y alimentación animal concentran la mayor parte de las emisiones de CO₂, mientras que el transporte representa un porcentaje mucho menor del impacto total, contradiciendo una creencia bastante extendida.

Este proyecto demuestra cómo un modelo relacional bien diseñado permite transformar un conjunto de datos plano en una base de datos preparada para responder preguntas de negocio mediante SQL.
