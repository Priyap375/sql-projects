USE mavenmovies;
SELECT length(concat(first_name,last_name))as name_length, concat(first_name," ",last_name) as full_name  from actor LIMIT 10;

SELECT concat(first_name," ",last_name) as full_name, length(concat(first_name,last_name))as name_length FROM actor_award WHERE awards = 'OSCAR';

SELECT a.actor_id, concat(a.first_name,' ',a.last_name) as full_name FROM actor as a JOIN film_actor as fa ON a.actor_id = fa.actor_id JOIN film as f ON f.film_id = fa.film_id WHERE f.title = 'Frost Head';

SELECT f.film_id, f.title FROM film f JOIN film_actor fa ON f.film_id = fa.film_id JOIN actor a ON a.actor_id = fa.actor_id WHERE a.first_name = 'Will' and a.last_name = 'Wilson';

SELECT f.film_id , f.title FROM film f JOIN inventory i ON f.film_id = i.film_id JOIN rental r ON r.inventory_id = i.inventory_id WHERE MONTHNAME(return_date)='May';

SELECT f.film_id,f.title FROM film f JOIN film_category fc ON f.film_id = fc.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Comedy';