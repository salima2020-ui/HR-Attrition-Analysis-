-- Overall company headcount and baseline attrition
SELECT 
    COUNT(*) AS total_headcount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS total_attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS overall_attrition_rate
FROM employees;

-- Attrition rate by department
SELECT 
    Department,
    COUNT(*) AS headcount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM employees
GROUP BY Department
ORDER BY attrition_rate DESC;

-- Attrition rate by job role with volume filter
SELECT 
    JobRole,
    COUNT(*) AS headcount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM employees
GROUP BY JobRole
HAVING COUNT(*) >= 30
ORDER BY attrition_rate DESC;

-- Attrition rate by tenure band
WITH tenure_cte AS (
    SELECT *,
        CASE 
            WHEN YearsAtCompany BETWEEN 0 AND 2 THEN '0-2'
            WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3-5'
            WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10'
            ELSE '11+' 
        END AS tenure_band
    FROM employees
)
SELECT 
    tenure_band,
    COUNT(*) AS headcount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM tenure_cte
GROUP BY tenure_band
ORDER BY tenure_band;

-- Attrition rate by income quartile
WITH income_cte AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY MonthlyIncome) AS income_quartile
    FROM employees
)
SELECT 
    income_quartile,
    COUNT(*) AS headcount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM income_cte
GROUP BY income_quartile
ORDER BY income_quartile;

-- Categorical risk drivers comparison
SELECT 'OverTime' AS dimension, OverTime AS category, 
       COUNT(*) AS headcount, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions, 
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate 
FROM employees GROUP BY OverTime
UNION ALL
SELECT 'MaritalStatus', MaritalStatus, COUNT(*), 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END), 
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) 
FROM employees GROUP BY MaritalStatus
UNION ALL
SELECT 'BusinessTravel', BusinessTravel, COUNT(*), 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END), 
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) 
FROM employees GROUP BY BusinessTravel
UNION ALL
SELECT 'Gender', Gender, COUNT(*), 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END), 
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) 
FROM employees GROUP BY Gender;

-- Department and job satisfaction matrix
SELECT 
    Department,
    ROUND(100.0 * SUM(CASE WHEN JobSatisfaction = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END) / SUM(CASE WHEN JobSatisfaction = 1 THEN 1 ELSE 1 END), 2) AS js_1_rate,
    ROUND(100.0 * SUM(CASE WHEN JobSatisfaction = 2 AND Attrition = 'Yes' THEN 1 ELSE 0 END) / SUM(CASE WHEN JobSatisfaction = 2 THEN 1 ELSE 1 END), 2) AS js_2_rate,
    ROUND(100.0 * SUM(CASE WHEN JobSatisfaction = 3 AND Attrition = 'Yes' THEN 1 ELSE 0 END) / SUM(CASE WHEN JobSatisfaction = 3 THEN 1 ELSE 1 END), 2) AS js_3_rate,
    ROUND(100.0 * SUM(CASE WHEN JobSatisfaction = 4 AND Attrition = 'Yes' THEN 1 ELSE 0 END) / SUM(CASE WHEN JobSatisfaction = 4 THEN 1 ELSE 1 END), 2) AS js_4_rate
FROM employees
GROUP BY Department;

-- Compensation benchmarking by job role and attrition
SELECT 
    JobRole,
    Attrition,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income,
    COUNT(*) AS headcount
FROM employees
GROUP BY JobRole, Attrition
ORDER BY JobRole, Attrition;

-- Work-life balance vs attrition rate
SELECT 
    WorkLifeBalance,
    COUNT(*) AS headcount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM employees
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- Distance from home impact on attrition
WITH distance_cte AS (
    SELECT *,
        CASE 
            WHEN DistanceFromHome BETWEEN 1 AND 5 THEN '1-5 km'
            WHEN DistanceFromHome BETWEEN 6 AND 15 THEN '6-15 km'
            ELSE '16+ km' 
        END AS distance_band
    FROM employees
)
SELECT 
    distance_band,
    COUNT(*) AS headcount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM distance_cte
GROUP BY distance_band
ORDER BY attrition_rate DESC;

-- Environment satisfaction impact on attrition
SELECT 
    EnvironmentSatisfaction,
    COUNT(*) AS headcount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM employees
GROUP BY EnvironmentSatisfaction
ORDER BY EnvironmentSatisfaction;

-- Multi-variable segment explorer
WITH risk_base AS (
    SELECT Department, JobRole, OverTime,
        CASE 
            WHEN YearsAtCompany BETWEEN 0 AND 2 THEN '0-2'
            WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3-5'
            WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10'
            ELSE '11+' 
        END AS tenure_band,
        NTILE(4) OVER (ORDER BY MonthlyIncome) AS income_quartile,
        Attrition
    FROM employees
)
SELECT 
    Department, 
    JobRole, 
    OverTime, 
    tenure_band, 
    income_quartile,
    COUNT(*) AS headcount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate
FROM risk_base
GROUP BY Department, JobRole, OverTime, tenure_band, income_quartile
HAVING COUNT(*) >= 10
ORDER BY attrition_rate DESC;
