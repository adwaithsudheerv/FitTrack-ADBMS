-- ============================================================================
-- FitTrack: Smart Gym Management System
-- ADBMS Lab Project: Database Schema DDL
-- Compatible with ANSI SQL, PostgreSQL, SQLite, and Oracle RDBMS
-- ============================================================================

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS REFUND;
DROP TABLE IF EXISTS ATTENDANCE_LOG;
DROP TABLE IF EXISTS SUBSCRIPTION_COUPON;
DROP TABLE IF EXISTS COUPON;
DROP TABLE IF EXISTS TRAINER_REVIEW;
DROP TABLE IF EXISTS INVOICE;
DROP TABLE IF EXISTS PAYMENT;
DROP TABLE IF EXISTS SUBSCRIPTION_ITEM;
DROP TABLE IF EXISTS MEMBER_SUBSCRIPTION;
DROP TABLE IF EXISTS BOOKING;
DROP TABLE IF EXISTS CLASS_SCHEDULE;
DROP TABLE IF EXISTS CART_ITEM;
DROP TABLE IF EXISTS SUBSCRIPTION_CART;
DROP TABLE IF EXISTS BRANCH_EQUIPMENT;
DROP TABLE IF EXISTS PLAN_SPECIFICATION;
DROP TABLE IF EXISTS MEMBERSHIP_PLAN;
DROP TABLE IF EXISTS PLAN_CATEGORY;
DROP TABLE IF EXISTS TRAINER;
DROP TABLE IF EXISTS MEMBER_PROFILE;
DROP TABLE IF EXISTS MEMBER;
DROP TABLE IF EXISTS EQUIPMENT_VENDOR;
DROP TABLE IF EXISTS GYM_BRANCH;
DROP TABLE IF EXISTS ADDRESS;

-- 1. ADDRESS
CREATE TABLE ADDRESS (
    address_id INT PRIMARY KEY,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    pincode VARCHAR(10) NOT NULL
);

-- 2. GYM_BRANCH
CREATE TABLE GYM_BRANCH (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    address_id INT NOT NULL,
    contact_phone VARCHAR(20) NOT NULL,
    opening_time VARCHAR(10) DEFAULT '06:00 AM',
    closing_time VARCHAR(10) DEFAULT '10:00 PM',
    FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id)
);

-- 3. EQUIPMENT_VENDOR
CREATE TABLE EQUIPMENT_VENDOR (
    vendor_id INT PRIMARY KEY,
    vendor_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(20) NOT NULL,
    tax_id VARCHAR(30) UNIQUE NOT NULL
);

-- 4. MEMBER
CREATE TABLE MEMBER (
    member_id INT PRIMARY KEY,
    branch_id INT NOT NULL,
    address_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    join_date DATE NOT NULL,
    role VARCHAR(20) CHECK (role IN ('MEMBER', 'TRAINER', 'ADMIN')),
    FOREIGN KEY (branch_id) REFERENCES GYM_BRANCH(branch_id),
    FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id)
);

-- 5. MEMBER_PROFILE
CREATE TABLE MEMBER_PROFILE (
    profile_id INT PRIMARY KEY,
    member_id INT UNIQUE NOT NULL,
    dob DATE NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    height_cm DECIMAL(5, 2) CHECK (height_cm > 0),
    weight_kg DECIMAL(5, 2) CHECK (weight_kg > 0),
    emergency_contact VARCHAR(20) NOT NULL,
    medical_notes_json TEXT,
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id) ON DELETE CASCADE
);

-- 6. TRAINER
CREATE TABLE TRAINER (
    trainer_id INT PRIMARY KEY,
    branch_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    hourly_rate DECIMAL(10, 2) CHECK (hourly_rate >= 0),
    availability_status VARCHAR(20) CHECK (availability_status IN ('AVAILABLE', 'IN_SESSION', 'ON_LEAVE')),
    FOREIGN KEY (branch_id) REFERENCES GYM_BRANCH(branch_id)
);

-- 7. PLAN_CATEGORY (Hierarchical: self-referencing foreign key)
CREATE TABLE PLAN_CATEGORY (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    parent_category_id INT NULL,
    FOREIGN KEY (parent_category_id) REFERENCES PLAN_CATEGORY(category_id)
);

-- 8. MEMBERSHIP_PLAN
CREATE TABLE MEMBERSHIP_PLAN (
    plan_id INT PRIMARY KEY,
    category_id INT NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    duration_months INT CHECK (duration_months > 0),
    base_price DECIMAL(10, 2) CHECK (base_price >= 0),
    description TEXT,
    FOREIGN KEY (category_id) REFERENCES PLAN_CATEGORY(category_id)
);

-- 9. PLAN_SPECIFICATION (Semi-structured JSON specs)
CREATE TABLE PLAN_SPECIFICATION (
    spec_id INT PRIMARY KEY,
    plan_id INT NOT NULL,
    specification_json TEXT NOT NULL,
    FOREIGN KEY (plan_id) REFERENCES MEMBERSHIP_PLAN(plan_id) ON DELETE CASCADE
);

-- 10. BRANCH_EQUIPMENT
CREATE TABLE BRANCH_EQUIPMENT (
    equipment_id INT PRIMARY KEY,
    branch_id INT NOT NULL,
    vendor_id INT NOT NULL,
    equipment_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    quantity INT CHECK (quantity >= 0),
    condition_status VARCHAR(30) CHECK (condition_status IN ('OPERATIONAL', 'UNDER_MAINTENANCE', 'RETIRED')),
    last_serviced_date DATE NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES GYM_BRANCH(branch_id),
    FOREIGN KEY (vendor_id) REFERENCES EQUIPMENT_VENDOR(vendor_id)
);

-- 11. SUBSCRIPTION_CART
CREATE TABLE SUBSCRIPTION_CART (
    cart_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id) ON DELETE CASCADE
);

-- 12. CART_ITEM
CREATE TABLE CART_ITEM (
    cart_item_id INT PRIMARY KEY,
    cart_id INT NOT NULL,
    plan_id INT NOT NULL,
    quantity INT CHECK (quantity > 0),
    FOREIGN KEY (cart_id) REFERENCES SUBSCRIPTION_CART(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES MEMBERSHIP_PLAN(plan_id)
);

-- 13. CLASS_SCHEDULE
CREATE TABLE CLASS_SCHEDULE (
    class_id INT PRIMARY KEY,
    branch_id INT NOT NULL,
    trainer_id INT NOT NULL,
    class_name VARCHAR(100) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    max_capacity INT CHECK (max_capacity > 0),
    status VARCHAR(20) CHECK (status IN ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    FOREIGN KEY (branch_id) REFERENCES GYM_BRANCH(branch_id),
    FOREIGN KEY (trainer_id) REFERENCES TRAINER(trainer_id)
);

-- 14. BOOKING
CREATE TABLE BOOKING (
    booking_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    class_id INT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    booking_status VARCHAR(20) CHECK (booking_status IN ('CONFIRMED', 'WAITLISTED', 'CANCELLED', 'ATTENDED')),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (class_id) REFERENCES CLASS_SCHEDULE(class_id)
);

-- 15. MEMBER_SUBSCRIPTION
CREATE TABLE MEMBER_SUBSCRIPTION (
    subscription_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    plan_id INT NOT NULL,
    branch_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) CHECK (total_amount >= 0),
    status VARCHAR(20) CHECK (status IN ('ACTIVE', 'EXPIRED', 'CANCELLED', 'PENDING')),
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (plan_id) REFERENCES MEMBERSHIP_PLAN(plan_id),
    FOREIGN KEY (branch_id) REFERENCES GYM_BRANCH(branch_id)
);

-- 16. SUBSCRIPTION_ITEM
CREATE TABLE SUBSCRIPTION_ITEM (
    item_id INT PRIMARY KEY,
    subscription_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    quantity INT CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) CHECK (unit_price >= 0),
    FOREIGN KEY (subscription_id) REFERENCES MEMBER_SUBSCRIPTION(subscription_id) ON DELETE CASCADE
);

-- 17. PAYMENT
CREATE TABLE PAYMENT (
    payment_id INT PRIMARY KEY,
    subscription_id INT NOT NULL,
    payment_mode VARCHAR(20) CHECK (payment_mode IN ('UPI', 'CREDIT_CARD', 'DEBIT_CARD', 'CASH', 'NET_BANKING')),
    amount DECIMAL(10, 2) CHECK (amount > 0),
    payment_status VARCHAR(20) CHECK (payment_status IN ('SUCCESS', 'FAILED', 'PENDING')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subscription_id) REFERENCES MEMBER_SUBSCRIPTION(subscription_id)
);

-- 18. INVOICE
CREATE TABLE INVOICE (
    invoice_id INT PRIMARY KEY,
    payment_id INT NOT NULL,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    invoice_date DATE NOT NULL,
    tax_rate_percent DECIMAL(5, 2) DEFAULT 18.00,
    tax_amount DECIMAL(10, 2) CHECK (tax_amount >= 0),
    final_total DECIMAL(10, 2) CHECK (final_total >= 0),
    FOREIGN KEY (payment_id) REFERENCES PAYMENT(payment_id)
);

-- 19. TRAINER_REVIEW
CREATE TABLE TRAINER_REVIEW (
    review_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    trainer_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    review_date DATE NOT NULL,
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (trainer_id) REFERENCES TRAINER(trainer_id)
);

-- 20. COUPON
CREATE TABLE COUPON (
    coupon_id INT PRIMARY KEY,
    coupon_code VARCHAR(30) UNIQUE NOT NULL,
    discount_percentage DECIMAL(5, 2) CHECK (discount_percentage BETWEEN 1 AND 100),
    min_order_amount DECIMAL(10, 2) CHECK (min_order_amount >= 0),
    valid_until DATE NOT NULL
);

-- 21. SUBSCRIPTION_COUPON
CREATE TABLE SUBSCRIPTION_COUPON (
    subscription_id INT NOT NULL,
    coupon_id INT NOT NULL,
    PRIMARY KEY (subscription_id, coupon_id),
    FOREIGN KEY (subscription_id) REFERENCES MEMBER_SUBSCRIPTION(subscription_id),
    FOREIGN KEY (coupon_id) REFERENCES COUPON(coupon_id)
);

-- 22. ATTENDANCE_LOG
CREATE TABLE ATTENDANCE_LOG (
    log_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    branch_id INT NOT NULL,
    check_in_time TIMESTAMP NOT NULL,
    check_out_time TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (branch_id) REFERENCES GYM_BRANCH(branch_id)
);

-- 23. REFUND
CREATE TABLE REFUND (
    refund_id INT PRIMARY KEY,
    payment_id INT NOT NULL,
    refund_amount DECIMAL(10, 2) CHECK (refund_amount > 0),
    refund_reason VARCHAR(255) NOT NULL,
    refund_status VARCHAR(20) CHECK (refund_status IN ('REQUESTED', 'PROCESSED', 'REJECTED')),
    refund_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES PAYMENT(payment_id)
);

-- ============================================================================
-- VIEWS (Task 5)
-- ============================================================================

-- View 1: Member_Subscription_View
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

-- View 2: Branch_Equipment_Inventory_View
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

-- View 3: Monthly_Revenue_View
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

-- View 4: Trainer_Class_Schedule_View
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



-- ============================================================================
-- 25. ADBMS EVALUATION SUPPORT REGISTRY TABLE
-- ============================================================================
DROP TABLE IF EXISTS new_fittrack_adbms_support_file;
CREATE TABLE new_fittrack_adbms_support_file (
    file_id INT PRIMARY KEY,
    deliverable_no INT NOT NULL,
    deliverable_title VARCHAR(100) NOT NULL,
    task_mapping VARCHAR(100) NOT NULL,
    file_name VARCHAR(100) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);
