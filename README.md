E-Commerce Operations Overview Dashboard
⚠️ Note: Dashboard built on internal staging/dummy data, with values further randomized for this public writeup. Structure and methodology reflect a real production project.
Overview
An end-to-end e-commerce operations dashboard built in Amazon QuickSight, tracking order lifecycle, revenue, and fulfillment performance across a multi-channel retail business. The dashboard supports daily decision-making by surfacing revenue trends, order status breakdowns, and top-performing products/regions, filterable by date, locality, and currency exchange rate. The dashboard caters to both local and international orders, with flexible currency handling for international sales.
Business question: 
The dashboard helps answer key operational and commercial questions: 
How are order volume and revenue trending over time? 
Which products and cities are generating the most revenue and orders? 
What proportion of orders are delivered, returned, cancelled, or pending? 
Where are we experiencing order losses through returns and cancellations? 
Which days of the week generate the highest revenue? 
How does performance differ between local and international sales? 
How does international revenue change when applying different USD/GBP exchange rates? 
Tools & Data Source
Visualization: Amazon QuickSight
Data warehouse / source: MYSQL 
Query language: SQL 
Data Model
The dashboard runs on a query that joins six tables at the line-item grain (one row per SKU per child order):
orders → the parent order
childorders → order splits (e.g. per-shop fulfillment)
childlineitems → individual SKUs within each child order
shippingaddress → delivery city/region
childorderassigned + shop → which fulfillment shop handled the order
salechannel → which sales channel the order originated from
A RIGHT OUTER JOIN from child orders to orders (rather than a plain LEFT JOIN from orders) ensures every child order is retained even in edge cases where the parent order record is incomplete — filtered down with WHERE c.order_id IS NOT NULL to exclude orphaned rows.

Dashboard Preview

Top-level KPIs (filterable by date, locality, currency):
Metric
What it measures
Gross Revenue
Total order value before deductions
Net Sales
Revenue excluding returns, cancellations & tax (local orders)
Average Order Value
Gross revenue ÷ order count
Average Daily Revenue
Revenue smoothed across the selected date range
Quantity Sold / Orders
Volume metrics
Delivered / Returned / Cancelled Orders
Fulfillment funnel health, color-coded (green/orange/red)

Breakdown Views

Order Status Distribution — donut chart of delivered vs. returned vs. cancelled orders
Top 10 Products by Revenue — identifies which SKUs are driving sales
Top 10 Cities by Orders — regional demand concentration

Revenue Trend (Gross vs. Net, daily) — dual-axis line/bar combo showing spend spikes (e.g. campaign or sale-day peaks) against the net-of-returns baseline
Day of Week analysis — identifies which weekdays consistently outperform (e.g. Thursday emerging as the strongest day in this dataset), useful for staffing and promo timing decisions
Key Insights
Revenue shows sharp, short-lived spikes rather than steady growth, worth investigating whether these align with promotions, paydays, or specific sales-channel campaigns.
30% of orders are returned and 35% cancelled, compare this against category or city to see if returns cluster anywhere specific.
Thursday consistently outperforms other weekdays for revenue — consider whether inventory/staffing should flex around this pattern.
Skills Demonstrated
SQL: multi-table joins (RIGHT/LEFT), NULL filtering, date extraction/formatting, aggregation logic
QuickSight: calculated fields, control filters (date/locality/currency), KPI cards, donut/bar/combo charts, dual-axis visuals
Dashboard design: grouping related KPIs, choosing chart types by data shape, color-coding status metrics for at-a-glance reading
Challenges & Learnings
Handling currency conversion (local vs. USD/GBP) across mixed-locality orders
Deciding between gross vs. net revenue framing to avoid overstating performance

