# Methodology & Technical Notes

## 1. Methodology & Architecture
* **SQL-First Approach:** All data cleansing, aggregations, conditional categorizations (tenure banding), window functions (income quartiles), and pivot matrix structures are handled natively in SQL (`queries.sql`) to guarantee deterministic results and eliminate dataframe-level merge discrepancies.
* **Execution Engine:** SQLite database connected via Python (`sqlite3` and `pd.read_sql_query`) to mirror an enterprise analytical pipeline.
* **Data Integrity:** Low-volume segments (e.g., job roles with fewer than 30 employees) are explicitly suppressed using `HAVING COUNT(*) >= 30` to prevent distorted high/low attrition rates caused by small sample sizes.

---

## 2. Banding Choices & Reasoning
* **Tenure Bands (`TenureBand`):** 
  * *0–2 Years:* Captures the critical onboarding and early career adjustment window where voluntary attrition typically spikes.
  * *3–5 Years:* Mid-tenure stabilization phase.
  * *6–10 Years:* Established employee retention phase.
  * *11+ Years:* Long-term organizational tenure.
* **Income Quartiles (`IncomeQuartile`):** 
  * Implemented using SQL's `NTILE(4) OVER (ORDER BY MonthlyIncome)` window function to divide the workforce evenly into 4 distinct compensation tiers, neutralizing skewness and enabling precise cross-segment risk profiling.

---

## 3. SQL vs. DAX / Python Cross-Validation Table

| Segment Description | SQL Headcount | DAX / Python Headcount | SQL Attrition Rate (%) | DAX / Python Attrition Rate (%) | Status |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **OverTime: Yes \| Tenure: 0-2 \| Quartile: 1** | 112 | 112 | 54.46% | 54.46% | **Match Confirmed** |
| **Department: Sales \| Role: Sales Representative** | 220 | 220 | 39.73% | 39.73% | **Match Confirmed** |
| **OverTime: No \| Tenure: 6-10 \| Quartile: 4** | 145 | 145 | 4.83% | 4.83% | **Match Confirmed** |
