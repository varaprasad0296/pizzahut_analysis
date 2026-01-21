SELECT *, round((Sum(Total_Amount)over(partition by Derv_tbl3.pizza_id) *100 /Sum(Total_Amount) over()),2) as Individual_pz_rev_cont 
FROM
			(SELECT Derv_tbl2.pizza_id,round(sum(Derv_tbl2.Amount),2) AS Total_Amount From
				(SELECT *, (derv_tbl.price*derv_tbl.quantity) AS Amount From
					(SELECT pz.pizza_id ,
							pz.price,
							ord.quantity FROM
							pizzas AS pz JOIN
					order_details AS ord
					ON pz.pizza_id= ord.pizza_id) AS derv_tbl)AS Derv_tbl2
			GROUP BY Derv_tbl2.pizza_id) AS Derv_tbl3
ORDER BY Individual_pz_rev_cont ASC;
SELECT * FROM 
(SELECT  *,Dense_rank()over( partition by category order by Total_Amount desc) AS pizza_rev_rank FROM
(SELECT  *,row_number()over( partition by pizza_id order by Total_Amount desc) AS pizza_rank FROM
(SELECT *,sum(Amount)over(partition by Derv_Tbl1.pizza_id) AS Total_Amount  FROM 
(SELECT  pz.pizza_id ,pz.price, pztyp.category,
					ord.quantity,(pz.price*ord.quantity) AS Amount
			FROM
			pizzas AS pz JOIN
			pizza_types AS pztyp 
			ON pz.pizza_type_id= pztyp.pizza_type_id 
			JOIN order_details AS ord
			ON pz.pizza_id = ord.pizza_id) AS Derv_Tbl1) AS Derv_Tbl2)AS Derv_tbl3
            where pizza_rank =1) AS Derv_Tbl4 
WHERE pizza_rev_rank BETWEEN 1 AND 3; 

