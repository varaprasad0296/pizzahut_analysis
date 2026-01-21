Use pizzaHut;
Select * from pizzas;
Select * from pizza_types;

Select * from Order_details;

SELECT count(order_details_id) AS Total_orders FROM Order_details;

SELECT *,dense_rank()over(partition by month_day) FROM
(SELECT ord.order_details_id,od.order_date,Extract(day from order_date) as month_day,quantity,sum(quantity)over()/365
FROM orders AS od JOIN
order_details AS ord 
ON od.order_id=ord.order_id)as derv_tbl;

SELECT count(order_id) As Total_No_of_orders from Order_details;

SELECT derv_tbl.category,count(derv_tbl.order_id) AS No_of_orders
FROM
		(SELECT  pz.pizza_id ,pztyp.pizza_type_id,
					pztyp.category,ord.order_id
			FROM
			pizzas AS pz JOIN
			pizza_types AS pztyp 
			ON pz.pizza_type_id= pztyp.pizza_type_id 
			JOIN order_details AS ord
			ON pz.pizza_id = ord.pizza_id) AS derv_tbl 
GROUP BY derv_tbl.category;

SELECT Hour,count(Hour) AS Hour_ord_occurance
FROM
	(Select *,Extract(Hour FROM order_time) as Hour
	  From orders) AS DERV_TBL1
GROUP BY HOUR
ORDER BY Hour_ord_occurance DESC;
SELECT category,sum(quantity) AS Total_Quantity From
		(SELECT  pz.pizza_id ,pztyp.pizza_type_id,
				pztyp.category,ord.quantity
		FROM
		pizzas AS pz JOIN
		pizza_types AS pztyp
        
		ON pz.pizza_type_id= pztyp.pizza_type_id 
		JOIN order_details AS ord
		ON pz.pizza_id = ord.pizza_id) AS derv_tbl 
Group by category;
SELECT * ,round(avg(Day_qty)over()) AS Avg_ord_per_day
FROM
		(SELECT Derv_tbl.ord_date, sum(Derv_tbl.quantity) AS Day_qty
		FROM
		(SELECT ord.order_date, ordt.quantity,
			extract(day from ord.order_date) as ord_date FROM 
			orders AS ord JOIN
			order_details AS ordt
			ON ord.order_id = ordt.order_id) AS Derv_tbl
GROUP BY Derv_tbl.ord_date)AS Derv_tbl2
ORDER BY Derv_tbl2.Day_qty desc;
SELECT * ,round(Sum(Total_Amount) over(),2)As Top_5_ord_pz_Rev FROM
(SELECT *, round(Sum(Total_Amount) over(),2)As Total_Revenue FROM
(SELECT Derv_Tbl1.pizza_id,round(sum(Derv_Tbl1.Amount),2) As Total_Amount
FROM
		(SELECT pz.pizza_id,
        round((pz.price* ord.quantity),2) AS Amount 
		FROM 
		pizzas as pz JOIN 
		order_details AS ord
		ON pz.pizza_id= ord.pizza_id) AS Derv_Tbl1
GROUP BY Derv_Tbl1.pizza_id) AS Derv_Tbl2
ORDER BY Derv_Tbl2.Total_Amount DESC
LIMIT 5) as Derv_Tbl3;

