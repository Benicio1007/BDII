-- 
-- 0) CREAR TABLA EMPLOYEES
-- 
drop table if exists employees;

create table employees (
  employeeNumber int not null primary key,
  firstName varchar(50) not null,
  lastName varchar(50) not null,
  email varchar(100) default null
) engine=innodb;

-- 
-- INSERTAR DATOS DE EJEMPLO
-- 
insert into employees (employeeNumber, firstName, lastName, email) values
(1,'juan','perez','juan.p@example.com'),
(2,'ana','gomez','ana.g@example.com'),
(3,'luis','lopez','luis.l@example.com'),
(4,'marta','diaz','marta.d@example.com');

SELECT * FROM employees;

-- 
-- 1) INSERTAR EMPLEADO CON EMAIL NULL
-- 
insert into employees (employeeNumber, firstName, lastName, email)
values (5,'diego','sosa', null);

SELECT * FROM employees;
-- explicación: como email permite NULL, la fila se inserta bien.

--
-- 2) UPDATES SOBRE employeeNumber
-- 
update employees set employeeNumber = employeeNumber - 20;
SELECT * FROM employees order by employeeNumber;

update employees set employeeNumber = employeeNumber + 20;
SELECT * FROM employees order by employeeNumber;
-- explicación: se restan y luego se suman 20, volviendo a los valores originales.
-- puede fallar si hubiera claves duplicadas o FKs apuntando sin CASCADE.

--
-- 3) AGREGAR COLUMNA AGE CON CHECK (16..70)
--
alter table employees
  add column age tinyint unsigned default null,
  add constraint chk_age check (age between 16 and 70);

-- para versiones viejas de MySQL, si el CHECK no se cumple,
-- hay que crear triggers (los dejo igual por compatibilidad)

delimiter $$
create trigger trg_employees_age_before_insert
before insert on employees
for each row
begin
  if new.age is not null and (new.age < 16 or new.age > 70) then
    signal sqlstate '45000' set message_text = 'age must be between 16 and 70';
  end if;
end$$

create trigger trg_employees_age_before_update
before update on employees
for each row
begin
  if new.age is not null and (new.age < 16 or new.age > 70) then
    signal sqlstate '45000' set message_text = 'age must be between 16 and 70';
  end if;
end$$
delimiter ;

--
-- 4) REFERENCIALIDAD FILM/ACTOR/FILM_ACTOR (solo explicación)
-- 
-- En la DB sakila:
-- - film_actor(actor_id, film_id) PK compuesta
-- - fk_film_actor_actor foreign key (actor_id) references actor(actor_id) on delete restrict on update cascade
-- - fk_film_actor_film foreign key (film_id) references film(film_id) on delete restrict on update cascade
-- Eso asegura integridad many-to-many entre films y actores.

-- 
-- 5) AGREGAR LASTUPDATE Y LASTUPDATEUSER + TRIGGERS
--
alter table employees
  add column lastUpdate datetime null,
  add column lastUpdateUser varchar(100) null;

delimiter $$
create trigger trg_employees_lastupdate_before_insert
before insert on employees
for each row
begin
  set new.lastUpdate = now();
  set new.lastUpdateUser = substring_index(current_user(),'@',1);
end$$

create trigger trg_employees_lastupdate_before_update
before update on employees
for each row
begin
  set new.lastUpdate = now();
  set new.lastUpdateUser = substring_index(current_user(),'@',1);
end$$
delimiter ;

-- 
-- 6) TRIGGERS EN SAKILA PARA film_text
-- 
-- Estos triggers ya existen en sakila:
-- ins_film  -> copia nuevos films a film_text
-- upd_film  -> actualiza film_text cuando cambia film
-- del_film  -> borra en film_text cuando se borra film
-- Se pueden ver con:
-- SELECT TRIGGER_NAME, EVENT_MANIPULATION, ACTION_STATEMENT
-- FROM information_schema.triggers
-- WHERE trigger_schema='sakila' AND action_statement LIKE '%film_text%';

-- ejemplo del código original de sakila:

-- CREATE TRIGGER ins_film AFTER INSERT ON film FOR EACH ROW
--   INSERT INTO film_text (film_id,title,description)
--   VALUES (new.film_id,new.title,new.description);

-- CREATE TRIGGER upd_film AFTER UPDATE ON film FOR EACH ROW
--   IF old.title!=new.title OR old.description!=new.description OR old.film_id!=new.film_id THEN
--     UPDATE film_text
--     SET title=new.title, description=new.description, film_id=new.film_id
--     WHERE film_id=old.film_id;
--   END IF;

-- CREATE TRIGGER del_film AFTER DELETE ON film FOR EACH ROW
--   DELETE FROM film_text WHERE film_id=old.film_id;
