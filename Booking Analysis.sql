--Q1
select distinct
replacement_cost
from film
order by replacement_cost asc;  --lowest replacement cost is 9.99

--Q2
select 
case 
when replacement_cost <=19.99 then 'low' 
when replacement_cost between 20.00 and 24.99 then 'medium'
when replacement_cost >24.99 then 'high' 
end as cost_range,
count(*)
from film
group by cost_range;

--Q3
select title,length,name
from film f
left join film_category fc
on f.film_id=fc.film_id
left join category c
on fc.category_id=c.category_id
where name='Sports'  or name= 'Drama';

--Q4
SELECT
name,
COUNT(title)
FROM film f
left JOIN film_category fc
ON f.film_id=fc.film_id
left JOIN category c
ON c.category_id=fc.category_id
GROUP BY name
ORDER BY 2 DESC;

--Q5
select first_name,last_name,count(*)
from actor a
left join film_actor fa
on a.actor_id=fa.actor_id
left join film f
on fa.film_id=f.film_id
group by first_name,last_name
order by count(*) desc;

--Q6
SELECT * FROM address a
LEFT JOIN customer c
ON c.address_id = a.address_id
WHERE c.first_name is null;

--Q7
select city,sum(amount)
from payment p
left join customer c
on p.customer_id=c.customer_id
left join address a
on c.address_id=a.address_id
left join city ci
on a.city_id=ci.city_id
group by  city
order by sum(amount) desc;

--Q8
select
country||', '||city,
sum(amount) as Amount
from payment p
left join customer c
on p.customer_id=c.customer_id
left join address a
on c.address_id=a.address_id
left join city ci
on a.city_id=ci.city_id
left join country co
on ci.country_id=co.country_id
group by country||', '||city 
order by amount asc;

--Q9
select
staff_id,
round(avg(total),2)
from
	(select sum(amount) as total,customer_id,staff_id
	 from payment
	 group  by staff_id,customer_id)
group by staff_id;

--Q10
select
round(avg(total),2)
from (select sum(amount) as total,
		date(payment_date),
	  extract(dow from payment_date) as weekday
	from payment
		where extract(dow from payment_date)=0
		group by date(payment_date),weekday);

--Q11
select
title,length
from film f1
where length > (select avg(length) from film f2
			  where f1.replacement_cost=f2.replacement_cost)
order by length asc;

--Q12
select
district,
round(avg(total))
from (select district,c.customer_id,sum(amount) total
		from payment p
		inner join customer c
		on c.customer_id=p.customer_id  
		inner join address a
		 on c.address_id=a.address_id
		group by district,c.customer_id)
group by district;

--Q13
SELECT
title,
amount,
name,
payment_id,
(SELECT SUM(amount) FROM payment p
LEFT JOIN rental r
ON r.rental_id=p.rental_id
LEFT JOIN inventory i
ON i.inventory_id=r.inventory_id
LEFT JOIN film f
ON f.film_id=i.film_id
LEFT JOIN film_category fc
ON fc.film_id=f.film_id
LEFT JOIN category c1
ON c1.category_id=fc.category_id
WHERE c1.name=c.name)
FROM payment p
LEFT JOIN rental r
ON r.rental_id=p.rental_id
LEFT JOIN inventory i
ON i.inventory_id=r.inventory_id
LEFT JOIN film f
ON f.film_id=i.film_id
LEFT JOIN film_category fc
ON fc.film_id=f.film_id
LEFT JOIN category c
ON c.category_id=fc.category_id
ORDER BY name
