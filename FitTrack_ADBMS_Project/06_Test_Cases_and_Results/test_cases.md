# FitTrack: Smart Gym Management System
## Deliverable 7: Comprehensive Test Cases & Empirical Verification Matrix

### 1. Test Suite Summary
This test suite covers relational integrity, ACID transactional boundaries, nested subqueries, set operations, common table expressions, view updatability, PL/SQL procedural logic, object-relational UDTs, JSON extractions, and XML parsing.

---

### 2. Comprehensive Test Case Matrix

| Test Case ID | Test Category | Target Feature / Constraint | Test Input / Action | Expected Result | Actual Result | Status |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: |
| **TC-01** | Integrity Constraints | Primary Key Constraint | Insert `MEMBER` with existing `member_id = 301` | Reject with `PRIMARY KEY constraint failed` | Caught SQLite/PostgreSQL PK Violation | **PASS** |
| **TC-02** | Integrity Constraints | Unique Constraint | Insert `MEMBER` with duplicate email `rahul.sharma@example.com` | Reject with `UNIQUE constraint failed: MEMBER.email` | Caught Unique constraint failure | **PASS** |
| **TC-03** | Integrity Constraints | Foreign Key Integrity | Insert `MEMBER` referencing non-existent `branch_id = 9999` | Reject with `FOREIGN KEY constraint failed` | Referential integrity blocked insert | **PASS** |
| **TC-04** | Integrity Constraints | CHECK Constraint (Rating) | Insert `TRAINER_REVIEW` with `rating = 7` | Reject with `CHECK constraint failed (rating BETWEEN 1 AND 5)` | Blocked out-of-range rating | **PASS** |
| **TC-05** | Integrity Constraints | CHECK Constraint (Price) | Insert `MEMBERSHIP_PLAN` with negative `base_price = -500` | Reject with `CHECK constraint failed (base_price >= 0)` | Blocked negative monetary value | **PASS** |
| **TC-06** | TCL Transactions | Multi-statement Atomicity | Enroll member, create subscription, item, payment, and invoice | All 4 tables updated synchronously under single `COMMIT` | All tuples committed in lockstep | **PASS** |
| **TC-07** | TCL Transactions | Transaction Rollback | Intentionally fail final invoice insert during subscription creation | Previous subscription and payment rolled back (`ROLLBACK`) | State restored; zero orphaned records | **PASS** |
| **TC-08** | Task 2: Subqueries | Average Price Filter | Execute query filtering plans with `base_price > AVG(base_price)` | Returns only plans with price > ~₹14,000 | Successfully returned top-tier plans | **PASS** |
| **TC-09** | Task 2: Subqueries | Correlated Subquery | Query `BOOKING` where booking date matches max per member | Exactly 1 most recent booking tuple per member | Correct latest booking retrieved | **PASS** |
| **TC-10** | Task 3: Joins | LEFT OUTER JOIN | Query `MEMBER` left joined with `MEMBER_SUBSCRIPTION` | Displays members with active plans and members with NULL plans | Successfully showed unsubscribed members | **PASS** |
| **TC-11** | Task 3: Joins | SELF JOIN Hierarchy | Self-join `PLAN_CATEGORY` on `parent_category_id` | Pairs child categories with their parent categories | Hierarchical pairs correctly matched | **PASS** |
| **TC-12** | Task 3: Set Operations | EXCEPT / MINUS | Strength category members `EXCEPT` Cardio category members | Returns members enrolled in Strength but never in Cardio | Filtered out dual-enrolled members | **PASS** |
| **TC-13** | Task 3: Set Operations | INTERSECT | Strength category members `INTERSECT` Cardio members | Returns members enrolled in both disciplines | Correctly identified cross-training users | **PASS** |
| **TC-14** | Task 4: CTEs | WITH Clause Aggregation | Calculate branch-wise total subscriptions and revenue | Aggregates revenue grouped by branch ID and name | Correct branch revenue breakdown | **PASS** |
| **TC-15** | Task 4: Recursive CTE | Category Hierarchy Tree | Execute recursive CTE traversing from Root (Level 1) to leaves | Emits full hierarchical breadcrumbs (`Root -> Strength -> Powerlifting`) | Full tree path successfully constructed | **PASS** |
| **TC-16** | Task 5: Views | View Querying | Query `Member_Subscription_View` for `ACTIVE` status | Returns flattened member, plan, and date info | View output matches joined base tables | **PASS** |
| **TC-17** | Task 5: Views | View Updatability Restriction | Attempt `UPDATE` on complex view containing joins and aggregates | Reject with update restriction error | Engine enforces non-updatable view rule | **PASS** |
| **TC-18** | Task 6: PL/SQL Logic | `calculate_final_bill` | Execute function with price ₹28,000 and coupon `ANNUALGOLD20` | Applies 20% discount + 18% GST ($28000 \times 0.8 \times 1.18 = 26432$) | Returned exact ₹26,432.00 | **PASS** |
| **TC-19** | Task 6: PL/SQL Logic | `get_class_available_slots` | Query available slots for Class 1201 (Cap 15, Booked 1) | Returns $15 - 1 = 14$ slots | Returned 14 available slots | **PASS** |
| **TC-20** | Task 7: Exceptions | Capacity Exceeded | Attempt booking when class capacity is full ($Current \ge Max$) | Raise `INSUFFICIENT_SLOTS` custom exception | Caught and returned user-friendly error | **PASS** |
| **TC-21** | Task 7: Exceptions | Duplicate Booking | Attempt booking same member into same class twice | Raise `DUPLICATE_BOOKING` custom exception | Prevented duplicate slot reservation | **PASS** |
| **TC-22** | Task 8: Object-Relational | Member Method `calculate_bmi()` | Create `Health_Metrics_Type(180, 81)` and invoke method | $BMI = \frac{81}{(1.8)^2} = 25.0$ | Method returned 25.0 | **PASS** |
| **TC-23** | Task 10: JSON Storage | JSON Path Extraction | Query `json_extract(nutrition_spec_json, '$.macros.protein_grams')` | Extracts integer protein count from semi-structured JSON | Extracted `200` without regex parsing | **PASS** |
| **TC-24** | Task 10: JSON In-Place | `json_set` Update | Update `hydration_liters` inside JSON without rewriting document | Updates scalar value within JSON string in-place | Field updated from 4.0 to 4.2 | **PASS** |
| **TC-25** | Task 11: XML & XPath | XPath Predicate Query | Evaluate `//Item[UnitPrice >= 5000]` on `member_order.xml` | Selects items priced $\ge 5000$ | Correctly filtered 2 high-value items | **PASS** |
