-- clickthrough rates that reached products page, and based on those who reached that page, how many orders are obtained  

CREATE TEMPORARY TABLE filtered_product_pageviews 
SELECT * FROM website_pageviews
WHERE pageview_url IN ('/products','/the-original-mr-fuzzy','/the-forever-love-bear','/the-birthday-sugar-panda','/the-hudson-river-mini-bear');


CREATE TEMPORARY TABLE filtered2_product_pageviews
SELECT 
	MIN(created_at) as created_at,
    MIN(website_pageview_id) as website_pageview_id,
    website_session_id
FROM filtered_product_pageviews
GROUP BY 3;

CREATE TEMPORARY TABLE click_to_next
SELECT 
    website_session_id,
	COUNT(website_pageview_id) AS next_page
FROM filtered_product_pageviews
GROUP BY website_session_id;

CREATE TEMPORARY TABLE sessions_w_pages
SELECT 
	website_session_id,
    created_at,
    next_page
FROM click_to_next
INNER JOIN filtered2_product_pageviews
	USING(website_session_id);
    
CREATE TEMPORARY TABLE final_table
SELECT 
	sessions_w_pages.created_at,
    sessions_w_pages.website_session_id,
    next_page,
    orders.order_id
FROM sessions_w_pages
	LEFT JOIN orders 
		USING (website_session_id);
        
        
        
SELECT 
	YEAR(created_at) as yr,
    MONTH(created_at) AS mth,
    COUNT(next_page) AS sessions_to_products,
    COUNT(CASE WHEN next_page > 1 THEN website_session_id ELSE NULL END) AS clicked_to_next,
    COUNT(CASE WHEN next_page > 1 THEN website_session_id ELSE NULL END) / COUNT(next_page) AS clickthrough_rt,
    COUNT(order_id) AS orders,
    COUNT(order_id) / COUNT(next_page) AS products_to_order_rt
FROM final_table
GROUP BY 1,2;