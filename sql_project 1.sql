select * from sql_project.sales_table;
select * from sql_project.sales_table;

-- sales sum
select count(*) as sales_sum from sql_project.sales_table;

-- total number of customers
select count(distinct customer_id) as total_customer from sql_project.sales_table;


-- Beginning of project

-- business problems and answer
-- Q.1 write a query to retrieve all the columns for sales made on 2022-11-05
select * from sql_project.sales_table
where sale_date = '2022-11-05';

-- write a query to retrieve all transactions where the category is 'clothing' and quantity sold is more than 10 in the month of Nov. 2022
select * from sql_project.sales_table
where category = 'Clothing' and date_format(sale_date, '%Y-%m') = '2022-11' and quantity >= 3;

-- write a query to calculate the total sales for all the categories
select category, sum(total_sale) as total_sales, count(*) as total_order from sql_project.sales_table
group by 1;

-- find the average age of customers who purchased items from the 'beauty' category
select round(avg(age), 2) from sql_project.sales_table
where category = 'beauty';

-- find all transactions where the total sale is greater than 1000
select * from sql_project.sales_table
where total_sale > 1000;

-- find the total number of transactions made by each gender in each category
select 
	category,
    gender,
    count(*) as total_transaction
    from sql_project.sales_table
    group by
    category,
    gender
    order by 1;
    
    -- calculate the average sales for each month. Find out the best selling month in each year
    select 
    year,
    month,
    round(average_sale, 2) as average_sale
    from
		(
		select 
			year(sale_date) as year,
			month(sale_date) as month,
			avg(total_sale) as average_sale,
			rank() over(partition by year(sale_date) order by avg(total_sale) desc) as best_month
			from sql_project.sales_table
			group by 1, 2
		) as t1
    where best_month = 1;
    
    -- find the top 5 customers based on the highest total sales
    select
    customer_id,
    sum(total_sale) as total_sale
    from sql_project.sales_table
    group by 1
    order by 2 desc
    limit 5;
    
    -- find the number of unique custumers who purchased items from each category
    select 
    category,
    count(distinct customer_id) as unique_customer
    from sql_project.sales_table
    group by category;
    
    -- Create each shift and number of orders (example of morning which is <= 11: 50) afternoon which is > 12:00 and which is >= 4: 00
    with hourly_sale
    as
		(
		select *,
		case
			when hour(sale_time) < 12 then 'morning'
			when hour(sale_time) between 12 and 17 then 'afternoon'
			else 'evening'
		end as shift
		from sql_project.sales_table
		)
        select
        shift,
        count(transactions_id) as total_order
        from hourly_sale
        group by shift
        order by 1;
-- End of project