/*1 Write a query that gets all the customers that live in Argentina. 
 Show the first and last name in one column, the address and the city.
 */

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS 'Nombre',
    ad.address,
    ci.city
FROM customer c
    INNER JOIN store sto USING(store_id)
    INNER JOIN address ad ON sto.address_id = ad.address_id
    INNER JOIN city ci USING(city_id)
    INNER JOIN country co USING(country_id)
WHERE co.country = 'Argentina';

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS 'Nombre',
    ad.address ci.city
FROM customer c
    INNER JOIN address ad USING(address_id)
    INNER JOIN city ci USING(city_id)
    INNER JOIN country co USING(country_id)
WHERE co.country = 'Argentina';

/*2 Write a query that shows the film title, language and rating. 
 Rating shall be shown as the full text described here*/

SELECT
    f.title,
    l.name,
    f.rating,
    CASE
        WHEN f.rating LIKE 'G' THEN 'All ages admitted'
        WHEN f.rating LIKE 'PG' THEN 'Some material may not be suitable for children'
        WHEN f.rating LIKE 'PG-13' THEN 'Some material may be inappropriate for children under 13'
        WHEN f.rating LIKE 'R' THEN 'Under 17 requires accompanying parent or adult guardian'
        WHEN f.rating LIKE 'NC-17' THEN 'No one 17 and under admitted'
    END 'Rating Text'
FROM film f
    INNER JOIN language l USING(language_id);

/*3 Write a search query that shows all the films (title and release year) an actor was part of.
 Assume the actor comes from a text box introduced by hand from a web page.
 Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.
 */

SELECT
    ac.actor_id,
    CONCAT(
        ac.first_name,
        ' ',
        ac.last_name
    ),
    f.film_id,
    f.title
FROM film f
    INNER JOIN film_actor USING(film_id)
    INNER JOIN actor ac USING(actor_id)
WHERE
    CONCAT(first_name, ' ', last_name) LIKE TRIM(UPPER('PENELOPE GUINESS'));

/*4Find all the rentals done in the months of May and June.
 Show the film title, customer name and if it was returned or not.
 There should be returned column with two possible values 'Yes' and 'No'.
 */

SELECT
    f.title,
    r.rental_date,
    c.first_name,
    CASE
        WHEN r.return_date IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END 'Returned'
FROM rental r
    INNER JOIN inventory i USING(inventory_id)
    INNER JOIN film f USING(film_id)
    INNER JOIN customer c USING(customer_id)
WHERE
    MONTH(r.rental_date) = '05'
    OR MONTH(r.rental_date) = '06'
ORDER BY r.rental_date;

/*5Investigate CAST and CONVERT functions.
 Explain the differences if any, write examples based on sakila DB.
 Cast Function: converts a value of any type into the specified datatype.
 Syntax: CAST(value AS datatype)
 Convert Fnction: converts a value into the specified datatype or character set.
 Syntax: CONVERT(value, type) OR CONVERT(value USING charset)
 Differences:
 Apart from their syntax, Convert and Cast functions have some differences:
-CONVERT can be used to convert data between character sets. Ej: CONVERT(title USING latin1)
-CAST is part of the ANSI-SQL specification(runs in all modern vendor databases).
 Whereas, CONVERT is not.CONVERT is SQL implementation-specific.
https://sqlandplsql.com/2011/11/20/what-is-ansi-sql/
Types that can be used:
DATE	Converts value to DATE. Format: "YYYY-MM-DD"
DATETIME	Converts value to DATETIME. Format: "YYYY-MM-DD HH:MM:SS"
DECIMAL	Converts value to DECIMAL. Use the optional M and D parameters to specify the maximum number of digits (M) and the number of digits following the decimal point (D).
TIME	Converts value to TIME. Format: "HH:MM:SS"
CHAR	Converts value to CHAR (a fixed length string)
NCHAR	Converts value to NCHAR (like CHAR, but produces a string with the national character set)
SIGNED	Converts value to SIGNED (a signed 64-bit integer)
UNSIGNED	Converts value to UNSIGNED (an unsigned 64-bit integer)
BINARY
*/

/*6 Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function.
 Explain what they do. Which ones are not in MySql and write usage examples.
IFNULL(): lets you return an alternative value if the expression is null
SELECT ProductName, UnitPrice * (UnitsInStock + IFNULL(UnitsOnOrder, 0))
FROM Products; 
(supported by mysql)
COALESCE: returns the first non-NULL argument. In case all arguments are NULL,
returns NULL:
SELECT COALESCE(NULL, 0);  -- 0
SELECT COALESCE(NULL, NULL); -- NULL
(supported by mysql)
ISNULL() function lets you return an alternative value when an expression is NULL:
SELECT ProductName, UnitPrice * (UnitsInStock + ISNULL(UnitsOnOrder, 0))
FROM Products;
(supported by sqlserver)
IsNull() function returns TRUE (-1) if the expression is a null value, otherwise FALSE (0):
SELECT ProductName, UnitPrice * (UnitsInStock + IIF(IsNull(UnitsOnOrder), 0, UnitsOnOrder))
FROM Products;
(supported by MS Access)
NVL() function achieves the same result:
SELECT ProductName, UnitPrice * (UnitsInStock + NVL(UnitsOnOrder, 0))
FROM Products;
 (supported by oracle)
*/
