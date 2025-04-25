create or replace TRIGGER trg_purchase_order
    BEFORE INSERT OR UPDATE OR DELETE ON purchase_order
BEGIN
    IF (TO_CHAR(SYSDATE, 'D') = 1) OR (TO_CHAR(SYSDATE, 'HH24') NOT BETWEEN 8 AND 20)
    THEN RAISE_APPLICATION_ERROR(-20001, 'Actualizarile tabelului purchase_order sunt permise doar intre orele 8 si 20, de luni pana sambata.');
    END IF;
END;