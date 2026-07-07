
SET SERVEROUTPUT ON;

-- Scenario 1:
CREATE OR REPLACE PROCEDURE SafeTransferFunds(
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
    
    -- Get the balance of the to account
    SELECT Balance INTO v_ToBalance
    FROM Accounts
    WHERE AccountID = p_ToAccountID;
    
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
END SafeTransferFunds;
/

-- Scenario 2: 
CREATE OR REPLACE PROCEDURE UpdateSalary(
    p_EmployeeID IN Employees.EmployeeID%TYPE,
    p_Percentage IN NUMBER
) IS
    v_Salary Employees.Salary%TYPE;
BEGIN
    -- Get the current salary of the employee
    SELECT Salary INTO v_Salary
    FROM Employees
    WHERE EmployeeID = p_EmployeeID;
    
    -- Update the salary
    UPDATE Employees
    SET Salary = Salary + (Salary * p_Percentage / 100)
    WHERE EmployeeID = p_EmployeeID;
    
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee ID ' || p_EmployeeID || ' does not exist.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END UpdateSalary;
/

-- Scenario 3: 
CREATE OR REPLACE PROCEDURE AddNewCustomer(
    p_CustomerID IN Customers.CustomerID%TYPE,
    p_Name IN Customers.Name%TYPE,
    p_DOB IN Customers.DOB%TYPE,
    p_Balance IN Customers.Balance%TYPE
) IS
BEGIN
    -- Insert a new customer
    INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
    VALUES (p_CustomerID, p_Name, p_DOB, p_Balance, SYSDATE);
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: A customer with ID ' || p_CustomerID || ' already exists.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END AddNewCustomer;
/
