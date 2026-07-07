
SET SERVEROUTPUT ON;

-- Scenario 1: 
    CURSOR customer_cursor IS
        SELECT CustomerID, ROUND(MONTHS_BETWEEN(SYSDATE, DOB) / 12) AS Age
        FROM Customers;
        
    v_CustomerID Customers.CustomerID%TYPE;
    v_Age NUMBER;
BEGIN
    OPEN customer_cursor;
    LOOP
        FETCH customer_cursor INTO v_CustomerID, v_Age;
        EXIT WHEN customer_cursor%NOTFOUND;
        
        IF v_Age > 60 THEN
            UPDATE Loans
            SET InterestRate = InterestRate - 1
            WHERE CustomerID = v_CustomerID;
        END IF;
    END LOOP;
    CLOSE customer_cursor;
    
    COMMIT;
END;
/

-- Scenario 2: 
DECLARE
    CURSOR customer_cursor IS
        SELECT CustomerID, Balance
        FROM Customers;
        
    v_CustomerID Customers.CustomerID%TYPE;
    v_Balance Customers.Balance%TYPE;
BEGIN
    OPEN customer_cursor;
    LOOP
        FETCH customer_cursor INTO v_CustomerID, v_Balance;
        EXIT WHEN customer_cursor%NOTFOUND;
        
        IF v_Balance > 10000 THEN
            UPDATE Customers
            SET IsVIP = 'TRUE'
            WHERE CustomerID = v_CustomerID;
        END IF;
    END LOOP;
    CLOSE customer_cursor;
    
    COMMIT;
END;
/

-- Scenario 3: 
DECLARE
    CURSOR loan_cursor IS
        SELECT LoanID, CustomerID, EndDate
        FROM Loans
        WHERE EndDate BETWEEN SYSDATE AND SYSDATE + 30;
        
    v_LoanID Loans.LoanID%TYPE;
    v_CustomerID Loans.CustomerID%TYPE;
    v_EndDate Loans.EndDate%TYPE;
    v_CustomerName Customers.Name%TYPE;
BEGIN
    OPEN loan_cursor;
    LOOP
        FETCH loan_cursor INTO v_LoanID, v_CustomerID, v_EndDate;
        EXIT WHEN loan_cursor%NOTFOUND;
        
        SELECT Name INTO v_CustomerName
        FROM Customers
        WHERE CustomerID = v_CustomerID;
        
        DBMS_OUTPUT.PUT_LINE('Reminder: Dear ' || v_CustomerName || ', your loan (ID: ' || v_LoanID || ') is due on ' || TO_CHAR(v_EndDate, 'YYYY-MM-DD') || '.');
    END LOOP;
    CLOSE loan_cursor;
END;
/
