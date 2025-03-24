/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */

/*
 * For each actor, report the three films they starred in that generated the most revenue.
 * Revenue is the sum of all payments for that film.
 */

WITH film_revenue AS (
  SELECT
    f.film_id,
    SUM(p.amount) AS revenue
  FROM payment p
  JOIN rental r ON p.rental_id = r.rental_id
  JOIN inventory i ON r.inventory_id = i.inventory_id
  JOIN film f ON i.film_id = f.film_id
  GROUP BY f.film_id
),
ranked_films AS (
  SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    f.film_id,
    f.title,
    fr.revenue,
    DENSE_RANK() OVER (
      PARTITION BY a.actor_id
      ORDER BY fr.revenue DESC, f.title
    ) AS rank
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  JOIN film f ON fa.film_id = f.film_id
  JOIN film_revenue fr ON f.film_id = fr.film_id
)
SELECT actor_id, first_name, last_name, film_id, title, rank, revenue
FROM ranked_films
WHERE rank <= 3
ORDER BY actor_id, rank;

