SET SERVEROUTPUT ON;

-- Scenario 1: 

-- Package Specification for CustomerManagement
CREATE OR REPLACE PACKAGE CustomerManagement AS
    PROCEDURE AddNewCustomer(p_CustomerID IN NUMBER, p_Name IN VARCHAR2, p_DOB IN DATE, p_Balance IN NUMBER);
    PROCEDURE UpdateCustomerDetails(p_CustomerID IN NUMBER, p_Name IN VARCHAR2, p_Balance IN NUMBER);
    FUNCTION GetCustomerBalance(p_CustomerID IN NUMBER) RETURN NUMBER;
END CustomerManagement;
/


CREATE OR REPLACE PACKAGE BODY CustomerManagement AS

    PROCEDURE AddNewCustomer(p_CustomerID IN NUMBER, p_Name IN VARCHAR2, p_DOB IN DATE, p_Balance IN NUMBER) IS
    BEGIN
        BEGIN
            INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
            VALUES (p_CustomerID, p_Name, p_DOB, p_Balance, SYSDATE);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || p_CustomerID || ' already exists.');
        END;
    END AddNewCustomer;

    PROCEDURE UpdateCustomerDetails(p_CustomerID IN NUMBER, p_Name IN VARCHAR2, p_Balance IN NUMBER) IS
    BEGIN
        UPDATE Customers
        SET Name = p_Name, Balance = p_Balance, LastModified = SYSDATE
        WHERE CustomerID = p_CustomerID;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || p_CustomerID || ' does not exist.');
        END IF;
    END UpdateCustomerDetails;

    FUNCTION GetCustomerBalance(p_CustomerID IN NUMBER) RETURN NUMBER IS
        v_Balance NUMBER;
    BEGIN
        SELECT Balance INTO v_Balance
        FROM Customers
        WHERE CustomerID = p_CustomerID;

        RETURN v_Balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || p_CustomerID || ' does not exist.');
            RETURN NULL;
    END GetCustomerBalance;

END CustomerManagement;
/

-- Scenario 2: 

-- Package Specification for EmployeeManagement
CREATE OR REPLACE PACKAGE EmployeeManagement AS
    PROCEDURE HireNewEmployee(p_EmployeeID IN NUMBER, p_Name IN VARCHAR2, p_Position IN VARCHAR2, p_Salary IN NUMBER, p_Department IN VARCHAR2);
    PROCEDURE UpdateEmployeeDetails(p_EmployeeID IN NUMBER, p_Name IN VARCHAR2, p_Salary IN NUMBER, p_Position IN VARCHAR2);
    FUNCTION CalculateAnnualSalary(p_EmployeeID IN NUMBER) RETURN NUMBER;
END EmployeeManagement;
/

-- Package Body for EmployeeManagement
CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS

    PROCEDURE HireNewEmployee(p_EmployeeID IN NUMBER, p_Name IN VARCHAR2, p_Position IN VARCHAR2, p_Salary IN NUMBER, p_Department IN VARCHAR2) IS
    BEGIN
        BEGIN
            INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
            VALUES (p_EmployeeID, p_Name, p_Position, p_Salary, p_Department, SYSDATE);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Error: Employee with ID ' || p_EmployeeID || ' already exists.');
        END;
    END HireNewEmployee;

    PROCEDURE UpdateEmployeeDetails(p_EmployeeID IN NUMBER, p_Name IN VARCHAR2, p_Salary IN NUMBER, p_Position IN VARCHAR2) IS
    BEGIN
        UPDATE Employees
        SET Name = p_Name, Salary = p_Salary, Position = p_Position
        WHERE EmployeeID = p_EmployeeID;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Employee with ID ' || p_EmployeeID || ' does not exist.');
        END IF;
    END UpdateEmployeeDetails;

    FUNCTION CalculateAnnualSalary(p_EmployeeID IN NUMBER) RETURN NUMBER IS
        v_Salary NUMBER;
    BEGIN
        SELECT Salary INTO v_Salary
        FROM Employees
        WHERE EmployeeID = p_EmployeeID;

        RETURN v_Salary * 12; -- Assuming salary is monthly
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Employee with ID ' || p_EmployeeID || ' does not exist.');
            RETURN NULL;
    END CalculateAnnualSalary;

END EmployeeManagement;
/

-- Scenario 3: 

-- Package Specification for AccountOperations
CREATE OR REPLACE PACKAGE AccountOperations AS
    PROCEDURE OpenNewAccount(p_AccountID IN NUMBER, p_CustomerID IN NUMBER, p_AccountType IN VARCHAR2, p_Balance IN NUMBER);
    PROCEDURE CloseAccount(p_AccountID IN NUMBER);
    FUNCTION GetTotalBalance(p_CustomerID IN NUMBER) RETURN NUMBER;
END AccountOperations;
/

-- Package Body for AccountOperations
CREATE OR REPLACE PACKAGE BODY AccountOperations AS

    PROCEDURE OpenNewAccount(p_AccountID IN NUMBER, p_CustomerID IN NUMBER, p_AccountType IN VARCHAR2, p_Balance IN NUMBER) IS
    BEGIN
        BEGIN
            INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
            VALUES (p_AccountID, p_CustomerID, p_AccountType, p_Balance, SYSDATE);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('Error: Account with ID ' || p_AccountID || ' already exists.');
        END;
    END OpenNewAccount;

    PROCEDURE CloseAccount(p_AccountID IN NUMBER) IS
    BEGIN
        DELETE FROM Accounts
        WHERE AccountID = p_AccountID;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Account with ID ' || p_AccountID || ' does not exist.');
        END IF;
    END CloseAccount;

    FUNCTION GetTotalBalance(p_CustomerID IN NUMBER) RETURN NUMBER IS
        v_TotalBalance NUMBER := 0;
    BEGIN
        FOR rec IN (SELECT Balance FROM Accounts WHERE CustomerID = p_CustomerID) LOOP
            v_TotalBalance := v_TotalBalance + rec.Balance;
        END LOOP;

        RETURN v_TotalBalance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: No accounts found for Customer ID ' || p_CustomerID);
            RETURN NULL;
    END GetTotalBalance;

END AccountOperations;
/
