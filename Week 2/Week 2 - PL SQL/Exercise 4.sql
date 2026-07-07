
SET SERVEROUTPUT ON;

-- Scenario 1: 
CREATE OR REPLACE FUNCTION CalculateAge(
    p_DOB IN DATE
) RETURN NUMBER IS
    v_Age NUMBER;
BEGIN
    -- Calculate age
    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, p_DOB) / 12) INTO v_Age FROM dual;
    
    RETURN v_Age;
END CalculateAge;
/

-- Scenario 2: 
CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment(
    p_LoanAmount IN NUMBER,
    p_InterestRate IN NUMBER,
    p_LoanDurationYears IN NUMBER
) RETURN NUMBER IS
    v_MonthlyInstallment NUMBER;
    v_MonthlyRate NUMBER;
    v_TotalMonths NUMBER;
BEGIN
    v_MonthlyRate := p_InterestRate / 12 / 100;
    v_TotalMonths := p_LoanDurationYears * 12;
    
    -- Calculate monthly installment using the formula for an amortizing loan
    v_MonthlyInstallment := (p_LoanAmount * v_MonthlyRate) / (1 - POWER(1 + v_MonthlyRate, -v_TotalMonths));
    
    RETURN v_MonthlyInstallment;
END CalculateMonthlyInstallment;
/

-- Scenario 3: 
CREATE OR REPLACE FUNCTION HasSufficientBalance(
    p_AccountID IN Accounts.AccountID%TYPE,
    p_Amount IN NUMBER
) RETURN BOOLEAN IS
    v_Balance Accounts.Balance%TYPE;
    v_Result BOOLEAN;
BEGIN
    -- Get the current balance of the account
    SELECT Balance INTO v_Balance
    FROM Accounts
    WHERE AccountID = p_AccountID;
    
    -- Check if the account has sufficient balance
    IF v_Balance >= p_Amount THEN
        v_Result := TRUE;
    ELSE
        v_Result := FALSE;
    END IF;
    
    RETURN v_Result;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Account ID ' || p_AccountID || ' does not exist.');
        RETURN FALSE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RETURN FALSE;
END HasSufficientBalance;
/
