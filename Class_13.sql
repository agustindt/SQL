INSERT INTO
    customer (
        store_id,
        first_name,
        last_name,
        email,
        address_id,
        active
    )
SELECT
    1,
    'Agustin',
    'Di Tomaso',
    agustindt95l@gmail.com',
    MAX(ad.address_id),
    1
FROM address ad
WHERE ad.city_id IN (
        SELECT ci.city_id
        FROM
            country co,
            city ci
        WHERE
            co.country = "United States"
            AND co.country_id = ci.country_id
            AND ci.city_id = ad.city_id
    );

SELECT * FROM customer WHERE last_name = "Carbel";

#Add a rental
#Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
#Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
#Select any staff_id from Store 2.
INSERT INTO
    rental (
        rental_date,
        inventory_id,
        customer_id,
        return_date,
        staff_id
    )
SELECT CURRENT_TIMESTAMP, (
        SELECT
            MAX(i.inventory_id)
        FROM inventory i
            INNER JOIN film f USING(film_id)
        WHERE
            f.title LIKE 'ACE GOLDFINGER'
    ),
    600,
    NULL, (
        SELECT
            manager_staff_id
        FROM store
        WHERE store_id = 2
        ORDER BY RAND()
        LIMIT 1
    );

SELECT * FROM rental WHERE customer_id = 600;

#Update film year based on the rating
#For example if rating is 'G' release date will be '2001'
#You can choose the mapping between rating and year.
#Write as many statements are needed.
SELECT DISTINCT rating
FROM film;

UPDATE film SET release_year = 2000 WHERE rating = 'PG';

UPDATE film SET release_year = 2001 WHERE rating ='G';

UPDATE film SET release_year = 2002 WHERE rating ='NC-17';

UPDATE film SET release_year = 2003 WHERE rating ='PG-13';

UPDATE film SET release_year = 2004 WHERE rating = 'R';

SELECT * FROM film WHERE rating = 'PG';

#Return a film
#Write the necessary statements and queries for the following steps.
#Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
#Use the id to return the film.
SELECT r.rental_id
FROM film f
    INNER JOIN inventory i USING(film_id)
    INNER JOIN rental r USING(inventory_id)
WHERE r.return_date IS NULL
ORDER BY r.rental_date DESC
LIMIT 1;

UPDATE rental
SET
    return_date = CURRENT_TIMESTAMP
WHERE rental_id = 16050;

#Try to delete a film
#Check what happens, describe what to do.
#Write all the necessary delete statements to entirely remove the film from the DB.
SELECT *
FROM film
ORDER BY film_id DESC
LIMIT 1;

DELETE FROM film WHERE title = 'ZORRO ARK';

#Resultado
#Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`,
#CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`)
#ON UPDATE CASCADE)
#La solucion para esto es borrar primero(en order de hijo a padre) las row a las que la pelicula esta relacionada.
#Tambien se puede desactivar FOREIGN KEY CHECK y luego volver a activarlo, pero esto no es recomendable
DELETE FROM payment
WHERE rental_id IN (
        SELECT rental_id
        FROM rental
            INNER JOIN inventory USING(inventory_id)
        WHERE film_id = 1000
    );

DELETE FROM rental
WHERE inventory_id IN (
        SELECT inventory_id
        FROM inventory
        WHERE film_id = 1000
    );

DELETE FROM inventory WHERE film_id = 1000;

DELETE FROM film_actor WHERE film_id = 1000;

DELETE FROM film_category WHERE film_id = 1000;

DELETE FROM film WHERE title = 'ZORRO ARK';

#6
SELECT inventory_id, film_id
FROM inventory
WHERE inventory_id NOT IN (
        SELECT inventory_id
        FROM inventory
            INNER JOIN rental USING (inventory_id)
        WHERE
            return_date IS NULL
    );

#(no funciona porque si no tiene rental aparece lo mismo ej: inventory_id 5)
SELECT *
FROM inventory i
    LEFT JOIN rental r USING(inventory_id)
WHERE r.return_date IS NULL;

#inventory_id 1 film_id 1
INSERT INTO
    rental (
        rental_date,
        inventory_id,
        customer_id,
        return_date,
        staff_id
    )
VALUES(
        CURRENT_TIMESTAMP, 10, (
            SELECT
                customer_id
            FROM customer
            ORDER BY RAND()
            LIMIT 1
        ), NULL, (
            SELECT staff_id
            FROM staff
            WHERE store_id IN(
                    SELECT
                        store_id
                    FROM
                        inventory
                    WHERE
                        inventory_id = 1
                )
        )
    );

INSERT INTO
    payment (
        customer_id,
        staff_id,
        rental_id,
        amount,
        payment_date
    )
VALUES( (#customer_id
            SELECT
                customer_id
            FROM rental r
            ORDER BY
                rental_date DESC
            LIMIT 1
        ), (#staff_id
            SELECT staff_id
            FROM rental r
            ORDER BY
                rental_date DESC
            LIMIT 1
        ), (#rental_id
            SELECT rental_id
            FROM rental r
            ORDER BY
                rental_date DESC
            LIMIT 1
        ), 10, CURRENT_TIMESTAMP
    );

SELECT * FROM payment ORDER BY payment_date DESC LIMIT 1;

/*
SELECT staff_id, customer_id, rental_id
FROM rental r
ORDER BY rental_date DESC
LIMIT 1;
*/
