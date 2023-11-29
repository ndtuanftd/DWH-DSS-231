SELECT @@VERSION

-- CREATE DATABASE DataWarehouseCourse_DW;

-- Switch to the new database context
USE DataWarehouseCourse_DW;
GO

-- Creating Dimension Tables

-- Product Dimension
CREATE TABLE DimProduct (
     ProductID INT PRIMARY KEY,
    [Name] NVARCHAR(50),
	[Product Identification Number] NVARCHAR(25), -- Từ ProductNumber
	-- [Product Size] NVARCHAR(70), -- Tính từ cột Size NVARCHAR(5), với bảng UnitMeasure
	-- [Product Weight] NVARCHAR(70), -- Tính từ cột Weight Decimal(8,2), với bảng UnitMeasure
	[Line Description] NVARCHAR(30),	
	[Class Description] NVARCHAR(30),
	[Style Description] NVARCHAR(30),				    -- Tính từ 
														--ProductLine NCHAR(2), 	R = Road, M = Mountain, T = Touring, S = Standard
														--Class NCHAR(2), 	H = High, M = Medium, L = Low
														--Style NCHAR(2), 	W = Womens, M = Mens, U = Universal
	[Category Description] NVARCHAR(50), -- Tính từ Name trong bảng Subcategory join với Category qua ProductCategoryID
	[Subcategory Description] NVARCHAR(50), -- Tính từ Name trong bảng Subcategory lấy ProductSubcategoryID
	-- Other product-related attributes
);
GO

-- Time Dimension
CREATE TABLE DimDate(
	DateKey int PRIMARY KEY,
	FullDateAlternateKey date NOT NULL,
	DayNumberOfWeek tinyint NOT NULL,
	EnglishDayNameOfWeek nvarchar(10) NOT NULL,
	DayNumberOfMonth tinyint NOT NULL,
	DayNumberOfYear smallint NOT NULL,
	WeekNumberOfYear tinyint NOT NULL,
	EnglishMonthName nvarchar(10) NOT NULL,
	CalendarMonth tinyint NOT NULL,
	CalendarQuarter tinyint NOT NULL,
	CalendarYear smallint NOT NULL,
	CalendarSemester tinyint NOT NULL,
	FiscalQuarter tinyint NOT NULL,
	FiscalMonth smallint NOT NULL,
	FiscalYear smallint NOT NULL,
	FiscalSemester tinyint NOT NULL,
);
GO



-- Sales Territory Dimension
CREATE TABLE DimSalesTerritory (
    TerritoryID INT PRIMARY KEY,
	[Name] NVARCHAR(50),
	CountryRegion NVARCHAR(50),
	[Group] NVARCHAR(50),
    -- Other sales territory-related attributes
);
GO

CREATE TABLE DimStateProvince (
    StateProvinceID INT PRIMARY KEY,
	StateProvinceCode NCHAR(3),
	StateProvinceName  NVARCHAR(50),
	CountryRegion NVARCHAR(50),
	TerritoryID INT,
	FOREIGN KEY (TerritoryID) REFERENCES DimSalesTerritory(TerritoryID),
	-- Other sales territory-related attributes
);
GO


-- Customer Individual Dimension
CREATE TABLE DimIndividualCustomer (
    BusinessEntityID INT PRIMARY KEY,

    FullName NVARCHAR(150), -- Tính từ FirstName + MiddleName + LastName
	Gender NVARCHAR(10),
	DateOfFirstPurcharse DATE, 

	
	Occupation NVARCHAR(50),

	[House Owner Indicator] int, -- Tính từ HouseOwnerFlag
	
	[Level of Education] NVARCHAR(50),
	
	[Yearly income range] NVARCHAR(50),

	[Cars owned] int,
	[Marital Status] NVARCHAR(1),
	[Total Children] int,
	[Children at home] int,

	-- StateProvinceID INT,
	[R] INT,
	[F] INT,
	[M] money,
	RFM_Score NVARCHAR(3),
	DemographicClusterID INT,
	[Age Segment] NVARCHAR(50), -- Tính từ cluster Birthday DATE,
	
	[Income Bracket Segment] NVARCHAR(50), -- Tính từ cluster attribute YearlyIncome 
	
	

	[Family Status Segment] NVARCHAR(50),

								-- Tính từ
									--MaritalStatus NCHAR(5),
									--TotalChildren SMALLINT,
									--NumberChildrenAtHome SMALLINT,
									--NumberCarsOwned SMALLINT,


	-- FOREIGN KEY (StateProvinceID) REFERENCES DimStateProvince(StateProvinceID)
    -- Other customer-related attributes
);
GO

-- Customer Store Dimension
CREATE TABLE DimStoreCustomer (
    BusinessEntityID INT PRIMARY KEY,
    [Store Name] NVARCHAR(50) NOT NULL,
	[Sales Volume] INT, -- Tính từ AnnualSales
	[Revenue] INT, -- Tính từ AnnualRevenue
	[StoreType] NVARCHAR(30), -- Tính từ BusinessType NVARCHAR(10): BM=Bicycle manu BS=bicyle store OS=online store SGS=sporting goods store D=Discount Store
	[YearOpened] INT,
	[Specialty] NVARCHAR(50),
	[SquareFeet] INT,
	[NumberOfEmployees] INT,
	-- StateProvinceID INT,
	[R] INT,
	[F] INT,
	[M] money,
	RFM_Score NVARCHAR(3),
	DemographicClusterID INT,
	[Sales Volume Segment] NVARCHAR(30),
	[Revenue Segment] NVARCHAR(30),
	[Store Establishment Status Segment] NVARCHAR(30), -- Tính từ YearOpened SMALLINT,
	[Store Specialty Segment] NVARCHAR(30), -- Tính từ Specialty NVARCHAR(50),
	[Store Size Segment] NVARCHAR(30), -- Tính từ SquareFeet INT,
	[Store Brand Number Segment] NVARCHAR(30), -- Tính từ Brands SMALLINT,
	[Store Employee Size Segment] NVARCHAR(30), -- Tính từ NumberEmployees SMALLINT,
    -- Other customer-related attributes
	-- StateProvinceID INT,
	-- FOREIGN KEY (StateProvinceID) REFERENCES DimStateProvince(StateProvinceID)
);
GO


CREATE TABLE FactSales (
    SalesOrderID INT NOT NULL,
	ProductKey INT NOT NULL,
    OrderDateKey INT NOT NULL,
    DueDateKey INT NOT NULL,
    ShipDateKey INT NOT NULL,
    
	IndividualCustomerKey INT,
	StoreCustomerKey INT,
   -- PromotionKey INT NOT NULL,
    SalesTerritoryKey INT NOT NULL,

	SalesOrderNumber NVARCHAR(25) NOT NULL,

    [Changes to Order] NVARCHAR(30), -- Tính từ RevisionNumber TINYINT NOT NULL,
    
	[Sales Product Quantity] INT, -- Tính từ OrderQuantity SMALLINT NOT NULL,

    [Sales Subtotal Amount] MONEY, -- Tính từ SalesOrderHeader.SubTotal: SUM(SalesOrderDetail.LineTotal)for the appropriate SalesOrderID.

	[Sales TotalDue Amount] MONEY, -- Tính từ TotalDue. Cách tính TotalDue trước khi tính tổng: Subtotal + TaxAmt + Freight
	
	-- Primary key could be a composite of SalesOrderNumber and SalesOrderLineNumber if they form a unique combination
    PRIMARY KEY (SalesOrderID, ProductKey),
    FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (OrderDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (DueDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (ShipDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (IndividualCustomerKey) REFERENCES DimIndividualCustomer(BusinessEntityID),
    FOREIGN KEY (StoreCustomerKey) REFERENCES DimStoreCustomer(BusinessEntityID),
    FOREIGN KEY (SalesTerritoryKey) REFERENCES DimSalesTerritory(TerritoryID)
);
GO



---======================================================================
-- DimDate Procedure
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Refresh_DimDate'))
EXEC('Create Procedure [dbo].[Refresh_DimDate]
as
Begin

declare @startdate date = ''2005-01-01'',
    @enddate date = ''2014-12-31''

IF @startdate IS NULL
    BEGIN
        Select Top 1 @startdate = FulldateAlternateKey
        From DimDate 
        Order By DateKey ASC 
    END

Declare @datelist table (FullDate date)

while @startdate <= @enddate

Begin 
    Insert into @datelist (FullDate)
    Select @startdate

    Set @startdate = dateadd(dd,1,@startdate)

end 

 Insert into dbo.DimDate 
    (DateKey, 
        FullDateAlternateKey, 
        DayNumberOfWeek, 
        EnglishDayNameOfWeek, 
      
        DayNumberOfMonth, 
        DayNumberOfYear, 
        WeekNumberOfYear, 
        EnglishMonthName, 
     
		CalendarMonth,
        CalendarQuarter,
        CalendarYear, 
        CalendarSemester, 
        FiscalQuarter, 
		FiscalMonth,
        FiscalYear, 
        FiscalSemester)


select convert(int,convert(varchar,dl.FullDate,112)) as DateKey,
    dl.FullDate,
    datepart(dw,dl.FullDate) as DayNumberOfWeek,
    datename(weekday,dl.FullDate) as EnglishDayNameOfWeek,
    
    
    datepart(d,dl.FullDate) as DayNumberOfMonth,
    datepart(dy,dl.FullDate) as DayNumberOfYear,
    datepart(wk, dl.FUllDate) as WeekNumberOfYear,
    datename(MONTH,dl.FullDate) as EnglishMonthName,
   
   
    Month(dl.FullDate) as CalendarMonth,
    datepart(qq, dl.FullDate) as CalendarQuarter,
    year(dl.FullDate) as CalendarYear,
    case datepart(qq, dl.FullDate)
        when 1 then 1
        when 2 then 1
        when 3 then 2
        when 4 then 2
    end as CalendarSemester,
    case datepart(qq, dl.FullDate)
        when 1 then 3
        when 2 then 4
        when 3 then 1
        when 4 then 2
    end as FiscalQuarter,
	case datepart(qq, dl.FullDate)
        when 1 then 7
        when 2 then 8
        when 3 then 9
        when 4 then 10
		when 5 then 11
        when 6 then 12
        when 7 then 1
        when 8 then 2
		when 9 then 3
        when 10 then 4
        when 11 then 5
        when 12 then 6
    end as FiscalMonth, -- TODO
    case datepart(qq, dl.FullDate)
        when 1 then year(dl.FullDate)
        when 2 then year(dl.FullDate)
        when 3 then year(dl.FullDate) + 1
        when 4 then year(dl.FullDate) + 1
    end as FiscalYear,
    case datepart(qq, dl.FullDate)
        when 1 then 2
        when 2 then 2
        when 3 then 1
        when 4 then 1
    end as FiscalSemester

from @datelist dl left join 
    DimDate dd 
        on dl.FullDate = dd.FullDateAlternateKey
Where dd.FullDateAlternateKey is null 
End')
GO

---- Refreshed_Product PROCEDURE
CREATE PROCEDURE Refreshed_Product
AS
BEGIN
DECLARE @table TABLE(
   RowId INT PRIMARY KEY IDENTITY(1, 1),
   ForeignKeyConstraintName NVARCHAR(200),
   ForeignKeyConstraintTableSchema NVARCHAR(200),
   ForeignKeyConstraintTableName NVARCHAR(200),
   ForeignKeyConstraintColumnName NVARCHAR(200),
   PrimaryKeyConstraintName NVARCHAR(200),
   PrimaryKeyConstraintTableSchema NVARCHAR(200),
   PrimaryKeyConstraintTableName NVARCHAR(200),
   PrimaryKeyConstraintColumnName NVARCHAR(200)    
);

INSERT INTO @table(ForeignKeyConstraintName, ForeignKeyConstraintTableSchema, ForeignKeyConstraintTableName, ForeignKeyConstraintColumnName)
SELECT 
   U.CONSTRAINT_NAME, 
   U.TABLE_SCHEMA, 
   U.TABLE_NAME, 
   U.COLUMN_NAME 
FROM 
   INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
         ON U.CONSTRAINT_NAME = C.CONSTRAINT_NAME
WHERE
   C.CONSTRAINT_TYPE = 'FOREIGN KEY';

UPDATE @table SET
   PrimaryKeyConstraintName = UNIQUE_CONSTRAINT_NAME
FROM 
   @table T
      INNER JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS R
         ON T.ForeignKeyConstraintName = R.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintTableSchema  = TABLE_SCHEMA,
   PrimaryKeyConstraintTableName  = TABLE_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
      ON T.PrimaryKeyConstraintName = C.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintColumnName = COLUMN_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      ON T.PrimaryKeyConstraintName = U.CONSTRAINT_NAME;

-- SELECT * FROM @table

--DROP CONSTRAINT:
DECLARE @sql NVARCHAR(MAX) = '';
SELECT
   @sql += '
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   DROP CONSTRAINT ' + ForeignKeyConstraintName + ';'
FROM
   @table;

-- PRINT @sql
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @sql;

--======== driver here====
TRUNCATE TABLE dbo.DimProduct;
INSERT INTO dbo.DimProduct(ProductID,[Name], [Product Identification Number], [Line Description], [Class Description], [Style Description], [Category Description],  [Subcategory Description])
SELECT 
	ProductId,
	P.Name AS Name,
	ProductNumber,
	CASE 
		WHEN ProductLine = 'R' THEN 'Road'
		WHEN ProductLine = 'M' THEN 'Mountain'
		WHEN ProductLine = 'T' THEN 'Touring'
		WHEN ProductLine = 'S' THEN 'Standard'
		ELSE 'Unknown'
	END AS [Product Identification Number],
	CASE 
		WHEN Class = 'H' THEN 'High'
		WHEN Class = 'L' THEN 'Medium'
		WHEN Class = 'M' THEN 'Low'
		ELSE 'Unknown'
	END AS [Class Description],
	CASE 
		WHEN Class = 'W' THEN 'Womens'
		WHEN Class = 'M' THEN 'Mens'
		WHEN Class = 'U' THEN 'Universal'
		ELSE 'Unknown'
	END AS [Style Description],
	ISNULL(C.Name, 'Unknown') AS Category,
	ISNULL(SC.Name, 'Unknown') AS Subcategory
FROM CO4031_Staging.Product.Product  AS P
LEFT JOIN CO4031_Staging.Product.ProductSubcategory AS SC
ON SC.ProductSubcategoryID = P.ProductSubcategoryID
LEFT JOIN CO4031_Staging.Product.ProductCategory AS C
ON C.ProductCategoryID = SC.ProductCategoryID
;


DECLARE @SQL_RECREATE NVARCHAR(MAX) = ''
--ADD CONSTRAINT:
SELECT
   @SQL_RECREATE+='
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   ADD CONSTRAINT ' + ForeignKeyConstraintName + ' FOREIGN KEY(' + ForeignKeyConstraintColumnName + ') REFERENCES [' + PrimaryKeyConstraintTableSchema + '].[' + PrimaryKeyConstraintTableName + '](' + PrimaryKeyConstraintColumnName + ');'
FROM
   @table;

-- PRINT @SQL_RECREATE
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @SQL_RECREATE;

END
GO

---- Refreshed_SalesTerritory
CREATE PROCEDURE Refreshed_SalesTerritory
AS
BEGIN
DECLARE @table TABLE(
   RowId INT PRIMARY KEY IDENTITY(1, 1),
   ForeignKeyConstraintName NVARCHAR(200),
   ForeignKeyConstraintTableSchema NVARCHAR(200),
   ForeignKeyConstraintTableName NVARCHAR(200),
   ForeignKeyConstraintColumnName NVARCHAR(200),
   PrimaryKeyConstraintName NVARCHAR(200),
   PrimaryKeyConstraintTableSchema NVARCHAR(200),
   PrimaryKeyConstraintTableName NVARCHAR(200),
   PrimaryKeyConstraintColumnName NVARCHAR(200)    
);

INSERT INTO @table(ForeignKeyConstraintName, ForeignKeyConstraintTableSchema, ForeignKeyConstraintTableName, ForeignKeyConstraintColumnName)
SELECT 
   U.CONSTRAINT_NAME, 
   U.TABLE_SCHEMA, 
   U.TABLE_NAME, 
   U.COLUMN_NAME 
FROM 
   INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
         ON U.CONSTRAINT_NAME = C.CONSTRAINT_NAME
WHERE
   C.CONSTRAINT_TYPE = 'FOREIGN KEY';

UPDATE @table SET
   PrimaryKeyConstraintName = UNIQUE_CONSTRAINT_NAME
FROM 
   @table T
      INNER JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS R
         ON T.ForeignKeyConstraintName = R.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintTableSchema  = TABLE_SCHEMA,
   PrimaryKeyConstraintTableName  = TABLE_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
      ON T.PrimaryKeyConstraintName = C.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintColumnName = COLUMN_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      ON T.PrimaryKeyConstraintName = U.CONSTRAINT_NAME;

-- SELECT * FROM @table

--DROP CONSTRAINT:
DECLARE @sql NVARCHAR(MAX) = '';
SELECT
   @sql += '
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   DROP CONSTRAINT ' + ForeignKeyConstraintName + ';'
FROM
   @table;

-- PRINT @sql
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @sql;

--======== driver here====
TRUNCATE TABLE dbo.DimSalesTerritory;
INSERT INTO dbo.DimSalesTerritory
SELECT TerritoryID,
	ST.[Name],
	CR.[Name],
	[Group]
FROM CO4031_Staging.Sales.SalesTerritory AS ST
LEFT JOIN CO4031_Staging.Person.CountryRegion AS CR
ON ST.CountryRegionCode = CR.CountryRegionCode
;

DECLARE @SQL_RECREATE NVARCHAR(MAX) = ''
--ADD CONSTRAINT:
SELECT
   @SQL_RECREATE+='
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   ADD CONSTRAINT ' + ForeignKeyConstraintName + ' FOREIGN KEY(' + ForeignKeyConstraintColumnName + ') REFERENCES [' + PrimaryKeyConstraintTableSchema + '].[' + PrimaryKeyConstraintTableName + '](' + PrimaryKeyConstraintColumnName + ');'
FROM
   @table;

-- PRINT @SQL_RECREATE
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @SQL_RECREATE;

END
GO

--
---- Refreshed_SalesTerritory
CREATE PROCEDURE Refreshed_StateProvince
AS
BEGIN
DECLARE @table TABLE(
   RowId INT PRIMARY KEY IDENTITY(1, 1),
   ForeignKeyConstraintName NVARCHAR(200),
   ForeignKeyConstraintTableSchema NVARCHAR(200),
   ForeignKeyConstraintTableName NVARCHAR(200),
   ForeignKeyConstraintColumnName NVARCHAR(200),
   PrimaryKeyConstraintName NVARCHAR(200),
   PrimaryKeyConstraintTableSchema NVARCHAR(200),
   PrimaryKeyConstraintTableName NVARCHAR(200),
   PrimaryKeyConstraintColumnName NVARCHAR(200)    
);

INSERT INTO @table(ForeignKeyConstraintName, ForeignKeyConstraintTableSchema, ForeignKeyConstraintTableName, ForeignKeyConstraintColumnName)
SELECT 
   U.CONSTRAINT_NAME, 
   U.TABLE_SCHEMA, 
   U.TABLE_NAME, 
   U.COLUMN_NAME 
FROM 
   INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
         ON U.CONSTRAINT_NAME = C.CONSTRAINT_NAME
WHERE
   C.CONSTRAINT_TYPE = 'FOREIGN KEY';

UPDATE @table SET
   PrimaryKeyConstraintName = UNIQUE_CONSTRAINT_NAME
FROM 
   @table T
      INNER JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS R
         ON T.ForeignKeyConstraintName = R.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintTableSchema  = TABLE_SCHEMA,
   PrimaryKeyConstraintTableName  = TABLE_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
      ON T.PrimaryKeyConstraintName = C.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintColumnName = COLUMN_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      ON T.PrimaryKeyConstraintName = U.CONSTRAINT_NAME;

-- SELECT * FROM @table

--DROP CONSTRAINT:
DECLARE @sql NVARCHAR(MAX) = '';
SELECT
   @sql += '
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   DROP CONSTRAINT ' + ForeignKeyConstraintName + ';'
FROM
   @table;

-- PRINT @sql
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @sql;

--======== driver here====
TRUNCATE TABLE dbo.DimStateProvince;
INSERT INTO dbo.DimStateProvince
SELECT StateProvinceID
	, StateProvinceCode
	,SP.[Name] AS StateProvinceName
	,CR.[Name] AS CountryRegion
	, TerritoryID
FROM CO4031_Staging.Person.StateProvince AS SP
LEFT JOIN  CO4031_Staging.Person.CountryRegion AS CR
ON SP.CountryRegionCode = CR.CountryRegionCode

DECLARE @SQL_RECREATE NVARCHAR(MAX) = ''
--ADD CONSTRAINT:
SELECT
   @SQL_RECREATE+='
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   ADD CONSTRAINT ' + ForeignKeyConstraintName + ' FOREIGN KEY(' + ForeignKeyConstraintColumnName + ') REFERENCES [' + PrimaryKeyConstraintTableSchema + '].[' + PrimaryKeyConstraintTableName + '](' + PrimaryKeyConstraintColumnName + ');'
FROM
   @table;

-- PRINT @SQL_RECREATE
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @SQL_RECREATE;

END
GO

---- Refreshed_InvidualCustomer
CREATE PROCEDURE Refreshed_InvidualCustomer
AS
BEGIN
DECLARE @table TABLE(
   RowId INT PRIMARY KEY IDENTITY(1, 1),
   ForeignKeyConstraintName NVARCHAR(200),
   ForeignKeyConstraintTableSchema NVARCHAR(200),
   ForeignKeyConstraintTableName NVARCHAR(200),
   ForeignKeyConstraintColumnName NVARCHAR(200),
   PrimaryKeyConstraintName NVARCHAR(200),
   PrimaryKeyConstraintTableSchema NVARCHAR(200),
   PrimaryKeyConstraintTableName NVARCHAR(200),
   PrimaryKeyConstraintColumnName NVARCHAR(200)    
);

INSERT INTO @table(ForeignKeyConstraintName, ForeignKeyConstraintTableSchema, ForeignKeyConstraintTableName, ForeignKeyConstraintColumnName)
SELECT 
   U.CONSTRAINT_NAME, 
   U.TABLE_SCHEMA, 
   U.TABLE_NAME, 
   U.COLUMN_NAME 
FROM 
   INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
         ON U.CONSTRAINT_NAME = C.CONSTRAINT_NAME
WHERE
   C.CONSTRAINT_TYPE = 'FOREIGN KEY';

UPDATE @table SET
   PrimaryKeyConstraintName = UNIQUE_CONSTRAINT_NAME
FROM 
   @table T
      INNER JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS R
         ON T.ForeignKeyConstraintName = R.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintTableSchema  = TABLE_SCHEMA,
   PrimaryKeyConstraintTableName  = TABLE_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
      ON T.PrimaryKeyConstraintName = C.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintColumnName = COLUMN_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      ON T.PrimaryKeyConstraintName = U.CONSTRAINT_NAME;

-- SELECT * FROM @table

--DROP CONSTRAINT:
DECLARE @sql NVARCHAR(MAX) = '';
SELECT
   @sql += '
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   DROP CONSTRAINT ' + ForeignKeyConstraintName + ';'
FROM
   @table;

-- PRINT @sql
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @sql;

--======== driver here====
TRUNCATE TABLE dbo.DimIndividualCustomer;
WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey' AS ns)
INSERT INTO dbo.DimIndividualCustomer(
	BusinessEntityID,
    FullName, -- Tính từ FirstName + MiddleName + LastName
	Gender,
	DateOfFirstPurcharse,
	Occupation,
	[House Owner Indicator],
	[Level of Education],
	[Yearly income range],
	[Cars owned],
	[Marital Status],
	[Total Children],
	[Children at home]
)
SELECT 
	P.BusinessEntityID,
	CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS FullName,
	Demographics.value('(/ns:IndividualSurvey/ns:Gender)[1]', 'nvarchar(2)') AS gender,
	Demographics.value('(/ns:IndividualSurvey/ns:DateFirstPurchase)[1]', 'Date') AS date_first_purchase,
	Demographics.value('(/ns:IndividualSurvey/ns:Occupation)[1]', 'varchar(50)') AS occupation,
	Demographics.value('(/ns:IndividualSurvey/ns:HomeOwnerFlag)[1]', 'int') AS home_owner_flag,
	Demographics.value('(/ns:IndividualSurvey/ns:Education)[1]', 'varchar(50)') AS education
	, Demographics.value('(/ns:IndividualSurvey/ns:YearlyIncome)[1]', 'nvarchar(50)') AS yearly_income
	, Demographics.value('(/ns:IndividualSurvey/ns:NumberCarsOwned)[1]', 'int') AS no_cars_owned
	, Demographics.value('(/ns:IndividualSurvey/ns:MaritalStatus)[1]', 'nvarchar(50)') AS marital_status
	, Demographics.value('(/ns:IndividualSurvey/ns:TotalChildren)[1]', 'int') AS total_children
	, Demographics.value('(/ns:IndividualSurvey/ns:NumberChildrenAtHome)[1]', 'int') AS no_children_at_home
	--Demographics.value('(/ns:IndividualSurvey/ns:TotalPurchaseYTD)[1]', 'money') AS total_purchase_ytd,
	--Demographics.value('(/ns:IndividualSurvey/ns:BirthDate)[1]', 'Date') AS birth_date,
FROM CO4031_Staging.Person.Person AS P
JOIN CO4031_Staging.Sales.Customer AS C
ON C.PersonID = P.BusinessEntityID
WHERE StoreID is null 

DECLARE @SQL_RECREATE NVARCHAR(MAX) = ''
--ADD CONSTRAINT:
SELECT
   @SQL_RECREATE+='
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   ADD CONSTRAINT ' + ForeignKeyConstraintName + ' FOREIGN KEY(' + ForeignKeyConstraintColumnName + ') REFERENCES [' + PrimaryKeyConstraintTableSchema + '].[' + PrimaryKeyConstraintTableName + '](' + PrimaryKeyConstraintColumnName + ');'
FROM
   @table;

-- PRINT @SQL_RECREATE
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @SQL_RECREATE;

END
GO
---- Refreshed_StoreCustomer
CREATE PROCEDURE Refreshed_StoreCustomer
AS
BEGIN
DECLARE @table TABLE(
   RowId INT PRIMARY KEY IDENTITY(1, 1),
   ForeignKeyConstraintName NVARCHAR(200),
   ForeignKeyConstraintTableSchema NVARCHAR(200),
   ForeignKeyConstraintTableName NVARCHAR(200),
   ForeignKeyConstraintColumnName NVARCHAR(200),
   PrimaryKeyConstraintName NVARCHAR(200),
   PrimaryKeyConstraintTableSchema NVARCHAR(200),
   PrimaryKeyConstraintTableName NVARCHAR(200),
   PrimaryKeyConstraintColumnName NVARCHAR(200)    
);

INSERT INTO @table(ForeignKeyConstraintName, ForeignKeyConstraintTableSchema, ForeignKeyConstraintTableName, ForeignKeyConstraintColumnName)
SELECT 
   U.CONSTRAINT_NAME, 
   U.TABLE_SCHEMA, 
   U.TABLE_NAME, 
   U.COLUMN_NAME 
FROM 
   INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
         ON U.CONSTRAINT_NAME = C.CONSTRAINT_NAME
WHERE
   C.CONSTRAINT_TYPE = 'FOREIGN KEY';

UPDATE @table SET
   PrimaryKeyConstraintName = UNIQUE_CONSTRAINT_NAME
FROM 
   @table T
      INNER JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS R
         ON T.ForeignKeyConstraintName = R.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintTableSchema  = TABLE_SCHEMA,
   PrimaryKeyConstraintTableName  = TABLE_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
      ON T.PrimaryKeyConstraintName = C.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintColumnName = COLUMN_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      ON T.PrimaryKeyConstraintName = U.CONSTRAINT_NAME;

-- SELECT * FROM @table

--DROP CONSTRAINT:
DECLARE @sql NVARCHAR(MAX) = '';
SELECT
   @sql += '
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   DROP CONSTRAINT ' + ForeignKeyConstraintName + ';'
FROM
   @table;

-- PRINT @sql
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @sql;

--======== driver here====
TRUNCATE TABLE DimStoreCustomer;
INSERT INTO DimStoreCustomer (
	 BusinessEntityID, [Store Name], [Sales Volume], [Revenue], -- Tính từ AnnualRevenue
	[StoreType],[YearOpened], [Specialty],[SquareFeet], [NumberOfEmployees]
)
SELECT 
    customer.StoreID
	,s.[Name] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/AnnualSales)[1]', 'money') AS [AnnualSales] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/AnnualRevenue)[1]', 'money') AS [AnnualRevenue] 
	,  CASE 
		WHEN s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') = 'BM' THEN 'Bicycle Manufacturer'
		WHEN s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') = 'BS' THEN 'Bicycle Store'
		WHEN s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') = 'OS' THEN 'Online Store'
		WHEN s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') = 'SGS' THEN 'Sporting Goods Store'
		WHEN s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') = 'D' THEN 'Discount Store'
		ELSE 'Unknown' -- If you have other values that you don't want to change
	END AS [BusinessType]
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/YearOpened)[1]', 'integer') AS [YearOpened] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/Specialty)[1]', 'nvarchar(50)') AS [Specialty] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/SquareFeet)[1]', 'integer') AS [SquareFeet] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/NumberEmployees)[1]', 'integer') AS [NumberEmployees] 
FROM CO4031_Staging.Sales.Customer customer
LEFT JOIN 
	CO4031_Staging.[Sales].[Store] s
ON customer.StoreID = s.BusinessEntityID
WHERE customer.PersonID is null

DECLARE @SQL_RECREATE NVARCHAR(MAX) = ''
--ADD CONSTRAINT:
SELECT
   @SQL_RECREATE+='
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   ADD CONSTRAINT ' + ForeignKeyConstraintName + ' FOREIGN KEY(' + ForeignKeyConstraintColumnName + ') REFERENCES [' + PrimaryKeyConstraintTableSchema + '].[' + PrimaryKeyConstraintTableName + '](' + PrimaryKeyConstraintColumnName + ');'
FROM
   @table;

-- PRINT @SQL_RECREATE
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @SQL_RECREATE;

END
GO

---- Refreshed_SalesTerritory
CREATE PROCEDURE Refreshed_FactSales
AS
BEGIN
DECLARE @table TABLE(
   RowId INT PRIMARY KEY IDENTITY(1, 1),
   ForeignKeyConstraintName NVARCHAR(200),
   ForeignKeyConstraintTableSchema NVARCHAR(200),
   ForeignKeyConstraintTableName NVARCHAR(200),
   ForeignKeyConstraintColumnName NVARCHAR(200),
   PrimaryKeyConstraintName NVARCHAR(200),
   PrimaryKeyConstraintTableSchema NVARCHAR(200),
   PrimaryKeyConstraintTableName NVARCHAR(200),
   PrimaryKeyConstraintColumnName NVARCHAR(200)    
);

INSERT INTO @table(ForeignKeyConstraintName, ForeignKeyConstraintTableSchema, ForeignKeyConstraintTableName, ForeignKeyConstraintColumnName)
SELECT 
   U.CONSTRAINT_NAME, 
   U.TABLE_SCHEMA, 
   U.TABLE_NAME, 
   U.COLUMN_NAME 
FROM 
   INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
         ON U.CONSTRAINT_NAME = C.CONSTRAINT_NAME
WHERE
   C.CONSTRAINT_TYPE = 'FOREIGN KEY';

UPDATE @table SET
   PrimaryKeyConstraintName = UNIQUE_CONSTRAINT_NAME
FROM 
   @table T
      INNER JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS R
         ON T.ForeignKeyConstraintName = R.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintTableSchema  = TABLE_SCHEMA,
   PrimaryKeyConstraintTableName  = TABLE_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS C
      ON T.PrimaryKeyConstraintName = C.CONSTRAINT_NAME;

UPDATE @table SET
   PrimaryKeyConstraintColumnName = COLUMN_NAME
FROM @table T
   INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE U
      ON T.PrimaryKeyConstraintName = U.CONSTRAINT_NAME;

-- SELECT * FROM @table

--DROP CONSTRAINT:
DECLARE @sql NVARCHAR(MAX) = '';
SELECT
   @sql += '
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   DROP CONSTRAINT ' + ForeignKeyConstraintName + ';'
FROM
   @table;

-- PRINT @sql
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @sql;

--======== driver here====
TRUNCATE TABLE FactSales;
INSERT INTO dbo.FactSales(
	SalesOrderID, ProductKey, OrderDateKey, DueDateKey, ShipDateKey,
	IndividualCustomerKey, StoreCustomerKey,SalesTerritoryKey, SalesOrderNumber
	, [Changes to Order]
	, [Sales Product Quantity], [Sales Subtotal Amount], [Sales TotalDue Amount])
SELECT 
	SOH.SalesOrderId
	, SOD.ProductID
	, SOH.OrderDate
	, SOH.DueDate
	, SOH.ShipDate
	,  
	CASE 
		WHEN Customer.StoreID IS NULL THEN Customer.PersonID
		ELSE NULL
	END AS PersonID,
	Customer.StoreID  AS StoreID
	,SOH.TerritoryID
	, SOH.SalesOrderNumber
	, RevisionNumber
	,OrderQty
	,SubTotal
	,TotalDue
-- SELECT *
FROM CO4031_Staging.Sales.SalesOrderHeader AS SOH
INNER JOIN CO4031_Staging.Sales.SalesOrderDetail As SOD ON SOH.SalesOrderId = SOD.SalesOrderID
LEFT JOIN  CO4031_Staging.Sales.Customer AS Customer  ON SOH.CustomerID = Customer.CustomerID
LEFT JOIN CO4031_Staging.Sales.Store AS Store ON Customer.StoreID = Store.BusinessEntityID 
LEFT JOIN CO4031_Staging.Person.Person AS Individual ON Customer.PersonID =  Individual.BusinessEntityID
where 
 	UnitPrice is NOT null and UnitPrice >= 0 and
	LineTotal >= 0 and 
	TotalDue >=0 and
	OrderQty >= 0 and OrderQty is NOT null 
;

SELECT COUNT(*) FROM CO4031_Staging.Sales.SalesOrderHeader
JOIN  CO4031_Staging.Sales.SalesOrderDetail
ON CO4031_Staging.Sales.SalesOrderHeader.SalesOrderId = CO4031_Staging.Sales.SalesOrderDetail.SalesOrderID

DECLARE @SQL_RECREATE NVARCHAR(MAX) = ''
--ADD CONSTRAINT:
SELECT
   @SQL_RECREATE+='
   ALTER TABLE [' + ForeignKeyConstraintTableSchema + '].[' + ForeignKeyConstraintTableName + '] 
   ADD CONSTRAINT ' + ForeignKeyConstraintName + ' FOREIGN KEY(' + ForeignKeyConstraintColumnName + ') REFERENCES [' + PrimaryKeyConstraintTableSchema + '].[' + PrimaryKeyConstraintTableName + '](' + PrimaryKeyConstraintColumnName + ');'
FROM
   @table;

-- PRINT @SQL_RECREATE
-- Execute the DROP CONSTRAINT statements
EXEC sp_executesql @SQL_RECREATE;

END
GO