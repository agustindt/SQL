#--- 1 ---#
SELECT title, rating FROM film f
WHERE length <= ALL(SELECT length FROM film);

#-- 2 --#
SELECT title FROM film
WHERE 1=(SELECT COUNT(*) FROM film
WHERE length <= ALL(SELECT length FROM film));

#-- 3 --# 
SELECT ALL c.customer_id,c.first_name,c.last_name,a.address, (SELECT MIN(amount) FROM payment p
WHERE c.customer_id = p.customer_id) AS lowest_payment
FROM customer c JOIN address a ON c.address_id = a.address_id;

#-- 4 --#
SELECT first_name, last_name,
(SELECT CONCAT(MIN(amount), ' / ', MAX(amount)) FROM payment p
WHERE customer.customer_id = p.customer_id) AS min_max_amount FROM customer
