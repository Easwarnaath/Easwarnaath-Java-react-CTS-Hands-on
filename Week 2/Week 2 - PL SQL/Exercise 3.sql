
SET SERVEROUTPUT ON;

-- Scenario 1:
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
    v_InterestRate NUMBER := 0.01; -- 1% interest rate
BEGIN
    -- Update balance for all savings accounts
    UPDATE Accounts
    SET Balance = Balance * (1 + v_InterestRate)
    WHERE AccountType = 'Savings';
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Monthly interest applied to all savings accounts.');
END ProcessMonthlyInterest;
/

-- Scenario 2: 
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    p_Department IN Employees.Department%TYPE,
    p_BonusPercentage IN NUMBER
) IS
BEGIN
    -- Update the salary of employees in the specified department
    UPDATE Employees
    SET Salary = Salary + (Salary * p_BonusPercentage / 100)
    WHERE Department = p_Department;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Bonus updated for employees in department: ' || p_Department);
END UpdateEmployeeBonus;
/

-- Scenario 3:
CREATE OR REPLACE PROCEDURE TransferFunds(
    p_FromAccountID IN Accounts.AccountID%TYPE,
    p_ToAccountID IN Accounts.AccountID%TYPE,
    p_Amount IN Accounts.Balance%TYPE
) IS
    v_FromBalance Accounts.Balance%TYPE;
    v_ToBalance Accounts.Balance%TYPE;
    insufficient_funds EXCEPTION;
    account_not_found EXCEPTION;
BEGIN
    -- Get the balance of the from account
    SELECT Balance INTO v_FromBalance
    FROM Accounts
    WHERE AccountID = p_FromAccountID;
    
    -- Check if the from account has sufficient funds
    IF v_FromBalance < p_Amount THEN
        RAISE insufficient_funds;
    END IF;
    
    -- Perform the transfer
    UPDATE Accounts
    SET Balance = Balance - p_Amount
    WHERE AccountID = p_FromAccountID;
    
    UPDATE Accounts
    SET Balance = Balance + p_Amount
    WHERE AccountID = p_ToAccountID;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Transferred ' || p_Amount || ' from account ' || p_FromAccountID || ' to account ' || p_ToAccountID);
EXCEPTION
    WHEN insufficient_funds THEN
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient funds in the from account.');
        ROLLBACK;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: One or both account IDs do not exist.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END TransferFunds;
/
