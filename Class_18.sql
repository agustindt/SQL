#1 

DELIMITER $

CREATE FUNCTION get_amount(f_id INT, st_id INT) RETURNS 
INT DETERMINISTIC 
BEGIN 
	DECLARE cant INT;
	SELECT
	    COUNT(i.inventory_id) INTO cant
	FROM film f
	    INNER JOIN inventory i USING(film_id)
	    INNER JOIN store st USING(store_id)
	WHERE
	    f.film_id = f_id
	    AND st.store_id = st_id;
	RETURN (cant);
	END E 
END END $ 

DELIMITER ;

SELECT get_amount(1,1);

#2(no usar ws usar cursor) 
DELIMITER $

DROP PROCEDURE IF EXISTS list_procedure $

CREATE PROCEDURE list_procedure(
	IN co_name VARCHAR(250), 
	OUT list VARCHAR(500)
	) 
BEGIN 
	DECLARE finished INT DEFAULT 0;
	DECLARE f_name VARCHAR(250) DEFAULT ''; 
	DECLARE l_name VARCHAR(250) DEFAULT '';
	DECLARE coun VARCHAR(250) DEFAULT '';

	DECLARE cursList CURSOR FOR
	SELECT
	    co.country,
	    c.first_name,
	    c.last_name
	FROM customer c
	    INNER JOIN address USING(address_id)
	    INNER JOIN city USING(city_id)
	    INNER JOIN country co USING(country_id);
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	OPEN cursList;

	looplabel: LOOP
		FETCH cursList INTO coun, f_name, l_name;
		IF finished = 1 THEN
			LEAVE looplabel;
		END IF;

		IF coun = co_name THEN
			SET list = CONCAT(f_name,';',l_name);
		END IF;
		
		
	END LOOP looplabel;
	CLOSE cursList;
	

END $
DELIMITER ;


set @list = '';

CALL list_procedure('Argentina',@list);

SELECT @list;

SELECT
    CONCAT_WS(';', c.first_name, c.last_name)
FROM customer c
    INNER JOIN address ad USING(address_id)
    INNER JOIN city ci USING(city_id)
    INNER JOIN country co USING(country_id)
WHERE co.country = 'Argentina';

#------------------------------------------------------------------
DELIMITER $
DROP PROCEDURE IF EXISTS list_procedure $

CREATE PROCEDURE list_procedure(IN co_name VARCHAR(250))
BEGIN
	DECLARE f_name VARCHAR(250);
	DECLARE l_name VARCHAR(250);
	DECLARE finished BOOLEAN DEFAULT FALSE;

	DECLARE cursList CURSOR FOR
	SELECT
	    c.first_name,
	    c.last_name
	FROM customer c
	    INNER JOIN address USING(address_id)
	    INNER JOIN city USING(city_id)
	    INNER JOIN country co USING(country_id) WHERE co.country = co_name;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;

	DROP TEMPORARY TABLE IF EXISTS tempTable;

	CREATE TEMPORARY TABLE tempTable(first_name VARCHAR(250), last_name VARCHAR(250));


	OPEN cursList;

	looplabel: LOOP
	FETCH cursList INTO f_name,l_name;

	IF finished = TRUE THEN
		LEAVE looplabel;
	END IF;

	INSERT INTO tempTable(first_name,last_name) VALUES (f_name, l_name);

	END LOOP looplabel;	

	CLOSE cursList;

	SELECT CONCAT(first_name,';',last_name) FROM tempTable;
END $

CALL list_procedure('Argentina') $
DELIMITER ;

#3
SELECT inventory_in_stock(1);  
SHOW CREATE FUNCTION inventory_in_stock;
/*
CREATE FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;
    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;
    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;
    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;
    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END
it returns 0 or 1 depending on whether there is stock of a film, or not. 
1 representing the availability of a film and 0 the opposite.
*/

CALL film_in_stock(2,2,@a);
SELECT @a;
SHOW CREATE PROCEDURE film_in_stock;
/*
CREATE PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);
     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END
it selects the inventory_ids of a film in stock, using two IN parameters for the film_id and store_id.
It also counts how many there are and returns it with an OUT parameter. 
*/
