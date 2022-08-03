#Agustin Di Tomaso 
#Clase 11 


#Find all the film titles that are not in the inventory.
SELECT *
FROM film f
    LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.film_id IS NULL;

#Find all the films that are in the inventory but were never rented.Show title and inventory_id.
SELECT *
FROM film f
    INNER JOIN inventory i ON f.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.inventory_id IS NULL;

#Generate a report with: customer (first, last) name, store id, film title, when the film was rented and returned for each of these customers order by store_id, customer last_name

SELECT
    r.rental_id,
    r.rental_date,
    r.return_date,
    i.film_id,
    f.title,
    CONCAT(c.first_name, ' ', c.last_name) AS 'Nombre',
    c.store_id
FROM rental r
    INNER JOIN customer c ON r.customer_id = c.customer_id
    INNER JOIN inventory i ON r.inventory_id = i.inventory_id
    INNER JOIN film f ON i.film_id = f.film_id
ORDER BY
    c.store_id,
    c.last_name;
    
#Which actor has appeared in the most films?
SELECT
    ac.actor_id,
    ac.first_name,
    ac.last_name,
    COUNT(film_id) as film_count
FROM actor ac
    INNER JOIN film_actor USING (actor_id)
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;


#Show sales per store (money of rented films),show store's city, country, manager info and total sales (money),(optional) Use concat to show city and country and manager first and last name
SELECT
    sto.store_id,
    CONCAT(
        sta.first_name,
        ' ',
        sta.last_name
    ) AS 'Nombre',
    COUNT(pay.payment_id) AS 'cantidad ventas',
    SUM(pay.amount) AS 'dinero ventas',
    CONCAT(co.country, ', ', ci.city) AS 'pais y ciudad'
FROM store sto
    INNER JOIN staff sta ON sto.manager_staff_id = sta.staff_id
    INNER JOIN payment pay ON sta.staff_id = pay.staff_id
    INNER JOIN address adr ON sto.address_id = adr.address_id
    INNER JOIN city ci ON adr.city_id = ci.city_id
    INNER JOIN country co ON ci.country_id = co.country_id
GROUP BY sto.store_id;

