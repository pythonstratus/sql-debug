CREATE OR REPLACE FUNCTION ENTITYDEV.GETASSNQUE_V2(
    etin      IN NUMBER,
    ett       IN NUMBER,
    efs       IN NUMBER,
    assn_cff  IN DATE,
    assn_ro   IN DATE)
RETURN DATE
IS
    quedt     DATE;
    v_default DATE := TO_DATE('01-JAN-1900', 'DD-MON-YYYY');
BEGIN
    -- Initialize with default date
    quedt := v_default;
    
    -- Validate input parameters
    IF etin IS NULL OR ett IS NULL OR efs IS NULL THEN
        RETURN v_default;
    END IF;
    
    BEGIN
        SELECT NVL(MIN(assnque), v_default)
        INTO quedt
        FROM ENTITYDEV.assn
        WHERE tin     = etin
          AND tt      = ett
          AND fs      = efs
          AND assnque <> v_default;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            quedt := v_default;
        WHEN OTHERS THEN
            -- Log error but still return a value
            dbms_output.put_line('GETASSNQUE_V2 error: sqlcode: '||sqlcode||' ERRM: '||sqlerrm);
            quedt := v_default;
    END;
    
    -- Apply the same logic as original function
    IF quedt = v_default THEN
        IF assn_cff = v_default OR assn_cff IS NULL THEN
            quedt := NVL(assn_ro, v_default);
        ELSE
            quedt := assn_cff;
        END IF;
    END IF;
    
    -- ALWAYS return a value
    RETURN quedt;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Catch-all: always return default date
        dbms_output.put_line('GETASSNQUE_V2 outer error: sqlcode: '||sqlcode||' ERRM: '||sqlerrm);
        RETURN v_default;
END GETASSNQUE_V2;
/
