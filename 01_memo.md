# Memo Summary: Report on Verification Success Rates and Method Analysis
### *By Umar Butt, 11 November 2024*
.
---

## File: 02_report_growth_data_analyst_exercise
This analysis focused on evaluating verification success rates across three test groups using SMS and WhatsApp as verification methods.

- **Group A (SMS-only)** demonstrated the lowest success rate (0.8735).
- **Groups B and C**, which offered both methods, achieved higher rates, suggesting that providing users with multiple verification options enhances success.
- **Group C (WhatsApp > SMS)** had the highest overall success rate at 0.9282, with SMS achieving the highest individual success rate within this group (0.9535).

- **Limitations to Consider:**
    - **Limited Method Insights:** This analysis only considers each user’s initial choice of verification method without data on switching, which may mean total success rates could be higher if users attempted another method after a failed attempt.
    - **Bias Toward First Preference:** Results may favour the first method chosen, especially in Groups B and C, where both options were available.
    - **Cost Analysis Constraints:** Cost assessments are based solely on the first method chosen, potentially skewing results if method switching occurred.

The findings show that SMS generally outperforms WhatsApp in verification success, particularly when offered as a secondary option. User preference tends to align with the first method offered, as shown by the higher WhatsApp uptake in Group C and higher SMS uptake in Group B. A key insight is that a two-method setup increases the likelihood of successful verification compared to a single-method approach.

Further analysis could integrate cost data by region, user demographics, and connectivity to optimise method selection for different user segments. Overall, incorporating a dual-method approach while prioritising SMS where feasible appears to be a reliable strategy for improving verification success.

---

## Key Questions and Findings:

- **Which screen would you suggest we proceed with?**
    - Group C (WhatsApp > SMS) demonstrated the highest overall success rate (0.9282), making it the preferred option. The dual-method approach provided a higher success rate.

- **Which success metrics did you consider and why?**
    - The analysis focused on the verification success rate and the method representation within groups. Groups B and C, which offered both methods, had higher success rates than Group A (SMS-only). SMS generally outperformed WhatsApp, particularly when SMS was the fallback method.

- **Would you incorporate additional data if you could?**
    - Yes, integrating cost data (e.g., per-method cost by region) and user demographics could further optimise method selection for different user segments.

- **Why do you think your chosen screen performed best?**
    - The dual-method setup in Group C allowed users to choose between WhatsApp and SMS, with SMS showing the highest success rate. This flexibility likely contributed to the higher success rate observed in Group C.

- **Would you recommend any additional changes to the screen?**
    - The current dual-method setup in Group C should be maintained, with WhatsApp as the primary method and SMS as the fallback due to its higher success rate. Additionally, improving user instructions and error messages could further enhance the user experience.

---

## File: 03_report_verification_and_cost_analysis
This analysis focused on evaluating the cost efficiency of different verification methods, considering both SMS and WhatsApp, and their respective success rates:

- **Key Insight:** While SMS had a higher success rate, WhatsApp may be more cost-effective in certain regions. A cost-benefit analysis could help prioritise the method for different regions, balancing verification success with cost efficiency.

---

## File: 04_age_bracket_method_failure_rates
This file analysed verification failure rates across different age brackets and methods:

- **Key Insight:** The failure rates were highest in the older age brackets, particularly in the 70-80 and 80-90 ranges for Group A (SMS-only), where 100% failure rates were observed. SMS had a higher success rate compared to WhatsApp, but WhatsApp was used more in Group C. This reinforces the value of SMS as a fallback option.

---

## Additional Note:
Some rows have been removed due to either null values found or lack of reference in another table. To set up the data locally, start by running the `main.py` file from the GitHub repository, which extracts the table locally. Then, execute the `00_data_cleanup_and_starschema_constraints.sql` script to clean up the data. For an overview of the project, refer to the `01_memo.md` file, which summarises the work carried out and findings. The main analysis is contained in `02_report_growth_data_analyst_exercise.sql`, with additional insights in `03_report_verification_and_cost_analysis.sql` and `04_age_bracket_method_failure_rates.sql`.
