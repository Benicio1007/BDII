USE sakila;

SELECT title FROM film
WHERE film_id NOT IN (
  SELECT film_id
  FROM inventory
);

SELECT f.title, i.inventory_id FROM inventory i
JOIN film f ON f.film_id = i.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IS NULL;

SELECT c.first_name, c.last_name, c.store_id, f.title, r.rental_date, r.return_date FROM rental r
JOIN customer c ON c.customer_id = r.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
ORDER BY c.store_id, c.last_name;


SELECT  s.store_id, SUM(p.amount) AS total_ventas FROM payment p
JOIN staff st ON st.staff_id = p.staff_id
JOIN store s ON s.store_id = st.store_id
GROUP BY s.store_id;

SELECT CONCAT(ci.city, ', ', co.country) AS ciudad_pais, CONCAT(stf.first_name, ' ', stf.last_name) AS gerente, SUM(p.amount) AS total_ventas FROM payment p
JOIN staff stf ON stf.staff_id = p.staff_id
JOIN store s ON s.store_id = stf.store_id
JOIN address a ON a.address_id = s.address_id
JOIN city ci ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id
GROUP BY ciudad_pais, gerente;

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_pelis FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id
ORDER BY cantidad_pelis DESC
LIMIT 1;

