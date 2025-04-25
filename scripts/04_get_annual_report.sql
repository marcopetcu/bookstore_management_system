CREATE OR REPLACE PROCEDURE get_annual_report(p_year IN NUMBER) IS
BEGIN
    FOR customer_rec IN (
        SELECT 
            first_name || ' ' || last_name AS customer_name,
            SUM(order_total) AS total_spent
        FROM (
            SELECT 
                c.first_name, 
                c.last_name, 
                NVL(SUM(sol.quantity * sol.unit_price), 0) - NVL(MAX(v.value), 0) AS order_total
            FROM customer c
            JOIN address a ON c.id = a.customer_id
            JOIN sale_order so 
                ON a.id = so.billing_address_id 
                AND EXTRACT(YEAR FROM so.order_date) = p_year
            JOIN sale_order_line sol 
                ON so.id = sol.sale_order_id
            LEFT JOIN voucher v 
                ON so.voucher_id = v.id
            GROUP BY so.id, c.first_name, c.last_name
        )
        GROUP BY first_name, last_name
        ORDER BY total_spent DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Clientul ' || customer_rec.customer_name || 
            ' a cheltuit ' || customer_rec.total_spent || ' lei în anul ' || p_year || '.'
        );
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Eroare: no data found');
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Eroare: too many rows');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Eroare: ' || SQLERRM);

END get_annual_report;