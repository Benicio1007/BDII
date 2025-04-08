

SELECT first_name, last_name FROM actor a1
 WHERE EXISTS (
       SELECT 1
         FROM actor a2
        WHERE a1.last_name = a2.last_name
          AND a1.actor_id <> a2.actor_id
 )
 ORDER BY last_name, first_name;
 
 SELECT first_name, last_name FROM actor
 WHERE actor_id NOT IN (
       SELECT DISTINCT actor_id
         FROM film_actor
 );


SELECT first_name, last_name FROM customer
 WHERE customer_id IN (
       SELECT customer_id
         FROM rental
     GROUP BY customer_id
       HAVING COUNT(*) = 1
 );

SELECT first_name, last_name FROM customer
 WHERE customer_id IN (
       SELECT customer_id
         FROM rental
     GROUP BY customer_id
       HAVING COUNT(*) > 1
 );

SELECT first_name, last_name FROM actor
 WHERE actor_id IN (
       SELECT actor_id
         FROM film_actor
        WHERE film_id IN (
              SELECT film_id
                FROM film
               WHERE title IN ('BETRAYED REAR', 'CATCH AMISTAD')
        )
 );


SELECT first_name, last_name FROM actor
 WHERE actor_id IN (
       SELECT actor_id
         FROM film_actor
        WHERE film_id = (
              SELECT film_id
                FROM film
               WHERE title = 'BETRAYED REAR'
        )
 )
   AND actor_id NOT IN (
       SELECT actor_id
         FROM film_actor
        WHERE film_id = (
              SELECT film_id
                FROM film
               WHERE title = 'CATCH AMISTAD'
        )
 );


SELECT first_name, last_name FROM actor
 WHERE actor_id IN (
       SELECT actor_id
         FROM film_actor
        WHERE film_id = (
              SELECT film_id
                FROM film
               WHERE title = 'BETRAYED REAR'
        )
 )
   AND actor_id IN (
       SELECT actor_id
         FROM film_actor
        WHERE film_id = (
              SELECT film_id
                FROM film
               WHERE title = 'CATCH AMISTAD'
        )
 );


SELECT first_name, last_name FROM actor
 WHERE actor_id NOT IN (
       SELECT actor_id
         FROM film_actor
        WHERE film_id IN (
              SELECT film_id
                FROM film
               WHERE title IN ('BETRAYED REAR', 'CATCH AMISTAD')
        )
 );
