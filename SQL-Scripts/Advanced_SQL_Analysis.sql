--Product-wise Quality Analysis
WITH ProductQuality AS
(
    SELECT
        P.Product_ID,
        P.Product_Name,
        P.Product_Category,
        SUM(PR.Total_Units) AS Total_Production,
        SUM(PR.Good_Units) AS Good_Units,
        SUM(PR.Rejected_Units) AS Rejected_Units
    FROM Products P
    INNER JOIN Production_Orders PO
        ON P.Product_ID = PO.Product_ID
    INNER JOIN Production_Records PR
        ON PO.Order_ID = PR.Order_ID
    GROUP BY
        P.Product_ID,
        P.Product_Name,
        P.Product_Category
)
SELECT
    Product_ID,
    Product_Name,
    Product_Category,
    Total_Production,
    Good_Units,
    Rejected_Units,
    CAST(
        Rejected_Units * 100.0 /
        NULLIF(Total_Production, 0)
        AS DECIMAL(10,2)
    ) AS Rejection_Rate
FROM ProductQuality
ORDER BY Rejection_Rate DESC;


-- Machines Above Average Rejection Rate

SELECT
    M.Machine_ID,
    M.Machine_Name,
    SUM(PR.Total_Units) AS Total_Production,
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
HAVING
    SUM(PR.Rejected_Units) * 100.0 /
    NULLIF(SUM(PR.Total_Units), 0)
    >
    (
        SELECT
            SUM(Rejected_Units) * 100.0 /
            NULLIF(SUM(Total_Units), 0)
        FROM Production_Records
    )
ORDER BY Rejection_Rate DESC;

-- Machine Production Ranking

SELECT
    M.Machine_ID,
    M.Machine_Name,
    SUM(PR.Total_Units) AS Total_Production,

    RANK() OVER (
        ORDER BY SUM(PR.Total_Units) DESC
    ) AS Production_Rank

FROM Machines M
INNER JOIN Production_Records PR
    ON M.Machine_ID = PR.Machine_ID

GROUP BY
    M.Machine_ID,
    M.Machine_Name

ORDER BY Production_Rank;


-- Comparing Window Functions

SELECT
    M.Machine_ID,
    M.Machine_Name,
    SUM(PR.Total_Units) AS Total_Production,

    RANK() OVER (
        ORDER BY SUM(PR.Total_Units) DESC
    ) AS Production_Rank,

    DENSE_RANK() OVER (
        ORDER BY SUM(PR.Total_Units) DESC
    ) AS Dense_Production_Rank,

    ROW_NUMBER() OVER (
        ORDER BY SUM(PR.Total_Units) DESC
    ) AS Production_Row_Number

FROM Machines M
INNER JOIN Production_Records PR
    ON M.Machine_ID = PR.Machine_ID

GROUP BY
    M.Machine_ID,
    M.Machine_Name

ORDER BY Total_Production DESC;



-- Rank machines within each production line

SELECT
    PL.Line_Name,
    M.Machine_ID,
    M.Machine_Name,
    SUM(PR.Total_Units) AS Total_Production,

    RANK() OVER (
        PARTITION BY PL.Line_ID
        ORDER BY SUM(PR.Total_Units) DESC
    ) AS Machine_Rank

FROM Production_Lines PL
INNER JOIN Production_Orders PO
    ON PL.Line_ID = PO.Line_ID
INNER JOIN Production_Records PR
    ON PO.Order_ID = PR.Order_ID
INNER JOIN Machines M
    ON PR.Machine_ID = M.Machine_ID

GROUP BY
    PL.Line_ID,
    PL.Line_Name,
    M.Machine_ID,
    M.Machine_Name

ORDER BY
    PL.Line_Name,
    Machine_Rank;



-- Month-over-month production comparison

WITH MonthlyProduction AS
(
    SELECT
        MONTH(Production_Date) AS Production_Month,
        DATENAME(MONTH, Production_Date) AS Month_Name,
        SUM(Total_Units) AS Total_Production
    FROM Production_Records
    GROUP BY
        MONTH(Production_Date),
        DATENAME(MONTH, Production_Date)
)
SELECT
    Month_Name,
    Total_Production,

    LAG(Total_Production) OVER (
        ORDER BY Production_Month
    ) AS Previous_Month_Production,

    Total_Production -
    LAG(Total_Production) OVER (
        ORDER BY Production_Month
    ) AS Production_Change

FROM MonthlyProduction
ORDER BY Production_Month;



-- Compare current production with next month

WITH MonthlyProduction AS
(
    SELECT
        MONTH(Production_Date) AS Production_Month,
        DATENAME(MONTH, Production_Date) AS Month_Name,
        SUM(Total_Units) AS Total_Production
    FROM Production_Records
    GROUP BY
        MONTH(Production_Date),
        DATENAME(MONTH, Production_Date)
)
SELECT
    Month_Name,
    Total_Production,

    LEAD(Total_Production) OVER (
        ORDER BY Production_Month
    ) AS Next_Month_Production

FROM MonthlyProduction
ORDER BY Production_Month;


-- Classify machines based on rejection rate

SELECT
    M.Machine_ID,
    M.Machine_Name,

    SUM(PR.Total_Units) AS Total_Production,
    SUM(PR.Rejected_Units) AS Rejected_Units,

    CAST(
        SUM(PR.Rejected_Units) * 100.0 /
        NULLIF(SUM(PR.Total_Units), 0)
        AS DECIMAL(10,2)
    ) AS Rejection_Rate,

    CASE
        WHEN SUM(PR.Rejected_Units) * 100.0 /
             NULLIF(SUM(PR.Total_Units), 0) < 5
            THEN 'Good'

        WHEN SUM(PR.Rejected_Units) * 100.0 /
             NULLIF(SUM(PR.Total_Units), 0) <= 6
            THEN 'Average'

        ELSE 'Poor'
    END AS Machine_Status

FROM Machines M
INNER JOIN Production_Records PR
    ON M.Machine_ID = PR.Machine_ID

GROUP BY
    M.Machine_ID,
    M.Machine_Name

ORDER BY Rejection_Rate DESC;



-- Conditional aggregation by production shift

SELECT
    Shift_Name,

    COUNT(*) AS Total_Records,

    SUM(CASE
        WHEN Rejected_Units = 0 THEN 1
        ELSE 0
    END) AS Zero_Rejection_Records,

    SUM(CASE
        WHEN Rejected_Units > 0 THEN 1
        ELSE 0
    END) AS Records_With_Rejections,

    SUM(Total_Units) AS Total_Production,

    SUM(CASE
        WHEN Rejected_Units > 0 THEN Rejected_Units
        ELSE 0
    END) AS Total_Rejected_Units

FROM Production_Records
GROUP BY Shift_Name
ORDER BY Shift_Name;


-- Validate production quantity consistency

SELECT
    COUNT(*) AS Total_Records,

    SUM(CASE
        WHEN Total_Units = Good_Units + Rejected_Units
        THEN 0
        ELSE 1
    END) AS Quantity_Mismatches,

    SUM(CASE
        WHEN Total_Units < 0
          OR Good_Units < 0
          OR Rejected_Units < 0
        THEN 1
        ELSE 0
    END) AS Invalid_Quantity_Records

FROM Production_Records;


