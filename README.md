# Análisis Geoespacial: Red Ferroviaria, Paisaje y Turismo en Chile

![](./resultados/patrimoniopaisajetren-gr.jpeg)




## 📋 Descripción
Proyecto de análisis espacial que estudia la relación entre la infraestructura ferroviaria y los ecosistemas chilenos mediante PostgreSQL/PostGIS. Incluye:
- Intersecciones con pisos vegetacionales
- Atractivos turísticos en zonas de influencia
- Corredores ferroviarios en áreas protegidas

## 🗂️ Estructura del Repositorio


```tree
/proyecto-ferrovias-ecologia/
│
├── /data/                   # Datos espaciales originales
├── /sql/                    # Scripts SQL
│   ├── 01_pisos_ferrovia.sql
│   ├── 02_atractivos_cercanos.sql
│   └── 03_corredores_protegidos.sql
├── /resultados/             # Exportación de resultados
├── README.md                # Este archivo
└── LICENSE                  # Licencia del proyecto
```

## 🔍 Consultas Principales

### 1. Pisos Vegetacionales con Ferrovías
**Objetivo**: Identificar unidades vegetacionales intersectadas por vías férreas.

```sql
CREATE VIEW pisosv_tren AS
SELECT 
    v.id,
    v.piso,
    v.geom
FROM pisos_vegetacionales v
WHERE EXISTS (
    SELECT 1 FROM red_ferroviaria r
    WHERE ST_Intersects(v.geom, ST_Transform(r.geom, 4326))
);
```

### 2. Atractivos Turísticos en Radio de 500m

**Metodología**: Buffer de proximidad con transformación UTM para precisión métrica.

```sql
CREATE TABLE aturistico_tren_500m AS
SELECT 
    a.id,
    a.nombre,
    a.region,
    ST_Distance(
        ST_Transform(a.geom, 32719),
        r.geom
    ) AS distancia_metros,
    a.geom
FROM atractivos_turisticos_nacionales a
JOIN red_ferroviaria r 
    ON ST_DWithin(ST_Transform(a.geom, 32719), r.geom, 500)
    ;
```

### 3. Corredores Ecológicos (10km buffer)

**Aporte**: Identificación de áreas protegidas atravesadas por la ferrovía
```sql
CREATE TABLE corredores_protegidos10k AS
SELECT 
    s.nombre,
    s.region,
    COUNT(r.id) AS num_tramos,
    ST_Buffer(s.geom, 10000) AS geom_buffer,
    s.geom
FROM snaspe s
JOIN red_ferroviaria r 
    ON ST_Intersects(ST_Buffer(s.geom, 10000), ST_Transform(r.geom, 3857))
GROUP BY s.nombre, s.region, s.geom;
```

### 🛠️ Configuración Técnica

Requisitos mínimos:

- PostgreSQL 13+ con PostGIS 3.2+
- Extensión postgis activada
- SRID consistentes (4326, 32719, 3857)

```sql 
CREATE EXTENSION postgis;
SELECT PostGIS_full_version();
```

### 📊 Visualización de Resultados

Recomendaciones para QGIS:

1. Cargar capas resultantes
2. Estilizar por:
    - Tipo de piso vegetacional
    - Distancia a ferrovías
    - Categoría de área protegida
3. Usar SRID correspondiente al exportar


### 🤝 Cómo Contribuir

1. Reportar issues con datos o análisis
2. Proponer mejoras a las consultas
3. Agregar nuevos análisis espaciales


