DROP DATABASE IF EXISTS imdb;
CREATE DATABASE IF NOT EXISTS imdb;

USE imdb;

DROP TABLE IF EXISTS film;
DROP TABLE IF EXISTS actor;
DROP TABLE IF EXISTS film_actor;

CREATE TABLE IF NOT EXISTS film (
    film_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS actor (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS film_actor (
    actor_id INT,
    film_id INT,
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON DELETE CASCADE,
    FOREIGN KEY (film_id) REFERENCES film(film_id) ON DELETE CASCADE
);


INSERT INTO actor (first_name, last_name) VALUES ('Leonardo', 'DiCaprio');
INSERT INTO actor (first_name, last_name) VALUES ('Robert', 'Downey Jr.');
INSERT INTO actor (first_name, last_name) VALUES ('Scarlett', 'Johansson');


INSERT INTO film (title, description, release_year) VALUES ('Inception', 'Un ladrón que entra en los sueños de la gente.', 2010);
INSERT INTO film (title, description, release_year) VALUES ('Iron Man', 'Un millonario construye un traje de alta tecnología.', 2008);
INSERT INTO film (title, description, release_year) VALUES ('Avengers', 'Un grupo de héroes se une para salvar el mundo.', 2012);


INSERT INTO film_actor (actor_id, film_id) VALUES (1, 1); 
INSERT INTO film_actor (actor_id, film_id) VALUES (2, 2); 
INSERT INTO film_actor (actor_id, film_id) VALUES (2, 3); 
INSERT INTO film_actor (actor_id, film_id) VALUES (3, 3); 

SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM film_actor;