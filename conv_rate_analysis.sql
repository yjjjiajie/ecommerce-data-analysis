-- overall conversion rates from sessions to orders, revenue per order, grouped by quarters
SELECT 
	YEAR(website_sessions.created_at) AS yr,
    QUARTER(website_sessions.created_at) AS qtr,
    COUNT(website_sessions.website_session_id) AS sessions,
    COUNT(orders.order_id) AS orders,
    COUNT(orders.order_id) / COUNT(website_sessions.website_session_id) AS conv_rate, -- average ecommerce conversion rate is 1 - 4% (food and drinks low, arts and craft conv rate high)
    SUM(price_usd) / COUNT(website_sessions.website_session_id) AS revenue_per_session,
    SUM(price_usd) / COUNT(orders.order_id) AS revenue_per_order -- show success of our cross products marketing
FROM website_sessions
	LEFT JOIN orders 
		USING(website_session_id)
GROUP BY 1,2;
