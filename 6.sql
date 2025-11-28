--Solution1
with cte as (
	select 
		city.city_id,
		c.active
	from address a
	join city
		on city.city_id = a.city_id
	join customer c
		on c.address_id = a.address_id 
),
cte2 as(
	select cte.city_id, count(cte.city_id) as count_active from cte
	where active = 1
	group by cte.city_id
),
cte3 as(
	select cte.city_id, count(cte.city_id) as count_inactive from cte
	where active = 0
	group by cte.city_id
)
select
	c.city,
	coalesce(cte2.city_id, cte3.city_id) as city_id,
	coalesce(cte2.count_active, 0) as active,--  as active_count,
	coalesce(cte3.count_inactive, 0) as inactive--  as inactive_count
from cte2
full join cte3
	on cte2.city_id = cte3.city_id
join city c
	on c.city_id = coalesce(cte2.city_id , cte3.city_id)
order by inactive desc

--Solution2

select
	c.city,
	sum(case
		when cu.active = 1 then 1 else 0 
	end) as active_count,
	sum(case
		when cu.active = 0 then 1 else 0 
	end) as inactive_count
from city c
join address a 
	on a.city_id = c.city_id
join customer cu
	on cu.address_id = a.address_id
group by c.city_id, c.city
order by inactive_count desc