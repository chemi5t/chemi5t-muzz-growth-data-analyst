# Verification Method Analysis Project

## Overview

This project focuses on analyzing verification success rates across three test groups using SMS and WhatsApp as verification methods. The goal is to evaluate the effectiveness of these methods, understand user preferences, and recommend strategies to optimize the verification process.

The project explores the performance of different verification methods, considering both user behavior and cost-efficiency, with the aim of enhancing user experience and increasing verification success rates.

## Project Structure

- **01_data_cleanup_and_starschema_constraints.sql**: Contains the data cleanup and schema constraints to ensure accurate analysis by removing incomplete data points.
- **02_report_growth_data_analyst_exercise**: The main report analyzing verification success rates, comparing the different test groups, and offering insights on the effectiveness of SMS and WhatsApp.
- **03_report_verification_and_cost_analysis**: An analysis focused on the cost and performance of each verification method across different regions.
- **04_age_bracket_method_failure_rates**: A report examining the verification success rates based on age brackets.
- **Verification_Method_Analysis.ipynb**: A Jupyter notebook containing the SQL queries and Python analysis for the project, including visualizations and statistical summaries.

## Insights

- **Highest Success Rate**: Group C (WhatsApp > SMS) shows the highest success rate at 0.9282, closely followed by Group B (SMS > WhatsApp) at 0.9281.
- **Lowest Success Rate**: Group A (SMS-only) has the lowest success rate at 0.8735, indicating that including an alternative verification method may improve outcomes.
- **Dual-Method Setup**: Offering two verification methods increases success rates. Groups B and C, which allow for both SMS and WhatsApp, demonstrated higher success than Group A (SMS-only).
  
## Key Findings

- **SMS outperforms WhatsApp**: Within Groups B and C, SMS consistently achieves higher success rates than WhatsApp, particularly in Group C.
- **User Preferences**: Users tend to favor the first verification method offered, with WhatsApp being more popular in Group C and SMS in Group B.

## Additional Analysis (Future Work)

If more data were available, additional analysis could be conducted on:
- **Cost-Benefit Analysis by Region**: Evaluate the cost-effectiveness of each method by region.
- **Demographic Insights**: Understand how user age, device type, and other demographics influence verification success rates.
- **Time-of-Day Analysis**: Analyze verification success based on time of day or day of the week.
- **Impact of Network Connectivity**: Assess the influence of network strength and Wi-Fi availability on verification success.
- **User Feedback**: Incorporate user feedback to further refine the verification process.

## Recommendations

- **Dual-Method Approach**: The results suggest that offering both SMS and WhatsApp as verification methods increases the likelihood of success.
- **Prioritize SMS as a Fallback**: SMS tends to outperform WhatsApp in verification success, especially when used as a secondary option.
- **Highlight SMS as a Reliable Option**: Given its higher success rate, SMS should be recommended as a fallback method.

## Setup and Installation

To get started with the project, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/chemi5t/chemi5t-muzz-growth-data-analyst.git
