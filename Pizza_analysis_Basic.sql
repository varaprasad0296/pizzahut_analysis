use pizzahut;
Select * from order_details;

Select count(order_id) as Total_no_orders from orders;

SELECT round(sum(Amount) ,2) as Total_Revenue
FROM(
		SELECT pz.pizza_id,pz.price,ord.quantity,
				(pz.price* ord.quantity) As Amount
		FROM pizzas AS pz JOIN
		order_details As ord
		ON pz.pizza_id= ord.pizza_id)AS dev_tbl;

SELECT * FROM Pizzas
ORDER BY price DESC
LIMIT 5;

SELECT derv_tbl.pizza_id, sum(derv_tbl.quantity) AS Total_Quantity
FROM 
		(SELECT pz.pizza_id ,ord.quantity FROM
                pizzas AS pz JOIN
		order_details AS ord
		ON pz.pizza_id= ord.pizza_id) AS derv_tbl
GROUP by derv_tbl.pizza_id
ORDER BY Total_Quantity DESC
LIMIT 5;
        
   SELECT dev_tbl.pizza_id,count(dev_tbl.pizza_id) AS TotalOrders 
   FROM
		(SELECT pz.pizza_id , pz.size,ord.order_id FROM
                pizzas AS pz JOIN
				order_details AS ord
			ON pz.pizza_id= ord.pizza_id) AS dev_tbl 
   GROUP BY dev_tbl.pizza_id
   ORDER BY TotalOrders DESC ;