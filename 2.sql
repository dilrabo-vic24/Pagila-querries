with cte as(
    select
    distinct film_actor.actor_id, film.rental_duration
from film
left join film_actor
    on film.film_id = film_actor.film_id
ORDER by film.rental_duration desc LIMIT 10
)select * from cte
join actor a
    on cte.actor_id = a.actor_id