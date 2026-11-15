-- ============================================================================
-- FitTrack: Smart Gym Management System
-- TASK 10: JSON in Databases (Storage, Path Queries, Filtering, and In-Place Updates)
-- Supports PostgreSQL (JSONB) and SQLite (json functions)
-- ============================================================================

-- ============================================================================
-- 10.1 Table with JSON Attributes and JSON Validation Constraints
-- ============================================================================
DROP TABLE IF EXISTS MEMBER_DIET_PLAN;

CREATE TABLE MEMBER_DIET_PLAN (
    diet_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    daily_calories INT CHECK (daily_calories > 0),
    nutrition_spec_json TEXT NOT NULL, -- Stored as JSON / JSONB
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 10.2 Inserting Rich Semi-Structured JSON Documents
-- ============================================================================
INSERT INTO MEMBER_DIET_PLAN (diet_id, member_id, plan_name, daily_calories, nutrition_spec_json)
VALUES (
    5001,
    301,
    'High-Protein Lean Bulk Protocol',
    2800,
    '{
        "macros": {
            "protein_grams": 200,
            "carbs_grams": 320,
            "fats_grams": 75
        },
        "diet_type": "Non-Vegetarian",
        "supplements": [
            {"name": "Whey Protein Isolate", "dosage": "30g", "timing": "Post-Workout"},
            {"name": "Creatine Monohydrate", "dosage": "5g", "timing": "Morning"},
            {"name": "Omega-3 Fish Oil", "dosage": "1000mg", "timing": "With Lunch"}
        ],
        "hydration_liters": 4.0,
        "allergens": ["peanuts"],
        "meal_distribution": {
            "breakfast": "Oatmeal with whey, berries and almonds",
            "lunch": "Grilled chicken breast, brown rice and broccoli",
            "evening_snack": "Boiled eggs and sweet potato",
            "dinner": "Salmon fillet with quinoa and asparagus"
        }
    }'
);

INSERT INTO MEMBER_DIET_PLAN (diet_id, member_id, plan_name, daily_calories, nutrition_spec_json)
VALUES (
    5002,
    302,
    'Plant-Based Shred & Tone Diet',
    1650,
    '{
        "macros": {
            "protein_grams": 110,
            "carbs_grams": 160,
            "fats_grams": 50
        },
        "diet_type": "Vegan",
        "supplements": [
            {"name": "Plant Protein Pea/Rice Blend", "dosage": "25g", "timing": "Post-Workout"},
            {"name": "Vitamin B12", "dosage": "500mcg", "timing": "Morning"}
        ],
        "hydration_liters": 3.0,
        "allergens": [],
        "meal_distribution": {
            "breakfast": "Chia seed pudding with soy milk and blueberries",
            "lunch": "Tofu bowl with edamame, spinach and olive oil",
            "dinner": "Lentil soup with mixed green salad"
        }
    }'
);

INSERT INTO MEMBER_DIET_PLAN (diet_id, member_id, plan_name, daily_calories, nutrition_spec_json)
VALUES (
    5003,
    303,
    'Keto Powerlifting Fuel',
    3100,
    '{
        "macros": {
            "protein_grams": 180,
            "carbs_grams": 30,
            "fats_grams": 240
        },
        "diet_type": "Ketogenic",
        "supplements": [
            {"name": "Electrolyte Complex", "dosage": "1 scoop", "timing": "Intra-Workout"},
            {"name": "MCT Oil", "dosage": "15ml", "timing": "Pre-Workout"}
        ],
        "hydration_liters": 4.5,
        "allergens": ["lactose"],
        "meal_distribution": {
            "breakfast": "Eggs fried in butter with avocado and bacon",
            "lunch": "Ribeye steak with buttered cauliflower mash",
            "dinner": "Mutton chops with zucchini noodles in olive oil"
        }
    }'
);


-- ============================================================================
-- 10.3 JSON Path Queries and Attribute Extractions
-- ============================================================================

-- Query 1: Extract scalar attributes using JSON path (SQLite / PostgreSQL)
-- Using SQLite syntax: json_extract(column, path)
SELECT 
    diet_id,
    plan_name,
    json_extract(nutrition_spec_json, '$.diet_type') AS diet_type,
    json_extract(nutrition_spec_json, '$.macros.protein_grams') AS protein_grams,
    json_extract(nutrition_spec_json, '$.macros.carbs_grams') AS carbs_grams,
    json_extract(nutrition_spec_json, '$.hydration_liters') AS daily_water_liters
FROM MEMBER_DIET_PLAN;

-- Equivalent PostgreSQL syntax:
-- SELECT diet_id, plan_name, nutrition_spec_json->>'diet_type' AS diet_type,
--        (nutrition_spec_json->'macros'->>'protein_grams')::int AS protein_g
-- FROM MEMBER_DIET_PLAN;

-- Query 2: Filter records based on nested JSON values
-- Find all diet plans providing >= 150 grams of protein
SELECT 
    diet_id,
    member_id,
    plan_name,
    json_extract(nutrition_spec_json, '$.macros.protein_grams') AS protein_g
FROM MEMBER_DIET_PLAN
WHERE CAST(json_extract(nutrition_spec_json, '$.macros.protein_grams') AS INTEGER) >= 150;

-- Query 3: Query Plan Specifications in the MEMBERSHIP_PLAN table
SELECT 
    p.plan_id,
    p.plan_name,
    json_extract(s.specification_json, '$.tier') AS membership_tier,
    json_extract(s.specification_json, '$.guest_passes') AS guest_passes_count,
    json_extract(s.specification_json, '$.spa_access') AS has_spa_access
FROM MEMBERSHIP_PLAN p
JOIN PLAN_SPECIFICATION s ON p.plan_id = s.plan_id
WHERE json_extract(s.specification_json, '$.spa_access') = 1 
   OR json_extract(s.specification_json, '$.spa_access') = 'true';


-- ============================================================================
-- 10.4 In-Place Updating of Selected JSON Attributes
-- ============================================================================

-- Update hydration to 4.2 liters and increase protein grams to 210 for diet 5001
-- Using SQLite json_set:
UPDATE MEMBER_DIET_PLAN
SET nutrition_spec_json = json_set(
    nutrition_spec_json,
    '$.hydration_liters', 4.2,
    '$.macros.protein_grams', 210
)
WHERE diet_id = 5001;

-- Verify update:
SELECT 
    diet_id, 
    plan_name, 
    json_extract(nutrition_spec_json, '$.macros.protein_grams') AS updated_protein,
    json_extract(nutrition_spec_json, '$.hydration_liters') AS updated_hydration
FROM MEMBER_DIET_PLAN
WHERE diet_id = 5001;

-- PostgreSQL Equivalent for In-Place JSONB update:
-- UPDATE MEMBER_DIET_PLAN
-- SET nutrition_spec_json = jsonb_set(nutrition_spec_json::jsonb, '{macros,protein_grams}', '210'::jsonb)
-- WHERE diet_id = 5001;
