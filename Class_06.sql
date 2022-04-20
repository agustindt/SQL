#--1--#
SELECT 
  a1.* 
FROM 
  actor a1 
WHERE 
  EXISTS (
    SELECT 
      * 
    FROM 
      actor a2 
    WHERE 
      a2.last_name = a1.last_name 
      AND a2.actor_id <> a1.actor_id
  ) 
ORDER BY 
  a1.last_name;
#--2--#
SELECT 
  first_name, 
  last_name 
FROM 
  actor a 
WHERE 
  NOT EXISTS(
    SELECT 
      first_name, 
      last_name 
    FROM 
      film_actor fa 
    WHERE 
      a.actor_id = fa.actor_id
  );
#--3--#
SELECT 
  first_name, 
  last_name 
FROM 
  customer c 
WHERE 
  1 =(
    SELECT 
      COUNT(*) 
    FROM 
      rental r 
    WHERE 
      c.customer_id = r.customer_id
  );
#--4--#
SELECT 
  first_name, 
  last_name 
FROM 
  customer c 
WHERE 
  1 <(
    SELECT 
      COUNT(*) 
    FROM 
      rental r 
    WHERE 
      c.customer_id = r.customer_id
  );
#--5--#
SELECT 
  first_name, 
  last_name 
FROM 
  actor 
WHERE 
  actor_id IN(
    SELECT 
      actor_id 
    FROM 
      film_actor 
    WHERE 
      film_id IN(
        SELECT 
          film_id 
        FROM 
          film 
        WHERE 
          title LIKE 'BETRAYED REAR' 
          OR title LIKE 'CATCH AMISTAD'
      )
  );
#--6--#
SELECT 
  first_name, 
  last_name 
FROM 
  actor 
WHERE 
  actor_id IN(
    SELECT 
      actor_id 
    FROM 
      film_actor 
    WHERE 
      film_id IN(
        SELECT 
          film_id 
        FROM 
          film 
        WHERE 
          title LIKE 'BETRAYED REAR'
      ) 
      AND film_id NOT IN(
        SELECT 
          film_id 
        FROM 
          film 
        WHERE 
          title LIKE 'CATCH AMISTAD'
      )
  );
#--7--#
SELECT 
  last_name, 
  first_name 
FROM 
  actor 
WHERE 
  actor_id IN (
    SELECT 
      actor_id 
    FROM 
      film_actor 
    WHERE 
      film_id in (
        SELECT 
          film_id 
        FROM 
          film 
        WHERE 
          title LIKE 'BETRAYED REAR'
      )
  ) 
  AND actor_id IN (
    SELECT 
      actor_id 
    FROM 
      film_actor 
    WHERE 
      film_id in (
        SELECT 
          film_id 
        FROM 
          film 
        WHERE 
          title LIKE 'CATCH AMISTAD'
      )
  );
#--8--#
SELECT 
  last_name, 
  first_name 
FROM 
  actor 
WHERE 
  actor_id not IN (
    SELECT 
      actor_id 
    FROM 
      film_actor 
    WHERE 
      film_id in (
        SELECT 
          film_id 
        from 
          film 
        where 
          title like 'BETRAYED REAR'
      )
  ) 
  and actor_id not in (
    SELECT 
      actor_id 
    FROM 
      film_actor 
    WHERE 
      film_id in (
        SELECT 
          film_id 
        from 
          film 
        where 
          title like 'CATCH AMISTAD'
      )
  );																					
