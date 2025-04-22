
SELECT title, rating FROM film
 WHERE length = (SELECT MIN(length) FROM film);



SELECT title FROM film 
 WHERE length = (SELECT MIN(length) FROM film)
   AND (SELECT COUNT(*) FROM film 
         WHERE length = (SELECT MIN(length) FROM film)) = 1;



SELECT c.customer_id, c.first_name, c.last_name, a.address, MIN(p.amount) AS min_payment FROM customer c
  JOIN address a ON c.address_id = a.address_id
  JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address;



SELECT c.customer_id, c.first_name, c.last_name, a.address, p.amount AS min_payment FROM customer c
  JOIN address a ON c.address_id = a.address_id
  JOIN payment p ON c.customer_id = p.customer_id
 WHERE p.amount <= ALL (
           SELECT amount FROM payment 
            WHERE customer_id = c.customer_id)
ORDER BY c.customer_id;



SELECT c.customer_id, c.first_name, c.last_name, a.address,
       (SELECT MAX(amount) FROM payment p 
         WHERE p.customer_id = c.customer_id) AS highest_payment,
       (SELECT MIN(amount) FROM payment p 
         WHERE p.customer_id = c.customer_id) AS lowest_payment
  FROM customer c
  JOIN address a ON c.address_id = a.address_id
ORDER BY highest_payment DESC;
