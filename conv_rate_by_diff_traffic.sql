-- Quarterly conv rate of sessions to orders from Gsearch nonbrand, Bsearch nonbrand, overall brand, organic, direct type in
SELECT 
	YEAR(website_sessions.created_at) AS yr,
    QUARTER(website_sessions.created_at) AS qtr,
    COUNT(CASE WHEN utm_source = "gsearch" AND utm_campaign = "nonbrand" THEN orders.order_id ELSE NULL END) / COUNT(CASE WHEN utm_source = "gsearch" AND utm_campaign = "nonbrand" THEN website_session_id ELSE NULL END) AS gsearch_nonbrand_conv, -- Non-branded keyword terms refer or relate to your company or products without the proper company name.
    COUNT(CASE WHEN utm_source = "bsearch" AND utm_campaign = "nonbrand" THEN order_id ELSE NULL END) / COUNT(CASE WHEN utm_source = "bsearch" AND utm_campaign = "nonbrand" THEN website_session_id ELSE NULL END) AS bsearch_nonbrand_conv,
    COUNT(CASE WHEN utm_campaign = "brand" THEN order_id ELSE NULL END) / COUNT(CASE WHEN utm_campaign = "brand" THEN website_session_id ELSE NULL END) AS brand_overall_conv, -- Branded keyword terms include the name of your company or branded product.
    COUNT(CASE WHEN utm_source IS NULL AND utm_campaign IS NULL and http_referer IS NOT NULL THEN order_id ELSE NULL END) / COUNT(CASE WHEN utm_source IS NULL AND utm_campaign IS NULL and http_referer IS NOT NULL THEN website_session_id ELSE NULL END) AS organic_search_conv,
    COUNT(CASE WHEN utm_source IS NULL AND utm_campaign IS NULL and http_referer IS NULL THEN order_id ELSE NULL END) / COUNT(CASE WHEN utm_source IS NULL AND utm_campaign IS NULL and http_referer IS NULL THEN website_session_id ELSE NULL END) AS direct_conv -- Direct traffic can include visits that result from typing the URL directly into a browser, which is good bc it shows that business is doing well 
FROM website_sessions
	LEFT JOIN orders
		USING (website_session_id)
GROUP BY YEAR(website_sessions.created_at), QUARTER(website_sessions.created_at);