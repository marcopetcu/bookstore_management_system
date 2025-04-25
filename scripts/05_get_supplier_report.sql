create or replace PROCEDURE get_supplier_report IS
    v_no NUMBER;
    v_name supplier.name%type;
    CURSOR c IS
    SELECT s.name, nvl(sum(pol.quantity), 0)
    from supplier S left join PURCHASE_ORDER po ON po.supplier_id=s.id left join purchase_order_line pol on pol.purchase_order_id=po.id
    GROUP BY s.name;

BEGIN
    OPEN c;
    LOOP
    FETCH c INTO v_name, v_no;
    EXIT WHEN c%NOTFOUND;
    IF v_no = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('Nu am achizitionat nicio de la furnizorul ' || v_name || '.');
    ELSIF v_no = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Am achizitionat o carte de la furnizorul ' || v_name || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Am achizitionat ' || v_no || ' carti de la furnizorul ' || v_name || '.');
    END IF;
    END LOOP;
    CLOSE c;
END get_supplier_report;