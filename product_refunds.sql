CREATE TEMPORARY TABLE order_w_refunds
SELECT 
	order_items.order_item_id,
    order_items.created_at,
    order_items.product_id,
    order_item_refunds.order_item_refund_id
FROM order_items
LEFT JOIN order_item_refunds
	USING (order_item_id)
WHERE order_items.created_at < "2014-10-15";


SELECT 
	YEAR(created_at) AS yr,
    MONTH(created_at) AS mth,
    COUNT(CASE WHEN product_id = 1 THEN order_item_id ELSE NULL END) AS p1_orders,
    COUNT(CASE WHEN product_id = 1 THEN order_item_refund_id END) /  COUNT(CASE WHEN product_id = 1 THEN order_item_id ELSE NULL END) AS p1_refund_rt,
    COUNT(CASE WHEN product_id = 2 THEN order_item_id ELSE NULL END) AS p1_orders,
    COUNT(CASE WHEN product_id = 2 THEN order_item_refund_id END) /  COUNT(CASE WHEN product_id = 2 THEN order_item_id ELSE NULL END) AS p2_refund_rt,
    COUNT(CASE WHEN product_id = 3 THEN order_item_id ELSE NULL END) AS p1_orders,
    COUNT(CASE WHEN product_id = 3 THEN order_item_refund_id END) /  COUNT(CASE WHEN product_id = 3 THEN order_item_id ELSE NULL END) AS p3_refund_rt,
    COUNT(CASE WHEN product_id = 4 THEN order_item_id ELSE NULL END) AS p1_orders,
    COUNT(CASE WHEN product_id = 4 THEN order_item_refund_id END) /  COUNT(CASE WHEN product_id = 4 THEN order_item_id ELSE NULL END) AS p4_refund_rt
FROM order_w_refunds
GROUP BY 1,2;
    
    
