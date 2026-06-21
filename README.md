# 🌱 Food Production Environmental Impact | SQL Relational Database Project

## Carmen Aparicio Vázquez

Este proyecto tiene como objetivo diseñar e implementar una base de datos relacional en SQL para analizar el impacto ambiental asociado a la producción de diferentes alimentos.

A partir de un conjunto de datos público procedente de Kaggle, se construye un modelo dimensional en estrella compuesto por una tabla de hechos y varias tablas de dimensiones, permitiendo responder preguntas de negocio mediante consultas SQL.

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

* dim_product
* dim_category
* dim_origin
* dim_system
* dim_sustainability

Este modelo permite separar la información descriptiva de las métricas cuantitativas, facilitando tanto el mantenimiento como el análisis posterior.

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

además de las claves foráneas que enlazan con las dimensiones.

---

## dim_product

Una fila por alimento.

Ejemplos:

* Beef
* Milk
* Rice
* Tomatoes

---

## dim_category

Agrupa los alimentos según su tipo.

Ejemplos:

* Meat
* Dairy
* Cereals
* Fruit
* Vegetables
* Fish
* Oils
* Nuts

---

## dim_origin

Clasifica los alimentos según su origen.

* Animal
* Plant

---

## dim_system

Representa el sistema de producción.

Actualmente todos los registros pertenecen al sistema convencional, aunque se ha diseñado esta dimensión pensando en futuras ampliaciones del proyecto.

---

## dim_sustainability

Clasifica cada alimento según el nivel de emisiones de CO₂.

Los niveles utilizados son:

* Low
* Medium
* High
* Very High

Esta clasificación no existe en el dataset original, sino que ha sido creada mediante una sentencia CASE utilizando las emisiones totales como criterio.

---

# Decisiones de diseño

Se ha optado por un modelo dimensional en estrella porque facilita el análisis mediante consultas SQL.

Todas las dimensiones poseen claves primarias autoincrementales.

La tabla de hechos almacena únicamente las claves foráneas y las métricas numéricas.

Se han utilizado:

* PRIMARY KEY para identificar cada registro.
* FOREIGN KEY para garantizar la integridad referencial.
* UNIQUE para evitar duplicados en las dimensiones.
* NOT NULL en los campos obligatorios.
* CHECK para impedir valores negativos en los indicadores ambientales.

Además, se creó un índice sobre product_id para acelerar las consultas más frecuentes por alimento.

---

# Carga y transformación de datos

El proyecto se divide en tres scripts:

## 01_schema.sql

Creación del modelo relacional.

Incluye:

* Tabla staging.
* Tabla de hechos.
* Cinco dimensiones.
* Índices.
* Restricciones de integridad.

## 02_data.sql

Carga de los datos desde la tabla staging.

Posteriormente:

* Se rellenan las dimensiones.
* Se clasifican los alimentos mediante CASE.
* Se generan las relaciones entre dimensiones y tabla de hechos mediante INNER JOIN.
* Se realizan operaciones UPDATE para simular cambios en el sistema de producción.

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

4. ¿Cuáles son los cinco alimentos con mayor consumo de agua?

5. ¿Qué alimentos generan más emisiones durante el transporte?

6. ¿Qué alimentos generan más emisiones durante el procesado?

7. ¿Qué porcentaje de alimentos pertenece a cada nivel de sostenibilidad?

8. ¿Qué alimentos presentan emisiones superiores a la media del conjunto?

9. ¿Cuál es el ranking de alimentos según emisiones totales?

10. ¿Qué categoría presenta el mayor promedio de emisiones?

11. ¿Cómo se distribuyen los alimentos según su origen y nivel de sostenibilidad?

12. ¿Qué fase de producción concentra la mayor parte del impacto ambiental?

Estas consultas permiten obtener información útil para comprender qué alimentos tienen un mayor impacto ambiental y en qué etapas de producción se generan las mayores emisiones.

---

# Conclusiones

Los resultados muestran claramente que los alimentos de origen animal presentan, en promedio, un impacto ambiental considerablemente superior al de los alimentos de origen vegetal.

Asimismo, el análisis evidencia que las fases de producción agrícola y alimentación animal concentran la mayor parte de las emisiones de CO₂, mientras que el transporte representa un porcentaje mucho menor del impacto total, contradiciendo una creencia bastante extendida.

Este proyecto demuestra cómo un modelo relacional bien diseñado permite transformar un conjunto de datos plano en una base de datos preparada para responder preguntas de negocio mediante SQL.
