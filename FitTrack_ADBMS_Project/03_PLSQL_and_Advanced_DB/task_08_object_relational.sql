-- ============================================================================
-- FitTrack: Smart Gym Management System
-- TASK 8: Object-Relational Database Features (ORDBMS)
-- User-Defined Types (UDTs), Member Methods, Type Inheritance, and Object Tables
-- ============================================================================

-- ============================================================================
-- 8.1 Create User-Defined Composite Types (UDTs)
-- ============================================================================

-- Composite Address Type
CREATE OR REPLACE TYPE Address_Type AS OBJECT (
    street   VARCHAR2(100),
    city     VARCHAR2(50),
    state    VARCHAR2(50),
    pincode  VARCHAR2(10)
);
/

-- Health Metrics Type with Member Method for BMI Calculation
CREATE OR REPLACE TYPE Health_Metrics_Type AS OBJECT (
    height_cm    NUMBER(5, 2),
    weight_kg    NUMBER(5, 2),
    blood_group  VARCHAR2(5),
    resting_hr   NUMBER(3),
    MEMBER FUNCTION calculate_bmi RETURN NUMBER
);
/

-- Implement Body for Health_Metrics_Type
CREATE OR REPLACE TYPE BODY Health_Metrics_Type AS
    MEMBER FUNCTION calculate_bmi RETURN NUMBER IS
        v_height_m NUMBER;
    BEGIN
        v_height_m := self.height_cm / 100.0;
        IF v_height_m > 0 THEN
            RETURN ROUND(self.weight_kg / (v_height_m * v_height_m), 2);
        ELSE
            RETURN 0;
        END IF;
    END calculate_bmi;
END;
/

-- Composite Gym Member Type containing embedded Address and Health Metrics Objects
CREATE OR REPLACE TYPE Gym_Member_Type AS OBJECT (
    member_id    NUMBER,
    full_name    VARCHAR2(100),
    email        VARCHAR2(100),
    home_address Address_Type,
    metrics      Health_Metrics_Type,
    MEMBER FUNCTION get_profile_summary RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY Gym_Member_Type AS
    MEMBER FUNCTION get_profile_summary RETURN VARCHAR2 IS
    BEGIN
        RETURN self.full_name || ' | City: ' || self.home_address.city || 
               ' | BMI: ' || TO_CHAR(self.metrics.calculate_bmi());
    END get_profile_summary;
END;
/

-- ============================================================================
-- 8.2 Type Inheritance Hierarchy
-- Base Type: Gym_Plan_Type (NOT FINAL allows derivation)
-- ============================================================================
CREATE OR REPLACE TYPE Gym_Plan_Type AS OBJECT (
    plan_id          NUMBER,
    plan_name        VARCHAR2(100),
    duration_months  NUMBER,
    base_price       NUMBER(10, 2),
    MEMBER FUNCTION get_discounted_price(discount_pct NUMBER) RETURN NUMBER
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY Gym_Plan_Type AS
    MEMBER FUNCTION get_discounted_price(discount_pct NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN ROUND(self.base_price * (1.0 - (discount_pct / 100.0)), 2);
    END get_discounted_price;
END;
/

-- Subtype 1: Personal Training Plan Type (Inherits from Gym_Plan_Type)
CREATE OR REPLACE TYPE Personal_Training_Plan_Type UNDER Gym_Plan_Type (
    pt_sessions_count  NUMBER,
    trainer_tier       VARCHAR2(50),
    diet_chart_included CHAR(1)
);
/

-- Subtype 2: Group Fitness Plan Type (Inherits from Gym_Plan_Type)
CREATE OR REPLACE TYPE Group_Fitness_Plan_Type UNDER Gym_Plan_Type (
    studio_access_level VARCHAR2(50),
    max_classes_per_week NUMBER,
    unlimited_sauna     CHAR(1)
);
/

-- ============================================================================
-- 8.3 Object Tables Creation
-- ============================================================================

-- Table storing structured Gym_Member_Type objects
CREATE TABLE MEMBER_OBJ_TABLE OF Gym_Member_Type (
    member_id PRIMARY KEY,
    email UNIQUE NOT NULL
);

-- Table storing specialized Personal Training Plans
CREATE TABLE PT_PLAN_OBJ_TABLE OF Personal_Training_Plan_Type (
    plan_id PRIMARY KEY
);

-- Table storing specialized Group Fitness Plans
CREATE TABLE GROUP_PLAN_OBJ_TABLE OF Group_Fitness_Plan_Type (
    plan_id PRIMARY KEY
);

-- ============================================================================
-- 8.4 DML: Inserting Structured Object Data
-- ============================================================================
INSERT INTO MEMBER_OBJ_TABLE VALUES (
    Gym_Member_Type(
        301,
        'Rahul Sharma',
        'rahul.sharma@example.com',
        Address_Type('100 Feet Road', 'Bangalore', 'Karnataka', '560038'),
        Health_Metrics_Type(178.50, 76.50, 'O+', 68)
    )
);

INSERT INTO MEMBER_OBJ_TABLE VALUES (
    Gym_Member_Type(
        302,
        'Priya Patel',
        'priya.patel@example.com',
        Address_Type('5th Block Koramangala', 'Bangalore', 'Karnataka', '560095'),
        Health_Metrics_Type(163.00, 58.00, 'B+', 72)
    )
);

-- Insert into inherited object tables
INSERT INTO PT_PLAN_OBJ_TABLE VALUES (
    Personal_Training_Plan_Type(
        701, 'Elite Bodybuilder 1-on-1', 12, 45000.00, 36, 'Master Coach', 'Y'
    )
);

INSERT INTO GROUP_PLAN_OBJ_TABLE VALUES (
    Group_Fitness_Plan_Type(
        702, 'Unlimited Studio All-Access', 6, 18000.00, 'Gold Studio Access', 7, 'Y'
    )
);

-- ============================================================================
-- 8.5 Querying Object Data and Calling Object Methods
-- ============================================================================

-- Query 1: Extract individual structured object attributes (dot notation)
SELECT 
    m.member_id,
    m.full_name,
    m.home_address.city AS city,
    m.home_address.pincode AS pincode,
    m.metrics.weight_kg AS weight,
    m.metrics.height_cm AS height
FROM MEMBER_OBJ_TABLE m;

-- Query 2: Call object method 'calculate_bmi()' directly in the SELECT clause
SELECT 
    m.member_id,
    m.full_name,
    m.metrics.weight_kg,
    m.metrics.height_cm,
    m.metrics.calculate_bmi() AS calculated_bmi,
    CASE 
        WHEN m.metrics.calculate_bmi() < 18.5 THEN 'Underweight'
        WHEN m.metrics.calculate_bmi() BETWEEN 18.5 AND 24.9 THEN 'Normal'
        WHEN m.metrics.calculate_bmi() BETWEEN 25.0 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_classification
FROM MEMBER_OBJ_TABLE m;

-- Query 3: Execute inherited method 'get_discounted_price' on subtype
SELECT 
    p.plan_id,
    p.plan_name,
    p.base_price,
    p.pt_sessions_count,
    p.trainer_tier,
    p.get_discounted_price(15) AS price_with_15_pct_discount
FROM PT_PLAN_OBJ_TABLE p;

-- ============================================================================
-- 8.6 Comparison: Relational Attributes vs Structured Object Attributes
-- ============================================================================
/*
1. Granularity & Encapsulation:
   - Relational: Each column is a scalar primitive (VARCHAR, INT, DATE). Business behavior is separated from the data.
   - Object-Relational: Attributes can be complex structured user-defined types (e.g. Address_Type, Health_Metrics_Type) encapsulating state and methods (e.g. calculate_bmi()).

2. Reusability:
   - Relational: Address columns (street, city, state, pin) must be repeated across tables or normalized via separate relation with JOIN overhead.
   - Object-Relational: The same Address_Type can be embedded across Gym_Branch, Member, and Trainer objects without table multiplication.

3. Type Inheritance:
   - Relational: Specialization requires polymorphic table design, single-table inheritance, or multiple nullable columns.
   - Object-Relational: Subtypes natively extend supertypes (Personal_Training_Plan_Type UNDER Gym_Plan_Type) inheriting attributes and member functions.
*/
