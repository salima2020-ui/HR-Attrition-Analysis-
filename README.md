# 📊 HR Attrition Analytics & Data Pipeline

An end-to-end HR analytics pipeline built on the IBM HR Employee Attrition dataset using SQL logic for all metric aggregation, risk segmentation, and windowing, with visual presentation built via Matplotlib inside a Jupyter Notebook environment.

---

## 🛠️ Architecture & Tech Stack
* **Interactive Environment:** Jupyter Notebook (`attrition_analytics.ipynb`)
* **Database Engine:** SQLite (`sqlite3`) via Python `conn`
* **Data Manipulation & Querying:** SQL (CTEs, Window Functions, Conditional Aggregations)
* **Visualization Layer:** Python (`matplotlib`)

---

## 📁 Project Structure

```text
├── attrition_analytics.ipynb   # Complete Jupyter Notebook pipeline (SQL execution & charts)
├── Queries.sql                 # All 12 modular SQL queries
├── summary.md                  # Non-technical Executive Summary for leadership
├── Note.md                     # Methodology, banding rules, and cross-validation table
└── README.md                   # Project overview
