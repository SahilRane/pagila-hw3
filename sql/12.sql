/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN LATERAL (
  SELECT DISTINCT f.film_id, r.rental_date
  FROM rental r
  JOIN inventory i ON r.inventory_id = i.inventory_id
  JOIN film f ON i.film_id = f.film_id
  WHERE r.customer_id = c.customer_id
  ORDER BY r.rental_date DESC
  LIMIT 5
) AS recent_films ON TRUE
LEFT JOIN film_category fc ON recent_films.film_id = fc.film_id
LEFT JOIN category cat ON fc.category_id = cat.category_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT recent_films.film_id) = 5
   AND COUNT(DISTINCT recent_films.film_id) FILTER (
         WHERE cat.name = 'Action') >= 4
ORDER BY c.customer_id;
