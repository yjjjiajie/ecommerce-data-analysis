SELECT 
	YEAR(orders.created_at) as yr,
    QUARTER(orders.created_at) as qtr,
    orders.primary_product_id,
    COUNT(orders.order_id) AS orders,
    COUNT(CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END) AS x_sell_pdt1,
    COUNT(CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END) AS x_sell_pdt2,
    COUNT(CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END) AS x_sell_pdt3,
    COUNT(CASE WHEN order_items.product_id = 4 THEN orders.order_id ELSE NULL END) AS x_sell_pdt4,
    
    COUNT(CASE WHEN order_items.product_id = 1 THEN orders.order_id ELSE NULL END) /  COUNT(orders.order_id) AS x_sell_pdt1_rt,
    COUNT(CASE WHEN order_items.product_id = 2 THEN orders.order_id ELSE NULL END) /  COUNT(orders.order_id) AS x_sell_pdt2_rt,
    COUNT(CASE WHEN order_items.product_id = 3 THEN orders.order_id ELSE NULL END) /  COUNT(orders.order_id) AS x_sell_pdt3_rt,
    COUNT(CASE WHEN order_items.product_id = 4 THEN orders.order_id ELSE NULL END) /  COUNT(orders.order_id) AS x_sell_pdt4_rt
FROM orders
	LEFT JOIN order_items
		ON orders.order_id = order_items.order_id
        AND order_items.is_primary_item = 0
GROUP BY 1,2,3
-- HAVING primary_product_id = 1;
-- HAVING primary_product_id = 2;
-- HAVING primary_product_id = 3;
-- HAVING primary_product_id = 4;