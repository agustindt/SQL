CREATE INDEX addressIndex ON address(postal_code);

SELECT *									#BEFORE INDEX  0,015
FROM address								#AFTER INDEX   0,000
WHERE postal_code between 5000 and 70000
AND district LIKE 'California';

SELECT a.address as 'Direccion', 			#BEFORE INDEX 0,016
	a.postal_code as 'Codigo Postal', 		#AFTER INDEX  0,000
    a.district as 'Distrito',
	a.phone as 'Telefono', 	
	ci.city as 'Ciudad', 
	co.country as 'Pais'
FROM address a
	INNER JOIN city ci USING(city_id)
	INNER JOIN country co USING(country_id)
WHERE a.postal_code IN(
	SELECT postal_code
    FROM address
    WHERE district LIKE '%c'
    AND postal_code IN(
		SELECT postal_code
        FROM address
        WHERE postal_code BETWEEN 10000 and 70000
		)
	)
ORDER BY a.postal_code ASC
;

DROP INDEX addressIndex ON address;

#After we run the querys with the INDEX we can see that runs faster and for mysql it is easiest

#Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?

SELECT first_name
FROM actor;

SELECT last_name
FROM actor;

SHOW INDEX FROM actor;
#When we run the first query the time is 0,015 and the second query it is 0,000 this happend because in the table actor it exist an INDEX for the last_name column

#Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.

SELECT description						# 0,046 This is the slowest way to find a description because of the LIKE, this happends because the LIKE analize all the table and then it extract.
FROM film
WHERE description like '%Action%';

CREATE FULLTEXT INDEX film_description_index		#Here we create the FULLTEXT INDEX
ON film(description);

SELECT description									#0,016 This is the fastest way 
FROM film
WHERE MATCH(description) AGAINST('%Action%' IN NATURAL LANGUAGE MODE);
