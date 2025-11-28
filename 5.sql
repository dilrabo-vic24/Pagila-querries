with count_appearance as (
	with children_category_cte as(
	    select film_id 
	    from category
	    join film_category
	        on category.category_id = film_category.category_id
	    where category.name = 'Children'
	)
	select a.actor_id from children_category_cte as chcc
	join film_actor fa 
		on fa.film_id   = chcc.film_id
	join actor a
		on a.actor_id  = fa.actor_id 
),
cte2 as (
	select 
		actor_id, 
		count(actor_id) as actor_appearance
	from count_appearance
	group by actor_id
),
cte3 as(
	select 
		*,
		rank() over(order by actor_appearance desc ) as r
	from cte2
)
select 
	a.first_name,
	a.last_name
from cte3
join actor a
	on cte3.actor_id = a.actor_id
where r = 1