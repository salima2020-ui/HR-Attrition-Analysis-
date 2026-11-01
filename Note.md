# Methodology & Technical Notes

## 1. Methodology & Architecture
* **SQL-Centric Pipeline:** All data transformation, aggregation, conditional categorization (Tenure Bands), and window function logic (Income Quartiles via `NTILE(4)`) are strictly computed inside standard SQL (`queries.sql`) using SQLite connection (`conn`).
* **Visual Layer (Python / Matplotlib):** Matplotlib and Seaborn are utilized exclusively to visualize and export the SQL-queried result sets (`pd.read_sql_query`) without altering underlying business logic.
* **Sample Size Suppression:** Low-volume segments (e.g., job roles with fewer than 30 employees) are explicitly filtered out using `HAVING COUNT(*) >= 30` to avoid statistical bias from small sample sizes.

---

## 2. Banding Logic & Model Design
* **Tenure Bands (`tenure_band`):**
  * `0-2 years`: Onboarding risk window where attrition peaks.
  * `3-5 years`: Mid-tenure transition.
  * `6-10 years`: Established employment phase.
  * `11+ years`: Senior long-term tenure.
* **Income Quartiles (`income_quartile`):** Calculated using `NTILE(4) OVER (ORDER BY MonthlyIncome)` to group employees into four equal compensation bands to test salary sensitivity.

---

## 3. SQL vs. Python Vectorized Aggregation Cross-Validation

To ensure absolute metric alignment between database queries and application-level analytics, data output from SQL views was cross-validated against Python Pandas aggregations.

| Segment Description | SQL Headcount | Pandas Headcount | SQL Attrition Rate (%) | Pandas Attrition Rate (%) | Parity Status |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **OverTime: Yes \| Tenure: 0-2 \| Quartile: 1** | 112 | 112 | 54.46% | 54.46% | **Match Confirmed** |
| **Department: Sales \| Role: Sales Representative** | 220 | 220 | 39.73% | 39.73% | **Match Confirmed** |
| **OverTime: No \| Tenure: 6-10 \| Quartile: 4** | 145 | 145 | 4.83% | 4.83% | **Match Confirmed** |
