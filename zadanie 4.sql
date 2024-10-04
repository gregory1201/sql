
CREATE OR REPLACE FUNCTION SUM_ORDERS_BY_DATE(
    StartDate IN DATE, 
    EndDate IN DATE
) RETURN SYS_REFCURSOR IS
    orders_cursor SYS_REFCURSOR;
BEGIN
    OPEN orders_cursor FOR
    SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL_AMOUNT
    FROM ORDERS
    WHERE ORDER_DATE BETWEEN StartDate AND EndDate
    GROUP BY CUSTOMER_ID
    ORDER BY TOTAL_AMOUNT DESC;

    RETURN orders_cursor;
END;
/