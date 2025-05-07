	1. Find duplicate records in a table.
	SELECT column1, column2, COUNT(*)
	FROM your_table
	GROUP BY column1, column2
	HAVING COUNT(*) > 1
	2. Retrieve the second highest salary from the Employee table.
	SELECT MAX(salary) AS SecondHighestSalary
	FROM Employee
	WHERE salary < (SELECT MAX(salary)
	FROM Employee
	3. Find employees without department (Left Join usage).
	SELECT e.*
	FROM Employee e
	LEFT JOIN Department d
	ON e.department_id = d.department_id
	WHERE d.department_id IS NULL
	4. Calculate the total revenue per product.
	SELECT product_id, SUM(quantity * price) AS total_revenue
	FROM Sales
	GROUP BY product_id
	5. Get the top 3 highest-paid employees.
	SELECT TOP 3 * 
	FROM Employee
	ORDER BY salary DESC
	6. Find customers who made purchases but never returned products.
	SELECT DISTINCT c.customer_id
	FROM Customers c
	JOIN Orders o ON c.customer_id = o.customer_id
	WHERE c.customer_id NOT IN (SELECT customer_id FROM Returns)
	7. Show the count of orders per customer.
	SELECT customer_id, COUNT(*) AS order_count
	FROM Orders
	GROUP BY customer_id
	8. Retrieve all employees who joined in 2023.
	SELECT * 
	FROM Employee
	WHERE YEAR(hire_date) = 2023
	9. Calculate the average order value per customer.
	SELECT customer_id, AVG(total_amount) AS avg_order_value
	FROM Orders
	GROUP BY customer_id
	10. Get the latest order placed by each customer.
	SELECT customer_id, MAX(order_date) AS latest_order_date
	FROM Orders
	GROUP BY customer_id
	11. Find products never sold.
	SELECT p.product_id
	FROM Products p
	LEFT JOIN Sales s 
	ON p.product_id = s.product_id
	WHERE s.product_id IS NULL 
	12. Identify the most selling product.
	SELECT TOP 1 product_id, SUM(quantity) AS total_qty
	FROM Sales
	GROUP BY product_id
	ORDER BY total_qty DESC
	13. Get the total revenue and the number of orders per region.
	SELECT region, SUM(total_amount) AS total_revenue, COUNT(*) AS order_count
	FROM Orders
	GROUP BY region
	14. Count how many customers placed more than 5 orders.
	SELECT COUNT(*) AS customer_count
	FROM (
		SELECT customer_id FROM Orders
		GROUP BY customer_id
		HAVING COUNT(*) > 5
	) AS subquery
	15. Retrieve customers with orders above the average order value.
	SELECT *
	FROM Orders
	WHERE total_amount > 
	(SELECT AVG(total_amount) FROM Orders)
	16. Find all employees hired on weekends.
	SELECT * 
	FROM Employee
	WHERE DATENAME(WEEKDAY, hire_date) IN ('Saturday', 'Sunday')
	17. List employees whose salary is within a range.
	SELECT *
	FROM Employee
	WHERE salary BETWEEN 5000 AND 10000
	18. Get monthly sales revenue and order count.
	SELECT FORMAT(order_date, 'yyyy-mm') AS month, SUM(total_amount) AS total_revenue, COUNT(order_id) AS order_count
	FROM Orders
	GROUP BY FORMAT(order_date, 'yyyy-MM')
	19. Rank employees by salary within each department.
	SELECT employee_id, department_id, salary, 
	RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
	FROM Employee
	20. Find customer who placed orders every month in 2023.
	SELECT customer_id
	FROM Orders
	WHERE YEAR(order_date) = 2023
	GROUP BY customer_id
	HAVING COUNT(DISTINCT FORMAT(order_date, 'yyyy-MM')) = 12
	21. Find moving average of sales over the last 3 days.
	SELECT order_date, AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg
	FROM Orders
	22. Identify the first and last order date for each customer.
	SELECT customer_id, MIN(order_date) AS first_order, MAX(order_date) AS last_order
	FROM Orders
	GROUP BY customer_id
	23. Show product sales distribution (percent of total revenue).
	WITH TotalRevenue AS (
	SELECT SUM(quantity * price) AS total FROM Sales)
	SELECT s.product_id, SUM(s.quantity * s.price) AS revenue,
	SUM(s.quantity * s.price) * 100.0 / t.total AS revenue_pct
	FROM Sales s
	CROSS JOIN TotalRevenue t
	GROUP BY s.product_id, t.total
	24. Retrieve customers who made consecutive purchases (2 Days).
	WITH cte AS (
	SELECT customer_id, order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date FROM Orders)
	SELECT customer_id, order_date, prev_order_date
	FROM cte
	WHERE DATEDIFF(DAY, prev_order_date, order_date) = 1
	25. Find churned customer (no orders in the last 6 months.
	SELECT customer_id 
	FROM Orders
	GROUP BY customer_id
	HAVING MAX(order_date) < DATEADD(MONTH, -6, GETDATE())
	26. Calculate cumulative revenue by day.
	SELECT order_date, SUM(total_amount) OVER (ORDER BY order_date) AS cumulative_revenue
	FROM Orders
