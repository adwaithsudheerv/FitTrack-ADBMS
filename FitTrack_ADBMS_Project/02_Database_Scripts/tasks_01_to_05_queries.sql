-- ============================================================================
-- FitTrack: Smart Gym Management System
-- ADBMS Tasks 1 through 5: Core SQL, Subqueries, Joins, CTEs, Views
-- ============================================================================

-- ============================================================================
-- TASK 1: Basic SQL Queries - DDL, DML, DCL, and TCL
-- ============================================================================

-- 1.1 DML: Update product/plan price and branch equipment quantity
UPDATE MEMBERSHIP_PLAN
SET base_price = base_price * 1.05
WHERE duration_months >= 12;

UPDATE BRANCH_EQUIPMENT
SET quantity = quantity + 2
WHERE category = 'Cardio' AND branch_id = 101;

-- 1.2 DML: Delete an unreferenced discontinued plan or inactive cart item
DELETE FROM CART_ITEM
WHERE cart_id = 1010 AND plan_id = 710;

-- 1.3 DCL: Create database roles and grant/revoke privileges
-- (Standard ANSI / PostgreSQL / Oracle syntax)
/*
CREATE ROLE gym_admin;
CREATE ROLE gym_trainer;
CREATE ROLE gym_member;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gym_admin;
GRANT SELECT ON CLASS_SCHEDULE, BOOKING, TRAINER_REVIEW TO gym_trainer;
GRANT UPDATE (availability_status) ON TRAINER TO gym_trainer;
GRANT SELECT ON MEMBERSHIP_PLAN, PLAN_CATEGORY, CLASS_SCHEDULE TO gym_member;
GRANT SELECT, INSERT ON BOOKING, SUBSCRIPTION_CART, CART_ITEM TO gym_member;

REVOKE DELETE ON MEMBERSHIP_PLAN FROM gym_trainer;
*/

-- 1.4 TCL: Demonstrate atomic transaction processing during member enrollment
-- Scenario: Member 302 enrolls in Plan 707 at Branch 101, creates subscription, items, and payment.
BEGIN TRANSACTION;

-- Step A: Insert Subscription Contract
INSERT INTO MEMBER_SUBSCRIPTION (subscription_id, member_id, plan_id, branch_id, start_date, end_date, total_amount, status)
VALUES (1411, 302, 707, 101, '2026-11-20', '2027-11-19', 38000.00, 'ACTIVE');

-- Step B: Insert Subscription Line Items
INSERT INTO SUBSCRIPTION_ITEM (item_id, subscription_id, item_name, quantity, unit_price)
VALUES (1511, 1411, 'Black Diamond Annual Pass', 1, 38000.00);

-- Step C: Record Successful Payment
INSERT INTO PAYMENT (payment_id, subscription_id, payment_mode, amount, payment_status, payment_date)
VALUES (1611, 1411, 'UPI', 38000.00, 'SUCCESS', CURRENT_TIMESTAMP);

-- Step D: Generate Invoice
INSERT INTO INVOICE (invoice_id, payment_id, invoice_number, invoice_date, tax_rate_percent, tax_amount, final_total)
VALUES (1711, 1611, 'INV-FT-2026-011', '2026-11-20', 18.00, 6840.00, 44840.00);

-- Commit transaction safely
COMMIT;

-- Rollback scenario demonstration (e.g. invalid member or payment failure):
BEGIN TRANSACTION;
INSERT INTO MEMBER_SUBSCRIPTION (subscription_id, member_id, plan_id, branch_id, start_date, end_date, total_amount, status)
VALUES (1412, 9999, 701, 101, '2026-11-20', '2027-11-19', 28000.00, 'PENDING');
-- If constraint fails or payment gateway rejects:
ROLLBACK;


-- ============================================================================
-- TASK 2: Subqueries, Nested Subqueries, and Correlated Subqueries
-- ============================================================================

-- 2.1 Display plans whose prices are greater than the average plan price
SELECT plan_id, plan_name, base_price, duration_months
FROM MEMBERSHIP_PLAN
WHERE base_price > (
    SELECT AVG(base_price) 
    FROM MEMBERSHIP_PLAN
);

-- 2.2 Identify members who have purchased at least one subscription
SELECT member_id, full_name, email, phone
FROM MEMBER
WHERE member_id IN (
    SELECT DISTINCT member_id 
    FROM MEMBER_SUBSCRIPTION
);

-- 2.3 Find members whose total purchase amount is greater than the average purchase amount of all members
SELECT m.member_id, m.full_name, SUM(s.total_amount) AS total_spend
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
GROUP BY m.member_id, m.full_name
HAVING SUM(s.total_amount) > (
    SELECT AVG(total_amount) 
    FROM MEMBER_SUBSCRIPTION
);

-- 2.4 Display membership plans that have never been subscribed to
SELECT plan_id, plan_name, base_price
FROM MEMBERSHIP_PLAN
WHERE plan_id NOT IN (
    SELECT DISTINCT plan_id 
    FROM MEMBER_SUBSCRIPTION 
    WHERE plan_id IS NOT NULL
);

-- 2.5 Identify the most expensive plan in each category (Nested Subquery)
SELECT p.category_id, c.category_name, p.plan_id, p.plan_name, p.base_price
FROM MEMBERSHIP_PLAN p
JOIN PLAN_CATEGORY c ON p.category_id = c.category_id
WHERE p.base_price = (
    SELECT MAX(sub_p.base_price)
    FROM MEMBERSHIP_PLAN sub_p
    WHERE sub_p.category_id = p.category_id
);

-- 2.6 Retrieve the latest booking placed by each member using a Correlated Subquery
SELECT b.booking_id, b.member_id, m.full_name, b.class_id, b.booking_date, b.booking_status
FROM BOOKING b
JOIN MEMBER m ON b.member_id = m.member_id
WHERE b.booking_date = (
    SELECT MAX(sub_b.booking_date)
    FROM BOOKING sub_b
    WHERE sub_b.member_id = b.member_id
);


-- ============================================================================
-- TASK 3: Joins and Set Operations
-- ============================================================================

-- 3.1 Display member names along with their subscription details using INNER JOIN
SELECT m.member_id, m.full_name, s.subscription_id, p.plan_name, s.start_date, s.end_date, s.total_amount
FROM MEMBER m
INNER JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
INNER JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id;

-- 3.2 Display all members, including members who have not placed any subscriptions, using LEFT OUTER JOIN
SELECT m.member_id, m.full_name, m.email, s.subscription_id, s.status, s.total_amount
FROM MEMBER m
LEFT OUTER JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id;

-- 3.3 Display all branches and equipment inventory, including branches without equipment, using LEFT/FULL OUTER JOIN
SELECT b.branch_id, b.branch_name, e.equipment_id, e.equipment_name, e.quantity, e.condition_status
FROM GYM_BRANCH b
LEFT OUTER JOIN BRANCH_EQUIPMENT e ON b.branch_id = e.branch_id;

-- 3.4 Retrieve plan and category information using NATURAL JOIN
-- (Works when matching on identical category_id column name)
SELECT plan_id, plan_name, category_id, category_name, base_price
FROM MEMBERSHIP_PLAN
NATURAL JOIN PLAN_CATEGORY;

-- 3.5 Use SELF JOIN to display parent and sub-categories in the category hierarchy
SELECT 
    child.category_id AS sub_category_id,
    child.category_name AS sub_category_name,
    parent.category_id AS parent_category_id,
    parent.category_name AS parent_category_name
FROM PLAN_CATEGORY child
LEFT JOIN PLAN_CATEGORY parent ON child.parent_category_id = parent.category_id;

-- 3.6 Display members who enrolled in Strength (Category 602) OR Cardio (Category 603) using UNION
SELECT DISTINCT m.member_id, m.full_name, 'Strength' AS category_enrolled
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
WHERE p.category_id IN (602, 605, 606)

UNION

SELECT DISTINCT m.member_id, m.full_name, 'Cardio' AS category_enrolled
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
WHERE p.category_id IN (603, 607, 608);

-- 3.7 Identify members who subscribed to BOTH Strength AND Cardio categories using INTERSECT
SELECT m.member_id, m.full_name
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
WHERE p.category_id IN (602, 605, 606)

INTERSECT

SELECT m.member_id, m.full_name
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
WHERE p.category_id IN (603, 607, 608);

-- 3.8 Identify members who subscribed to Strength but NEVER subscribed to Cardio using EXCEPT (or MINUS in Oracle)
SELECT m.member_id, m.full_name
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
WHERE p.category_id IN (602, 605, 606)

EXCEPT

SELECT m.member_id, m.full_name
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
WHERE p.category_id IN (603, 607, 608);


-- ============================================================================
-- TASK 4: EXISTS, WITH Clause (CTEs) and Recursive Queries
-- ============================================================================

-- 4.1 Use EXISTS to display members who have placed active class bookings
SELECT m.member_id, m.full_name, m.phone
FROM MEMBER m
WHERE EXISTS (
    SELECT 1 
    FROM BOOKING b 
    WHERE b.member_id = m.member_id 
      AND b.booking_status = 'CONFIRMED'
);

-- 4.2 Use NOT EXISTS to identify trainers who have never conducted or been assigned a class
SELECT t.trainer_id, t.full_name, t.specialization, t.hourly_rate
FROM TRAINER t
WHERE NOT EXISTS (
    SELECT 1 
    FROM CLASS_SCHEDULE c 
    WHERE c.trainer_id = t.trainer_id
);

-- 4.3 Use a WITH clause (CTE) to calculate branch-wise total membership revenue
WITH BranchRevenueCTE AS (
    SELECT 
        b.branch_id,
        b.branch_name,
        COUNT(s.subscription_id) AS total_subscriptions,
        COALESCE(SUM(s.total_amount), 0) AS total_revenue
    FROM GYM_BRANCH b
    LEFT JOIN MEMBER_SUBSCRIPTION s ON b.branch_id = s.branch_id
    GROUP BY b.branch_id, b.branch_name
)
SELECT branch_id, branch_name, total_subscriptions, total_revenue
FROM BranchRevenueCTE
ORDER BY total_revenue DESC;

-- 4.4 Use CTEs to identify the top 5 members based on total purchase value
WITH MemberSpendRankCTE AS (
    SELECT 
        m.member_id,
        m.full_name,
        m.email,
        SUM(s.total_amount) AS total_spent,
        DENSE_RANK() OVER (ORDER BY SUM(s.total_amount) DESC) AS spend_rank
    FROM MEMBER m
    JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
    GROUP BY m.member_id, m.full_name, m.email
)
SELECT member_id, full_name, email, total_spent, spend_rank
FROM MemberSpendRankCTE
WHERE spend_rank <= 5;

-- 4.5 Recursive Query: Retrieve the complete workout plan category hierarchy
WITH RECURSIVE CategoryHierarchy AS (
    -- Anchor Member: Root Categories
    SELECT 
        category_id, 
        category_name, 
        parent_category_id, 
        1 AS level,
        CAST(category_name AS VARCHAR(255)) AS full_path
    FROM PLAN_CATEGORY
    WHERE parent_category_id IS NULL

    UNION ALL

    -- Recursive Member: Child Categories
    SELECT 
        child.category_id, 
        child.category_name, 
        child.parent_category_id, 
        parent.level + 1 AS level,
        CAST(parent.full_path || ' -> ' || child.category_name AS VARCHAR(255)) AS full_path
    FROM PLAN_CATEGORY child
    INNER JOIN CategoryHierarchy parent ON child.parent_category_id = parent.category_id
)
SELECT category_id, category_name, parent_category_id, level, full_path
FROM CategoryHierarchy
ORDER BY level, category_id;


-- ============================================================================
-- TASK 5: Views and View Operations
-- ============================================================================

-- 5.1 Create View 1: Customer_Order_View -> Member_Subscription_View
DROP VIEW IF EXISTS Member_Subscription_View;
CREATE VIEW Member_Subscription_View AS
SELECT 
    m.member_id,
    m.full_name,
    m.email,
    m.phone,
    s.subscription_id,
    p.plan_name,
    s.start_date,
    s.end_date,
    s.total_amount,
    s.status AS subscription_status
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id;

-- 5.2 Create View 2: Product_Inventory_View -> Branch_Equipment_Inventory_View
DROP VIEW IF EXISTS Branch_Equipment_Inventory_View;
CREATE VIEW Branch_Equipment_Inventory_View AS
SELECT 
    e.equipment_id,
    e.equipment_name,
    e.category,
    b.branch_id,
    b.branch_name,
    v.vendor_name,
    e.quantity,
    e.condition_status,
    e.last_serviced_date
FROM BRANCH_EQUIPMENT e
JOIN GYM_BRANCH b ON e.branch_id = b.branch_id
JOIN EQUIPMENT_VENDOR v ON e.vendor_id = v.vendor_id;

-- 5.3 Create View 3: Monthly_Sales_View -> Monthly_Revenue_View
DROP VIEW IF EXISTS Monthly_Revenue_View;
CREATE VIEW Monthly_Revenue_View AS
SELECT 
    SUBSTR(payment_date, 1, 7) AS payment_month,
    payment_mode,
    COUNT(payment_id) AS total_transactions,
    SUM(amount) AS gross_revenue
FROM PAYMENT
WHERE payment_status = 'SUCCESS'
GROUP BY SUBSTR(payment_date, 1, 7), payment_mode;

-- 5.4 Create View 4: Store_Product_View -> Trainer_Class_Schedule_View
DROP VIEW IF EXISTS Trainer_Class_Schedule_View;
CREATE VIEW Trainer_Class_Schedule_View AS
SELECT 
    c.class_id,
    c.class_name,
    b.branch_name,
    t.full_name AS trainer_name,
    t.specialization,
    c.start_time,
    c.end_time,
    c.max_capacity,
    c.status AS class_status
FROM CLASS_SCHEDULE c
JOIN GYM_BRANCH b ON c.branch_id = b.branch_id
JOIN TRAINER t ON c.trainer_id = t.trainer_id;

-- 5.5 Querying the Views
SELECT * FROM Member_Subscription_View WHERE subscription_status = 'ACTIVE';
SELECT * FROM Branch_Equipment_Inventory_View WHERE condition_status = 'OPERATIONAL';
SELECT * FROM Monthly_Revenue_View ORDER BY payment_month DESC;
SELECT * FROM Trainer_Class_Schedule_View WHERE class_status = 'SCHEDULED';

-- 5.6 Updatable View demonstration
-- Create a simple single-table view (meets updatable view criteria)
DROP VIEW IF EXISTS Updatable_Trainer_Contact_View;
CREATE VIEW Updatable_Trainer_Contact_View AS
SELECT trainer_id, full_name, phone, availability_status
FROM TRAINER;

-- Perform update through the view:
UPDATE Updatable_Trainer_Contact_View
SET availability_status = 'AVAILABLE'
WHERE trainer_id = 505;

-- 5.7 Altering / Modifying Views
-- Drop and re-create with additional attributes
DROP VIEW IF EXISTS Member_Subscription_View;
CREATE VIEW Member_Subscription_View AS
SELECT 
    m.member_id,
    m.full_name,
    m.email,
    m.phone,
    gb.branch_name,
    s.subscription_id,
    p.plan_name,
    s.start_date,
    s.end_date,
    s.total_amount,
    s.status AS subscription_status
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
JOIN GYM_BRANCH gb ON s.branch_id = gb.branch_id;

-- 5.8 Explanation of Restrictions on Updating Complex Views:
-- 1. Views containing joins (e.g. Member_Subscription_View) cannot update multiple base tables simultaneously.
-- 2. Views containing aggregate functions (SUM, AVG, COUNT, MIN, MAX) are non-updatable because there is no 1-to-1 row correspondence.
-- 3. Views containing GROUP BY or HAVING clauses cannot accept INSERT, UPDATE, or DELETE statements.
-- 4. Views containing DISTINCT or UNION/INTERSECT/EXCEPT cannot be updated because individual underlying tuple identity is ambiguous.
