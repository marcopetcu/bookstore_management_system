create or replace TRIGGER trg_book_price
    BEFORE UPDATE OF unit_price ON book
    FOR EACH ROW
BEGIN
    IF (:NEW.unit_price > 2 * :OLD.unit_price OR :NEW.unit_price < 0.5 * :OLD.unit_price) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Pret prea mare sau prea mic');
    END IF;
END;