with cte as (
	select 
		c.city,
		CASE 
            WHEN c.city ILIKE 'a%' THEN 'Starts with a'
            WHEN c.city LIKE '%-%' THEN 'Has symbol (-)'
        END AS city_group,
		extract(epoch from (r.return_date - r.rental_date)) as rental_seconds,
		r.rental_date,
		r.return_date ,
		ct.category_id,
		ct.name as category_name
	from city c
	join address a
		on c.city_id = a.city_id
	join customer cu
		on cu.address_id  = a.address_id
	join rental r
		on r.customer_id = cu.customer_id
	join inventory i 
		on i.inventory_id = r.inventory_id 
	join film_category fc
		on	fc.film_id = i.film_id
	join category ct
		on	ct.category_id = fc.category_id
	WHERE c.city ILIKE 'a%' OR c.city LIKE '%-%'

),
cte2 as (
	select
		city_group,
		category_name,
		sum(rental_seconds) as total_rental_seconds
	from cte
	WHERE city_group IS NOT NULL 
	group by city_group, category_name
),
cte3 as (
	select 
		city_group,
		category_name,
		total_rental_seconds,
		rank() over(partition by city_group order by total_rental_seconds desc) as r
	from cte2
)
select 
	city_group,
	category_name,
	total_rental_seconds
from cte3
where r = 1


