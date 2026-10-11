
USE online_game;

-- Analisis 1: Empresas con mayores ventas totales
SELECT
    p.publisher_name,
    COUNT(*) AS publications,
    ROUND(SUM(r.global_sales), 2) AS total_sales,
    ROUND(AVG(r.global_sales), 2) AS average_sales
FROM game_release r
JOIN publisher p ON r.publisher_id = p.publisher_id
GROUP BY p.publisher_id, p.publisher_name
ORDER BY total_sales DESC
LIMIT 5;

-- Analisis 1: Empresas con mayor promedio y minimo 10 publicaciones
SELECT
    p.publisher_name,
    COUNT(*) AS publications,
    ROUND(SUM(r.global_sales), 2) AS total_sales,
    ROUND(AVG(r.global_sales), 2) AS average_sales
FROM game_release r
JOIN publisher p ON r.publisher_id = p.publisher_id
GROUP BY p.publisher_id, p.publisher_name
HAVING COUNT(*) >= 10
ORDER BY average_sales DESC
LIMIT 5;


-- Analisis 2: Plataformas con mas juegos Action despues de 2005
SELECT
    p.platform_name,
    COUNT(DISTINCT r.game_id) AS total_games
FROM game_release r
JOIN platform p ON r.platform_id = p.platform_id
JOIN genre g ON r.genre_id = g.genre_id
WHERE g.genre_name = 'Action'
    AND r.release_year > 2005
GROUP BY p.platform_id, p.platform_name
ORDER BY total_games DESC;


-- Analisis 3: Publicaciones con mayores ventas en Japon
SELECT
    COUNT(*) AS jp_higher_than_na,
    SUM(na_sales = 0) AS zero_na_sales
FROM game_release
WHERE jp_sales > na_sales;

-- Analisis 3: Juegos con mayor diferencia a favor de Japon
SELECT
    g.game_name,
    p.platform_name,
    ge.genre_name,
    r.jp_sales,
    r.na_sales,
    ROUND(r.jp_sales - r.na_sales, 2) AS sales_difference
FROM game_release r
JOIN game g ON r.game_id = g.game_id
JOIN platform p ON r.platform_id = p.platform_id
JOIN genre ge ON r.genre_id = ge.genre_id
WHERE r.jp_sales > r.na_sales
ORDER BY sales_difference DESC
LIMIT 10;

-- Analisis 3: Comparacion por genero
SELECT
    g.genre_name,
    COUNT(*) AS total_releases,
    SUM(r.jp_sales > r.na_sales) AS jp_higher,
    ROUND(100 * SUM(r.jp_sales > r.na_sales) / COUNT(*), 2) AS percentage
FROM game_release r
JOIN genre g ON r.genre_id = g.genre_id
GROUP BY g.genre_id, g.genre_name
ORDER BY percentage DESC;

-- Analisis 3: Comparacion por plataforma
SELECT
    p.platform_name,
    COUNT(*) AS total_releases,
    SUM(r.jp_sales > r.na_sales) AS jp_higher,
    ROUND(100 * SUM(r.jp_sales > r.na_sales) / COUNT(*), 2) AS percentage
FROM game_release r
JOIN platform p ON r.platform_id = p.platform_id
GROUP BY p.platform_id, p.platform_name
HAVING COUNT(*) >= 30
ORDER BY percentage DESC;


-- Analisis 4: Promedio de ventas globales por genero
SELECT
    g.genre_name,
    COUNT(*) AS publications,
    ROUND(AVG(r.global_sales), 3) AS average_sales
FROM game_release r
JOIN genre g ON r.genre_id = g.genre_id
GROUP BY g.genre_id, g.genre_name
ORDER BY average_sales DESC;
