# 📊 HR Attrition Analytics & Data Pipeline (SQL + Matplotlib)

An end-to-end HR analytics pipeline built on the IBM HR Employee Attrition dataset using SQL logic for all metric aggregation, risk segmentation, and windowing, with visual presentation built via Matplotlib and Seaborn inside a Jupyter Notebook environment.

---

## 🛠️ Architecture & Tech Stack
* **Interactive Environment:** Jupyter Notebook (`attrition_analytics.ipynb`)
* **Database Engine:** SQLite (`sqlite3`) via Python `conn`
* **Data Manipulation & Querying:** SQL (CTEs, Window Functions, Conditional Aggregations)
* **Visualization Layer:** Python (`matplotlib`, `seaborn`)

---

## 📁 Project Structure

```text
├── attrition_analytics.ipynb   # Complete Jupyter Notebook pipeline (SQL execution & charts)
├── queries.sql                 # All 12 modular SQL queries
├── hr_attrition_dashboard.png # High-resolution export of visual dashboards
├── summary.md                  # Non-technical Executive Summary for leadership
├── note.md                     # Methodology, banding rules, and cross-validation table
└── README.md                   # Project overview
