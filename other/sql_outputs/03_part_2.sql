-- Part 1: Failure Counts, Success Counts, Method Selection Counts, and Verification Success Rates

WITH failure_counts AS (
    -- Counting the failures (where verified = 0)
    SELECT 
        fv."group", 
        fv.method, 
        COUNT(*) AS failure_count,
        (SELECT COUNT(*) FROM fact_verification) AS total_entries,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_verification), 2) AS failure_entries_percent
    FROM 
        fact_verification AS fv
    WHERE 
        fv.verified = 0
    GROUP BY 
        fv."group", fv.method
),

success_counts AS (
    -- Counting the successes (where verified = 1)
    SELECT 
        fv."group", 
        fv.method, 
        COUNT(*) AS success_count,
        (SELECT COUNT(*) FROM fact_verification) AS total_entries,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_verification), 2) AS success_entries_percent
    FROM 
        fact_verification AS fv
    WHERE 
        fv.verified = 1
    GROUP BY 
        fv."group", fv.method
),

method_selection_counts AS (
    -- Counting the method selections by user
    SELECT 
        fv."group", 
        fv.method, 
        COUNT(fv."userID") AS method_selection_count,
        (SELECT COUNT(*) FROM fact_verification) AS total_entries,
        ROUND(COUNT(fv."userID") * 100.0 / (SELECT COUNT(*) FROM fact_verification), 2) AS method_selection_percent
    FROM 
        fact_verification AS fv
    GROUP BY 
        fv."group", fv.method
),

verification_success_rate_by_method AS (
    -- Calculating verification success rate by method
    SELECT 
        fv."group", 
        fv.method, 
        ROUND(AVG(fv.verified), 4) AS verification_success_rate
    FROM 
        fact_verification AS fv
    GROUP BY 
        fv."group", fv.method
),

verification_success_rate_by_group AS (
    -- Calculating the average verification success rate by group
    SELECT 
        fv."group", 
        ROUND(AVG(fv.verified), 4) AS verification_success_rate,
        ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 2) AS group_representation_percentage
    FROM 
        fact_verification AS fv
    GROUP BY 
        fv."group"
)

-- Final Output for Part 1: Combining all counts, percentages, and success rates
SELECT 
    fc."group", 
    fc.method, 
    fc.failure_count,
    sc.success_count,
    msc.method_selection_count,
    fc.total_entries,
    fc.failure_entries_percent AS failure_entries_percent,
    sc.success_entries_percent AS success_entries_percent,
    msc.method_selection_percent AS method_selection_percent,
    vsr.verification_success_rate AS verification_success_rate_by_method,
    vsrg.verification_success_rate AS verification_success_rate_by_group
FROM 
    failure_counts fc
LEFT JOIN 
    success_counts sc ON fc."group" = sc."group" AND fc.method = sc.method
LEFT JOIN 
    method_selection_counts msc ON fc."group" = msc."group" AND fc.method = msc.method
LEFT JOIN 
    verification_success_rate_by_method vsr ON fc."group" = vsr."group" AND fc.method = vsr.method
LEFT JOIN 
    verification_success_rate_by_group vsrg ON fc."group" = vsrg."group"
ORDER BY 
    failure_entries_percent DESC, verification_success_rate_by_method DESC;

-- Summary of Part 1: Verification Analysis

-- - Failure Counts: This section shows the number of failed verifications (verified = 0) for each group (SMS/WhatsApp) and method. It also calculates the percentage of failures relative to total entries.
-- - Success Counts: This part counts successful verifications (verified = 1) and computes the percentage of successes.
-- - Method Selection Counts: This calculates how often each method (SMS/WhatsApp) was selected by users and its relative percentage.
-- - Verification Success Rate by Method: The average success rate of verification for each method (SMS/WhatsApp).
-- - Verification Success Rate by Group: The overall success rate for each group (SMS/WhatsApp) and the group’s representation in the data.


-- Part 2: Cost Analysis and Calculation of Total Cost

WITH cost_analysis AS (
    -- Calculating the cost per country and method based on user counts and USD cost
    SELECT 
        du.country, 
        fv.method,
        COUNT(fv."userID") AS user_count,
        ROUND(
            CASE 
                WHEN fv.method = 'Whatsapp' THEN COUNT(fv."userID") * dc.whatsapp_usd::numeric
                WHEN fv.method = 'Sms' THEN COUNT(fv."userID") * dc.sms_usd::numeric
            END, 
            2
        ) AS total_cost,
        ROUND(AVG(fv.verified), 4) AS verification_success_rate
    FROM 
        fact_verification AS fv
    LEFT JOIN 
        dim_user AS du ON fv."userID" = du."userID"
    LEFT JOIN 
        dim_country AS dc ON du.country = dc.country
    GROUP BY 
        du.country, fv.method, dc.whatsapp_usd, dc.sms_usd
)

-- Final Output for Part 2: Combining cost analysis with verification success rate by country and method
SELECT 
    ca.country,
    ca.method,
    ca.user_count,
    ca.total_cost,
    ca.verification_success_rate AS verification_success_rate_by_country_and_method,
    ROUND(
        ca.user_count * 100.0 / (SELECT SUM(user_count) FROM cost_analysis), 2
    ) AS total_entries_percent
FROM 
    cost_analysis ca
ORDER BY 
    --total_entries_percent DESC, 
	ca.total_cost DESC, ca.verification_success_rate DESC;

-- Summary of Part 2: Cost Analysis

-- - Cost Analysis: This section calculates the total cost per country and method (SMS/WhatsApp) based on the user count and cost per method. It also calculates the verification success rate for each country and method.
-- - Total Entries Percent: The percentage of total entries for each country and method is computed relative to all entries.

-- Overall Findings

-- - Verification Performance: You can see the distribution of failure and success rates across different verification methods (SMS/WhatsApp) and groups. This helps in understanding which method performs better and where improvements might be needed.
-- - Cost Efficiency: The analysis highlights the total costs incurred for each method and country. It also compares the verification success rate, helping assess the cost-effectiveness of each method.
-- - Country and Method Trends: The data shows how often each method is used in different countries and its correlation with verification success rates and costs, providing insights into regional preferences and their impact on verification efficiency.
-- - This analysis can guide decisions on optimizing verification methods and managing costs based on performance and regional trends.