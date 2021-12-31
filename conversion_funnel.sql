CREATE TEMPORARY TABLE pages_reached_overall
SELECT 
	website_pageviews.created_at,
	website_session_id, 
	pageview_url, 
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_page,
	CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_pageviews 
	LEFT JOIN website_sessions ws 
		USING (website_session_id)
WHERE website_pageviews.created_at < "2012-08-01"
ORDER BY website_session_id;

CREATE TEMPORARY TABLE website_session_max_page_reached
SELECT
	MIN(created_at) AS created_at,
	website_session_id, 
	MAX(product_page) as products_made_it,
	MAX(mrfuzzy_page) as mrfuzzy_made_it,
	MAX(cart_page) as carts_made_it,
	MAX(shipping_page) as shipping_made_it,
	MAX(billing_page) as bills_made_it,
	MAX(thankyou_page) as thankyou_made_it
FROM pages_reached_overall
GROUP BY website_session_id; 


SELECT 
	MONTH(created_at),
    WEEK(created_at),
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE NULL END) AS to_fuzzy,
    COUNT(DISTINCT CASE WHEN carts_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN carts_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN bills_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN bills_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM website_session_max_page_reached
GROUP BY 1,2;

