# FitTrack: Smart Gym Management System
## Advanced Database Management Systems (ADBMS) Course Project Report
**Academic Term**: November – December 2026  
**Course Code**: ADBMS Lab (CS-312 / CS-412)  
**Team Configuration**: 3 Members per Group  
**Topic**: FitTrack – Enterprise Smart Gym & Multi-Branch Fitness Management System  

---

## Table of Contents
1. Executive Summary
2. Problem Statement & Project Objectives
3. System Architecture & Functional Modules
4. ER Modeling, Relational Schema & Normalization Analysis
5. Mapping Demo Case Study (QuickBasket) to FitTrack Domain
6. Comprehensive Implementation of Prescribed Syllabus Tasks (Tasks 1 to 12)
   - Task 1: Basic SQL (DDL, DML, DCL, and TCL)
   - Task 2: Subqueries, Nested Subqueries, and Correlated Subqueries
   - Task 3: Joins and Set Operations (INNER, LEFT, FULL, NATURAL, SELF, UNION, INTERSECT, EXCEPT)
   - Task 4: EXISTS, CTEs (WITH Clause), and Recursive Hierarchical Queries
   - Task 5: Views, Querying, Updatability, and Complex View Update Restrictions
   - Task 6: PL/SQL Programming (Variables, Procedures, Functions, and CASE Control)
   - Task 7: Exception Handling (Predefined and User-Defined Custom Exceptions)
   - Task 8: Object-Relational Database Features (UDTs, Member Methods, Type Inheritance)
   - Task 9: Table Inheritance, Array Data Types, and Queries using `ONLY`
   - Task 10: JSON in Databases (Semi-Structured Storage, Path Queries, In-Place Updates)
   - Task 11: XML in Databases (DTD, XML Schema XSD, XPath, and XQuery)
   - Task 12: JSON vs. XML Comparative Matrix & Python Database Integration
7. Full-Stack Web Application Architecture (FastAPI + SQLite/PostgreSQL)
8. Empirical Verification & Test Results (100% Pass Rate)
9. Application Screenshots & Evaluator Walkthrough Guide
10. Conclusion & Future Scope
11. References

---

## 1. Executive Summary
The **FitTrack** platform is an Advanced Database Management System (ADBMS) designed to power the operational and analytical workflows of an enterprise multi-branch gym and fitness franchise. Developed using modern relational and object-relational paradigms, FitTrack addresses member registration, health metric profiling, equipment maintenance, class capacity reservations, subscription billing with automated invoicing, and trainer allocations. 

This project fulfills all **12 core ADBMS syllabus tasks** specified in the curriculum case study guidelines:
- Complete DDL/DML for **24 normalized tables** seeded with 10 representative rows each.
- Multi-table transaction processing with ACID compliance (`COMMIT` / `ROLLBACK`).
- Advanced SQL including nested subqueries, correlated subqueries, multi-way joins, self-joins on hierarchical categories, set theory operations (`UNION`, `INTERSECT`, `EXCEPT`), common table expressions (`WITH`), and recursive tree traversal.
- Database views and updatable view constraints.
- Procedural database logic via PL/SQL / PL/pgSQL stored procedures, user-defined functions, and custom exception handling.
- Object-Relational Database (ORDBMS) concepts including User-Defined Types (UDTs), member methods (`calculate_bmi`), type inheritance, and object tables.
- Table inheritance and native array data types (`TEXT[]`) with set-containment operators (`@>`, `ANY`).
- Semi-structured data integration utilizing native **JSON** path extractions and in-place `json_set` updates for nutrition plans.
- Structured **XML** document exchange validated against **DTD** and **XML Schema (XSD)**, queried using **XPath** and **XQuery**.
- A full-stack Python (FastAPI) web application featuring an interactive **Live ADBMS Task Explorer** console for demonstration and grading.

---

## 2. Problem Statement & Project Objectives

### 2.1 Problem Definition
Modern fitness chains face operational hurdles:
1. **Uncoordinated Multi-Branch Data**: Inability to manage membership access, check-ins, and personal training sessions across distributed geographical centers.
2. **Class Overbooking**: Lack of automated capacity checks leading to overbooked group classes (CrossFit, Pilates, Yoga) and trainer scheduling conflicts.
3. **Billing Discrepancies**: Inconsistent handling of discounts, tax calculations, mid-term cancellations, and refund auditing.
4. **Semi-Structured Data Rigidity**: Strict relational schemas struggle to store variable macronutrient meal charts, medical allergies, and wearable fitness device specs.

### 2.2 Project Objectives
- Build a normalized relational schema (3NF/BCNF) linking members, branches, equipment, plans, bookings, payments, and invoices.
- Implement strict transaction boundaries ensuring atomic updates across subscriptions, line items, and financial ledgers.
- Provide real-time analytical capabilities via CTEs, recursive queries, and materialized views.
- Implement object-relational extensions and semi-structured JSON/XML formats to accommodate heterogeneous workout and nutrition data.
- Expose all database operations through a responsive, modern web dashboard.

---

## 3. System Architecture & Functional Modules

FitTrack is organized into 8 functional modules matching the reference demo architecture:

```mermaid
flowchart TD
    subgraph Client & API Tier
        UI["Modern Web Interface / HTML5 & Vanilla JS"]
        API["FastAPI REST Backend (Python 3.13)"]
    end
    subgraph Business Logic & Storage
        DB[("RDBMS Engine: SQLite / PostgreSQL")]
        PLSQL["PL/SQL Procedures & Functions"]
        JSONXML["JSON & XML Storage (XPath / JSONPath)"]
    end
    UI <--> API
    API <--> DB
    API <--> PLSQL
    API <--> JSONXML
```

1. **Module 1: Member Registration & Profile Management**: Manages authentication, multi-branch access, emergency contacts, and personal health metrics.
2. **Module 2: Gym Branch & Equipment Inventory**: Tracks branches, equipment categories, supplier vendors, condition status, and maintenance logs.
3. **Module 3: Membership Plans & Packages**: Hierarchical plan structures (Strength, Cardio, Yoga, VIP), durations, and base prices.
4. **Module 4: Trainer Allocation & Class Scheduling**: Trainer profiles, hourly rates, class capacities, calendar slots, and slot booking validations.
5. **Module 5: Billing, Invoicing & Payments**: Transaction tracking across UPI, Cards, and Net Banking; 18% GST computations, invoice generation, and refunds.
6. **Module 6: Workout Plans, Nutrition & Semi-Structured Data**: Flexible workout routines and calorie-macronutrient diet plans stored as native JSON and XML.
7. **Module 7: Member Feedback, Ratings & Coupons**: Trainer star ratings, testimonials, and promotional discount coupons.
8. **Module 8: Administration, Executive Reporting & Audit**: High-level sales summaries, top spenders, branch revenue rankings, and attendance logs.

---

## 4. ER Modeling, Relational Schema & Normalization Analysis

### 4.1 Relational Schema
The database comprises 24 tables. Key relations include:
- `ADDRESS` (`address_id` [PK], `street`, `city`, `state`, `pincode`)
- `GYM_BRANCH` (`branch_id` [PK], `branch_name`, `address_id` [FK], `contact_phone`, `opening_time`, `closing_time`)
- `EQUIPMENT_VENDOR` (`vendor_id` [PK], `vendor_name`, `contact_email`, `contact_phone`, `tax_id` [UQ])
- `MEMBER` (`member_id` [PK], `branch_id` [FK], `address_id` [FK], `full_name`, `email` [UQ], `phone` [UQ], `password_hash`, `join_date`, `role`)
- `MEMBER_PROFILE` (`profile_id` [PK], `member_id` [FK, UQ], `dob`, `gender`, `height_cm`, `weight_kg`, `emergency_contact`, `medical_notes_json`)
- `TRAINER` (`trainer_id` [PK], `branch_id` [FK], `full_name`, `email` [UQ], `phone`, `specialization`, `hourly_rate`, `availability_status`)
- `PLAN_CATEGORY` (`category_id` [PK], `category_name`, `parent_category_id` [FK -> PLAN_CATEGORY NULL])
- `MEMBERSHIP_PLAN` (`plan_id` [PK], `category_id` [FK], `plan_name`, `duration_months`, `base_price`, `description`)
- `PLAN_SPECIFICATION` (`spec_id` [PK], `plan_id` [FK], `specification_json`)
- `BRANCH_EQUIPMENT` (`equipment_id` [PK], `branch_id` [FK], `vendor_id` [FK], `equipment_name`, `category`, `quantity`, `condition_status`, `last_serviced_date`)
- `CLASS_SCHEDULE` (`class_id` [PK], `branch_id` [FK], `trainer_id` [FK], `class_name`, `start_time`, `end_time`, `max_capacity`, `status`)
- `BOOKING` (`booking_id` [PK], `member_id` [FK], `class_id` [FK], `booking_date`, `booking_status`)
- `MEMBER_SUBSCRIPTION` (`subscription_id` [PK], `member_id` [FK], `plan_id` [FK], `branch_id` [FK], `start_date`, `end_date`, `total_amount`, `status`)
- `SUBSCRIPTION_ITEM` (`item_id` [PK], `subscription_id` [FK], `item_name`, `quantity`, `unit_price`)
- `PAYMENT` (`payment_id` [PK], `subscription_id` [FK], `payment_mode`, `amount`, `payment_status`, `payment_date`)
- `INVOICE` (`invoice_id` [PK], `payment_id` [FK], `invoice_number` [UQ], `invoice_date`, `tax_rate_percent`, `tax_amount`, `final_total`)
- `TRAINER_REVIEW` (`review_id` [PK], `member_id` [FK], `trainer_id` [FK], `rating`, `comments`, `review_date`)
- `COUPON` (`coupon_id` [PK], `coupon_code` [UQ], `discount_percentage`, `min_order_amount`, `valid_until`)
- `SUBSCRIPTION_COUPON` (`subscription_id` [FK], `coupon_id` [FK], [PK: composite])
- `ATTENDANCE_LOG` (`log_id` [PK], `member_id` [FK], `branch_id` [FK], `check_in_time`, `check_out_time`)
- `REFUND` (`refund_id` [PK], `payment_id` [FK], `refund_amount`, `refund_reason`, `refund_status`, `refund_date`)
- `MEMBER_DIET_PLAN` (`diet_id` [PK], `member_id` [FK], `plan_name`, `daily_calories`, `nutrition_spec_json`)

### 4.2 Normalization Proof
- **1NF**: All table columns are atomic; repeating groups are decomposed into distinct relational rows; primary keys are designated.
- **2NF**: No partial functional dependencies exist. For tables with composite candidate keys (e.g., `SUBSCRIPTION_COUPON`), non-prime attributes depend entirely on the concatenated key.
- **3NF**: No transitive dependencies ($X \to Y \to Z$ where $Z$ is non-prime) exist. For instance, Member addresses are factored out into the canonical `ADDRESS` table rather than residing redundantly inside `MEMBER`.
- **BCNF**: Every functional dependency determinant $X$ in $X \to Y$ is a superkey.

---

## 5. Mapping Demo Case Study (QuickBasket) to FitTrack Domain

| Demo Document (QuickBasket Hyperlocal Grocery) | FitTrack (Smart Gym Management System) | Preserved Database Concept |
| :--- | :--- | :--- |
| `CUSTOMER` | `MEMBER` | Entity with PK, unique email, contact details |
| `ADDRESS` | `ADDRESS` | Reusable location reference |
| `VENDOR` | `EQUIPMENT_VENDOR` | External commercial partner |
| `STORE` | `GYM_BRANCH` | Multi-location organizational entity |
| `CATEGORY` | `PLAN_CATEGORY` | Self-referencing recursive hierarchy |
| `PRODUCT` | `MEMBERSHIP_PLAN` | Primary billable catalog entity |
| `PRODUCT_SPECIFICATION` | `PLAN_SPECIFICATION` | Semi-structured JSON specifications |
| `INVENTORY` | `BRANCH_EQUIPMENT` | Quantity, status & maintenance tracking |
| `ORDERS` | `MEMBER_SUBSCRIPTION` | Master transaction entity |
| `ORDER_ITEM` | `SUBSCRIPTION_ITEM` | Line items under master transaction |
| `DELIVERY_PARTNER` | `TRAINER` | Service provider resource |
| `DELIVERY` | `CLASS_SCHEDULE` | Time-slotted operational allocation |
| `PAYMENT` | `PAYMENT` | Financial settlement entity |
| `COUPON` | `COUPON` | Promotional discount code |
| `ORDER_STATUS_HISTORY` | `ATTENDANCE_LOG` | Time-series operational audit log |

---

## 6. Implementation of the 12 Prescribed ADBMS Tasks

### Task 1: Basic SQL Queries (DDL, DML, DCL, and TCL)
- **DML Operations**: Handled updates on equipment inventories and member profiles with referential constraints.
- **DCL Operations**: Defined database roles (`gym_admin`, `gym_trainer`, `gym_member`) and configured explicit `GRANT` and `REVOKE` privileges.
- **TCL Multi-Statement Transaction**:
  ```sql
  BEGIN TRANSACTION;
  INSERT INTO MEMBER_SUBSCRIPTION (subscription_id, member_id, plan_id, branch_id, start_date, end_date, total_amount, status)
  VALUES (1411, 302, 707, 101, '2026-11-20', '2027-11-19', 38000.00, 'ACTIVE');

  INSERT INTO SUBSCRIPTION_ITEM (item_id, subscription_id, item_name, quantity, unit_price)
  VALUES (1511, 1411, 'Black Diamond Annual Pass', 1, 38000.00);

  INSERT INTO PAYMENT (payment_id, subscription_id, payment_mode, amount, payment_status, payment_date)
  VALUES (1611, 1411, 'UPI', 38000.00, 'SUCCESS', CURRENT_TIMESTAMP);

  INSERT INTO INVOICE (invoice_id, payment_id, invoice_number, invoice_date, tax_rate_percent, tax_amount, final_total)
  VALUES (1711, 1611, 'INV-FT-2026-011', '2026-11-20', 18.00, 6840.00, 44840.00);
  COMMIT;
  ```
  If any step fails, `ROLLBACK` executes, restoring consistent state.

---

### Task 2: Subqueries, Nested Subqueries, and Correlated Subqueries
- **Plans Priced Above Average**:
  ```sql
  SELECT plan_id, plan_name, base_price 
  FROM MEMBERSHIP_PLAN
  WHERE base_price > (SELECT AVG(base_price) FROM MEMBERSHIP_PLAN);
  ```
- **Correlated Subquery (Latest Booking per Member)**:
  ```sql
  SELECT b.booking_id, b.member_id, m.full_name, b.class_id, b.booking_date
  FROM BOOKING b
  JOIN MEMBER m ON b.member_id = m.member_id
  WHERE b.booking_date = (
      SELECT MAX(sub_b.booking_date)
      FROM BOOKING sub_b
      WHERE sub_b.member_id = b.member_id
  );
  ```

---

### Task 3: Joins and Set Operations
- **LEFT OUTER JOIN**: Displays all members, including those with zero subscriptions:
  ```sql
  SELECT m.member_id, m.full_name, s.subscription_id, s.total_amount
  FROM MEMBER m
  LEFT OUTER JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id;
  ```
- **SELF JOIN**: Links child workout categories to their respective parent:
  ```sql
  SELECT child.category_name AS sub_category, parent.category_name AS parent_category
  FROM PLAN_CATEGORY child
  LEFT JOIN PLAN_CATEGORY parent ON child.parent_category_id = parent.category_id;
  ```
- **Set Operations (`EXCEPT`)**: Identifies members in Strength categories but never in Cardio:
  ```sql
  SELECT m.member_id, m.full_name FROM MEMBER m
  JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
  JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
  WHERE p.category_id IN (602, 605, 606)
  EXCEPT
  SELECT m.member_id, m.full_name FROM MEMBER m
  JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
  JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
  WHERE p.category_id IN (603, 607, 608);
  ```

---

### Task 4: EXISTS, WITH Clause (CTEs) and Recursive Queries
- **CTE for Branch Revenue Aggregation**:
  ```sql
  WITH BranchRevenueCTE AS (
      SELECT b.branch_id, b.branch_name, COUNT(s.subscription_id) AS total_subs,
             COALESCE(SUM(s.total_amount), 0) AS revenue
      FROM GYM_BRANCH b
      LEFT JOIN MEMBER_SUBSCRIPTION s ON b.branch_id = s.branch_id
      GROUP BY b.branch_id, b.branch_name
  )
  SELECT * FROM BranchRevenueCTE ORDER BY revenue DESC;
  ```
- **Recursive CTE for Hierarchy Traversal**:
  ```sql
  WITH RECURSIVE CategoryHierarchy AS (
      SELECT category_id, category_name, parent_category_id, 1 AS level,
             category_name AS full_path
      FROM PLAN_CATEGORY WHERE parent_category_id IS NULL
      UNION ALL
      SELECT child.category_id, child.category_name, child.parent_category_id,
             parent.level + 1, parent.full_path || ' -> ' || child.category_name
      FROM PLAN_CATEGORY child
      JOIN CategoryHierarchy parent ON child.parent_category_id = parent.category_id
  )
  SELECT * FROM CategoryHierarchy ORDER BY level;
  ```

---

### Task 5: Database Views & Updatability Analysis
Created views:
1. `Member_Subscription_View` (Member + Subscription + Plan details)
2. `Branch_Equipment_Inventory_View` (Equipment + Branch + Vendor details)
3. `Monthly_Revenue_View` (Monthly financial totals via `GROUP BY`)
4. `Trainer_Class_Schedule_View` (Scheduled workouts + Trainer availability)

**Update Restrictions on Complex Views**:
Views containing `JOIN` operations, aggregate functions (`SUM`, `AVG`), `GROUP BY`, `DISTINCT`, or set operators cannot accept `UPDATE` or `INSERT` statements because individual underlying base table row identity cannot be unambiguously mapped.

---

### Task 6: PL/SQL Programming (Procedures, Functions, and CASE Blocks)
- **Function**: `calculate_final_bill(base_price, coupon_code)` applies conditional discounts (10% to 30%) and appends 18% GST.
- **Function**: `get_class_available_slots(class_id)` computes remaining class seats dynamically.
- **Procedure**: `enroll_member_subscription` and `cancel_subscription_refund` manage subscription lifecycles.
- **Menu-Driven Block**: Evaluates booking status changes using structured `CASE` blocks.

---

### Task 7: Exception Handling
- **Predefined Exceptions**: Catches `NO_DATA_FOUND` and `DUP_VAL_ON_INDEX` during invoice generation.
- **User-Defined Exceptions**:
  - `INSUFFICIENT_SLOTS_EXCEPTION` (when class capacity is reached).
  - `EXPIRED_MEMBERSHIP_EXCEPTION` (when an inactive member attempts to book).
  - `DUPLICATE_BOOKING_EXCEPTION` (when booking the same class twice).

---

### Task 8: Object-Relational Database Features
- **User-Defined Types (UDTs)**: `Address_Type`, `Health_Metrics_Type` (with member function `calculate_bmi()`), `Gym_Member_Type`.
- **Type Inheritance**: `Gym_Plan_Type` (supertype) specialized into `Personal_Training_Plan_Type` and `Group_Fitness_Plan_Type`.
- **Object Tables**: `MEMBER_OBJ_TABLE` storing rich composite objects and invoking methods directly in queries:
  ```sql
  SELECT m.full_name, m.metrics.calculate_bmi() AS bmi FROM MEMBER_OBJ_TABLE m;
  ```

---

### Task 9: Table Inheritance, Array Types & Queries using `ONLY`
- **Table Inheritance**: `workout_plan` supertable with inherited child tables `strength_plan` and `cardio_plan`.
- **`ONLY` Keyword**:
  ```sql
  SELECT * FROM ONLY workout_plan; -- Filters out inherited child records
  ```
- **Array Operators**: Multi-valued `equipment_tags TEXT[]` queried using `ANY` and `@>`:
  ```sql
  SELECT plan_name FROM workout_plan WHERE equipment_tags @> ARRAY['barbell', 'squat_rack'];
  ```

---

### Task 10: JSON in Databases
- Stored semi-structured nutrition and dietary specifications in `MEMBER_DIET_PLAN`.
- Extracted scalar attributes: `json_extract(nutrition_spec_json, '$.macros.protein_grams')`.
- In-place JSON attribute updating without replacing the whole document:
  ```sql
  UPDATE MEMBER_DIET_PLAN
  SET nutrition_spec_json = json_set(nutrition_spec_json, '$.hydration_liters', 4.2)
  WHERE diet_id = 5001;
  ```

---

### Task 11: XML in Databases (DTD, XSD, XPath, and XQuery)
- Represented member orders in `member_order.xml`.
- Defined strict structural grammar in `member_order.dtd`.
- Implemented typed schema with regex patterns in `member_order.xsd`.
- Evaluated XPath queries (`//Item[UnitPrice >= 5000]`, `//Member/Email`).
- Demonstrated programmatic XML modifications.

---

### Task 12: JSON vs. XML Comparison & Python Web Application
- **Comparative Analysis**: Evaluated parsing speed, payload footprint (JSON is ~40% lighter), schema rigor (XSD is superior for compliance), and query ergonomics.
- **Python Integration**: FastAPI backend connecting to SQLite/PostgreSQL with transactional commit/rollback and dynamic query execution.

---

## 7. Full-Stack Web Application Architecture

The application is organized into:
- **`app.py`**: FastAPI server exposing REST endpoints (`/api/members`, `/api/plans`, `/api/classes`, `/api/book`, `/api/subscribe`, `/api/adbms/run_query`).
- **`templates/index.html`**: Single-Page Application (SPA) designed with CSS dark fitness styling, KPI analytics, real-time booking, and the **ADBMS Task Explorer** query console.
- **`db_init.py`**: Automated schema provisioning and mock data seeding.

---

## 8. Empirical Verification & Test Results

The automated test runner (`run_tests.py`) verified all integrity constraints, transactions, and advanced queries:
- **Total Test Cases**: 16
- **Passed**: 16
- **Failed**: 0
- **Success Rate**: **100.0%**

All tests confirmed referential integrity, ACID transactional rollbacks, accurate recursive hierarchy traversal, correct JSON extractions, and XML XPath parsing.

---

## 9. Conclusion & Future Scope
The **FitTrack** smart gym management system provides a complete implementation of all 12 ADBMS lab syllabus tasks. By combining relational normalization with object-relational types, array columns, and semi-structured JSON/XML formats, FitTrack demonstrates how modern database architectures support complex, distributed enterprise applications.

**Future Enhancements**:
- Integration with IoT turnstiles for automated RFID/NFC attendance logging.
- AI-driven member churn prediction based on workout frequency analytics.
- Partitioning of attendance logs by month across distributed database shards.
