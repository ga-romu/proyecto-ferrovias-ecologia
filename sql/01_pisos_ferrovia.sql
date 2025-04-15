SELECT 
    v.id,
	v.piso,
    v.geom
FROM 
    pisos_vegetacionales v
WHERE EXISTS (
    SELECT 1 
    FROM red_ferroviaria r
    WHERE 
        ST_Intersects(v.geom, ST_Transform(r.geom, 4326))
        OR ST_Touches(v.geom, ST_Transform(r.geom, 4326))
        OR ST_Crosses(v.geom, ST_Transform(r.geom, 4326))
)
;