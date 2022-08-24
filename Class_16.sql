CREATE TABLE
    `employees` (
        `employeeNumber` int(11) NOT NULL,
        `lastName` varchar(50) NOT NULL,
        `firstName` varchar(50) NOT NULL,
        `extension` varchar(10) NOT NULL,
        `email` varchar(100) NOT NULL,
        `officeCode` varchar(10) NOT NULL,
        `reportsTo` int(11) DEFAULT NULL,
        `jobTitle` varchar(50) NOT NULL,
        PRIMARY KEY (`employeeNumber`)
    );

insert into
    `employees`(
        `employeeNumber`,
        `lastName`,
        `firstName`,
        `extension`,
        `email`,
        `officeCode`,
        `reportsTo`,
        `jobTitle`
    )
values (
        1002,
        'Murphy',
        'Diane',
        'x5800',
        'dmurphy@classicmodelcars.com',
        '1',
        NULL,
        'President'
    ), (
        1056,
        'Patterson',
        'Mary',
        'x4611',
        'mpatterso@classicmodelcars.com',
        '1',
        1002,
        'VP Sales'
    ), (
        1076,
        'Firrelli',
        'Jeff',
        'x9273',
        'jfirrelli@classicmodelcars.com',
        '1',
        1002,
        'VP Marketing'
    );

CREATE TABLE
    employees_audit (
        id INT AUTO_INCREMENT PRIMARY KEY,
        employeeNumber INT NOT NULL,
        lastname VARCHAR(50) NOT NULL,
        changedat DATETIME DEFAULT NULL,
        action VARCHAR(50) DEFAULT NULL
    );

INSERT INTO
    employees(
        employeeNumber,
        lastName,
        firstName,
        extension,
        email,
        officecode,
        reportsTo,
        jobTitle
    )
VALUES (
        1,
        'Carbel',
        'Matias',
        'a',
        NULL,
        '1',
        1002,
        'Worker'
    );

/*Column 'email' cannot be null. esto es debido a la constraint que tiene el campo email
 la cual no lo deja ser null*/

/*
 *2 DONE
 */

UPDATE employees SET employeeNumber = employeeNumber - 20;

#se le resto 20 a los employeeNumber de todos los employee
UPDATE employees
SET
    employeeNumber = employeeNumber + 20;

#Duplicate entry '1056' for key 'PRIMARY'. no sucede nada ya que si se sumaran 20
#habria 2 primary keys exactas por un momento
SELECT *
FROM employees;

/*
 *3 DONE
 */

ALTER TABLE employees ADD age int CHECK(
        age >= 16
        AND age <= 70
    );

ALTER TABLE employees DROP age;


INSERT INTO
    employees(
        employeeNumber,
        lastName,
        firstName,
        extension,
        email,
        officecode,
        reportsTo,
        jobTitle,
        age
    )
VALUES (
        2,
        'Pedro',
        'Sanchez',
        'b',
        'pedroGmail',
        '1',
        1002,
        'Worker',
        1
    );


DELETE FROM employees WHERE employeeNumber = 2;


/*
 *4
Referential Integrity is a set of constraints applied to foreign keys which prevents entering a row in the child table 
for which you don't have any corresponding row in the parent table. It prevents having incorrect or incomplete relationships.
for example in the table film_actor you shouldnt be able to enter a film_id that doesnt exist in the table film. The same with the actor_id.
https://javarevisited.blogspot.com/2012/12/what-is-referential-integrity-in-database-sql-mysql-example-tutorial.html
*/


/*
*5
*/
ALTER TABLE employees ADD COLUMN lastUpdate TIMESTAMP;
ALTER TABLE employees ADD COLUMN lastUpdateUser VARCHAR(255);

DELIMITER $$
CREATE Trigger before_employee_update BEFORE UPDATE ON employees FOR EACH ROW
BEGIN
SET NEW.lastUpdate = CURRENT_TIMESTAMP;
SET NEW.lastUpdateUser = CURRENT_USER;
END$$
DELIMITER;

UPDATE employees SET age = 15 WHERE employeeNumber = 2;


/*
*6
*/
SHOW TRIGGERS FROM sakila;

/* ins_film after a film is inserted this trigger inserts the film_id,title and description to film_text */
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END

/* upd_film updates the title, description and film_id of film_text whenever an update, that changes either title, description or film_id of a film, is made */
BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END

  /* del_film deletes the film_text of the erased film*/
  BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END
