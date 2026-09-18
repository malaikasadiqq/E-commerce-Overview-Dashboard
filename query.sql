-- =========================================================
-- E-Commerce Order Report Query
-- Built on internal staging/sample data, with values further
-- randomized here for this public portfolio writeup.
-- Written for MySQL/MariaDB syntax.
-- =========================================================

SELECT 
    o.isInternational, 
    o.currency,

    -- Monetary fields: scaled by one consistent factor so every
    -- derived KPI (AOV, gross vs net, discount %) still checks out
    ROUND(c.shipping_charge * 1.37, 2)   AS shipping_charge,
    ROUND(c.total_discounts * 1.37, 2)   AS total_discounts,

    l.sku,
    l.barcode,
    l.quantity,
    ROUND(l.price * 1.37, 2)             AS price,
    ROUND(l.compare_at_price * 1.37, 2)  AS compare_at_price,
    l.fulfillable_quantity,

    -- Vendor pseudonymized via hash: the same real vendor always maps
    -- to the same fake label, so "top vendor by revenue" still works
    CONCAT('Vendor_', UPPER(SUBSTRING(MD5(CONCAT('anon_salt_2026', l.vendor)), 1, 6))) AS vendor,
    l.product_type,

    -- Shop name pseudonymized the same way
    CONCAT('Shop_', UPPER(SUBSTRING(MD5(CONCAT('anon_salt_2026', sh.name)), 1, 6))) AS shop,

    UPPER(s.city) AS city,  -- left as-is (generic city names); hash it too if you'd rather not disclose regional footprint

    l.title,
    ROUND(l.total_discounts * 1.37, 2) AS line_item_discount,

    -- Order identifiers pseudonymized so real sequence/volume info can't be inferred
    SUBSTRING(MD5(CONCAT('anon_salt_2026', c.id)), 1, 10)   AS childID,
    c.status AS childorderStatus,
    SUBSTRING(MD5(CONCAT('anon_salt_2026', c.name)), 1, 10) AS childOrder_no,

    l.product_type AS ProductType,

    -- Sales channel name pseudonymized (hides which real marketplaces/channels you use)
    CONCAT('Channel_', UPPER(SUBSTRING(MD5(CONCAT('anon_salt_2026', ss.sale_channel_name)), 1, 4))) AS sale_channel_name,

    -- Dates shifted by exactly 26 weeks (182 days, a multiple of 7)
    -- so weekday patterns (e.g. "Thursday is the best day") stay accurate,
    -- but the real calendar dates — and any real promo/sale-day spikes — are hidden
    DATE_SUB(c.awaitingApproval_at, INTERVAL 26 WEEK)          AS awaitingApproval_at,
    DATE(DATE_SUB(c.approved_at, INTERVAL 26 WEEK))            AS childApproved_at,
    DATE(DATE_SUB(c.dispatched_at, INTERVAL 26 WEEK))          AS dispatched_at,
    DATE(DATE_SUB(c.returned_at, INTERVAL 26 WEEK))            AS returned_at,
    DATE(DATE_SUB(c.cancelled_at, INTERVAL 26 WEEK))           AS cancelled_at_at,
    DATE(DATE_SUB(c.created_at, INTERVAL 26 WEEK))             AS childOrder_at,

    c.cancel_reason,

    -- Courier and payment gateway pseudonymized (hides real operational partners)
    CONCAT('Courier_', UPPER(SUBSTRING(MD5(CONCAT('anon_salt_2026', c.courierName)), 1, 4))) AS courierName,
    c.financial_status, 
    c.fulfillment_status,
    o.verification, 
    CONCAT('Gateway_', UPPER(SUBSTRING(MD5(CONCAT('anon_salt_2026', c.gateway)), 1, 4))) AS gateway,
    c.sale_channel_id

FROM OrderManagement_childorders c
RIGHT OUTER JOIN OrderManagement_orders o ON c.orders_id = o.id
LEFT OUTER JOIN OrderManagement_shippingaddress s ON o.id = s.orders_id
LEFT OUTER JOIN OrderManagement_childlineitems l ON l.childOrders_id = c.id
LEFT OUTER JOIN OrderManagement_childorderassigned ca ON c.id = ca.childOrders_id AND ca.is_active = 1
LEFT OUTER JOIN InventoryManagement_shop sh ON sh.id = ca.shop_id
LEFT OUTER JOIN SaleChannel_salechannel ss ON o.sale_channel_id = ss.id

WHERE c.order_id IS NOT NULL
