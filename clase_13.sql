USE sakila;

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES (1, 'juan', 'perez', 'juanperez@email.com',
  (SELECT MAX(address_id)
   FROM address a
   JOIN city c ON a.city_id = c.city_id
   JOIN country co ON c.country_id = co.country_id
   WHERE co.country = 'United States'),1
);

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (NOW(),
  (SELECT MAX(i.inventory_id)
   FROM inventory i
   JOIN film f ON f.film_id = i.film_id
   WHERE f.title = 'ACADEMY DINOSAUR'),
  (SELECT customer_id FROM customer LIMIT 1),
  (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1)
);

SET SQL_SAFE_UPDATES = 0;

UPDATE film
SET release_year = 2001
WHERE rating = 'G';

UPDATE film
SET release_year = 2005
WHERE rating = 'PG';

UPDATE film
SET release_year = 2010
WHERE rating = 'PG-13';

UPDATE film
SET release_year = 2015
WHERE rating = 'R';

UPDATE film
SET release_year = 2020
WHERE rating = 'NC-17';


UPDATE rental SET return_date = NOW()
WHERE rental_id = (
  SELECT rental_id FROM (
    SELECT rental_id
    FROM rental
    WHERE return_date IS NULL
    ORDER BY rental_date DESC
    LIMIT 1
  ) AS sub
);



DELETE FROM payment
WHERE rental_id IN (
  SELECT rental_id
  FROM rental
  WHERE inventory_id IN (
    SELECT inventory_id
    FROM inventory
    WHERE film_id = (SELECT film_id FROM film WHERE title = 'ACA_VA_EL_TITULO')
  )
);

DELETE FROM rental
WHERE inventory_id IN (
  SELECT inventory_id
  FROM inventory
  WHERE film_id = (SELECT film_id FROM film WHERE title = 'ACA_VA_EL_TITULO')
);

DELETE FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'ACA_VA_EL_TITULO');

DELETE FROM film_actor
WHERE film_id = (SELECT film_id FROM film WHERE title = 'ACA_VA_EL_TITULO');

DELETE FROM film_category
WHERE film_id = (SELECT film_id FROM film WHERE title = 'ACA_VA_EL_TITULO');

DELETE FROM film
WHERE title = 'ACA_VA_EL_TITULO';

SELECT inventory_id FROM inventory
WHERE inventory_id NOT IN (
  SELECT inventory_id FROM rental
  WHERE return_date IS NULL
)
LIMIT 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
  NOW(),
  4567,
  (SELECT customer_id FROM customer LIMIT 1),
  (SELECT staff_id FROM staff LIMIT 1)
);

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
  (SELECT customer_id FROM customer LIMIT 1),
  (SELECT staff_id FROM staff LIMIT 1),
  (SELECT rental_id FROM rental ORDER BY rental_id DESC LIMIT 1),
  4.99,
  NOW()
);
