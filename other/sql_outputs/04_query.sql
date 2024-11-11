WITH method_selection_counts AS (
    -- Counting the method selections by user and grouping by age brackets
    SELECT 
        fv."group", 
        fv.method,
        CASE 
            WHEN EXTRACT(YEAR FROM age(du.dob)) <= 16 THEN '0-16'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 16 AND EXTRACT(YEAR FROM age(du.dob)) <= 20 THEN '16-20'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 20 AND EXTRACT(YEAR FROM age(du.dob)) <= 25 THEN '20-25'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 25 AND EXTRACT(YEAR FROM age(du.dob)) <= 30 THEN '25-30'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 30 AND EXTRACT(YEAR FROM age(du.dob)) <= 40 THEN '30-40'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 40 AND EXTRACT(YEAR FROM age(du.dob)) <= 50 THEN '40-50'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 50 AND EXTRACT(YEAR FROM age(du.dob)) <= 60 THEN '50-60'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 60 AND EXTRACT(YEAR FROM age(du.dob)) <= 70 THEN '60-70'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 70 AND EXTRACT(YEAR FROM age(du.dob)) <= 80 THEN '70-80'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 80 AND EXTRACT(YEAR FROM age(du.dob)) <= 90 THEN '80-90'
            WHEN EXTRACT(YEAR FROM age(du.dob)) > 90 THEN '90-100'
            ELSE 'Unknown'
        END AS age_bracket,
        COUNT(*) AS method_count,
        SUM(CASE WHEN fv.verified = 0 THEN 1 ELSE 0 END) AS failure_count
    FROM 
        fact_verification AS fv
    LEFT JOIN 
        dim_user AS du 
	ON 	fv."userID" = du."userID"
    GROUP BY 
        fv."group", fv.method, age_bracket
)
-- Selecting and displaying the counts per method, age bracket, and failure counts, with relative failure count
SELECT 
    "group", 
    method, 
    age_bracket,
    method_count,
    failure_count,
    ROUND((failure_count * 100.0) / method_count, 2) AS relative_failure_count
FROM 
    method_selection_counts
ORDER BY 
    relative_failure_count DESC, "group", method, age_bracket;

-- Observed Trends Based on the Data:
-- 100% Failure Rate in Specific Age Brackets:

-- - Group A (Sms, 70-80): 1 method count, 1 failure (100% failure rate).
-- - Group B (Sms, 80-90): 2 method counts, 2 failures (100% failure rate).
-- - These are the only two instances where 100% failure rates are observed. No further age brackets exhibit this level of failure.

-- Failure Rate Calculations:
-- - For age brackets like 16-20, 20-25, and 30-40, failure rates vary but are not 100%. For example:
-- 		- Group A (Sms, 16-20): 823 method counts, 139 failures (16.89% failure rate).
-- 		- Group A (Sms, 20-25): 2010 method counts, 251 failures (12.49% failure rate).
-- - "For Group B, failure rates generally follow a similar pattern to those in Group A, though they can differ depending on the specific method and age bracket."

-- Age Bracket Trends:
-- - Older age brackets like 50-60, 60-70, and 70-80 show a relatively higher number of failures for the Sms method, but these rates do not reach 100% unless specific smaller groups (like 70-80 in Group A) are considered.

-- Difference in Failure Rates by Method:
-- - The failure rates for WhatsApp verifications tend to be lower than those for Sms, but there are still notable failure counts:
-- 		- Group B (Whatsapp, 30-40): 162 method counts, 18 failures (11.11% failure rate).
--   	- Group C (Whatsapp, 50-60): 43 method counts, 5 failures (11.63% failure rate).
-- - The data does not show any group where WhatsApp has a failure rate approaching that of Sms for the same age brackets.

-- Larger Sample Sizes for Younger Age Groups:
-- - Younger age groups (16-20, 20-25) have larger sample sizes but moderate failure rates. For instance:
-- 		- Group A (Sms, 16-20): 823 method counts, 139 failures (16.89% failure rate).
-- 		- Group A (Sms, 20-25): 2010 method counts, 251 failures (12.49% failure rate).
-- - The sample sizes for these groups are large, but the failure rate remains relatively consistent across different age brackets.

-- Summary:
-- - 100% failure rates appear only in the 70-80 and 80-90 age brackets for Sms in Group A and Group B.
-- - Failure rates across other age brackets show variation but are not as extreme as 100%.
-- - WhatsApp shows lower failure rates in comparison to Sms across most age groups.
-- - Younger age groups have larger sample sizes, but failure rates are relatively moderate.
