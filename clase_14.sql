SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name, CONCAT(a.address, ' ', COALESCE(a.address2, ''), ' ', a.district) AS address, ci.city FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

SELECT f.title, l.name AS language,
  CASE f.rating
    WHEN 'G' THEN 'general audiences'
    WHEN 'PG' THEN 'parental guidance suggested'
    WHEN 'PG-13' THEN 'parents strongly cautioned'
    WHEN 'R' THEN 'restricted'
    WHEN 'NC-17' THEN 'no one 17 and under admitted'
    ELSE 'unrated'
  END AS rating_text
FROM film f
JOIN language l ON f.language_id = l.language_id;


SET @actor_name = 'robert de niro';

SELECT DISTINCT f.title, f.release_year
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE LOWER(CONCAT(a.first_name, ' ', a.last_name)) LIKE CONCAT('%', LOWER(@actor_name), '%') OR LOWER(CONCAT(a.last_name, ' ', a.first_name)) LIKE CONCAT('%', LOWER(@actor_name), '%')
ORDER BY f.release_year DESC, f.title;

SELECT f.title, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, CASE WHEN r.return_date IS NULL THEN 'No' ELSE 'Yes' END AS returned
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) IN (5, 6)
ORDER BY r.rental_date;

-- convertir fecha completa a solo fecha
SELECT r.rental_id, CAST(r.rental_date AS DATE) AS rental_date_only
FROM rental r
LIMIT 5;

-- convertir string numérico a número
SELECT CAST('2025' AS UNSIGNED) AS year_num,
  CONVERT('2025', UNSIGNED) AS year_num2;

-- convertir string a otro charset (ejemplo conceptual)
SELECT CONVERT(f.title USING latin1) AS title_latin1
FROM film f
WHERE f.film_id = 1;


