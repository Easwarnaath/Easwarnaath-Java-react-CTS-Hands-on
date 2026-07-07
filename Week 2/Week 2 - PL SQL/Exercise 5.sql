
SET SERVEROUTPUT ON;
CREATE TABLE AuditLog (
    AuditID NUMBER PRIMARY KEY,
    TransactionID NUMBER,
    ActionDate DATE,
    ActionType VARCHAR2(50),
    Details VARCHAR2(255)
);
-- Scenario 1: 
CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    :NEW.LastModified := SYSDATE;
END UpdateCustomerLastModified;
/

-- Scenario 2:
CREATE OR REPLACE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (AuditID, TransactionID, ActionDate, ActionType, Details)
    VALUES (AuditLog_seq.NEXTVAL, :NEW.TransactionID, SYSDATE, 'INSERT', 'Transaction inserted with amount ' || :NEW.Amount);
END LogTransaction;
/

-- Scenario 3: 
CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
    v_Balance Accounts.Balance%TYPE;
BEGIN
    -- Ensure deposits are positive
    IF :NEW.TransactionType = 'Deposit' AND :NEW.Amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Deposit amount must be positive.');
    END IF;

    -- Ensure withdrawals do not exceed the balance
    IF :NEW.TransactionType = 'Withdrawal' THEN
        SELECT Balance INTO v_Balance
        FROM Accounts
        WHERE AccountID = :NEW.AccountID;
        
        IF v_Balance < :NEW.Amount THEN
            RAISE_APPLICATION_ERROR(-20002, 'Insufficient funds for withdrawal.');
        END IF;
    END IF;
END CheckTransactionRules;
/
