/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

SELECT name, title, "total rentals"
FROM (
    SELECT 
        c.name, 
        f.title, 
        COUNT(r.rental_id) AS "total rentals",
        RANK() OVER (
            PARTITION BY c.name 
            ORDER BY COUNT(r.rental_id) DESC, f.title DESC
        ) AS "rank"
    FROM category c
    JOIN film_category fc USING (category_id)
    JOIN film f USING (film_id)
    JOIN inventory i USING (film_id)
    JOIN rental r USING (inventory_id)
    GROUP BY c.category_id, f.film_id, c.name, f.title
) AS t
WHERE "rank" <= 5
ORDER BY t.name, t."total rentals" DESC, t.title;

