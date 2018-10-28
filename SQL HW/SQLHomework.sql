
USE sakila

/*1a. Display the first and last names of all actors from the table actor. */

  SELECT first_name, last_name FROM actor;


/*1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. */


  SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name` FROM actor;


/*2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?*/

 
  SELECT first_name, last_name, actor_id
  FROM actor
  WHERE first_name = "Joe";
  

/*2b. Find all actors whose last name contain the letters GEN: */


  SELECT first_name, last_name, actor_id
  FROM actor
  WHERE last_name LIKE '%GEN%';


/*2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:*/

  
  SELECT first_name, last_name, actor_id
  FROM actor
  WHERE last_name LIKE '%LI%'
  ORDER BY last_name, first_name; 


/*2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:*/

  
  SELECT country_id, country
  FROM country
  WHERE country 
  

/*3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).*/

  ALTER TABLE actor
  MODIFY COLUMN description blob;
  

/*3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.*/


  ALTER TABLE actor
  DROP COLUMN description;


/*4a. List the last names of actors, as well as how many actors have that last name.*/


  SELECT last_name, count(last_name) AS 'last_name_frequency'
  FROM actor
  GROUP BY last_name
  

/*4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.*/

  
  SELECT last_name, count(last_name) AS 'last_name_frequency'
  FROM actor
  GROUP BY last_name
  Having `last_name_frequency` >= 2;
  

/*4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.*/


  UPDATE actor
  SET first_name = 'HARPO'
  WHERE first_name = 'GROUCHO'
  and last_name = 'WILLIAMS';


/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.*/


  UPDATE actor
  SET first_name =
	CASE
	WHEN first_name = 'HARPO'
    THEN 'GROUCHO'
   ELSE 'MUCHO GROUCHO'
  END
  WHERE actor_id = 172;


/* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?*/

  SHOW CREATE TABLE address;


/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:*/


  SELECT staff.first_name, staff.last_name, address.address
  FROM staff 
  INNER JOIN address 
  ON (staff.address_id = address.address_id);


/*6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.*/

  SELECT staff.first_name, staff.last_name, SUM(payment.amount)
  FROM staff
  INNER JOIN payment 
  ON payment.staff_id = staff.staff_id
  WHERE payment.payment_date LIKE '2005-08%'
	GROUP BY payment.staff_id;

/*6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.*/


  SELECT title, COUNT(actor_id) AS 'Actors'
  FROM film_actor 
  INNER JOIN film 
  ON film.film_id = film_actor.film_id
  GROUP BY film.title
 

/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/


  SELECT title, COUNT(inventory_id) AS 'number of copies'
  FROM film
  INNER JOIN inventory
  USING (film_id)
  WHERE title = 'Hunchback Impossible'
 

/*6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:*/


  SELECT first_name, last_name, SUM(amount) AS 'total paid'
  FROM payment 
  JOIN customer 
  ON payment.customer_id = customer.customer_id
  GROUP BY payment.customer_id
  ORDER BY customer.last_name;


/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. */


  SELECT title
  FROM film
  WHERE title LIKE 'K%' OR title LIKE 'Q%'
  AND language_id IN
  (
   SELECT language_id
   FROM language
   WHERE name = 'English'
  );
  
/*7b. Use subqueries to display all actors who appear in the film `Alone Trip`.*/


  SELECT first_name, last_name
  FROM actor 
  WHERE actor_id IN 
  (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = 
    (
       SELECT film_id
       FROM film
       WHERE title = 'Alone Trip'
      )
   );

/* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.*/

  SELECT 
    customer.last_name, customer.first_name, customer.email
FROM
    customer
        INNER JOIN
    customer_list ON customer.customer_id = customer_list.ID
WHERE
    customer_list.country = 'Canada';


/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.*/


  SELECT title,
  FROM film 
  JOIN film_category 
  ON (film_id = film_id)
  JOIN category 
  ON (category_id = category_id)
  WHERE name = 'family';


/*7e. Display the most frequently rented movies in descending order.*/


  SELECT title, COUNT(title) as 'Rentals'
  FROM film
  JOIN inventory
  ON (film.film_id = inventory.film_id)
  JOIN rental
  ON (inventory.inventory_id = rental.inventory_id)
  GROUP by rentals desc

/* 7f. Write a query to display how much business, in dollars, each store brought in.*/


  SELECT store.store_id, SUM(amount) AS Gross
  FROM payment 
  JOIN rental 
  ON (payment.rental_id = rental.rental_id)
  JOIN inventory 
  ON (inventory.inventory_id = rental.inventory_id)
  JOIN store 
  ON (store.store_id = inventory.store_id)
  GROUP BY store.store_id;	

/*7g. Write a query to display for each store its store ID, city, and country.*/

  SELECT 
    store.store_id, city.city, country.country
FROM
    store
        INNER JOIN
    address ON store.address_id = address.address_id
        INNER JOIN
    city ON address.city_id = city.city_id
        INNER JOIN
    country ON city.country_id = country.country_id;


/*7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/

  SELECT name SUM(amount) AS 'gross revenue', 
  FROM payment 
  JOIN rental 
  ON (payment.rental_id = rental.rental_id)
  JOIN inventory 
  ON (rental.inventory_id = inventory.inventory_id)
  JOIN film_category 
  ON (inventory.film_id = film_category.film_id)
  JOIN category c
  ON (film_category.category_id = category.category_id)
 
  ORDER BY gross revenue desc;


/*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.*/


  CREATE VIEW top_five_genres AS
  SELECT SUM(amount) AS 'gross revenue',
  FROM payment p
  JOIN rental r
  ON (p.rental_id = r.rental_id)
  JOIN inventory i
  ON (r.inventory_id = i.inventory_id)
  JOIN film_category fc
  ON (i.film_id = fc.film_id)
  JOIN category c
  ON (fc.category_id = c.category_id)
  GROUP BY c.name
  ORDER BY gross_revenue DESC
  LIMIT 5;
 

/*8b. How would you display the view that you created in 8a?*/

  SELECT * FROM top_five_genres;

/*8c. You find that you no longer need the view top_five_genres. Write a query to delete it.*/


  DROP VIEW top_five_genres;


