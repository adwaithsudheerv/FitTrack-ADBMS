"""
FitTrack: Smart Gym Management System
Automated Test Runner for ADBMS Verification
Executes integrity checks, transaction tests, complex queries, JSON, and XML operations.
"""

import sqlite3
import os
import xml.etree.ElementTree as ET

DB_PATH = os.path.join(os.path.dirname(__file__), "..", "05_Web_Application", "fittrack.db")
XML_PATH = os.path.join(os.path.dirname(__file__), "..", "04_JSON_and_XML", "member_order.xml")

def run_all_tests():
    print("=" * 80)
    print("FITTRACK ADBMS AUTOMATED TEST SUITE")
    print("=" * 80)
    
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")
    c = conn.cursor()

    passed = 0
    total = 0

    def assert_test(test_id, desc, condition, detail=""):
        nonlocal passed, total
        total += 1
        if condition:
            passed += 1
            print(f"[{test_id}] PASS: {desc} {detail}")
        else:
            print(f"[{test_id}] FAIL: {desc} {detail}")

    # 1. Primary Key Constraint
    try:
        c.execute("INSERT INTO MEMBER (member_id, branch_id, address_id, full_name, email, phone, password_hash, join_date, role) VALUES (301, 101, 1, 'Dup Member', 'dup@test.com', '+91-0000000000', 'pwd', '2026-01-01', 'MEMBER');")
        assert_test("TC-01", "Primary Key duplicate rejection", False)
    except sqlite3.IntegrityError:
        conn.rollback()
        assert_test("TC-01", "Primary Key duplicate rejection", True, "(PK violation caught)")

    # 2. Unique Constraint
    try:
        c.execute("INSERT INTO MEMBER (member_id, branch_id, address_id, full_name, email, phone, password_hash, join_date, role) VALUES (399, 101, 1, 'Dup Email', 'rahul.sharma@example.com', '+91-9999999999', 'pwd', '2026-01-01', 'MEMBER');")
        assert_test("TC-02", "Unique constraint on email rejection", False)
    except sqlite3.IntegrityError:
        conn.rollback()
        assert_test("TC-02", "Unique constraint on email rejection", True, "(Unique violation caught)")

    # 3. Foreign Key Constraint
    try:
        c.execute("INSERT INTO MEMBER (member_id, branch_id, address_id, full_name, email, phone, password_hash, join_date, role) VALUES (398, 9999, 1, 'FK Test', 'fk@test.com', '+91-9999999998', 'pwd', '2026-01-01', 'MEMBER');")
        assert_test("TC-03", "Foreign Key referential integrity rejection", False)
    except sqlite3.IntegrityError:
        conn.rollback()
        assert_test("TC-03", "Foreign Key referential integrity rejection", True, "(FK 9999 blocked)")

    # 4. Check Constraint on Price
    try:
        c.execute("INSERT INTO MEMBERSHIP_PLAN (plan_id, category_id, plan_name, duration_months, base_price) VALUES (799, 601, 'Negative Plan', 1, -500);")
        assert_test("TC-04", "CHECK constraint on negative plan price", False)
    except sqlite3.IntegrityError:
        conn.rollback()
        assert_test("TC-04", "CHECK constraint on negative plan price", True, "(base_price >= 0 enforced)")

    # 5. Atomic Transaction Processing
    try:
        conn.execute("BEGIN TRANSACTION;")
        test_sub_id = c.execute("SELECT COALESCE(MAX(subscription_id), 1400) + 1 FROM MEMBER_SUBSCRIPTION").fetchone()[0]
        test_pay_id = c.execute("SELECT COALESCE(MAX(payment_id), 1600) + 1 FROM PAYMENT").fetchone()[0]
        c.execute("INSERT INTO MEMBER_SUBSCRIPTION (subscription_id, member_id, plan_id, branch_id, start_date, end_date, total_amount, status) VALUES (?, 303, 701, 101, '2026-11-20', '2027-11-19', 28000.0, 'ACTIVE');", (test_sub_id,))
        c.execute("INSERT INTO PAYMENT (payment_id, subscription_id, payment_mode, amount, payment_status, payment_date) VALUES (?, ?, 'UPI', 28000.0, 'SUCCESS', '2026-11-20 10:00:00');", (test_pay_id, test_sub_id))
        conn.commit()
        # Verify
        sub_row = c.execute("SELECT total_amount FROM MEMBER_SUBSCRIPTION WHERE subscription_id = ?", (test_sub_id,)).fetchone()
        assert_test("TC-05", "Atomic Multi-Table Transaction Commit", sub_row is not None and sub_row[0] == 28000.0)
    except Exception as e:
        conn.rollback()
        assert_test("TC-05", "Atomic Multi-Table Transaction Commit", False, str(e))

    # 6. Intentional Transaction Rollback
    try:
        conn.execute("BEGIN TRANSACTION;")
        c.execute("INSERT INTO MEMBER_SUBSCRIPTION (subscription_id, member_id, plan_id, branch_id, start_date, end_date, total_amount, status) VALUES (1498, 303, 701, 101, '2026-11-20', '2027-11-19', 28000.0, 'ACTIVE');")
        # Rollback before commit
        conn.rollback()
        check_row = c.execute("SELECT subscription_id FROM MEMBER_SUBSCRIPTION WHERE subscription_id = 1498").fetchone()
        assert_test("TC-06", "Transaction Rollback Verification", check_row is None, "(State reverted safely)")
    except Exception as e:
        assert_test("TC-06", "Transaction Rollback Verification", False, str(e))

    # 7. Task 2: Nested Subquery (Plans > Average Price)
    rows = c.execute("SELECT plan_id, base_price FROM MEMBERSHIP_PLAN WHERE base_price > (SELECT AVG(base_price) FROM MEMBERSHIP_PLAN)").fetchall()
    assert_test("TC-07", "Task 2: Nested Subquery (Price > Average)", len(rows) > 0, f"(Found {len(rows)} plans)")

    # 8. Task 2: Correlated Subquery (Latest Booking)
    cor_rows = c.execute("""
        SELECT b.booking_id, b.member_id FROM BOOKING b
        WHERE b.booking_date = (SELECT MAX(sub_b.booking_date) FROM BOOKING sub_b WHERE sub_b.member_id = b.member_id)
    """).fetchall()
    assert_test("TC-08", "Task 2: Correlated Subquery (Latest Booking)", len(cor_rows) >= 8, f"(Returned {len(cor_rows)} records)")

    # 9. Task 3: LEFT OUTER JOIN
    left_rows = c.execute("SELECT m.member_id, s.subscription_id FROM MEMBER m LEFT JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id").fetchall()
    assert_test("TC-09", "Task 3: LEFT OUTER JOIN Execution", len(left_rows) >= 10, f"({len(left_rows)} joined rows)")

    # 10. Task 3: SELF JOIN Hierarchy
    self_rows = c.execute("""
        SELECT child.category_name, parent.category_name
        FROM PLAN_CATEGORY child
        LEFT JOIN PLAN_CATEGORY parent ON child.parent_category_id = parent.category_id
        WHERE child.parent_category_id IS NOT NULL
    """).fetchall()
    assert_test("TC-10", "Task 3: SELF JOIN Category Hierarchy", len(self_rows) >= 5, f"(Matched {len(self_rows)} sub-categories)")

    # 11. Task 3: Set Operations (EXCEPT)
    except_rows = c.execute("""
        SELECT m.member_id FROM MEMBER m JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id WHERE p.category_id IN (602, 605, 606)
        EXCEPT
        SELECT m.member_id FROM MEMBER m JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id WHERE p.category_id IN (603, 607, 608)
    """).fetchall()
    assert_test("TC-11", "Task 3: EXCEPT Set Operation", len(except_rows) > 0, f"({len(except_rows)} members filtered)")

    # 12. Task 4: CTE (Common Table Expression)
    cte_rows = c.execute("""
        WITH BranchRev AS (
            SELECT b.branch_id, SUM(s.total_amount) AS rev FROM GYM_BRANCH b LEFT JOIN MEMBER_SUBSCRIPTION s ON b.branch_id = s.branch_id GROUP BY b.branch_id
        ) SELECT * FROM BranchRev WHERE rev > 0
    """).fetchall()
    assert_test("TC-12", "Task 4: CTE (WITH Clause) Revenue Calculation", len(cte_rows) > 0, f"({len(cte_rows)} branches with revenue)")

    # 13. Task 4: Recursive Hierarchy CTE
    rec_rows = c.execute("""
        WITH RECURSIVE Tree AS (
            SELECT category_id, category_name, 1 AS lvl FROM PLAN_CATEGORY WHERE parent_category_id IS NULL
            UNION ALL
            SELECT c.category_id, c.category_name, p.lvl + 1 FROM PLAN_CATEGORY c JOIN Tree p ON c.parent_category_id = p.category_id
        ) SELECT * FROM Tree
    """).fetchall()
    assert_test("TC-13", "Task 4: Recursive Category Hierarchy CTE", len(rec_rows) == 10, f"(Traversed {len(rec_rows)} hierarchy nodes)")

    # 14. Task 5: View Execution
    view_rows = c.execute("SELECT * FROM Member_Subscription_View").fetchall()
    assert_test("TC-14", "Task 5: View Querying (Member_Subscription_View)", len(view_rows) >= 10, f"({len(view_rows)} rows from view)")

    # 15. Task 10: JSON Extraction
    json_val = c.execute("SELECT json_extract(nutrition_spec_json, '$.macros.protein_grams') FROM MEMBER_DIET_PLAN WHERE diet_id = 5001").fetchone()
    assert_test("TC-15", "Task 10: JSON Path Query Extraction", json_val is not None and int(json_val[0]) in [200, 210], f"(Protein: {json_val[0]}g)")

    # 16. Task 11: XML XPath Execution
    tree = ET.parse(XML_PATH)
    root = tree.getroot()
    order_id = root.get("orderId")
    item_count = len(root.findall(".//Item"))
    assert_test("TC-16", "Task 11: XML Document Parsing & XPath", order_id == "SO-2026-9001" and item_count == 3, f"(Parsed Order {order_id} with {item_count} items)")

    conn.close()

    print("=" * 80)
    print(f"TEST SUMMARY: {passed} / {total} TESTS PASSED ({(passed/total)*100:.1f}% Success Rate)")
    print("=" * 80)

if __name__ == "__main__":
    run_all_tests()
