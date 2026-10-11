
USE online_game;

-- Consulta 1: Juegos posteriores a 2013 con ventas mayores a 7 millones
SELECT
    release_id,
    game_id,
    platform_id,
    release_year,
    global_sales
FROM game_release
WHERE release_year > 2013
    AND global_sales > 7
ORDER BY global_sales DESC;


-- Consulta 2: Los 10 videojuegos con mayores ventas globales
SELECT
    g.game_name,
    r.release_year,
    r.global_sales
FROM game_release r
JOIN game g ON r.game_id = g.game_id
ORDER BY r.global_sales DESC
LIMIT 10;


-- Consulta 3: Plataformas y empresas de los juegos mas vendidos
SELECT
    g.game_name,
    p.platform_name,
    pub.publisher_name,
    r.global_sales
FROM game_release r
JOIN game g ON r.game_id = g.game_id
JOIN platform p ON r.platform_id = p.platform_id
JOIN publisher pub ON r.publisher_id = pub.publisher_id
ORDER BY r.global_sales DESC
LIMIT 10;


-- Consulta 4: Ventas globales por plataforma
SELECT
    p.platform_name,
    COUNT(*) AS publications,
    SUM(r.global_sales) AS total_sales
FROM game_release r
JOIN platform p ON r.platform_id = p.platform_id
GROUP BY p.platform_id, p.platform_name
ORDER BY total_sales DESC
LIMIT 10;
