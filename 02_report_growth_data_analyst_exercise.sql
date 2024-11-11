-- Summary
-- This analysis focused on evaluating verification success rates across three test groups using SMS and WhatsApp as verification methods. Group A (SMS-only) demonstrated the lowest success rate (0.8735), while Groups B and C, which offered both methods, achieved higher rates, suggesting that providing users with multiple verification options enhances success. Group C (WhatsApp > SMS) had the highest overall success rate at 0.9282, with SMS achieving the highest individual success rate within this group (0.9535).

-- The findings show that SMS generally outperforms WhatsApp in verification success, particularly when offered as a secondary option. User preference tends to align with the first method offered, as shown by the higher WhatsApp uptake in Group C and higher SMS uptake in Group B. A key insight is that a two-method setup increases the likelihood of successful verification compared to a single-method approach.

-- Further analysis could integrate cost data by region, user demographics, and connectivity to optimise method selection for different user segments. Overall, incorporating a dual-method approach while prioritising SMS where feasible appears to be a reliable strategy for improving verification success.

-- Note on Data Integrity: Some rows were removed due to either null values or a lack of reference in another table. This data cleanup process is detailed in the 00_data_cleanup_and_starschema_constraints.sql file, ensuring more accurate analysis by excluding incomplete data points.

-- References:
-- Additional to this report file name: 
--      02_report_growth_data_analyst_exercise, 
-- Mini-reports have been carried out for insights:
--      03_report_verification_and_cost_analysis
--      04_age_bracket_method_failure_rates


-- 1. Which screen would you suggest we proceed with?
-- To determine the optimal screen, verification success rates was analysed across methods and groups, aiming to select the screen configuration with the highest success rate for future use.

-- 1.a. Verification success rates by group and method:
-- This query identifies the combination of group and method with the highest verification success rate.

SELECT 
    v.group, 
    v.method, 
    ROUND(AVG(v.verified), 4) AS verification_success_rate
FROM 
    fact_verification AS v
GROUP BY 
    v.group, v.method
ORDER BY 
    verification_success_rate DESC;
'''
"group"	"method"	"verification_success_rate"
"C"	"Sms"	0.9535
"B"	"Sms"	0.9298
"B"	"Whatsapp"	0.9144
"C"	"Whatsapp"	0.9140
"A"	"Sms"	0.8735
'''

-- 1.b. Verification success rates by group:
-- This query calculates the success rate by group and the representation percentage of each group in the overall data set.

SELECT 
    v.group, 
    ROUND(AVG(v.verified), 4) AS verification_success_rate,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 2) AS group_representation_percentage
FROM 
    fact_verification AS v
GROUP BY 
    v.group
ORDER BY 
    verification_success_rate DESC;
'''
"group"	"verification_success_rate"	"group_representation_percentage"
"C"	0.9282	33.21
"B"	0.9281	32.16
"A"	0.8735	34.63
'''

-- Insights:
-- Highest Success Rate: Group C (WhatsApp > SMS) demonstrates the highest success rate (0.9282), followed closely by Group B (SMS > WhatsApp) at 0.9281.

-- Lowest Success Rate: Group A (SMS-only) has the lowest success rate of 0.8735, indicating that including an alternative verification method may enhance effectiveness.

-- Representation: Distribution among test groups is fairly balanced: Group A makes up 34.64% of total participants, Group B 32.16%, and Group C 33.21%.




-- 2. Which success metrics did you consider and why?
-- To evaluate each method’s performance, I analysed success rates by method within each group, especially for Groups B and C, where users had access to both SMS and WhatsApp. This query retrieves essential metrics, including success rate and usage distribution.

SELECT 
    v.group, 
    v.method, 
    ROUND(AVG(v.verified), 4) AS verification_success_rate,
    ROUND(COUNT(*) / SUM(COUNT(*)) OVER (), 4) AS method_representation_percentage_within_group,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY v.group), 2) AS method_share_within_group_percent
FROM 
    fact_verification AS v
GROUP BY 
    v.group, v.method
ORDER BY 
    verification_success_rate DESC;
'''
"group"	"method"	"verification_success_rate"	"method_representation_percentage_within_group"	"method_share_within_group_percent"
"C"	"Sms"	0.9535	0.1201	36.17
"B"	"Sms"	0.9298	0.2854	88.76
"B"	"Whatsapp"	0.9144	0.0362	11.24
"C"	"Whatsapp"	0.9140	0.2120	63.83
"A"	"Sms"	0.8735	0.3463	100.00
'''

-- Insights:
-- Group A (SMS-only): Success rate of 0.8735, with SMS used exclusively.

-- Group B (SMS > WhatsApp): SMS has a 0.9298 success rate, representing 88.76% of group interactions. WhatsApp has a slightly lower success rate of 0.9144, representing 11.24% of the group.

-- Group C (WhatsApp > SMS): WhatsApp is used more frequently (63.83%) but has a lower success rate (0.9140). SMS, though less used (36.17%), has the highest success rate across all methods at 0.9535.

-- Key Observations:
-- Dual-Method Effectiveness: Groups B and C, both of which offer SMS and WhatsApp, show higher success rates than Group A, suggesting that providing a choice of methods may increase verification success.

-- Higher Success with SMS: Within Groups B and C, SMS consistently outperforms WhatsApp, especially in Group C, where SMS achieves a 0.9535 success rate, indicating it may be a more reliable option in some cases.

-- First Method Preference: In groups with two methods, the first method is often preferred: Group C (WhatsApp > SMS) favors WhatsApp at 63.83%, while Group B (SMS > WhatsApp) heavily favors SMS at 88.74%. Group C’s lower performance when WhatsApp is prioritised suggests that SMS could be a better first choice.




-- 3. Would you incorporate additional data if you could?
-- Additional Data:
-- Including data on method costs and regional distribution would offer valuable insights into the cost-effectiveness and performance of verification methods. This would enable refined recommendations on method allocation based on geographic differences and regional preferences.

SELECT 
    u.country, 
    v.method,
    COUNT(v."userID") AS user_count,
    ROUND(
        CASE 
            WHEN v.method = 'Whatsapp' THEN COUNT(v."userID") * c.whatsapp_usd::numeric
            WHEN v.method = 'Sms' THEN COUNT(v."userID") * c.sms_usd::numeric
        END, 
        2
    ) AS total_cost,
    ROUND(AVG(v.verified), 4) AS verification_success_rate
FROM 
    fact_verification AS v
JOIN 
    dim_user AS u 
ON 
    v."userID" = u."userID"
JOIN 
    dim_country AS c 
ON 
    u.country = c.country
GROUP BY 
    u.country, v.method, c.whatsapp_usd, c.sms_usd
ORDER BY 
    total_cost DESC;

-- Explanation of Results:
-- The query is designed to calculate the total cost of each verification method (SMS and WhatsApp) per country, based on the number of users and the unit costs (whatsapp_usd and sms_usd). It also computes the verification success rate for each method by country. This allows for a cost-performance evaluation, which could influence decision-making on which verification method to prioritise in each region.

-- Sample Output:
-- "country"	"method"	"user_count"	"total_cost"	"verification_success_rate"
-- "PK"	"Sms"	1096	197.28	0.8823
-- "MA"	"Sms"	1511	181.32	0.8776
-- "ID"	"Sms"	711	149.48	0.8650
-- "EG"	"Sms"	804	102.98	0.8682
-- "DZ"	"Sms"	539	70.07	0.8998
-- "NG"	"Sms"	221	44.20	0.9864
-- "FR"	"Sms"	1320	43.56	0.9424
-- "BD"	"Sms"	142	41.18	0.9577
-- "TN"	"Sms"	290	37.70	0.9552
-- "IN"	"Sms"	485	34.92	0.9608
-- "DE"	"Sms"	520	31.20	0.9269
-- "SA"	"Sms"	450	27.90	0.8756
-- "EG"	"Whatsapp"	324	27.22	0.8981
-- "GB"	"Sms"	911	26.18	0.9363
-- "IQ"	"Sms"	101	25.80	0.8911
-- "SO"	"Sms"	126	22.81	0.9444
-- "JO"	"Sms"	96	19.27	0.8021
-- "FR"	"Whatsapp"	269	18.29	0.8996
-- "MY"	"Sms"	243	17.01	0.8930
-- "RU"	"Sms"	93	15.81	0.9677




-- 4. Why do you think your chosen screen performed best?

-- The chosen screen, which offers both WhatsApp and SMS verification options (Group C: WhatsApp > SMS), 
-- performed best due to a few key factors:

-- - Increased Flexibility: Offering two methods gives users the flexibility to select their preferred 
--   verification method, which may boost comfort and ease of use, enhancing success rates.

-- - Higher Success Rates with SMS as a Secondary Option: While WhatsApp was the primary option in this 
--   group, SMS verification proved to have the highest individual success rate across all groups (0.9535). 
--   This suggests that users are more likely to succeed when SMS is available as a fallback option, 
--   especially for those who may face connectivity issues or limitations with WhatsApp.

-- - User Preference Alignment: Data suggests that when presented with multiple options, users tend to 
--   select the first method offered, as shown by the higher WhatsApp uptake in Group C. This initial 
--   engagement likely contributes to the group’s high overall success rate (0.9282).

-- Overall, the dual-method setup, paired with prioritising WhatsApp but retaining SMS as a secondary 
-- option, likely optimizes both user satisfaction and verification success.




-- 5. Would you recommend any additional changes to the screen?

-- Yes, I would recommend the following adjustments to further enhance the screen's effectiveness 
-- based on observed success rates and user preferences:

-- - Highlight SMS as a Recommended Option: Given that SMS generally has a higher individual success 
--   rate, especially as a secondary choice (0.9535 in Group C), subtly recommending it could improve 
--   overall verification rates. This can be achieved without overwhelming users by framing SMS as 
--   a reliable fallback option.

-- - Implement a Hybrid Model: Allow users to select their preferred primary method, with an option 
--   to switch if the initial method fails. This flexibility may improve verification success, 
--   particularly for users in regions with connectivity challenges that impact WhatsApp or SMS availability.

-- - Add Contextual Guidance: Briefly explain why one method may be more reliable under specific 
--   conditions. For instance, SMS could be recommended in regions with low internet connectivity, 
--   guiding users toward the method most likely to succeed in their situation.

-- - Regular Evaluation and Adjustment: Conduct periodic evaluations of verification success rates by 
--   region and adjust the method allocation based on regional performance, user preference, and cost 
--   efficiency. This could involve making SMS the default method in areas where it outperforms WhatsApp 
--   and prioritizing WhatsApp in regions where it is more successful.

-- - Incorporate User Feedback Mechanisms: Including a feedback option for users who experience issues 
--   with their chosen method can help refine the system for future users. Analyzing this feedback would 
--   also allow for further personalization and regional adjustments in verification processes.




-- Summary of Findings and Recommendations:

-- This analysis supports the effectiveness of a two-method setup, particularly when SMS is prioritized 
-- or recommended as a fallback. The recommendations aim to enhance the user experience while maximizing 
-- verification success across diverse user segments. Future improvements should integrate regional performance, 
-- user preference, and cost data to ensure the verification process remains efficient, cost-effective, 
-- and user-friendly.
