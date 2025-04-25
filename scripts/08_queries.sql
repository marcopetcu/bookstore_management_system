--query_1 Write a query to obtain email address and date of second order of every customer
WITH tab AS (
SELECT c.email, sol.order_date, ROW_NUMBER() OVER (PARTITION BY a.customer_id ORDER BY order_date) row_no
FROM sale_order sol JOIN address a ON sol.billing_address_id = a.id
LEFT JOIN customer c ON a.customer_id = c.id
)
SELECT email, order_date
FROM tab
WHERE row_no = 2;

-- query_2 Write a query to calculate authors' stock levels by subtracting total books sold from total books purchased, displaying results for all authors
SELECT a.id, a.first_name, a.last_name,
NVL((SELECT SUM(pol.quantity) 
FROM author a2 LEFT JOIN book_author ba ON a2.id = ba.author_id
LEFT JOIN book b ON ba.book_id = b.id
LEFT JOIN purchase_order_line pol ON pol.book_id = b.id
WHERE a2.id = a.id), 0)
-
NVL((SELECT SUM(sol.quantity) 
FROM author a2 LEFT JOIN book_author ba ON a2.id = ba.author_id
LEFT JOIN book b ON ba.book_id = b.id
LEFT JOIN sale_order_line sol ON sol.book_id = b.id
WHERE a2.id = a.id), 0) STOCK
FROM author a;

-- query_3 Write a query to show customers' emails and their count of wishlisted books that are priced below average, sorted by the most wishlisted books first
SELECT c.email, count(w.book_id) wb
FROM customer c JOIN wishlist w ON c.id = w.customer_id
JOIN book b ON w.book_id = b.id
WHERE unit_price < (select avg(unit_price) from book)
GROUP BY c.email
ORDER BY wb DESC;

--query_4 Write a query to list all counties and their total shipped books, showing only counties where more than 2 books were shipped, sorted alphabetically by county name
SELECT county.name, sum(sol.quantity) books_shipped
FROM county JOIN city ON county.id = city.county_id
JOIN address a ON a.city_id = city.id
JOIN sale_order so ON a.id = so.shipping_address_id
JOIN sale_order_line sol ON so.id = sol.sale_order_id
GROUP BY county.name
HAVING SUM(sol.quantity) > 2
ORDER BY county.name;

-- query_5 Select addresses where the most recent order in their shipping history is from 2025
SELECT a.id, a.address_line_1
FROM address a
WHERE (
SELECT MAX(so.order_date)
FROM sale_order so
WHERE so.shipping_address_id = a.id
) >= DATE '2025-01-01';
