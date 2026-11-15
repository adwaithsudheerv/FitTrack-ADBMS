-- ============================================================================
-- FitTrack: Smart Gym Management System
-- TASK 6: PL/SQL Programming - Variables, Control Structures, Procedures & Functions
-- Provided in both Oracle PL/SQL and PostgreSQL PL/pgSQL Syntax
-- ============================================================================

-- ============================================================================
-- PART A: ORACLE PL/SQL IMPLEMENTATION
-- ============================================================================

-- 6.1 Function: Calculate Final Payable Amount After Applying Discounts & Tax
CREATE OR REPLACE FUNCTION calculate_final_bill (
    p_base_price IN NUMBER,
    p_coupon_code IN VARCHAR2 DEFAULT NULL
) RETURN NUMBER IS
    v_discount_pct NUMBER := 0.00;
    v_discount_amt NUMBER := 0.00;
    v_tax_rate     NUMBER := 0.18; -- 18% GST
    v_subtotal     NUMBER;
    v_final_total  NUMBER;
BEGIN
    -- Determine discount using IF-ELSE conditions based on coupon code
    IF p_coupon_code = 'FITFIRST10' THEN
        v_discount_pct := 0.10;
    ELSIF p_coupon_code = 'ANNUALGOLD20' THEN
        v_discount_pct := 0.20;
    ELSIF p_coupon_code = 'STUDENT15' THEN
        v_discount_pct := 0.15;
    ELSIF p_coupon_code = 'NEWYEAR30' THEN
        v_discount_pct := 0.30;
    ELSE
        -- Tier-based conditional discount on high cart values
        IF p_base_price >= 30000 THEN
            v_discount_pct := 0.08;
        ELSIF p_base_price >= 15000 THEN
            v_discount_pct := 0.05;
        ELSE
            v_discount_pct := 0.00;
        END IF;
    END IF;

    v_discount_amt := p_base_price * v_discount_pct;
    v_subtotal     := p_base_price - v_discount_amt;
    v_final_total  := v_subtotal + (v_subtotal * v_tax_rate);

    RETURN ROUND(v_final_total, 2);
END calculate_final_bill;
/

-- 6.2 Function: Return Current Available Slots for a Scheduled Fitness Class
CREATE OR REPLACE FUNCTION get_class_available_slots (
    p_class_id IN NUMBER
) RETURN NUMBER IS
    v_max_cap NUMBER := 0;
    v_booked_count NUMBER := 0;
    v_available_slots NUMBER := 0;
BEGIN
    -- Fetch maximum class capacity
    SELECT max_capacity INTO v_max_cap
    FROM CLASS_SCHEDULE
    WHERE class_id = p_class_id;

    -- Fetch count of confirmed bookings
    SELECT COUNT(*) INTO v_booked_count
    FROM BOOKING
    WHERE class_id = p_class_id AND booking_status = 'CONFIRMED';

    v_available_slots := v_max_cap - v_booked_count;

    IF v_available_slots < 0 THEN
        v_available_slots := 0;
    END IF;

    RETURN v_available_slots;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1; -- Indicates class not found
END get_class_available_slots;
/

-- 6.3 Stored Procedure: Enroll Member and Process Subscription Atomically
CREATE OR REPLACE PROCEDURE enroll_member_subscription (
    p_subscription_id IN NUMBER,
    p_member_id       IN NUMBER,
    p_plan_id         IN NUMBER,
    p_branch_id       IN NUMBER,
    p_payment_mode    IN VARCHAR2,
    p_coupon_code     IN VARCHAR2 DEFAULT NULL
) IS
    v_base_price     NUMBER;
    v_duration       NUMBER;
    v_final_amount   NUMBER;
    v_start_date     DATE := SYSDATE;
    v_end_date       DATE;
    v_payment_id     NUMBER;
    v_invoice_id     NUMBER;
    v_invoice_num    VARCHAR2(50);
BEGIN
    -- Retrieve plan details
    SELECT base_price, duration_months 
    INTO v_base_price, v_duration
    FROM MEMBERSHIP_PLAN
    WHERE plan_id = p_plan_id;

    -- Calculate end date and final payable bill
    v_end_date := ADD_MONTHS(v_start_date, v_duration);
    v_final_amount := calculate_final_bill(v_base_price, p_coupon_code);

    -- 1. Insert Subscription Record
    INSERT INTO MEMBER_SUBSCRIPTION (
        subscription_id, member_id, plan_id, branch_id, start_date, end_date, total_amount, status
    ) VALUES (
        p_subscription_id, p_member_id, p_plan_id, p_branch_id, v_start_date, v_end_date, v_final_amount, 'ACTIVE'
    );

    -- 2. Insert Base Subscription Item
    INSERT INTO SUBSCRIPTION_ITEM (
        item_id, subscription_id, item_name, quantity, unit_price
    ) VALUES (
        p_subscription_id + 1000, p_subscription_id, 'Primary Membership Plan Enrollment', 1, v_base_price
    );

    -- 3. Record Payment
    v_payment_id := p_subscription_id + 2000;
    INSERT INTO PAYMENT (
        payment_id, subscription_id, payment_mode, amount, payment_status, payment_date
    ) VALUES (
        v_payment_id, p_subscription_id, p_payment_mode, v_final_amount, 'SUCCESS', SYSTIMESTAMP
    );

    -- 4. Generate Official Tax Invoice
    v_invoice_id  := p_subscription_id + 3000;
    v_invoice_num := 'INV-FT-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || p_subscription_id;
    INSERT INTO INVOICE (
        invoice_id, payment_id, invoice_number, invoice_date, tax_rate_percent, tax_amount, final_total
    ) VALUES (
        v_invoice_id, v_payment_id, v_invoice_num, TRUNC(SYSDATE), 18.00, ROUND(v_final_amount * 0.18 / 1.18, 2), v_final_amount
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Enrollment successful! Generated Invoice: ' || v_invoice_num);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Enrollment transaction failed: ' || SQLERRM);
        RAISE;
END enroll_member_subscription;
/

-- 6.4 Stored Procedure: Cancel Subscription and Issue Pro-rated Refund
CREATE OR REPLACE PROCEDURE cancel_subscription_refund (
    p_subscription_id IN NUMBER,
    p_refund_reason   IN VARCHAR2
) IS
    v_status       VARCHAR2(20);
    v_payment_id   NUMBER;
    v_amount       NUMBER;
    v_refund_id    NUMBER;
    v_refund_amt   NUMBER;
BEGIN
    -- Check current subscription status
    SELECT status, total_amount INTO v_status, v_amount
    FROM MEMBER_SUBSCRIPTION
    WHERE subscription_id = p_subscription_id;

    IF v_status != 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Only active subscriptions are eligible for cancellation.');
    END IF;

    -- Retrieve corresponding successful payment
    SELECT payment_id INTO v_payment_id
    FROM PAYMENT
    WHERE subscription_id = p_subscription_id AND payment_status = 'SUCCESS';

    -- Compute 80% refund policy (20% administrative handling charge deduction)
    v_refund_amt := ROUND(v_amount * 0.80, 2);
    v_refund_id  := p_subscription_id + 5000;

    -- Update subscription status
    UPDATE MEMBER_SUBSCRIPTION
    SET status = 'CANCELLED'
    WHERE subscription_id = p_subscription_id;

    -- Insert Refund Record
    INSERT INTO REFUND (
        refund_id, payment_id, refund_amount, refund_reason, refund_status, refund_date
    ) VALUES (
        v_refund_id, v_payment_id, v_refund_amt, p_refund_reason, 'PROCESSED', SYSTIMESTAMP
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Subscription cancelled. Refund of INR ' || v_refund_amt || ' processed successfully.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Subscription or Payment ID not found.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Cancellation error: ' || SQLERRM);
        RAISE;
END cancel_subscription_refund;
/

-- 6.5 Menu-Driven Program for Managing Booking Status Using CASE Statements
DECLARE
    v_choice NUMBER := 2; -- Simulating user menu input: 1: Confirm, 2: Reschedule, 3: Cancel, 4: Complete
    v_booking_id NUMBER := 1301;
    v_new_status VARCHAR2(20);
    v_status_desc VARCHAR2(100);
BEGIN
    CASE v_choice
        WHEN 1 THEN
            v_new_status := 'CONFIRMED';
            v_status_desc := 'Booking confirmed. Locker reserved.';
        WHEN 2 THEN
            v_new_status := 'WAITLISTED';
            v_status_desc := 'Moved to slot waitlist for the next cycle.';
        WHEN 3 THEN
            v_new_status := 'CANCELLED';
            v_status_desc := 'Slot released back to branch inventory.';
        WHEN 4 THEN
            v_new_status := 'ATTENDED';
            v_status_desc := 'Member attendance verified at turnstile.';
        ELSE
            v_new_status := 'UNKNOWN';
            v_status_desc := 'Invalid operation selected.';
    END CASE;

    IF v_new_status != 'UNKNOWN' THEN
        UPDATE BOOKING
        SET booking_status = v_new_status
        WHERE booking_id = v_booking_id;
        DBMS_OUTPUT.PUT_LINE('Updated Booking #' || v_booking_id || ': ' || v_status_desc);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: ' || v_status_desc);
    END IF;
END;
/


-- ============================================================================
-- PART B: POSTGRESQL PL/pgSQL IMPLEMENTATION
-- (Ready for execution on PostgreSQL / SQLite Python app)
-- ============================================================================

-- Function in PL/pgSQL: Calculate Final Bill
CREATE OR REPLACE FUNCTION fn_calculate_final_bill(p_base_price NUMERIC, p_coupon_code TEXT DEFAULT NULL)
RETURNS NUMERIC AS $$
DECLARE
    v_discount_pct NUMERIC := 0.00;
    v_subtotal NUMERIC;
    v_final NUMERIC;
BEGIN
    IF p_coupon_code = 'FITFIRST10' THEN
        v_discount_pct := 0.10;
    ELSIF p_coupon_code = 'ANNUALGOLD20' THEN
        v_discount_pct := 0.20;
    ELSIF p_coupon_code = 'STUDENT15' THEN
        v_discount_pct := 0.15;
    ELSIF p_base_price >= 25000 THEN
        v_discount_pct := 0.08;
    ELSE
        v_discount_pct := 0.00;
    END IF;

    v_subtotal := p_base_price * (1.0 - v_discount_pct);
    v_final := v_subtotal * 1.18; -- 18% tax
    RETURN ROUND(v_final, 2);
END;
$$ LANGUAGE plpgsql;

-- Function in PL/pgSQL: Get Remaining Available Slots
CREATE OR REPLACE FUNCTION fn_get_available_slots(p_class_id INT)
RETURNS INT AS $$
DECLARE
    v_cap INT;
    v_booked INT;
BEGIN
    SELECT max_capacity INTO v_cap FROM CLASS_SCHEDULE WHERE class_id = p_class_id;
    IF NOT FOUND THEN
        RETURN -1;
    END IF;
    SELECT COUNT(*) INTO v_booked FROM BOOKING WHERE class_id = p_class_id AND booking_status = 'CONFIRMED';
    RETURN GREATEST(v_cap - v_booked, 0);
END;
$$ LANGUAGE plpgsql;
