-- ============================================================================
-- FitTrack: Smart Gym Management System
-- ADBMS Lab Project: Mock Data Insertion (10 Records Per Table)
-- ============================================================================

-- 1. ADDRESS (10 records)
INSERT INTO ADDRESS VALUES (1, '100 Feet Road, Indiranagar', 'Bangalore', 'Karnataka', '560038');
INSERT INTO ADDRESS VALUES (2, '5th Block, Koramangala', 'Bangalore', 'Karnataka', '560095');
INSERT INTO ADDRESS VALUES (3, 'HSR Layout Sector 2', 'Bangalore', 'Karnataka', '560102');
INSERT INTO ADDRESS VALUES (4, 'Banjara Hills Road No 12', 'Hyderabad', 'Telangana', '500034');
INSERT INTO ADDRESS VALUES (5, 'Jubilee Hills Checkpost', 'Hyderabad', 'Telangana', '500033');
INSERT INTO ADDRESS VALUES (6, 'Connaught Place Outer Circle', 'New Delhi', 'Delhi', '110001');
INSERT INTO ADDRESS VALUES (7, 'Bandra West, Linking Road', 'Mumbai', 'Maharashtra', '400050');
INSERT INTO ADDRESS VALUES (8, 'Anna Nagar 2nd Avenue', 'Chennai', 'Tamil Nadu', '600040');
INSERT INTO ADDRESS VALUES (9, 'Sector 18 Market', 'Noida', 'Uttar Pradesh', '201301');
INSERT INTO ADDRESS VALUES (10, 'Koregaon Park North Main Rd', 'Pune', 'Maharashtra', '411001');

-- 2. GYM_BRANCH (10 records)
INSERT INTO GYM_BRANCH VALUES (101, 'FitTrack Elite - Indiranagar', 1, '+91-9880011221', '05:30 AM', '11:00 PM');
INSERT INTO GYM_BRANCH VALUES (102, 'FitTrack Arena - Koramangala', 2, '+91-9880011222', '06:00 AM', '10:30 PM');
INSERT INTO GYM_BRANCH VALUES (103, 'FitTrack Prime - HSR Layout', 3, '+91-9880011223', '06:00 AM', '10:00 PM');
INSERT INTO GYM_BRANCH VALUES (104, 'FitTrack Platinum - Banjara Hills', 4, '+91-9880011224', '05:30 AM', '11:00 PM');
INSERT INTO GYM_BRANCH VALUES (105, 'FitTrack Studio - Jubilee Hills', 5, '+91-9880011225', '06:30 AM', '09:30 PM');
INSERT INTO GYM_BRANCH VALUES (106, 'FitTrack Central - Connaught Place', 6, '+91-9880011226', '06:00 AM', '10:00 PM');
INSERT INTO GYM_BRANCH VALUES (107, 'FitTrack Edge - Bandra West', 7, '+91-9880011227', '05:00 AM', '11:30 PM');
INSERT INTO GYM_BRANCH VALUES (108, 'FitTrack Pro - Anna Nagar', 8, '+91-9880011228', '06:00 AM', '10:00 PM');
INSERT INTO GYM_BRANCH VALUES (109, 'FitTrack Apex - Sector 18', 9, '+91-9880011229', '06:00 AM', '10:30 PM');
INSERT INTO GYM_BRANCH VALUES (110, 'FitTrack Zen - Koregaon Park', 10, '+91-9880011230', '06:00 AM', '10:00 PM');

-- 3. EQUIPMENT_VENDOR (10 records)
INSERT INTO EQUIPMENT_VENDOR VALUES (201, 'TechnoGym India Pvt Ltd', 'sales@technogym.in', '+91-11-45601100', 'GSTIN29AAACT1001A1Z1');
INSERT INTO EQUIPMENT_VENDOR VALUES (202, 'LifeFitness Solutions', 'contact@lifefitness.in', '+91-22-67802200', 'GSTIN27AAACL2002B1Z2');
INSERT INTO EQUIPMENT_VENDOR VALUES (203, 'Rogue Fitness India', 'support@roguefitness.in', '+91-80-23403300', 'GSTIN29AAACR3003C1Z3');
INSERT INTO EQUIPMENT_VENDOR VALUES (204, 'Precor Commercial Gear', 'orders@precor.co.in', '+91-40-89104400', 'GSTIN36AAACP4004D1Z4');
INSERT INTO EQUIPMENT_VENDOR VALUES (205, 'Hammer Strength Works', 'info@hammerstrength.in', '+91-44-33205500', 'GSTIN33AAACH5005E1Z5');
INSERT INTO EQUIPMENT_VENDOR VALUES (206, 'Matrix Fitness Distro', 'commercial@matrixfit.in', '+91-120-410066', 'GSTIN09AAACM6006F1Z6');
INSERT INTO EQUIPMENT_VENDOR VALUES (207, 'Bodycraft Machines Co', 'care@bodycraft.in', '+91-20-25607700', 'GSTIN27AAACB7007G1Z7');
INSERT INTO EQUIPMENT_VENDOR VALUES (208, 'Eleiko Barbell Supplies', 'india@eleiko.com', '+91-80-66708800', 'GSTIN29AAACE8008H1Z8');
INSERT INTO EQUIPMENT_VENDOR VALUES (209, 'Concept2 Rowers India', 'sales@concept2india.com', '+91-11-22309900', 'GSTIN07AAACC9009I1Z9');
INSERT INTO EQUIPMENT_VENDOR VALUES (210, 'Afton Fitness Commercial', 'help@aftonfitness.com', '+91-44-49001010', 'GSTIN33AAACA1010J1Z0');

-- 4. MEMBER (10 records)
INSERT INTO MEMBER VALUES (301, 101, 1, 'Rahul Sharma', 'rahul.sharma@example.com', '+91-9876500001', 'hash_pass_301', '2026-01-10', 'MEMBER');
INSERT INTO MEMBER VALUES (302, 101, 2, 'Priya Patel', 'priya.patel@example.com', '+91-9876500002', 'hash_pass_302', '2026-01-15', 'MEMBER');
INSERT INTO MEMBER VALUES (303, 102, 3, 'Aditya Varma', 'aditya.varma@example.com', '+91-9876500003', 'hash_pass_303', '2026-02-01', 'MEMBER');
INSERT INTO MEMBER VALUES (304, 103, 4, 'Sneha Reddy', 'sneha.reddy@example.com', '+91-9876500004', 'hash_pass_304', '2026-02-14', 'MEMBER');
INSERT INTO MEMBER VALUES (305, 104, 5, 'Vikram Malhotra', 'vikram.m@example.com', '+91-9876500005', 'hash_pass_305', '2026-03-01', 'MEMBER');
INSERT INTO MEMBER VALUES (306, 105, 6, 'Ananya Sen', 'ananya.sen@example.com', '+91-9876500006', 'hash_pass_306', '2026-03-12', 'MEMBER');
INSERT INTO MEMBER VALUES (307, 106, 7, 'Rohan Kapoor', 'rohan.k@example.com', '+91-9876500007', 'hash_pass_307', '2026-03-20', 'MEMBER');
INSERT INTO MEMBER VALUES (308, 107, 8, 'Deepika Iyer', 'deepika.iyer@example.com', '+91-9876500008', 'hash_pass_308', '2026-04-05', 'MEMBER');
INSERT INTO MEMBER VALUES (309, 108, 9, 'Kunal Singhania', 'kunal.s@example.com', '+91-9876500009', 'hash_pass_309', '2026-04-18', 'ADMIN');
INSERT INTO MEMBER VALUES (310, 109, 10, 'Meera Joshi', 'meera.joshi@example.com', '+91-9876500010', 'hash_pass_310', '2026-05-01', 'MEMBER');

-- 5. MEMBER_PROFILE (10 records)
INSERT INTO MEMBER_PROFILE VALUES (401, 301, '1995-04-12', 'Male', 178.50, 76.50, '+91-9876599901', '{"blood_group": "O+", "allergies": ["peanuts"], "fitness_goal": "hypertrophy", "target_weight": 80.0}');
INSERT INTO MEMBER_PROFILE VALUES (402, 302, '1998-08-25', 'Female', 163.00, 58.00, '+91-9876599902', '{"blood_group": "B+", "allergies": [], "fitness_goal": "weight_loss", "target_weight": 52.0}');
INSERT INTO MEMBER_PROFILE VALUES (403, 303, '1992-11-03', 'Male', 182.00, 88.00, '+91-9876599903', '{"blood_group": "A+", "allergies": ["lactose"], "fitness_goal": "strength", "target_weight": 84.0}');
INSERT INTO MEMBER_PROFILE VALUES (404, 304, '1997-02-18', 'Female', 168.00, 62.00, '+91-9876599904', '{"blood_group": "AB+", "allergies": [], "fitness_goal": "endurance", "target_weight": 58.0}');
INSERT INTO MEMBER_PROFILE VALUES (405, 305, '1989-07-30', 'Male', 175.00, 82.50, '+91-9876599905', '{"blood_group": "O-", "allergies": ["gluten"], "fitness_goal": "general_fitness", "target_weight": 75.0}');
INSERT INTO MEMBER_PROFILE VALUES (406, 306, '2000-01-15', 'Female', 158.00, 50.00, '+91-9876599906', '{"blood_group": "A-", "allergies": [], "fitness_goal": "flexibility", "target_weight": 50.0}');
INSERT INTO MEMBER_PROFILE VALUES (407, 307, '1994-09-09', 'Male', 180.00, 79.00, '+91-9876599907', '{"blood_group": "B+", "allergies": [], "fitness_goal": "hypertrophy", "target_weight": 82.0}');
INSERT INTO MEMBER_PROFILE VALUES (408, 308, '1996-05-22', 'Female', 165.00, 60.00, '+91-9876599908', '{"blood_group": "O+", "allergies": [], "fitness_goal": "tone", "target_weight": 57.0}');
INSERT INTO MEMBER_PROFILE VALUES (409, 309, '1985-03-10', 'Male', 172.00, 74.00, '+91-9876599909', '{"blood_group": "AB-", "allergies": [], "fitness_goal": "mobility", "target_weight": 72.0}');
INSERT INTO MEMBER_PROFILE VALUES (410, 310, '1999-12-05', 'Female', 170.00, 64.00, '+91-9876599910', '{"blood_group": "B-", "allergies": ["dust"], "fitness_goal": "cardiovascular", "target_weight": 60.0}');

-- 6. TRAINER (10 records)
INSERT INTO TRAINER VALUES (501, 101, 'Karan Grover', 'karan.grover@fittrack.com', '+91-9123400001', 'Bodybuilding & Hypertrophy', 1200.00, 'AVAILABLE');
INSERT INTO TRAINER VALUES (502, 101, 'Natasha Dsouza', 'natasha.d@fittrack.com', '+91-9123400002', 'CrossFit & Functional Training', 1500.00, 'AVAILABLE');
INSERT INTO TRAINER VALUES (503, 102, 'Rajesh Kannan', 'rajesh.k@fittrack.com', '+91-9123400003', 'Powerlifting & Olympic Lifting', 1400.00, 'AVAILABLE');
INSERT INTO TRAINER VALUES (504, 103, 'Aarti Nair', 'aarti.n@fittrack.com', '+91-9123400004', 'Ashtanga Yoga & Core Pilates', 1100.00, 'AVAILABLE');
INSERT INTO TRAINER VALUES (505, 104, 'Sameer Sheikh', 'sameer.s@fittrack.com', '+91-9123400005', 'HIIT & Metabolic Conditioning', 1300.00, 'IN_SESSION');
INSERT INTO TRAINER VALUES (506, 105, 'Zoya Farooqui', 'zoya.f@fittrack.com', '+91-9123400006', 'Spin Cycle & Endurance Coach', 1250.00, 'AVAILABLE');
INSERT INTO TRAINER VALUES (507, 106, 'Arjun Rampal', 'arjun.r@fittrack.com', '+91-9123400007', 'Calisthenics & Mobility', 1350.00, 'ON_LEAVE');
INSERT INTO TRAINER VALUES (508, 107, 'Shweta Rao', 'shweta.r@fittrack.com', '+91-9123400008', 'Zumba & Aerobics Specialist', 1000.00, 'AVAILABLE');
INSERT INTO TRAINER VALUES (509, 108, 'Devendra Bisht', 'devendra.b@fittrack.com', '+91-9123400009', 'Boxing & Kickboxing Conditioning', 1600.00, 'AVAILABLE');
INSERT INTO TRAINER VALUES (510, 109, 'Pooja Bhatt', 'pooja.b@fittrack.com', '+91-9123400010', 'Pre/Post Natal Fitness & Rehabilitation', 1700.00, 'AVAILABLE');

-- 7. PLAN_CATEGORY (10 records: Hierarchical parent and sub-categories)
INSERT INTO PLAN_CATEGORY VALUES (601, 'Fitness & Wellness Root', NULL);
INSERT INTO PLAN_CATEGORY VALUES (602, 'Strength & Hypertrophy', 601);
INSERT INTO PLAN_CATEGORY VALUES (603, 'Cardiovascular & Endurance', 601);
INSERT INTO PLAN_CATEGORY VALUES (604, 'Mind & Body Recovery', 601);
INSERT INTO PLAN_CATEGORY VALUES (605, 'Powerlifting Specialization', 602);
INSERT INTO PLAN_CATEGORY VALUES (606, 'Bodybuilding Pro Tier', 602);
INSERT INTO PLAN_CATEGORY VALUES (607, 'High Intensity Interval Training', 603);
INSERT INTO PLAN_CATEGORY VALUES (608, 'Indoor Spinning & Row', 603);
INSERT INTO PLAN_CATEGORY VALUES (609, 'Power Yoga & Meditation', 604);
INSERT INTO PLAN_CATEGORY VALUES (610, 'Rehab & Physiotherapy Stretches', 604);

-- 8. MEMBERSHIP_PLAN (10 records)
INSERT INTO MEMBERSHIP_PLAN VALUES (701, 605, 'Iron Champion Annual', 12, 28000.00, 'Full access to Olympic lifting platforms, heavy weights, and recovery plunge pool');
INSERT INTO MEMBERSHIP_PLAN VALUES (702, 606, 'Hypertrophy Gold Quarterly', 3, 10500.00, 'Quarterly access to commercial selectorized machines and premium free weights');
INSERT INTO MEMBERSHIP_PLAN VALUES (703, 607, 'MetCon HIIT Monthly', 1, 4500.00, 'Intensive high-intensity functional training classes and conditioning');
INSERT INTO MEMBERSHIP_PLAN VALUES (704, 608, 'Spin & Cycle Silver Half-Yearly', 6, 16000.00, 'Dedicated spinning studio reservation privileges and biometric tracking');
INSERT INTO MEMBERSHIP_PLAN VALUES (705, 609, 'Zen Yoga & Pilates Pass', 3, 9000.00, 'Unlimited guided yoga, mat pilates, and steam bath access');
INSERT INTO MEMBERSHIP_PLAN VALUES (706, 610, 'Physio Rehab & Mobility 6M', 6, 19500.00, 'Guided rehabilitation stretches, posture correction, and infrared sauna');
INSERT INTO MEMBERSHIP_PLAN VALUES (707, 602, 'All-Access Black Diamond Annual', 12, 38000.00, 'Unlimited multi-branch gym access, 12 complimentary PT sessions, and towel service');
INSERT INTO MEMBERSHIP_PLAN VALUES (708, 603, 'Cardio Blast Monthly Starter', 1, 3000.00, 'Treadmill, elliptical, rowing access, and initial fitness assessment');
INSERT INTO MEMBERSHIP_PLAN VALUES (709, 602, 'Weekend Warrior Bi-Monthly', 2, 5500.00, 'Saturday and Sunday unlimited access across all training zones');
INSERT INTO MEMBERSHIP_PLAN VALUES (710, 601, 'Student Fitness Sprint 3M', 3, 7500.00, 'Special student package with off-peak hours access and locker facility');

-- 9. PLAN_SPECIFICATION (10 records)
INSERT INTO PLAN_SPECIFICATION VALUES (801, 701, '{"tier": "Platinum", "towel_service": true, "guest_passes": 5, "pt_sessions_included": 6, "spa_access": true}');
INSERT INTO PLAN_SPECIFICATION VALUES (802, 702, '{"tier": "Gold", "towel_service": true, "guest_passes": 2, "pt_sessions_included": 2, "spa_access": false}');
INSERT INTO PLAN_SPECIFICATION VALUES (803, 703, '{"tier": "Silver", "towel_service": false, "guest_passes": 0, "pt_sessions_included": 1, "spa_access": false}');
INSERT INTO PLAN_SPECIFICATION VALUES (804, 704, '{"tier": "Gold", "towel_service": true, "guest_passes": 2, "pt_sessions_included": 0, "spa_access": false}');
INSERT INTO PLAN_SPECIFICATION VALUES (805, 705, '{"tier": "Silver", "towel_service": true, "guest_passes": 1, "pt_sessions_included": 0, "spa_access": true}');
INSERT INTO PLAN_SPECIFICATION VALUES (806, 706, '{"tier": "Gold", "towel_service": true, "guest_passes": 1, "pt_sessions_included": 4, "spa_access": true}');
INSERT INTO PLAN_SPECIFICATION VALUES (807, 707, '{"tier": "VIP_Diamond", "towel_service": true, "guest_passes": 10, "pt_sessions_included": 12, "spa_access": true}');
INSERT INTO PLAN_SPECIFICATION VALUES (808, 708, '{"tier": "Bronze", "towel_service": false, "guest_passes": 0, "pt_sessions_included": 0, "spa_access": false}');
INSERT INTO PLAN_SPECIFICATION VALUES (809, 709, '{"tier": "Bronze", "towel_service": false, "guest_passes": 0, "pt_sessions_included": 0, "spa_access": false}');
INSERT INTO PLAN_SPECIFICATION VALUES (810, 710, '{"tier": "Student", "towel_service": false, "guest_passes": 1, "pt_sessions_included": 1, "spa_access": false}');

-- 10. BRANCH_EQUIPMENT (10 records)
INSERT INTO BRANCH_EQUIPMENT VALUES (901, 101, 201, 'Skillmill Curved Treadmill', 'Cardio', 6, 'OPERATIONAL', '2026-09-15');
INSERT INTO BRANCH_EQUIPMENT VALUES (902, 101, 208, 'Eleiko Olympic Power Rack', 'Free Weights', 4, 'OPERATIONAL', '2026-10-01');
INSERT INTO BRANCH_EQUIPMENT VALUES (903, 102, 205, 'Hammer Strength Iso-Lateral Chest Press', 'Strength', 3, 'OPERATIONAL', '2026-08-20');
INSERT INTO BRANCH_EQUIPMENT VALUES (904, 102, 209, 'Concept2 RowERG Rower', 'Endurance', 5, 'OPERATIONAL', '2026-07-10');
INSERT INTO BRANCH_EQUIPMENT VALUES (905, 103, 202, 'LifeFitness Integrity Upright Bike', 'Cardio', 8, 'OPERATIONAL', '2026-09-05');
INSERT INTO BRANCH_EQUIPMENT VALUES (906, 104, 203, 'Rogue Calibrated Steel Plates (Sets)', 'Free Weights', 12, 'OPERATIONAL', '2026-10-15');
INSERT INTO BRANCH_EQUIPMENT VALUES (907, 105, 204, 'Precor Adaptive Motion Trainer (AMT)', 'Cardio', 4, 'UNDER_MAINTENANCE', '2026-11-01');
INSERT INTO BRANCH_EQUIPMENT VALUES (908, 106, 206, 'Matrix Dual Cable Cross Pulley', 'Selectorized', 2, 'OPERATIONAL', '2026-06-18');
INSERT INTO BRANCH_EQUIPMENT VALUES (909, 107, 207, 'Bodycraft Smith Machine Ensemble', 'Compound', 3, 'OPERATIONAL', '2026-08-14');
INSERT INTO BRANCH_EQUIPMENT VALUES (910, 108, 210, 'Afton Commercial Dumbbell Rack (2-50kg)', 'Free Weights', 6, 'OPERATIONAL', '2026-09-28');

-- 11. SUBSCRIPTION_CART (10 records)
INSERT INTO SUBSCRIPTION_CART VALUES (1001, 301, '2026-10-01 10:00:00');
INSERT INTO SUBSCRIPTION_CART VALUES (1002, 302, '2026-10-02 11:30:00');
INSERT INTO SUBSCRIPTION_CART VALUES (1003, 303, '2026-10-03 14:15:00');
INSERT INTO SUBSCRIPTION_CART VALUES (1004, 304, '2026-10-05 09:45:00');
INSERT INTO SUBSCRIPTION_CART VALUES (1005, 305, '2026-10-07 16:20:00');
INSERT INTO SUBSCRIPTION_CART VALUES (1006, 306, '2026-10-08 18:00:00');
INSERT INTO SUBSCRIPTION_CART VALUES (1007, 307, '2026-10-10 12:00:00');
INSERT INTO SUBSCRIPTION_CART VALUES (1008, 308, '2026-10-12 17:30:00');
INSERT INTO SUBSCRIPTION_CART VALUES (1009, 309, '2026-10-15 08:30:00');
INSERT INTO SUBSCRIPTION_CART VALUES (1010, 310, '2026-10-18 19:10:00');

-- 12. CART_ITEM (10 records)
INSERT INTO CART_ITEM VALUES (1101, 1001, 701, 1);
INSERT INTO CART_ITEM VALUES (1102, 1002, 702, 1);
INSERT INTO CART_ITEM VALUES (1103, 1003, 703, 1);
INSERT INTO CART_ITEM VALUES (1104, 1004, 704, 1);
INSERT INTO CART_ITEM VALUES (1105, 1005, 705, 1);
INSERT INTO CART_ITEM VALUES (1106, 1006, 706, 1);
INSERT INTO CART_ITEM VALUES (1107, 1007, 707, 1);
INSERT INTO CART_ITEM VALUES (1108, 1008, 708, 1);
INSERT INTO CART_ITEM VALUES (1109, 1009, 709, 1);
INSERT INTO CART_ITEM VALUES (1110, 1010, 710, 1);

-- 13. CLASS_SCHEDULE (10 records)
INSERT INTO CLASS_SCHEDULE VALUES (1201, 101, 501, 'Iron Core Hypertrophy Clinic', '2026-11-20 07:00:00', '2026-11-20 08:30:00', 15, 'SCHEDULED');
INSERT INTO CLASS_SCHEDULE VALUES (1202, 101, 502, 'Spartan CrossFit WOD', '2026-11-20 08:30:00', '2026-11-20 09:30:00', 20, 'SCHEDULED');
INSERT INTO CLASS_SCHEDULE VALUES (1203, 102, 503, 'Deadlift & Squat Form Lab', '2026-11-20 18:00:00', '2026-11-20 19:30:00', 12, 'SCHEDULED');
INSERT INTO CLASS_SCHEDULE VALUES (1204, 103, 504, 'Sunrise Ashtanga Vinyasa', '2026-11-21 06:30:00', '2026-11-21 07:45:00', 25, 'SCHEDULED');
INSERT INTO CLASS_SCHEDULE VALUES (1205, 104, 505, 'Tabata Torch Metabolic HIIT', '2026-11-21 19:00:00', '2026-11-21 20:00:00', 18, 'SCHEDULED');
INSERT INTO CLASS_SCHEDULE VALUES (1206, 105, 506, 'Tour-de-Spin Rhythm Ride', '2026-11-22 07:15:00', '2026-11-22 08:15:00', 20, 'SCHEDULED');
INSERT INTO CLASS_SCHEDULE VALUES (1207, 106, 507, 'Handstand & Rings Calisthenics', '2026-11-22 17:30:00', '2026-11-22 18:45:00', 10, 'CANCELLED');
INSERT INTO CLASS_SCHEDULE VALUES (1208, 107, 508, 'Cardio Bollywood Zumba Blast', '2026-11-23 18:30:00', '2026-11-23 19:30:00', 30, 'SCHEDULED');
INSERT INTO CLASS_SCHEDULE VALUES (1209, 108, 509, 'Boxing Conditioning & Pads', '2026-11-23 07:00:00', '2026-11-23 08:15:00', 14, 'SCHEDULED');
INSERT INTO CLASS_SCHEDULE VALUES (1210, 109, 510, 'Postural Reset & Spine Decompression', '2026-11-24 10:00:00', '2026-11-24 11:15:00', 12, 'SCHEDULED');

-- 14. BOOKING (10 records)
INSERT INTO BOOKING VALUES (1301, 301, 1201, '2026-11-15 09:00:00', 'CONFIRMED');
INSERT INTO BOOKING VALUES (1302, 302, 1202, '2026-11-15 09:30:00', 'CONFIRMED');
INSERT INTO BOOKING VALUES (1303, 303, 1203, '2026-11-15 10:15:00', 'CONFIRMED');
INSERT INTO BOOKING VALUES (1304, 304, 1204, '2026-11-15 11:00:00', 'CONFIRMED');
INSERT INTO BOOKING VALUES (1305, 305, 1205, '2026-11-15 12:20:00', 'CONFIRMED');
INSERT INTO BOOKING VALUES (1306, 306, 1206, '2026-11-15 14:00:00', 'CONFIRMED');
INSERT INTO BOOKING VALUES (1307, 307, 1208, '2026-11-15 15:45:00', 'CONFIRMED');
INSERT INTO BOOKING VALUES (1308, 308, 1209, '2026-11-15 16:30:00', 'CONFIRMED');
INSERT INTO BOOKING VALUES (1309, 310, 1210, '2026-11-15 17:10:00', 'CONFIRMED');
INSERT INTO BOOKING VALUES (1310, 301, 1203, '2026-11-15 18:00:00', 'CONFIRMED');

-- 15. MEMBER_SUBSCRIPTION (10 records)
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1401, 301, 701, 101, '2026-01-10', '2027-01-09', 28000.00, 'ACTIVE');
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1402, 302, 702, 101, '2026-01-15', '2026-04-14', 10500.00, 'ACTIVE');
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1403, 303, 703, 102, '2026-02-01', '2026-03-01', 4500.00, 'ACTIVE');
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1404, 304, 704, 103, '2026-02-14', '2026-08-13', 16000.00, 'ACTIVE');
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1405, 305, 705, 104, '2026-03-01', '2026-05-31', 9000.00, 'ACTIVE');
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1406, 306, 706, 105, '2026-03-12', '2026-09-11', 19500.00, 'ACTIVE');
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1407, 307, 707, 106, '2026-03-20', '2027-03-19', 38000.00, 'ACTIVE');
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1408, 308, 708, 107, '2026-04-05', '2026-05-04', 3000.00, 'EXPIRED');
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1409, 309, 709, 108, '2026-04-18', '2026-06-17', 5500.00, 'ACTIVE');
INSERT INTO MEMBER_SUBSCRIPTION VALUES (1410, 310, 710, 109, '2026-05-01', '2026-07-31', 7500.00, 'CANCELLED');

-- 16. SUBSCRIPTION_ITEM (10 records)
INSERT INTO SUBSCRIPTION_ITEM VALUES (1501, 1401, 'Base Annual Membership Fee', 1, 24000.00);
INSERT INTO SUBSCRIPTION_ITEM VALUES (1502, 1401, 'VIP Locker Rental (12M)', 1, 4000.00);
INSERT INTO SUBSCRIPTION_ITEM VALUES (1503, 1402, 'Base Quarterly Membership Fee', 1, 9500.00);
INSERT INTO SUBSCRIPTION_ITEM VALUES (1504, 1402, 'Nutritional Diet Consultation', 1, 1000.00);
INSERT INTO SUBSCRIPTION_ITEM VALUES (1505, 1403, 'Monthly HIIT Package', 1, 4500.00);
INSERT INTO SUBSCRIPTION_ITEM VALUES (1506, 1404, 'Spinning Pass (6M)', 1, 16000.00);
INSERT INTO SUBSCRIPTION_ITEM VALUES (1507, 1405, 'Mind-Body Yoga Pass (3M)', 1, 9000.00);
INSERT INTO SUBSCRIPTION_ITEM VALUES (1508, 1406, 'Rehab Assessment & 6M Plan', 1, 19500.00);
INSERT INTO SUBSCRIPTION_ITEM VALUES (1509, 1407, 'Black Diamond All-Access 1Y', 1, 38000.00);
INSERT INTO SUBSCRIPTION_ITEM VALUES (1510, 1410, 'Student Pass 3M', 1, 7500.00);

-- 17. PAYMENT (10 records)
INSERT INTO PAYMENT VALUES (1601, 1401, 'CREDIT_CARD', 28000.00, 'SUCCESS', '2026-01-10 10:15:00');
INSERT INTO PAYMENT VALUES (1602, 1402, 'UPI', 10500.00, 'SUCCESS', '2026-01-15 11:45:00');
INSERT INTO PAYMENT VALUES (1603, 1403, 'UPI', 4500.00, 'SUCCESS', '2026-02-01 14:30:00');
INSERT INTO PAYMENT VALUES (1604, 1404, 'NET_BANKING', 16000.00, 'SUCCESS', '2026-02-14 10:00:00');
INSERT INTO PAYMENT VALUES (1605, 1405, 'CREDIT_CARD', 9000.00, 'SUCCESS', '2026-03-01 16:40:00');
INSERT INTO PAYMENT VALUES (1606, 1406, 'DEBIT_CARD', 19500.00, 'SUCCESS', '2026-03-12 18:25:00');
INSERT INTO PAYMENT VALUES (1607, 1407, 'CREDIT_CARD', 38000.00, 'SUCCESS', '2026-03-20 12:20:00');
INSERT INTO PAYMENT VALUES (1608, 1408, 'UPI', 3000.00, 'SUCCESS', '2026-04-05 17:50:00');
INSERT INTO PAYMENT VALUES (1609, 1409, 'CASH', 5500.00, 'SUCCESS', '2026-04-18 08:45:00');
INSERT INTO PAYMENT VALUES (1610, 1410, 'UPI', 7500.00, 'SUCCESS', '2026-05-01 19:20:00');

-- 18. INVOICE (10 records)
INSERT INTO INVOICE VALUES (1701, 1601, 'INV-FT-2026-001', '2026-01-10', 18.00, 5040.00, 33040.00);
INSERT INTO INVOICE VALUES (1702, 1602, 'INV-FT-2026-002', '2026-01-15', 18.00, 1890.00, 12390.00);
INSERT INTO INVOICE VALUES (1703, 1603, 'INV-FT-2026-003', '2026-02-01', 18.00, 810.00, 5310.00);
INSERT INTO INVOICE VALUES (1704, 1604, 'INV-FT-2026-004', '2026-02-14', 18.00, 2880.00, 18880.00);
INSERT INTO INVOICE VALUES (1705, 1605, 'INV-FT-2026-005', '2026-03-01', 18.00, 1620.00, 10620.00);
INSERT INTO INVOICE VALUES (1706, 1606, 'INV-FT-2026-006', '2026-03-12', 18.00, 3510.00, 23010.00);
INSERT INTO INVOICE VALUES (1707, 1607, 'INV-FT-2026-007', '2026-03-20', 18.00, 6840.00, 44840.00);
INSERT INTO INVOICE VALUES (1708, 1608, 'INV-FT-2026-008', '2026-04-05', 18.00, 540.00, 3540.00);
INSERT INTO INVOICE VALUES (1709, 1609, 'INV-FT-2026-009', '2026-04-18', 18.00, 990.00, 6490.00);
INSERT INTO INVOICE VALUES (1710, 1610, 'INV-FT-2026-010', '2026-05-01', 18.00, 1350.00, 8850.00);

-- 19. TRAINER_REVIEW (10 records)
INSERT INTO TRAINER_REVIEW VALUES (1801, 301, 501, 5, 'Karan is a master of muscle anatomy! Helped me add 5kg lean mass safely.', '2026-02-15');
INSERT INTO TRAINER_REVIEW VALUES (1802, 302, 502, 5, 'Natasha pushes intensity beyond limits. Incredible CrossFit workouts.', '2026-02-20');
INSERT INTO TRAINER_REVIEW VALUES (1803, 303, 503, 4, 'Rajesh perfected my deadlift form. Great cues and attention to safety.', '2026-03-05');
INSERT INTO TRAINER_REVIEW VALUES (1804, 304, 504, 5, 'Aarti teaches authentic pranayama and challenging vinyasa flows.', '2026-03-18');
INSERT INTO TRAINER_REVIEW VALUES (1805, 305, 505, 4, 'High calorie burn in Sameer classes. Fun playlists and high energy.', '2026-04-02');
INSERT INTO TRAINER_REVIEW VALUES (1806, 306, 506, 5, 'Best spin class in the city! Zoya keeps everyone motivated throughout.', '2026-04-15');
INSERT INTO TRAINER_REVIEW VALUES (1807, 307, 501, 5, 'Top notch hypertrophy advice. Body recomposition progress on point.', '2026-04-25');
INSERT INTO TRAINER_REVIEW VALUES (1808, 308, 508, 5, 'Shweta Zumba is pure cardio joy. Burned 600 kcal without feeling exhausted.', '2026-05-08');
INSERT INTO TRAINER_REVIEW VALUES (1809, 310, 510, 4, 'Very knowledgeable about lumbar spine and posture rehabilitation.', '2026-05-18');
INSERT INTO TRAINER_REVIEW VALUES (1810, 301, 502, 5, 'Olympic lifting technique drills with Natasha gave huge PRs.', '2026-06-01');

-- 20. COUPON (10 records)
INSERT INTO COUPON VALUES (1901, 'FITFIRST10', 10.00, 3000.00, '2026-12-31');
INSERT INTO COUPON VALUES (1902, 'ANNUALGOLD20', 20.00, 20000.00, '2026-12-31');
INSERT INTO COUPON VALUES (1903, 'DIWALI25', 25.00, 15000.00, '2026-11-30');
INSERT INTO COUPON VALUES (1904, 'STUDENT15', 15.00, 5000.00, '2026-12-31');
INSERT INTO COUPON VALUES (1905, 'SUMMERSHRED12', 12.00, 8000.00, '2026-06-30');
INSERT INTO COUPON VALUES (1906, 'NEWYEAR30', 30.00, 25000.00, '2027-01-31');
INSERT INTO COUPON VALUES (1907, 'WOMENFIT15', 15.00, 7000.00, '2026-12-31');
INSERT INTO COUPON VALUES (1908, 'RENEWAL10', 10.00, 10000.00, '2026-12-31');
INSERT INTO COUPON VALUES (1909, 'FLASH5', 5.00, 2000.00, '2026-12-31');
INSERT INTO COUPON VALUES (1910, 'CORPORATE18', 18.00, 12000.00, '2026-12-31');

-- 21. SUBSCRIPTION_COUPON (10 records)
INSERT INTO SUBSCRIPTION_COUPON VALUES (1401, 1902);
INSERT INTO SUBSCRIPTION_COUPON VALUES (1402, 1908);
INSERT INTO SUBSCRIPTION_COUPON VALUES (1403, 1901);
INSERT INTO SUBSCRIPTION_COUPON VALUES (1404, 1903);
INSERT INTO SUBSCRIPTION_COUPON VALUES (1405, 1905);
INSERT INTO SUBSCRIPTION_COUPON VALUES (1406, 1907);
INSERT INTO SUBSCRIPTION_COUPON VALUES (1407, 1906);
INSERT INTO SUBSCRIPTION_COUPON VALUES (1408, 1909);
INSERT INTO SUBSCRIPTION_COUPON VALUES (1409, 1904);
INSERT INTO SUBSCRIPTION_COUPON VALUES (1410, 1910);

-- 22. ATTENDANCE_LOG (10 records)
INSERT INTO ATTENDANCE_LOG VALUES (2001, 301, 101, '2026-11-14 06:15:00', '2026-11-14 07:45:00');
INSERT INTO ATTENDANCE_LOG VALUES (2002, 302, 101, '2026-11-14 07:00:00', '2026-11-14 08:15:00');
INSERT INTO ATTENDANCE_LOG VALUES (2003, 303, 102, '2026-11-14 18:30:00', '2026-11-14 20:00:00');
INSERT INTO ATTENDANCE_LOG VALUES (2004, 304, 103, '2026-11-14 06:45:00', '2026-11-14 08:00:00');
INSERT INTO ATTENDANCE_LOG VALUES (2005, 305, 104, '2026-11-14 19:15:00', '2026-11-14 20:30:00');
INSERT INTO ATTENDANCE_LOG VALUES (2006, 306, 105, '2026-11-15 07:15:00', '2026-11-15 08:30:00');
INSERT INTO ATTENDANCE_LOG VALUES (2007, 307, 106, '2026-11-15 17:45:00', '2026-11-15 19:15:00');
INSERT INTO ATTENDANCE_LOG VALUES (2008, 308, 107, '2026-11-15 18:30:00', '2026-11-15 19:40:00');
INSERT INTO ATTENDANCE_LOG VALUES (2009, 309, 108, '2026-11-15 08:00:00', '2026-11-15 09:30:00');
INSERT INTO ATTENDANCE_LOG VALUES (2010, 310, 109, '2026-11-15 19:00:00', '2026-11-15 20:15:00');

-- 23. REFUND (10 records)
INSERT INTO REFUND VALUES (2101, 1610, 7500.00, 'Student relocated overseas before semester begin', 'PROCESSED', '2026-05-05 11:20:00');
INSERT INTO REFUND VALUES (2102, 1601, 1000.00, 'Accidental double locker charge adjustment', 'PROCESSED', '2026-01-12 14:10:00');
INSERT INTO REFUND VALUES (2103, 1602, 500.00, 'Promotional coupon credit applied retroactively', 'PROCESSED', '2026-01-18 16:30:00');
INSERT INTO REFUND VALUES (2104, 1603, 300.00, 'Single class cancellation compensation', 'PROCESSED', '2026-02-05 10:00:00');
INSERT INTO REFUND VALUES (2105, 1604, 1200.00, 'Branch renovation 10-day downtime rebate', 'PROCESSED', '2026-02-25 15:45:00');
INSERT INTO REFUND VALUES (2106, 1605, 600.00, 'Diet consultation rescheduled credit', 'PROCESSED', '2026-03-08 17:00:00');
INSERT INTO REFUND VALUES (2107, 1606, 1500.00, 'Medical injury pause converted to cash credit', 'PROCESSED', '2026-03-25 12:15:00');
INSERT INTO REFUND VALUES (2108, 1607, 2000.00, 'VIP corporate wellness loyalty cashback', 'PROCESSED', '2026-04-01 11:00:00');
INSERT INTO REFUND VALUES (2109, 1608, 400.00, 'App payment gateway timeout double debit reversal', 'PROCESSED', '2026-04-07 09:30:00');
INSERT INTO REFUND VALUES (2110, 1609, 500.00, 'Early bird renewal fee adjustment', 'REQUESTED', '2026-04-20 18:00:00');


-- ============================================================================
-- 24. ADBMS SUPPORT FILE REGISTRY (Expected Deliverables 1-9 & Tasks 1-12)
-- ============================================================================
INSERT INTO new_fittrack_adbms_support_file VALUES (1, 1, 'Problem definition and project objectives', 'Problem Statement & Roles', '01_Problem_Statement_and_Objectives.md', '01_Design_and_Schema/01_Problem_Statement_and_Objectives.md', 'Documentation', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (2, 2, 'ER diagram and relational schema', 'Task 1: DDL & Constraints', 'schema_ddl.sql', '02_Database_Scripts/schema_ddl.sql', 'Database DDL', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (3, 2, 'ER diagram and relational schema', 'Relational Model & Normalization', '02_ER_Diagram_and_Relational_Schema.md', '01_Design_and_Schema/02_ER_Diagram_and_Relational_Schema.md', 'Design Architecture', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (4, 3, 'SQL query implementation document', 'Task 1: Seed Records', 'mock_data_dml.sql', '02_Database_Scripts/mock_data_dml.sql', 'Database DML', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (5, 3, 'SQL query implementation document', 'Tasks 1-5: Queries & Views', 'tasks_01_to_05_queries.sql', '02_Database_Scripts/tasks_01_to_05_queries.sql', 'Core SQL', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (6, 4, 'PL/SQL programs and stored procedure scripts', 'Task 6: Procedures & Functions', 'task_06_plsql_procedures_functions.sql', '03_PLSQL_and_Advanced_DB/task_06_plsql_procedures_functions.sql', 'PL/SQL', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (7, 4, 'PL/SQL programs and stored procedure scripts', 'Task 7: Exception Handling', 'task_07_exception_handling.sql', '03_PLSQL_and_Advanced_DB/task_07_exception_handling.sql', 'PL/SQL Exceptions', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (8, 4, 'PL/SQL programs and stored procedure scripts', 'Task 8-9: ORDBMS & Inheritance', 'task_08_object_relational.sql', '03_PLSQL_and_Advanced_DB/task_08_object_relational.sql', 'Advanced Database', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (9, 5, 'JSON and XML implementation scripts', 'Tasks 10-12: JSON, XML & DTD/XSD', 'task_10_json_operations.sql', '04_JSON_and_XML/task_10_json_operations.sql', 'Semi-Structured Data', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (10, 6, 'Python/PHP application source code', 'Full-Stack Web Platform', 'app.py', '05_Web_Application/app.py', 'Application Code', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (11, 7, 'Test cases and test results', '25 Test Cases & 100% Pass Runner', 'test_cases.md', '06_Test_Cases_and_Results/test_cases.md', 'Quality Assurance', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (12, 8, 'Screenshots of application modules', 'Evaluation Screenshots Guide', 'Module_Walkthrough_and_Screenshots_Guide.md', '07_Documentation_and_Report/Module_Walkthrough_and_Screenshots_Guide.md', 'Module Evaluation', 'ACTIVE');
INSERT INTO new_fittrack_adbms_support_file VALUES (13, 9, 'Complete project report and demonstration', 'Deliverables 1-9 Master Report', 'FitTrack_ADBMS_Final_Project_Report.md', '07_Documentation_and_Report/FitTrack_ADBMS_Final_Project_Report.md', 'Final Master Report', 'ACTIVE');
