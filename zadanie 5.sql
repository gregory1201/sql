CREATE OR REPLACE PROCEDURE INSERT_JSON_DATA(json_data IN CLOB) IS
    customer_name VARCHAR2(100);
    customer_surname VARCHAR2(100);
    customer_address VARCHAR2(255);
    customer_id NUMBER;
BEGIN
    -- pobranie danych klienta
    SELECT json_value(json_data, '$.klient.imie') INTO customer_name FROM dual;
    SELECT json_value(json_data, '$.klient.nazwisko') INTO customer_surname FROM dual;
    SELECT json_value(json_data, '$.klient.adres') INTO customer_address FROM dual;

    -- wstawienie danych klienta do tabeli CUSTOMERS
    INSERT INTO CUSTOMERS (customer_id, name, surname, address)
    VALUES (CUSTOMERS_SEQ.NEXTVAL, customer_name, customer_surname, customer_address)
    RETURNING customer_id INTO customer_id;

    -- wstawienie zamówieñ do tabeli ORDERS
    FOR i IN 1..json_ext.get_count(json_data, '$.zamowienia') LOOP
        INSERT INTO ORDERS (product, cnt, price, customer_id)
        VALUES (
            json_value(json_data, '$.zamowienia[' || i-1 || '].produkt'),
            json_value(json_data, '$.zamowienia[' || i-1 || '].ilosc'),
            json_value(json_data, '$.zamowienia[' || i-1 || '].cena'),
            customer_id
        );
    END LOOP;
    
    COMMIT;
END;
/