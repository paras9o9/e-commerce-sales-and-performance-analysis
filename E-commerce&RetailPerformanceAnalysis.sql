WITH MonthlyCategoryRevenue AS (
    SELECT 
        '20' || SUBSTR(Date, 7, 2) || '-' || SUBSTR(Date, 1, 2) AS order_month,
        Category,
        SUM(Amount) AS total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY '20' || SUBSTR(Date, 7, 2) || '-' || SUBSTR(Date, 1, 2)
            ORDER BY SUM(Amount) DESC
        ) AS category_rank
    FROM AmazonSaleReport
    WHERE Status NOT LIKE '%Cancel%' AND Amount IS NOT NULL
    GROUP BY order_month, Category
)
SELECT 
    order_month,
    Category,
    ROUND(total_revenue, 2) AS total_revenue
FROM MonthlyCategoryRevenue
WHERE category_rank <= 5
ORDER BY order_month ASC, category_rank ASC;

select
    `ship_city` as City,
    `ship_state` as State,
    `ship_postal_code` as Postal_Code,
    COUNT(DISTINCT `Order_id`) as Total_Orders,
    ROUND(SUM(amount), 2) as Total_Revenue
FROM AmazonSaleReport
where status not LIKE '%Cancel%' and amount is not NULL
GROUP by `ship_postal_code`, `ship_city`, `ship_state`
order by Total_Revenue DESC
LIMIT 10;

select
    `ship_state` as Region,
    COUNT(DISTINCT `Order_id`) as Total_Orders,
    ROUND(SUM(amount), 2) as Total_Revenue
From AmazonSaleReport
where status not like '%Cancel%' and `ship_state` is not NULL
group by `ship_state`
order by Total_Orders DESC
limit 10;

select
    category,
    ROUND(SUM(amount), 2) as Category_Revenue,
    ROUND(
        100.0 * SUM(amount) / (SELECT SUM(amount) from AmazonSaleReport where status not like '%Cancel%' and amount is NOT NULL),
        2
   ) as Revenue_Percentage
FROM AmazonSaleReport
where status not like '%cancel%' and amount is not NULL
GROUP by category
order by Category_Revenue desc;