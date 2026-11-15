-- ============================================================================
-- FitTrack: Smart Gym Management System
-- TASK 7: Exception Handling (Predefined and User-Defined Exceptions)
-- ============================================================================

-- ============================================================================
-- 7.1 Invoice Generation Procedure with Predefined Exception Handling
-- ============================================================================
CREATE OR REPLACE PROCEDURE generate_member_invoice (
    p_payment_id IN NUMBER
) IS
    v_payment_status VARCHAR2(20);
    v_amount         NUMBER;
    v_subscription_id NUMBER;
    v_member_name    VARCHAR2(100);
    v_tax_amt        NUMBER;
    v_final_total    NUMBER;
    v_invoice_id     NUMBER;
    v_invoice_num    VARCHAR2(50);
BEGIN
    -- Query Payment Details (May raise NO_DATA_FOUND if ID is invalid)
    SELECT subscription_id, amount, payment_status
    INTO v_subscription_id, v_amount, v_payment_status
    FROM PAYMENT
    WHERE payment_id = p_payment_id;

    -- Query Member Details via Subscription
    SELECT m.full_name
    INTO v_member_name
    FROM MEMBER m
    JOIN MEMBER_SUBSCRIPTION s ON m.member_id = s.member_id
    WHERE s.subscription_id = v_subscription_id;

    -- Check if payment is successful
    IF v_payment_status != 'SUCCESS' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Cannot generate invoice for unpaid or failed transaction.');
    END IF;

    -- Compute Tax and Total
    v_tax_amt     := ROUND(v_amount * 0.18, 2);
    v_final_total := v_amount + v_tax_amt;
    v_invoice_id  := p_payment_id + 500;
    v_invoice_num := 'INV-FT-TAX-' || p_payment_id;

    -- Insert Invoice (May raise DUP_VAL_ON_INDEX if invoice exists)
    INSERT INTO INVOICE (
        invoice_id, payment_id, invoice_number, invoice_date, tax_rate_percent, tax_amount, final_total
    ) VALUES (
        v_invoice_id, p_payment_id, v_invoice_num, TRUNC(SYSDATE), 18.00, v_tax_amt, v_final_total
    );

    DBMS_OUTPUT.PUT_LINE('Success: Invoice ' || v_invoice_num || ' issued to ' || v_member_name);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error [NO_DATA_FOUND]: Payment record with ID ' || p_payment_id || ' does not exist.');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error [DUP_VAL_ON_INDEX]: Invoice for payment ' || p_payment_id || ' has already been generated.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unhandled Error: ' || SQLCODE || ' - ' || SQLERRM);
END generate_member_invoice;
/


-- ============================================================================
-- 7.2 Class Booking Procedure with User-Defined Exceptions
-- ============================================================================
CREATE OR REPLACE PROCEDURE book_fitness_session (
    p_booking_id IN NUMBER,
    p_member_id  IN NUMBER,
    p_class_id   IN NUMBER
) IS
    -- Declaration of User-Defined Exceptions
    e_insufficient_slots   EXCEPTION;
    e_expired_membership   EXCEPTION;
    e_duplicate_booking    EXCEPTION;
    e_invalid_member       EXCEPTION;

    PRAGMA EXCEPTION_INIT(e_duplicate_booking, -20010);
    PRAGMA EXCEPTION_INIT(e_insufficient_slots, -20011);
    PRAGMA EXCEPTION_INIT(e_expired_membership, -20012);

    v_member_status   VARCHAR2(20);
    v_member_exists   NUMBER := 0;
    v_existing_books  NUMBER := 0;
    v_max_capacity    NUMBER := 0;
    v_current_booked  NUMBER := 0;
BEGIN
    -- Check 1: Validate Member Existence
    SELECT COUNT(*) INTO v_member_exists
    FROM MEMBER
    WHERE member_id = p_member_id;

    IF v_member_exists = 0 THEN
        RAISE e_invalid_member;
    END IF;

    -- Check 2: Validate Active Subscription
    SELECT COALESCE(MAX(status), 'NONE') INTO v_member_status
    FROM MEMBER_SUBSCRIPTION
    WHERE member_id = p_member_id AND status = 'ACTIVE' AND end_date >= TRUNC(SYSDATE);

    IF v_member_status != 'ACTIVE' THEN
        RAISE e_expired_membership;
    END IF;

    -- Check 3: Prevent Duplicate Booking for Same Member & Class
    SELECT COUNT(*) INTO v_existing_books
    FROM BOOKING
    WHERE member_id = p_member_id AND class_id = p_class_id AND booking_status = 'CONFIRMED';

    IF v_existing_books > 0 THEN
        RAISE e_duplicate_booking;
    END IF;

    -- Check 4: Capacity Check
    SELECT max_capacity INTO v_max_capacity
    FROM CLASS_SCHEDULE
    WHERE class_id = p_class_id;

    SELECT COUNT(*) INTO v_current_booked
    FROM BOOKING
    WHERE class_id = p_class_id AND booking_status = 'CONFIRMED';

    IF v_current_booked >= v_max_capacity THEN
        RAISE e_insufficient_slots;
    END IF;

    -- All checks passed: Confirm Booking
    INSERT INTO BOOKING (booking_id, member_id, class_id, booking_date, booking_status)
    VALUES (p_booking_id, p_member_id, p_class_id, SYSTIMESTAMP, 'CONFIRMED');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Booking #' || p_booking_id || ' confirmed successfully for Member #' || p_member_id);

EXCEPTION
    WHEN e_invalid_member THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Custom Exception: Member #' || p_member_id || ' does not exist in the gym database.');
    WHEN e_expired_membership THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Custom Exception [EXPIRED_MEMBERSHIP]: Member has no active subscription. Booking denied.');
    WHEN e_duplicate_booking THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Custom Exception [DUPLICATE_BOOKING]: Member #' || p_member_id || ' is already booked for this class.');
    WHEN e_insufficient_slots THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Custom Exception [INSUFFICIENT_SLOTS]: Class #' || p_class_id || ' is completely full! Capacity: ' || v_max_capacity);
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('General Error: ' || SQLERRM);
END book_fitness_session;
/
