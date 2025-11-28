select
    count(*) as movie_count,
    film_category.category_id
from film
left join film_category
    on film.film_id = film_category.film_id
GROUP by film_category.category_id
ORDER by movie_count DESC
