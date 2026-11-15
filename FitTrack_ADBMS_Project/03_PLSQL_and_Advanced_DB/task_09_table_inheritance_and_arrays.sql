-- ============================================================================
-- FitTrack: Smart Gym Management System
-- TASK 9: Table Inheritance, Array Data Types & Inherited Table Queries
-- (Implemented using PostgreSQL / ORDBMS standard syntax)
-- ============================================================================

-- ============================================================================
-- 9.1 Table Inheritance: Parent and Inherited Child Tables
-- ============================================================================

-- Parent Table: General Gym Workout Plan
DROP TABLE IF EXISTS strength_plan CASCADE;
DROP TABLE IF EXISTS cardio_plan CASCADE;
DROP TABLE IF EXISTS workout_plan CASCADE;

CREATE TABLE workout_plan (
    plan_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    target_level VARCHAR(20) CHECK (target_level IN ('Beginner', 'Intermediate', 'Advanced')),
    duration_weeks INT NOT NULL,
    equipment_tags TEXT[] -- Array data type for multi-valued equipment tags
);

-- Child Table 1: Inherits from workout_plan (Specialized for Strength & Hypertrophy)
CREATE TABLE strength_plan (
    compound_lifts_count INT,
    target_muscle_group VARCHAR(50),
    rest_period_seconds INT
) INHERITS (workout_plan);

-- Child Table 2: Inherits from workout_plan (Specialized for Cardio & Endurance)
CREATE TABLE cardio_plan (
    target_heart_rate_zone VARCHAR(30),
    avg_calories_burned_per_session INT,
    vo2_max_focus BOOLEAN
) INHERITS (workout_plan);


-- ============================================================================
-- 9.2 Inserting Data into Parent and Inherited Child Tables
-- ============================================================================

-- Insert directly into parent table
INSERT INTO workout_plan (plan_name, target_level, duration_weeks, equipment_tags)
VALUES 
('Full Body Mobility Reset', 'Beginner', 4, ARRAY['foam_roller', 'yoga_mat', 'resistance_bands']),
('General Conditioning Routine', 'Intermediate', 6, ARRAY['dumbbells', 'pullup_bar', 'jump_rope']);

-- Insert into specialized Strength Child Table
INSERT INTO strength_plan (plan_name, target_level, duration_weeks, equipment_tags, compound_lifts_count, target_muscle_group, rest_period_seconds)
VALUES 
('Texas Method Powerlifting', 'Advanced', 12, ARRAY['barbell', 'squat_rack', 'bench_press', 'chalk'], 4, 'Full Body Compound', 180),
('Arnold Golden 6 Hypertrophy', 'Intermediate', 8, ARRAY['barbell', 'dumbbells', 'cable_machine'], 3, 'Chest & Back', 90),
('StrongLifts 5x5 Foundation', 'Beginner', 12, ARRAY['barbell', 'squat_rack', 'weight_plates'], 5, 'Full Body Strength', 120);

-- Insert into specialized Cardio Child Table
INSERT INTO cardio_plan (plan_name, target_level, duration_weeks, equipment_tags, target_heart_rate_zone, avg_calories_burned_per_session, vo2_max_focus)
VALUES 
('HIIT Tabata Meltdown', 'Advanced', 4, ARRAY['air_bike', 'kettlebell', 'rower', 'battle_ropes'], 'Zone 5 (90-100% HR)', 650, TRUE),
('Zone 2 Aerobic Base Builder', 'Beginner', 16, ARRAY['treadmill', 'stationary_bike'], 'Zone 2 (60-70% HR)', 400, FALSE),
('Spartan Race Obstacle Prep', 'Advanced', 8, ARRAY['rower', 'box_jump', 'medicine_ball', 'sled'], 'Zone 4 (80-90% HR)', 750, TRUE);


-- ============================================================================
-- 9.3 Querying Parent Table vs Child Tables
-- ============================================================================

-- Query 1: Querying Parent Table retrieves records from parent AND all inherited children!
-- Returns both general plans, strength plans, and cardio plans.
SELECT plan_id, plan_name, target_level, duration_weeks, equipment_tags
FROM workout_plan;

-- Query 2: Demonstrating the 'ONLY' keyword:
-- Retrieves records from ONLY the parent table, excluding inherited child rows!
SELECT plan_id, plan_name, target_level, duration_weeks, equipment_tags
FROM ONLY workout_plan;

-- Query 3: Querying specific child table with its specialized columns
SELECT plan_name, target_level, compound_lifts_count, target_muscle_group, rest_period_seconds, equipment_tags
FROM strength_plan
WHERE compound_lifts_count >= 4;

SELECT plan_name, target_heart_rate_zone, avg_calories_burned_per_session, vo2_max_focus
FROM cardio_plan
WHERE vo2_max_focus = TRUE;


-- ============================================================================
-- 9.4 Array Data Type Operations and Queries
-- ============================================================================

-- Query 4: Search for plans requiring a 'barbell' using the ANY operator
SELECT plan_name, target_level, equipment_tags
FROM workout_plan
WHERE 'barbell' = ANY (equipment_tags);

-- Query 5: Search for plans containing specific multiple tags using array contains operator (@>)
SELECT plan_name, equipment_tags
FROM workout_plan
WHERE equipment_tags @> ARRAY['squat_rack', 'barbell'];

-- Query 6: Unnesting array elements to count frequency of equipment required across all workouts
SELECT 
    UNNEST(equipment_tags) AS individual_equipment,
    COUNT(*) AS workout_usage_frequency
FROM workout_plan
GROUP BY individual_equipment
ORDER BY workout_usage_frequency DESC;
