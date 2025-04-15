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