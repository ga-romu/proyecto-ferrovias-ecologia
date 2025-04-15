SELECT 
    a.id,
	a.nombre AS atractivo_turistico,
    a.region,
    a.comuna,
	a.geom,
    ST_Distance(
        ST_Transform(a.geom, 32719),  -- Transformar punto a UTM 19S (metros)
        r.geom                         -- La red ferroviaria ya está en 32719
    ) AS distancia_metros
FROM 
    atractivos_turisticos_nacionales a
CROSS JOIN 
    red_ferroviaria r
WHERE 
    ST_DWithin(
        ST_Transform(a.geom, 32719),  -- Punto transformado a UTM
        r.geom,                       -- Línea en UTM
        1000                          -- 1000 metros = 1km
    )
ORDER BY 
    distancia_metros ASC
LIMIT 100;