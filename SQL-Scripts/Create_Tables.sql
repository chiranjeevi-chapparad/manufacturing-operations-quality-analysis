
USE ManufacturingDB;
GO

-- 1. Production Lines
CREATE TABLE Production_Lines (
    Line_ID INT PRIMARY KEY,
    Line_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    Capacity_Per_Shift INT
);
GO

-- 2. Machines
CREATE TABLE Machines (
    Machine_ID INT PRIMARY KEY,
    Machine_Name VARCHAR(100) NOT NULL,
    Line_ID INT NOT NULL,
    Machine_Type VARCHAR(100),
    Installation_Date DATE,
    FOREIGN KEY (Line_ID)
        REFERENCES Production_Lines(Line_ID)
);
GO

-- 3. Products
CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(150) NOT NULL,
    Product_Category VARCHAR(100),
    Standard_Cycle_Time_Seconds DECIMAL(10,2)
);
GO

-- 4. Production Orders
CREATE TABLE Production_Orders (
    Order_ID INT PRIMARY KEY,
    Product_ID INT NOT NULL,
    Line_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    Planned_Quantity INT NOT NULL,
    FOREIGN KEY (Product_ID)
        REFERENCES Products(Product_ID),
    FOREIGN KEY (Line_ID)
        REFERENCES Production_Lines(Line_ID)
);
GO

-- 5. Production Records
CREATE TABLE Production_Records (
    Record_ID INT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Machine_ID INT NOT NULL,
    Shift_Name VARCHAR(20),
    Production_Date DATE NOT NULL,
    Total_Units INT NOT NULL,
    Good_Units INT NOT NULL,
    Rejected_Units INT NOT NULL,
    FOREIGN KEY (Order_ID)
        REFERENCES Production_Orders(Order_ID),
    FOREIGN KEY (Machine_ID)
        REFERENCES Machines(Machine_ID)
);
GO

-- 6. Quality Inspections
CREATE TABLE Quality_Inspections (
    Inspection_ID INT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Inspection_Date DATE NOT NULL,
    Inspected_Quantity INT NOT NULL,
    Defect_Quantity INT NOT NULL,
    Defect_Type VARCHAR(100),
    FOREIGN KEY (Order_ID)
        REFERENCES Production_Orders(Order_ID)
);
GO

-- 7. Downtime Logs
CREATE TABLE Downtime_Logs (
    Downtime_ID INT PRIMARY KEY,
    Machine_ID INT NOT NULL,
    Downtime_Date DATE NOT NULL,
    Downtime_Minutes INT NOT NULL,
    Reason VARCHAR(150),
    FOREIGN KEY (Machine_ID)
        REFERENCES Machines(Machine_ID)
);
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;