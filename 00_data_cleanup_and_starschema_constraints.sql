-- 1. Rename Tables
-- Rename existing tables to fit the star schema naming conventions
ALTER TABLE profiles RENAME TO dim_user;
ALTER TABLE verification RENAME TO fact_verification;
ALTER TABLE costs RENAME TO dim_country;

-- 2. Clean Data (Fix Invalid or Missing Data)
-- ********** Identifying the problem with IM country code **********
-- Find rows in dim_user where the country is not present in dim_country.
SELECT *
FROM dim_user
WHERE country NOT IN (SELECT country FROM dim_country);

-- 3. Handle Missing or Invalid Data
-- ********** Verifying and Cleaning Data **********
-- Remove rows in dim_user with invalid or NULL country values
DELETE FROM dim_user
WHERE "userID" IN (
    SELECT du."userID"
    FROM dim_user du
    LEFT JOIN dim_country dc 
	ON du.country = dc.country
    WHERE dc.country IS NULL
);

-- Delete rows from fact_verification where userID is not found in dim_user
DELETE FROM fact_verification
WHERE "userID" NOT IN (SELECT "userID" FROM dim_user);

-- 4. Add Primary Keys, Foreign Keys, and Constraints
-- Add Primary Keys and Constraints to Dim Tables

-- Primary Keys
-- Add PK to dim_user on userID
ALTER TABLE dim_user
    ADD CONSTRAINT pk_user PRIMARY KEY ("userID");

-- Foreign Key Constraints
-- Add PK to dim_country on country
ALTER TABLE dim_country
    ADD CONSTRAINT pk_country PRIMARY KEY (country);

-- Add PK and FK constraints to fact_verification
ALTER TABLE fact_verification
    ADD CONSTRAINT pk_fact_verification PRIMARY KEY ("userID"),
    ADD CONSTRAINT fk_user FOREIGN KEY ("userID") REFERENCES dim_user("userID");
	
-- Add FK on country in dim_user
ALTER TABLE dim_user
    ADD CONSTRAINT fk_user_country FOREIGN KEY (country) REFERENCES dim_country(country);

-- Data Type Adjustments and Check Constraints
-- Fact_Verification table
ALTER TABLE fact_verification
    ALTER COLUMN verified TYPE BIGINT,
    ALTER COLUMN method TYPE TEXT,
    ALTER COLUMN "group" TYPE TEXT;

-- Dim_Country table: Correcting data types
ALTER TABLE dim_country
    ALTER COLUMN whatsapp_usd TYPE DOUBLE PRECISION,
    ALTER COLUMN sms_usd TYPE DOUBLE PRECISION;

-- Dim_User table: Correcting data types
ALTER TABLE dim_user
    ALTER COLUMN gender TYPE TEXT,
    ALTER COLUMN country TYPE TEXT;

ALTER TABLE dim_user
    ALTER COLUMN dob TYPE DATE
    USING TO_DATE(dob, 'DD Mon YYYY');  -- For better handling of date formatting

-- 5. Final Verification and Cleanup
-- Check the cleaned data for any issues
SELECT * 
FROM dim_user 
WHERE country IS NULL;

SELECT * 
FROM fact_verification 
WHERE "userID" IS NULL;
