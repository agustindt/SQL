CREATE OR REPLACE VIEW list_of_customers AS
  SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name), a.address, a.postal_code, a.phone, c2.city, c3.country,
  	CASE
  		WHEN c.active = 1 THEN 'active'
  		ELSE 'inactive'
  	END AS status
  FROM customer c
  	INNER JOIN address a USING(address_id)
  	INNER JOIN city c2 USING(city_id)
  	INNER JOIN country c3 USING(country_id);
    
#------#
  
CREATE OR REPLACE VIEW film_details AS
	SELECT f.film_id, f.title, f.description, f.rental_rate, f.`length`, f.rating, GROUP_CONCAT(CONCAT_WS(" ", a.first_name, a.last_name) SEPARATOR ",") AS actors 
	FROM film f 
		INNER JOIN film_category fc USING(film_id)
		INNER JOIN category c USING(category_id)
		INNER JOIN film_actor fa USING(film_id)
		INNER JOIN actor a USING(actor_id)
	GROUP BY film_id;

#------#

CREATE OR REPLACE VIEW sales_by_films_category AS
	SELECT DISTINCT c.name, SUM(p.amount) as total_rental
	FROM category c
		INNER JOIN film_category fc USING(category_id)
		INNER JOIN film f USING(film_id)
		INNER JOIN inventory i USING(film_id)
		INNER JOIN rental r USING(inventory_id)
		INNER JOIN payment p USING(rental_id)
	GROUP BY c.name;

#------#

CREATE OR REPLACE VIEW actor_information AS
	SELECT a.actor_id, CONCAT_WS(" ", a.first_name, a.last_name) AS 'full name',
	(SELECT COUNT(f.film_id)
		FROM film f
			INNER JOIN film_actor fa USING(film_id)
			INNER JOIN actor a2 USING(actor_id)
		WHERE a2.actor_id = a.actor_id) AS 'amount of films he/she acted on'
	FROM actor a;

SELECT * FROM actor_info ai;


/*
5. Analyze view actor_info, explain the entire query and specially how the sub query works.
Be very specific, take some time and decompose each part and give an explanation for each.
	
ALGORITHM = UNDEFINED crea la view, haciendo que MySQL elija entre MERGE y TEMPTABLE, viendose afectado asi el procesamiento de la view.
El SELECT trae id y el nombre del actor, mostrando en la cuarta columna todas las peliculas donde este actuó agrupadas por categoría. 
Luego hay un FROM y los JOINS necesarios, además de GOROUP BY que agrupa por actor.
*/

/*
6. Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.
Materialized view sirve para ver los resultados de una query, diferenciandose por ser tablas que almacenan los resultados de una query.
Son usados para una mejor performance en una variedad de sistemas de manejo de bases de datos, pero no en MySQL por lo que una 
alternativa seria usar triggers o stored procedures.
*/
