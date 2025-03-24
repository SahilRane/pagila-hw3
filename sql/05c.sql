/* 
 * You also like the acting in the movies ACADEMY DINOSAUR and AGENT TRUMAN,
 * and so you'd like to see movies with actors that were in either of these movies or AMERICAN CIRCUS.
 *
 * Write a SQL query that lists all movies where at least 3 actors were in one of the above three movies.
 * (The actors do not necessarily have to all be in the same movie, and you do not necessarily need one actor from each movie.)
 */

WITH shared_actors AS (
  SELECT fa.actor_id
  FROM film_actor fa
  JOIN film f ON fa.film_id = f.film_id
  WHERE f.title IN ('ACADEMY DINOSAUR', 'AGENT TRUMAN', 'AMERICAN CIRCUS')
)
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN shared_actors sa ON fa.actor_id = sa.actor_id
GROUP BY f.title
HAVING COUNT(sa.actor_id) >= 3
ORDER BY f.title;

