SELECT DB_NAME() AS Current_Database;

USE ManufacturingDB;
GO

--Total Production
SELECT
    SUM(Total_Units) AS Total_Production,
    SUM(Good_Units) AS Total_Good_Units,
    SUM(Rejected_Units) AS Total_Rejected_Units
FROM Production_Records;

--Rejection rate
SELECT
    SUM(Total_Units) AS Total_Production,
    SUM(Rejected_Units) AS Total_Rejected,
    CAST(
        SUM(Rejected_Units) * 100.0 /
        NULLIF(SUM(Total_Units), 0)
        AS DECIMAL(10,2)
    ) AS Rejection_Rate_Percentage
FROM Production_Records;

--Production analysis by shift
SELECT
    Shift_Name,
    SUM(Total_Units) AS Total_Production,
    SUM(Good_Units) AS Good_Production,
    SUM(Rejected_Units) AS Rejected_Production,
    CAST(
        SUM(Rejected_Units) * 100.0 /
        NULLIF(SUM(Total_Units), 0)
        AS DECIMAL(10,2)
    ) AS Rejection_Rate
FROM Production_Records
GROUP BY Shift_Name
ORDER BY Total_Production DESC;

--Machine wise performance
SELECT
    M.Machine_ID,
    M.Machine_Name,
    SUM(PR.Total_Units) AS Total_Production,
    SUM(PR.Good_Units) AS Good_Units,
    SUM(PR.Rejected_Units) AS Rejected_Units,
    CAST(
        SUM(PR.Rejected_Units) * 100.0 /
        NULLIF(SUM(PR.Total_Units), 0)
        AS DECIMAL(10,2)
    ) AS Rejection_Rate
FROM Machines M
INNER JOIN Production_Records PR
    ON M.Machine_ID = PR.Machine_ID
GROUP BY
    M.Machine_ID,
    M.Machine_Name
ORDER BY Rejection_Rate DESC;

--Production line performance
SELECT
    PL.Line_ID,
    PL.Line_Name,
    SUM(PR.Total_Units) AS Total_Production,
    SUM(PR.Good_Units) AS Good_Units,
    SUM(PR.Rejected_Units) AS Rejected_Units,
    CAST(
        SUM(PR.Rejected_Units) * 100.0 /
        NULLIF(SUM(PR.Total_Units), 0)
        AS DECIMAL(10,2)
    ) AS Rejection_Rate
FROM Production_Lines PL
INNER JOIN Production_Orders PO
    ON PL.Line_ID = PO.Line_ID
INNER JOIN Production_Records PR
    ON PO.Order_ID = PR.Order_ID
GROUP BY
    PL.Line_ID,
    PL.Line_Name
ORDER BY Rejection_Rate DESC;

--Downtime analysis
SELECT
    Machine_ID,
    SUM(Downtime_Minutes) AS Total_Downtime_Minutes,
    COUNT(*) AS Downtime_Incidents,
    AVG(CAST(Downtime_Minutes AS DECIMAL(10,2)))
        AS Average_Downtime_Minutes
FROM Downtime_Logs
GROUP BY Machine_ID
ORDER BY Total_Downtime_Minutes DESC;

--Downtime by reason
SELECT
    Reason,
    COUNT(*) AS Total_Incidents,
    SUM(Downtime_Minutes) AS Total_Downtime,
    CAST(
        AVG(CAST(Downtime_Minutes AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS Average_Downtime
FROM Downtime_Logs
GROUP BY Reason
ORDER BY Total_Downtime DESC;

--Monthly production trends
SELECT
    YEAR(Production_Date) AS Production_Year,
    MONTH(Production_Date) AS Production_Month,
    DATENAME(MONTH, Production_Date) AS Month_Name,
    SUM(Total_Units) AS Total_Production,
    SUM(Good_Units) AS Good_Units,
    SUM(Rejected_Units) AS Rejected_Units,
    CAST(
        SUM(Rejected_Units) * 100.0 /
        NULLIF(SUM(Total_Units), 0)
        AS DECIMAL(10,2)
    ) AS Rejection_Rate
FROM Production_Records
GROUP BY
    YEAR(Production_Date),
    MONTH(Production_Date),
    DATENAME(MONTH, Production_Date)
ORDER BY
    Production_Year,
    Production_Month;