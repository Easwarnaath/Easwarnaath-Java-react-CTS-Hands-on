-- Enable server output
SET SERVEROUTPUT ON;

-- Scenario 1: 
DECLARE
    CURSOR c_Transactions IS
        SELECT c.CustomerID, c.Name, t.TransactionDate, t.Amount, t.TransactionType
        FROM Customers c
        JOIN Accounts a ON c.CustomerID = a.CustomerID
        JOIN Transactions t ON a.AccountID = t.AccountID
        WHERE EXTRACT(MONTH FROM t.TransactionDate) = EXTRACT(MONTH FROM SYSDATE)
          AND EXTRACT(YEAR FROM t.TransactionDate) = EXTRACT(YEAR FROM SYSDATE);
    
    v_CustomerID Customers.CustomerID%TYPE;
    v_CustomerName Customers.Name%TYPE;
    v_TransactionDate Transactions.TransactionDate%TYPE;
    v_Amount Transactions.Amount%TYPE;
    v_TransactionType Transactions.TransactionType%TYPE;
BEGIN
    FOR rec IN c_Transactions LOOP
        v_CustomerID := rec.CustomerID;
        v_CustomerName := rec.Name;
        v_TransactionDate := rec.TransactionDate;
        v_Amount := rec.Amount;
        v_TransactionType := rec.TransactionType;

        DBMS_OUTPUT.PUT_LINE('Statement for Customer ID: ' || v_CustomerID);
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_CustomerName);
        DBMS_OUTPUT.PUT_LINE('Date: ' || v_TransactionDate);
        DBMS_OUTPUT.PUT_LINE('Amount: ' || v_Amount);
        DBMS_OUTPUT.PUT_LINE('Type: ' || v_TransactionType);
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;
END;
/

-- Scenario 2: 
DECLARE
    CURSOR c_Accounts IS
        SELECT AccountID, Balance
        FROM Accounts;
    
    v_AccountID Accounts.AccountID%TYPE;
    v_Balance Accounts.Balance%TYPE;
    v_AnnualFee NUMBER := 50; -- Example annual fee amount
BEGIN
    FOR rec IN c_Accounts LOOP
        v_AccountID := rec.AccountID;
        v_Balance := rec.Balance;

        -- Deduct the annual fee from the balance
        UPDATE Accounts
        SET Balance = Balance - v_AnnualFee
        WHERE AccountID = v_AccountID;

        DBMS_OUTPUT.PUT_LINE('Applied annual fee to Account ID: ' || v_AccountID);
        DBMS_OUTPUT.PUT_LINE('New Balance: ' || v_Balance - v_AnnualFee);
    END LOOP;
    
    COMMIT;
END;
/

-- Scenario 3: 
DECLARE
    CURSOR c_Loans IS
        SELECT LoanID, InterestRate
        FROM Loans;
    
    v_LoanID Loans.LoanID%TYPE;
    v_CurrentInterestRate Loans.InterestRate%TYPE;
    v_NewInterestRate NUMBER;
BEGIN
    -- Define new interest rate policy (example: increase by 0.5%)
    v_NewInterestRate := 0.005;

    FOR rec IN c_Loans LOOP
        v_LoanID := rec.LoanID;
        v_CurrentInterestRate := rec.InterestRate;

        -- Update the interest rate based on the new policy
        UPDATE Loans
        SET InterestRate = v_CurrentInterestRate + v_NewInterestRate
        WHERE LoanID = v_LoanID;

        DBMS_OUTPUT.PUT_LINE('Updated Loan ID: ' || v_LoanID);
        DBMS_OUTPUT.PUT_LINE('Old Interest Rate: ' || v_CurrentInterestRate);
        DBMS_OUTPUT.PUT_LINE('New Interest Rate: ' || v_CurrentInterestRate + v_NewInterestRate);
    END LOOP;
    
    COMMIT;
END;
/
