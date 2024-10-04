-- procedura do rezerwacji biletu
CREATE OR REPLACE PROCEDURE RESERVE_TICKET(
    PESEL IN VARCHAR2,    -- PESEL klienta
    STATUS OUT NUMBER,     -- Status rezerwacji
    IDR OUT VARCHAR2       -- ID rezerwacji
) IS
    total_reservations NUMBER;
BEGIN
    -- sprawdzenie czy bilet zosta� ju� zarezerwowany
    SELECT COUNT(*) INTO total_reservations 
    FROM TICKETS 
    WHERE PESEL = PESEL;

    IF total_reservations > 0 THEN
        STATUS := 1;  -- bilet zarezerwowany
    ELSE
        -- sprawdzenie czy jest jeszcze miejsce
        SELECT COUNT(*) INTO total_reservations 
        FROM TICKETS;

        IF total_reservations >= 50000 THEN
            STATUS := 2;  -- limit rezerwacji
        ELSE
            IDR := SYS_GUID();  
            INSERT INTO TICKETS (IDR, PESEL) VALUES (IDR, PESEL);
            COMMIT;
            STATUS := 0;  --udana rezerwacja
        END IF;
    END IF;
END;
/
