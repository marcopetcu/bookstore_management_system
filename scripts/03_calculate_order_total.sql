CREATE OR REPLACE FUNCTION calculate_order_total(p_order_id IN NUMBER)
RETURN NUMBER 
IS
    v_total NUMBER;
BEGIN
    SELECT 
    SUM(sol.quantity * sol.unit_price) - NVL(MAX(v.value), 0)
    INTO v_total
    FROM sale_order so
    LEFT JOIN sale_order_line sol ON so.id = sol.sale_order_id
    LEFT JOIN voucher v ON v.id = so.voucher_id
    WHERE so.id = p_order_id;

    RETURN v_total;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END;