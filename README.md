# Manufacturing Operations & Quality Analytics

An end-to-end data analytics project using **SQL Server, Python, and Power BI** to analyze manufacturing production performance, product quality, machine rejection rates, and equipment downtime.

> **Note:** This project uses synthetic manufacturing data generated for portfolio and learning purposes. It does not contain actual Bosch or any other company's production data.

## 1. Project Overview

Manufacturing organizations generate large amounts of production and quality data. Analyzing this information helps identify production trends, quality issues, machine-level performance variations, and downtime patterns.

This project simulates a manufacturing environment and performs end-to-end analysis to transform raw operational data into meaningful insights using SQL queries, Python visualizations, and an interactive Power BI dashboard.

## 2. Business Objectives

- Evaluate overall production performance.
- Analyze good units and rejected units.
- Identify machines with higher rejection rates.
- Compare production and quality performance across production lines.
- Analyze shift-wise and monthly production trends.
- Monitor machine downtime and identify major downtime reasons.
- Build a Power BI dashboard to communicate key performance indicators (KPIs).

## 3. Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL Server | Database creation, querying, joins, aggregations, and advanced analysis |
| Python | Data cleaning, exploratory data analysis, and visualization |
| Pandas | Data manipulation and analysis |
| NumPy | Synthetic data generation and numerical operations |
| Matplotlib | Data visualization |
| Jupyter Notebook | Python development and analysis |
| Power BI | Interactive dashboard and KPI reporting |
| DAX | Calculated measures and performance indicators |

## 4. Dataset Description

The project uses seven interconnected synthetic CSV datasets covering January to December 2025.

| Dataset | Description | Records |
|---|---|---:|
| Production_Lines | Manufacturing production lines | 5 |
| Machines | Machines assigned to production lines | 20 |
| Products | Manufactured product information | 15 |
| Production_Orders | Production order details | 1,000 |
| Production_Records | Production quantities by machine and shift | 5,000 |
| Quality_Inspections | Product quality inspection records | 5,000 |
| Downtime_Logs | Machine downtime events and reasons | 1,000 |

**Total production records:** 5,000

## 5. Database Design

The SQL Server database is named `ManufacturingDB`.

The database contains seven relational tables connected through primary keys and foreign keys.

Main relationships:

- Production_Lines → Machines
- Production_Lines → Production_Orders
- Products → Production_Orders
- Production_Orders → Production_Records
- Production_Orders → Quality_Inspections
- Machines → Production_Records
- Machines → Downtime_Logs

## 6. SQL Analysis

SQL Server was used to create the database, import datasets, validate records, and perform analytical queries.

### SQL concepts implemented

- Database and table creation
- Primary keys and foreign keys
- INNER JOIN and LEFT JOIN
- Aggregate functions: SUM, AVG, COUNT
- GROUP BY and ORDER BY
- Common Table Expressions (CTEs)
- Subqueries
- HAVING clause
- CASE WHEN statements
- Window functions:
  - RANK()
  - DENSE_RANK()
  - ROW_NUMBER()
  - LAG()
  - LEAD()
  - PARTITION BY
- Conditional aggregation
- Data validation and referential integrity checks

### Key SQL analyses

1. Overall production performance
2. Overall rejection and quality rates
3. Shift-wise production analysis
4. Machine-wise rejection analysis
5. Production-line performance
6. Machine downtime analysis
7. Downtime reason analysis
8. Monthly production trends
9. Product-wise quality analysis
10. Machine performance ranking
11. Month-over-month production comparison
12. Production quantity and referential integrity validation

## 7. Python Exploratory Data Analysis

Python was used to perform exploratory data analysis (EDA) on all seven datasets.

### Analysis performed

- Dataset inspection and structure validation
- Missing-value analysis
- Duplicate-record checks
- Overall production KPI calculation
- Shift-wise production analysis
- Machine-wise rejection analysis
- Product-wise rejection analysis
- Machine downtime analysis
- Downtime reason analysis
- Monthly production trend analysis
- Product category analysis

### Libraries used

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
```

## 8. Key Performance Indicators

The following KPIs were calculated from the simulated production dataset.

| KPI | Result |
|---|---:|
| Total Production | 710,454 |
| Good Production | 671,172 |
| Rejected Production | 39,282 |
| Rejection Rate | 5.53% |
| Quality Rate | 94.47% |
| Total Downtime | 93,118 minutes |
| Total Downtime | 1,551.97 hours |
| Downtime Incidents | 1,000 |

## 9. Key Findings

### Production Performance
- May recorded the highest monthly production at 70,251 units.
- February recorded the lowest monthly production at 44,919 units.
- Morning shift recorded the highest production volume at 284,480 units.

### Quality Performance
- Overall rejection rate was 5.53%.
- Machine 7 recorded the highest rejection rate at 5.80%.
- Machine 5 recorded the lowest rejection rate at 5.18%.
- Machining Line recorded the highest line-level rejection rate at 5.61%.
- Industrial Component 6 and Industrial Component 9 recorded the highest product rejection rates at 5.71%.

### Downtime Analysis
- Machine 1005 recorded the highest accumulated downtime at 6,008 minutes.
- Tool Change accounted for the highest accumulated downtime by reason at 16,594 minutes.
- Preventive Maintenance had the highest average downtime duration per incident at approximately 99.74 minutes.

*These are descriptive findings from synthetic data, not verified operational problems or causal conclusions.*

## 10. Power BI Dashboard

An interactive Power BI dashboard was developed to provide a consolidated view of manufacturing operations.

### Dashboard features

- Total production KPI
- Good production KPI
- Rejected production KPI
- Rejection rate
- Quality rate
- Total downtime in hours
- Monthly production trend
- Machine-wise rejection rate
- Downtime by reason
- Shift-wise production
- Product-wise rejection rate

### Dashboard Preview

![Manufacturing Operations and Quality Dashboard](Dashboard/manufacturing_dashboard_overview.png)

**Power BI report:** `Dashboard/manufacturing_operations_dashboard.pbix`

## 11. Business Recommendations

Based on the simulated analysis, the following areas could be investigated in a real manufacturing environment:

1. **Quality improvement:** Investigate machines and products with comparatively higher rejection rates.
2. **Machine monitoring:** Review maintenance and operating conditions for machines with higher accumulated downtime.
3. **Downtime reduction:** Examine tool-change and breakdown events to identify opportunities for process improvement.
4. **Production monitoring:** Track monthly and shift-wise production against planned targets and available capacity.
5. **Continuous improvement:** Establish regular KPI monitoring to evaluate the impact of corrective actions.

These are suggested investigation areas, not proven root causes.

## 12. Project Structure

```text
Manufacturing-Operations-Quality-Analysis/
│
├── SQL-Scripts/
│   ├── Create_Database.sql
│   ├── Create_Tables.sql
│   ├── Production_and_Quality_Analysis.sql
│   └── Advanced_SQL_Analysis.sql
│
├── Dataset/
│   ├── Production_Lines.csv
│   ├── Machines.csv
│   ├── Products.csv
│   ├── Production_Orders.csv
│   ├── Production_Records.csv
│   ├── Quality_Inspections.csv
│   └── Downtime_Logs.csv
│
├── Python/
│
├── Analysis/
│   ├── manufacturing_analysis.ipynb
│   ├── manufacturing_data_generation.ipynb
│   └── final_manufacturing_kpi_report.csv
│
├── Dashboard/
│   ├── manufacturing_dashboard_overview.png
│   └── Manufacturing_Operations.pbix
│
└── README.md
```

## 13. How to Run the Project

### Step 1: Database Setup
- Install SQL Server and SQL Server Management Studio (SSMS).
- Execute the database and table creation script.
- Import the seven CSV files into the corresponding tables.

### Step 2: SQL Analysis
- Open the SQL scripts in SSMS.
- Execute the production, quality, and advanced analysis queries.

### Step 3: Python Analysis
- Install Python and Jupyter Notebook.
- Install the required libraries:

```bash
pip install pandas numpy matplotlib jupyter
```

- Open `Analysis/manufacturing_analysis.ipynb`.
- Run the notebook cells to reproduce the exploratory analysis.

### Step 4: Power BI Dashboard
- Open `manufacturing_operations_dashboard.pbix` in Power BI Desktop.
- If required, update the SQL Server connection settings.
- Refresh the data to view the dashboard.

## 14. Skills Demonstrated

- SQL querying and database management
- Data cleaning and validation
- Exploratory Data Analysis
- Python programming
- Data visualization
- Power BI dashboard development
- DAX measures and KPI calculations
- Manufacturing operations analytics
- Quality and downtime analysis
- Business insight generation

## 15. Future Enhancements

- Develop predictive models for product rejection.
- Explore machine downtime prediction.
- Introduce production targets and availability data for more comprehensive operational efficiency analysis.
- Add additional dashboard filters and time-based comparisons.

## Author

**Chiranjeevi R Chapparad**

Aspiring Data Analyst

**Technical Skills:** SQL | Python | Power BI | Excel | Data Analytics

---

*This project was developed as a self-learning and portfolio project to demonstrate end-to-end data analytics capabilities using a simulated manufacturing dataset.*
