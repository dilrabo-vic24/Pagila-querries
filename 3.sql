with cte as(
    SELECT
    sum(replacement_cost) as total_cost,
    t.category_id
from (
    select * from film
    join film_category
        on film.film_id = film_category.film_id
) t
GROUP by category_id
)
SELECT c.name, total_cost from cte
join category c
    on c.category_id = cte.category_id
order by  total_cost desc limit 1