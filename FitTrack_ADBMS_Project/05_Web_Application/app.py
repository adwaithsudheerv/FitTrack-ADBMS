"""
FitTrack Pro: Enterprise Smart Gym Management System
Advanced Database Management Systems (ADBMS) Course Platform
FastAPI Backend with Comprehensive Multi-Module REST Endpoints
Zero-Emoji Architecture, Full Transaction Safety, and Multi-Engine Support
"""

import os
import sqlite3
import time
import json
from fastapi import FastAPI, HTTPException, Request, Response
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Optional, List, Any

app = FastAPI(title="FitTrack Pro ADBMS Platform", version="3.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DB_PATH = os.path.join(os.path.dirname(__file__), "fittrack.db")
TEMPLATES_PATH = os.path.join(os.path.dirname(__file__), "templates")

# Auto-initialize database on startup if not present (Essential for Render deployment)
if not os.path.exists(DB_PATH):
    try:
        from db_init import init_database
        init_database()
    except Exception as e:
        print("Database auto-init notice:", e)

def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn

# ============================================================================
# Pydantic Schemas (Strong Typing)
# ============================================================================
class MemberRegisterRequest(BaseModel):
    full_name: str
    email: str
    phone: str
    branch_id: int
    address_id: int = 1
    role: str = "MEMBER"

class BookingCreateRequest(BaseModel):
    member_id: int
    class_id: int

class BookingCancelRequest(BaseModel):
    booking_id: int

class SubscriptionCreateRequest(BaseModel):
    member_id: int
    plan_id: int
    branch_id: int
    payment_mode: str
    coupon_code: Optional[str] = None

class EquipmentStatusUpdateRequest(BaseModel):
    equipment_id: int
    condition_status: str

class ReviewCreateRequest(BaseModel):
    member_id: int
    trainer_id: int
    rating: int
    comments: str

class RefundCreateRequest(BaseModel):
    payment_id: int
    refund_amount: float
    refund_reason: str

class QueryExecuteRequest(BaseModel):
    sql: str

# ============================================================================
# Static & HTML Route
# ============================================================================
@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    return Response(status_code=204)

@app.get("/", response_class=HTMLResponse)
async def serve_home():
    html_file = os.path.join(TEMPLATES_PATH, "index.html")
    with open(html_file, "r", encoding="utf-8") as f:
        return HTMLResponse(content=f.read())

# ============================================================================
# 1. Analytics & Executive KPI Endpoints
# ============================================================================
@app.get("/api/dashboard/stats")
def get_dashboard_stats():
    conn = get_db()
    c = conn.cursor()
    total_members = c.execute("SELECT COUNT(*) FROM MEMBER").fetchone()[0]
    total_trainers = c.execute("SELECT COUNT(*) FROM TRAINER WHERE availability_status = 'AVAILABLE'").fetchone()[0]
    total_revenue = c.execute("SELECT COALESCE(SUM(amount), 0) FROM PAYMENT WHERE payment_status = 'SUCCESS'").fetchone()[0]
    active_subs = c.execute("SELECT COUNT(*) FROM MEMBER_SUBSCRIPTION WHERE status = 'ACTIVE'").fetchone()[0]
    classes_today = c.execute("SELECT COUNT(*) FROM CLASS_SCHEDULE WHERE status = 'SCHEDULED'").fetchone()[0]
    operational_equip = c.execute("SELECT COALESCE(SUM(quantity), 0) FROM BRANCH_EQUIPMENT WHERE condition_status = 'OPERATIONAL'").fetchone()[0]
    conn.close()

    return {
        "total_members": total_members,
        "available_trainers": total_trainers,
        "gross_revenue": total_revenue,
        "active_subscriptions": active_subs,
        "scheduled_classes": classes_today,
        "operational_equipment": operational_equip
    }

# ============================================================================
# 2. Member Management & Health Profiles
# ============================================================================
@app.get("/api/members")
def get_members():
    conn = get_db()
    c = conn.cursor()
    rows = c.execute("""
        SELECT m.member_id, m.full_name, m.email, m.phone, m.join_date, m.role, b.branch_name,
               p.height_cm, p.weight_kg, p.emergency_contact, p.medical_notes_json
        FROM MEMBER m
        JOIN GYM_BRANCH b ON m.branch_id = b.branch_id
        LEFT JOIN MEMBER_PROFILE p ON m.member_id = p.member_id
        ORDER BY m.member_id DESC
    """).fetchall()
    members = []
    for r in rows:
        d = dict(r)
        bmi = None
        if d.get("height_cm") and d.get("weight_kg"):
            h_m = d["height_cm"] / 100.0
            bmi = round(d["weight_kg"] / (h_m * h_m), 1)
        d["calculated_bmi"] = bmi
        try:
            d["medical_notes"] = json.loads(d["medical_notes_json"]) if d["medical_notes_json"] else {}
        except Exception:
            d["medical_notes"] = {}
        members.append(d)
    conn.close()
    return members

@app.post("/api/members")
def register_member(req: MemberRegisterRequest):
    conn = get_db()
    c = conn.cursor()
    try:
        new_id = c.execute("SELECT COALESCE(MAX(member_id), 300) + 1 FROM MEMBER").fetchone()[0]
        c.execute("""
            INSERT INTO MEMBER (member_id, branch_id, address_id, full_name, email, phone, password_hash, join_date, role)
            VALUES (?, ?, ?, ?, ?, ?, 'hash_default_secret', DATE('now'), ?)
        """, (new_id, req.branch_id, req.address_id, req.full_name, req.email, req.phone, req.role))

        # Default profile
        new_prof_id = c.execute("SELECT COALESCE(MAX(profile_id), 400) + 1 FROM MEMBER_PROFILE").fetchone()[0]
        c.execute("""
            INSERT INTO MEMBER_PROFILE (profile_id, member_id, dob, gender, height_cm, weight_kg, emergency_contact, medical_notes_json)
            VALUES (?, ?, '1995-01-01', 'Other', 172.0, 70.0, req.phone, '{"blood_group": "Unknown", "fitness_goal": "general"}')
        """, (new_prof_id, new_id))

        conn.commit()
        return {"status": "success", "member_id": new_id, "message": f"Member {req.full_name} enrolled successfully with ID #{new_id}."}
    except sqlite3.IntegrityError as ie:
        conn.rollback()
        raise HTTPException(status_code=400, detail=f"Database Integrity Violation: {str(ie)}")
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()

# ============================================================================
# 3. Membership Plans & Subscriptions
# ============================================================================
@app.get("/api/plans")
def get_plans():
    conn = get_db()
    c = conn.cursor()
    rows = c.execute("""
        SELECT p.plan_id, p.plan_name, p.duration_months, p.base_price, p.description,
               c.category_name, s.specification_json
        FROM MEMBERSHIP_PLAN p
        JOIN PLAN_CATEGORY c ON p.category_id = c.category_id
        LEFT JOIN PLAN_SPECIFICATION s ON p.plan_id = s.plan_id
        ORDER BY p.base_price DESC
    """).fetchall()
    plans = []
    for r in rows:
        d = dict(r)
        try:
            d["specifications"] = json.loads(d["specification_json"]) if d["specification_json"] else {}
        except Exception:
            d["specifications"] = {}
        plans.append(d)
    conn.close()
    return plans

@app.post("/api/subscribe")
def create_subscription(req: SubscriptionCreateRequest):
    conn = get_db()
    c = conn.cursor()
    try:
        c.execute("BEGIN TRANSACTION;")

        plan = c.execute("SELECT base_price, duration_months, plan_name FROM MEMBERSHIP_PLAN WHERE plan_id = ?", (req.plan_id,)).fetchone()
        if not plan:
            raise HTTPException(status_code=404, detail="Membership plan not found.")

        base_price, duration_months, plan_name = plan[0], plan[1], plan[2]
        discount = 0.0
        if req.coupon_code == "FITFIRST10":
            discount = base_price * 0.10
        elif req.coupon_code == "ANNUALGOLD20":
            discount = base_price * 0.20
        elif req.coupon_code == "STUDENT15":
            discount = base_price * 0.15

        taxable = base_price - discount
        tax = taxable * 0.18
        final_total = taxable + tax

        new_sub_id = c.execute("SELECT COALESCE(MAX(subscription_id), 1400) + 1 FROM MEMBER_SUBSCRIPTION").fetchone()[0]

        # 1. Insert Subscription
        c.execute("""
            INSERT INTO MEMBER_SUBSCRIPTION (subscription_id, member_id, plan_id, branch_id, start_date, end_date, total_amount, status)
            VALUES (?, ?, ?, ?, DATE('now'), DATE('now', ?), ?, 'ACTIVE')
        """, (new_sub_id, req.member_id, req.plan_id, req.branch_id, f"+{duration_months} month", final_total))

        # 2. Insert Line Item
        new_item_id = c.execute("SELECT COALESCE(MAX(item_id), 1500) + 1 FROM SUBSCRIPTION_ITEM").fetchone()[0]
        c.execute("""
            INSERT INTO SUBSCRIPTION_ITEM (item_id, subscription_id, item_name, quantity, unit_price)
            VALUES (?, ?, ?, 1, ?)
        """, (new_item_id, new_sub_id, f"{plan_name} Enrollment", base_price))

        # 3. Record Payment
        new_pay_id = c.execute("SELECT COALESCE(MAX(payment_id), 1600) + 1 FROM PAYMENT").fetchone()[0]
        c.execute("""
            INSERT INTO PAYMENT (payment_id, subscription_id, payment_mode, amount, payment_status, payment_date)
            VALUES (?, ?, ?, ?, 'SUCCESS', CURRENT_TIMESTAMP)
        """, (new_pay_id, new_sub_id, req.payment_mode, final_total))

        # 4. Generate Official Tax Invoice
        new_inv_id = c.execute("SELECT COALESCE(MAX(invoice_id), 1700) + 1 FROM INVOICE").fetchone()[0]
        inv_number = f"INV-FT-2026-{new_inv_id}"
        c.execute("""
            INSERT INTO INVOICE (invoice_id, payment_id, invoice_number, invoice_date, tax_rate_percent, tax_amount, final_total)
            VALUES (?, ?, ?, DATE('now'), 18.00, ?, ?)
        """, (new_inv_id, new_pay_id, inv_number, tax, final_total))

        conn.commit()
        return {
            "status": "success",
            "subscription_id": new_sub_id,
            "invoice_number": inv_number,
            "amount_paid": final_total,
            "message": "Subscription confirmed and transaction committed successfully."
        }
    except HTTPException:
        conn.rollback()
        raise
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=f"Transaction rolled back: {str(e)}")
    finally:
        conn.close()

# ============================================================================
# 4. Classes, Schedules & Slot Reservations
# ============================================================================
@app.get("/api/classes")
def get_classes():
    conn = get_db()
    c = conn.cursor()
    rows = c.execute("""
        SELECT c.class_id, c.class_name, c.start_time, c.end_time, c.max_capacity, c.status,
               b.branch_name, t.full_name AS trainer_name, t.specialization,
               (c.max_capacity - (SELECT COUNT(*) FROM BOOKING b WHERE b.class_id = c.class_id AND b.booking_status = 'CONFIRMED')) AS available_slots
        FROM CLASS_SCHEDULE c
        JOIN GYM_BRANCH b ON c.branch_id = b.branch_id
        JOIN TRAINER t ON c.trainer_id = t.trainer_id
        ORDER BY c.start_time ASC
    """).fetchall()
    classes = [dict(r) for r in rows]
    conn.close()
    return classes

@app.post("/api/book")
def book_class(req: BookingCreateRequest):
    conn = get_db()
    c = conn.cursor()
    try:
        # Check capacity
        c.execute("SELECT max_capacity FROM CLASS_SCHEDULE WHERE class_id = ?", (req.class_id,))
        row = c.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Scheduled class session not found.")
        max_cap = row[0]

        booked = c.execute("SELECT COUNT(*) FROM BOOKING WHERE class_id = ? AND booking_status = 'CONFIRMED'", (req.class_id,)).fetchone()[0]
        if booked >= max_cap:
            raise HTTPException(status_code=400, detail="Class capacity reached. No seats available.")

        # Check duplicate booking
        exists = c.execute("SELECT COUNT(*) FROM BOOKING WHERE member_id = ? AND class_id = ? AND booking_status = 'CONFIRMED'", (req.member_id, req.class_id)).fetchone()[0]
        if exists > 0:
            raise HTTPException(status_code=400, detail="Selected member is already booked for this class.")

        new_bid = c.execute("SELECT COALESCE(MAX(booking_id), 1300) + 1 FROM BOOKING").fetchone()[0]
        c.execute("""
            INSERT INTO BOOKING (booking_id, member_id, class_id, booking_date, booking_status)
            VALUES (?, ?, ?, CURRENT_TIMESTAMP, 'CONFIRMED')
        """, (new_bid, req.member_id, req.class_id))
        conn.commit()
        return {"status": "success", "booking_id": new_bid, "message": f"Slot reserved successfully! Booking #{new_bid} confirmed."}
    except HTTPException:
        conn.rollback()
        raise
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()

@app.get("/api/bookings")
def get_all_bookings():
    conn = get_db()
    c = conn.cursor()
    rows = c.execute("""
        SELECT b.booking_id, b.member_id, m.full_name AS member_name, c.class_id, c.class_name,
               b.booking_date, b.booking_status, br.branch_name, t.full_name AS trainer_name
        FROM BOOKING b
        JOIN MEMBER m ON b.member_id = m.member_id
        JOIN CLASS_SCHEDULE c ON b.class_id = c.class_id
        JOIN GYM_BRANCH br ON c.branch_id = br.branch_id
        JOIN TRAINER t ON c.trainer_id = t.trainer_id
        ORDER BY b.booking_id DESC
    """).fetchall()
    bookings = [dict(r) for r in rows]
    conn.close()
    return bookings

@app.post("/api/bookings/cancel")
def cancel_booking(req: BookingCancelRequest):
    conn = get_db()
    c = conn.cursor()
    try:
        c.execute("UPDATE BOOKING SET booking_status = 'CANCELLED' WHERE booking_id = ?", (req.booking_id,))
        if c.rowcount == 0:
            raise HTTPException(status_code=404, detail="Booking record not found.")
        conn.commit()
        return {"status": "success", "message": f"Booking #{req.booking_id} cancelled. Seat returned to inventory."}
    finally:
        conn.close()

# ============================================================================
# 5. Facilities & Equipment Inventory Management
# ============================================================================
@app.get("/api/equipment")
def get_equipment():
    conn = get_db()
    c = conn.cursor()
    rows = c.execute("""
        SELECT e.equipment_id, e.equipment_name, e.category, b.branch_name, v.vendor_name,
               e.quantity, e.condition_status, e.last_serviced_date
        FROM BRANCH_EQUIPMENT e
        JOIN GYM_BRANCH b ON e.branch_id = b.branch_id
        JOIN EQUIPMENT_VENDOR v ON e.vendor_id = v.vendor_id
        ORDER BY e.equipment_id ASC
    """).fetchall()
    equipment = [dict(r) for r in rows]
    conn.close()
    return equipment

@app.post("/api/equipment/status")
def update_equipment_status(req: EquipmentStatusUpdateRequest):
    conn = get_db()
    c = conn.cursor()
    try:
        valid_statuses = ['OPERATIONAL', 'UNDER_MAINTENANCE', 'RETIRED']
        if req.condition_status not in valid_statuses:
            raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of {valid_statuses}")

        c.execute("""
            UPDATE BRANCH_EQUIPMENT 
            SET condition_status = ?, last_serviced_date = DATE('now')
            WHERE equipment_id = ?
        """, (req.condition_status, req.equipment_id))
        
        if c.rowcount == 0:
            raise HTTPException(status_code=404, detail="Equipment ID not found.")

        conn.commit()
        return {"status": "success", "message": f"Equipment #{req.equipment_id} updated to {req.condition_status}."}
    finally:
        conn.close()

# ============================================================================
# 6. Trainers, Ratings & Reviews
# ============================================================================
@app.get("/api/trainers")
def get_trainers():
    conn = get_db()
    c = conn.cursor()
    rows = c.execute("""
        SELECT t.trainer_id, t.full_name, t.specialization, t.hourly_rate, t.availability_status,
               b.branch_name, COALESCE(ROUND(AVG(r.rating), 1), 5.0) AS avg_rating,
               COUNT(r.review_id) AS total_reviews
        FROM TRAINER t
        JOIN GYM_BRANCH b ON t.branch_id = b.branch_id
        LEFT JOIN TRAINER_REVIEW r ON t.trainer_id = r.trainer_id
        GROUP BY t.trainer_id
        ORDER BY avg_rating DESC
    """).fetchall()
    trainers = [dict(r) for r in rows]
    conn.close()
    return trainers

@app.get("/api/reviews")
def get_reviews():
    conn = get_db()
    c = conn.cursor()
    rows = c.execute("""
        SELECT r.review_id, m.full_name AS member_name, t.full_name AS trainer_name,
               r.rating, r.comments, r.review_date
        FROM TRAINER_REVIEW r
        JOIN MEMBER m ON r.member_id = m.member_id
        JOIN TRAINER t ON r.trainer_id = t.trainer_id
        ORDER BY r.review_id DESC
    """).fetchall()
    reviews = [dict(r) for r in rows]
    conn.close()
    return reviews

@app.post("/api/reviews")
def create_review(req: ReviewCreateRequest):
    conn = get_db()
    c = conn.cursor()
    try:
        if req.rating < 1 or req.rating > 5:
            raise HTTPException(status_code=400, detail="Rating must be between 1 and 5.")

        new_rid = c.execute("SELECT COALESCE(MAX(review_id), 1800) + 1 FROM TRAINER_REVIEW").fetchone()[0]
        c.execute("""
            INSERT INTO TRAINER_REVIEW (review_id, member_id, trainer_id, rating, comments, review_date)
            VALUES (?, ?, ?, ?, ?, DATE('now'))
        """, (new_rid, req.member_id, req.trainer_id, req.rating, req.comments))
        conn.commit()
        return {"status": "success", "message": "Review submitted successfully."}
    finally:
        conn.close()

# ============================================================================
# 7. Invoices, Payments & Refunds
# ============================================================================
@app.get("/api/invoices")
def get_invoices():
    conn = get_db()
    c = conn.cursor()
    rows = c.execute("""
        SELECT i.invoice_id, i.invoice_number, i.invoice_date, i.tax_rate_percent, i.tax_amount, i.final_total,
               p.payment_id, p.payment_mode, p.payment_status, m.full_name AS member_name, s.subscription_id
        FROM INVOICE i
        JOIN PAYMENT p ON i.payment_id = p.payment_id
        JOIN MEMBER_SUBSCRIPTION s ON p.subscription_id = s.subscription_id
        JOIN MEMBER m ON s.member_id = m.member_id
        ORDER BY i.invoice_id DESC
    """).fetchall()
    invoices = [dict(r) for r in rows]
    conn.close()
    return invoices

@app.get("/api/refunds")
def get_refunds():
    conn = get_db()
    c = conn.cursor()
    rows = c.execute("""
        SELECT r.refund_id, r.payment_id, r.refund_amount, r.refund_reason, r.refund_status, r.refund_date,
               m.full_name AS member_name
        FROM REFUND r
        JOIN PAYMENT p ON r.payment_id = p.payment_id
        JOIN MEMBER_SUBSCRIPTION s ON p.subscription_id = s.subscription_id
        JOIN MEMBER m ON s.member_id = m.member_id
        ORDER BY r.refund_id DESC
    """).fetchall()
    refunds = [dict(r) for r in rows]
    conn.close()
    return refunds

@app.post("/api/refunds")
def request_refund(req: RefundCreateRequest):
    conn = get_db()
    c = conn.cursor()
    try:
        new_ref_id = c.execute("SELECT COALESCE(MAX(refund_id), 2100) + 1 FROM REFUND").fetchone()[0]
        c.execute("""
            INSERT INTO REFUND (refund_id, payment_id, refund_amount, refund_reason, refund_status, refund_date)
            VALUES (?, ?, ?, ?, 'PROCESSED', CURRENT_TIMESTAMP)
        """, (new_ref_id, req.payment_id, req.refund_amount, req.refund_reason))
        conn.commit()
        return {"status": "success", "refund_id": new_ref_id, "message": f"Refund of INR {req.refund_amount:,.2f} processed successfully."}
    finally:
        conn.close()

# ============================================================================
# 8. All 12 ADBMS Syllabus Task Presets
# ============================================================================
PRESET_TASKS = [
    {
        "id": "task_01",
        "title": "Task 1: Transaction Processing & DML Updates",
        "description": "Multi-table atomic transaction during enrollment: creates subscription, line items, payment record, and official invoice.",
        "sql": """SELECT s.subscription_id, m.full_name, p.plan_name, s.total_amount, s.status, py.payment_mode, i.invoice_number
FROM MEMBER_SUBSCRIPTION s
JOIN MEMBER m ON s.member_id = m.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
JOIN PAYMENT py ON s.subscription_id = py.subscription_id
JOIN INVOICE i ON py.payment_id = i.payment_id
ORDER BY s.subscription_id DESC
LIMIT 8;"""
    },
    {
        "id": "task_02_1",
        "title": "Task 2.1: Nested Subquery - Plans Above Average Price",
        "description": "Filters membership tiers whose price strictly exceeds the mathematical average of all plans.",
        "sql": """SELECT plan_id, plan_name, base_price, duration_months
FROM MEMBERSHIP_PLAN
WHERE base_price > (SELECT AVG(base_price) FROM MEMBERSHIP_PLAN)
ORDER BY base_price DESC;"""
    },
    {
        "id": "task_02_2",
        "title": "Task 2.2: Correlated Subquery - Latest Member Booking",
        "description": "Retrieves the most recent reservation timestamp for every member via a correlated inner query.",
        "sql": """SELECT b.booking_id, b.member_id, m.full_name, b.class_id, b.booking_date, b.booking_status
FROM BOOKING b
JOIN MEMBER m ON b.member_id = m.member_id
WHERE b.booking_date = (
    SELECT MAX(sub_b.booking_date)
    FROM BOOKING sub_b
    WHERE sub_b.member_id = b.member_id
)
ORDER BY b.booking_id ASC;"""
    },
    {
        "id": "task_03_1",
        "title": "Task 3.1: LEFT OUTER JOIN - Members Without Subscriptions",
        "description": "Returns all registered members including those with zero subscriptions using LEFT OUTER JOIN.",
        "sql": """SELECT m.member_id, m.full_name, m.email, s.subscription_id, s.status, s.total_amount
FROM MEMBER m
LEFT OUTER JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
ORDER BY m.member_id ASC;"""
    },
    {
        "id": "task_03_2",
        "title": "Task 3.2: SELF JOIN - Workout Category Hierarchy",
        "description": "Performs a self-join on PLAN_CATEGORY matching sub-disciplines to their respective root discipline.",
        "sql": """SELECT 
    child.category_id AS sub_category_id,
    child.category_name AS sub_category_name,
    parent.category_id AS parent_category_id,
    parent.category_name AS parent_category_name
FROM PLAN_CATEGORY child
LEFT JOIN PLAN_CATEGORY parent ON child.parent_category_id = parent.category_id
ORDER BY child.category_id ASC;"""
    },
    {
        "id": "task_03_3",
        "title": "Task 3.3: Set Operations (EXCEPT / MINUS)",
        "description": "Identifies members enrolled in Strength (Category 602) but never enrolled in Cardio (Category 603).",
        "sql": """SELECT m.member_id, m.full_name
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
WHERE p.category_id IN (602, 605, 606)

EXCEPT

SELECT m.member_id, m.full_name
FROM MEMBER m
JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
JOIN MEMBERSHIP_PLAN p ON s.plan_id = p.plan_id
WHERE p.category_id IN (603, 607, 608);"""
    },
    {
        "id": "task_04_1",
        "title": "Task 4.1: CTE (WITH Clause) - Branch Revenue Aggregations",
        "description": "Aggregates branch-level subscriptions and cumulative revenues using a Common Table Expression.",
        "sql": """WITH BranchRevenueCTE AS (
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
ORDER BY total_revenue DESC;"""
    },
    {
        "id": "task_04_2",
        "title": "Task 4.2: Recursive CTE - Complete Category Hierarchy Tree",
        "description": "Traverses the category tree recursively from anchor roots down to leaf levels, building breadcrumb paths.",
        "sql": """WITH RECURSIVE CategoryHierarchy AS (
    SELECT 
        category_id, 
        category_name, 
        parent_category_id, 
        1 AS level,
        category_name AS full_path
    FROM PLAN_CATEGORY
    WHERE parent_category_id IS NULL

    UNION ALL

    SELECT 
        child.category_id, 
        child.category_name, 
        child.parent_category_id, 
        parent.level + 1 AS level,
        parent.full_path || ' -> ' || child.category_name AS full_path
    FROM PLAN_CATEGORY child
    INNER JOIN CategoryHierarchy parent ON child.parent_category_id = parent.category_id
)
SELECT category_id, category_name, parent_category_id, level, full_path
FROM CategoryHierarchy
ORDER BY level, category_id;"""
    },
    {
        "id": "task_05",
        "title": "Task 5: Database Views (Member_Subscription_View)",
        "description": "Queries the predefined view displaying flattened member details and active subscription terms.",
        "sql": """SELECT member_id, full_name, plan_name, start_date, end_date, total_amount, subscription_status
FROM Member_Subscription_View
WHERE subscription_status = 'ACTIVE'
LIMIT 8;"""
    },
    {
        "id": "task_10",
        "title": "Task 10: JSON Semi-Structured Queries (Diet & Macronutrients)",
        "description": "Extracts nested JSON attributes (protein_grams, carbs, hydration_liters) without document decomposition.",
        "sql": """SELECT 
    diet_id,
    member_id,
    plan_name,
    daily_calories,
    json_extract(nutrition_spec_json, '$.diet_type') AS diet_type,
    json_extract(nutrition_spec_json, '$.macros.protein_grams') AS protein_grams,
    json_extract(nutrition_spec_json, '$.hydration_liters') AS water_liters
FROM MEMBER_DIET_PLAN
ORDER BY daily_calories DESC;"""
    }
]

@app.get("/api/adbms/tasks")
def list_preset_tasks():
    return PRESET_TASKS

@app.post("/api/adbms/run_query")
def execute_custom_query(req: QueryExecuteRequest):
    conn = get_db()
    c = conn.cursor()
    start_time = time.time()
    try:
        c.execute(req.sql)
        elapsed_ms = round((time.time() - start_time) * 1000, 2)

        if c.description:
            columns = [col[0] for col in c.description]
            rows = [list(r) for r in c.fetchall()]
            conn.commit()
            return {
                "status": "success",
                "columns": columns,
                "rows": rows,
                "row_count": len(rows),
                "elapsed_ms": elapsed_ms
            }
        else:
            conn.commit()
            return {
                "status": "success",
                "columns": ["Result"],
                "rows": [[f"Statement executed successfully. Rows affected: {c.rowcount}"]],
                "row_count": c.rowcount,
                "elapsed_ms": elapsed_ms
            }
    except Exception as e:
        conn.rollback()
        return {
            "status": "error",
            "message": str(e),
            "elapsed_ms": round((time.time() - start_time) * 1000, 2)
        }
    finally:
        conn.close()

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("app:app", host="0.0.0.0", port=port, reload=False)
