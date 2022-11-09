/* SIMPLE EXPLORATIONS AND CLEANSING DATA */

-- For the data set, you can directly download it on the Microsoft page below
	--https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms

-- For simplicity, you can also download via the file that I uploaded on the following google driver link
   --https://drive.google.com/drive/folders/1FALkpAOmz_SODQ7O1xuT0rnQktUT3F3Y?usp=share_link
   
--The tools I use are Microsoft SQL Server Management Studio, so the datasets used are directly Restored to the application




-- Cleansed DIM_Customers Table --

WITH customer_01 as (
  SELECT 
    c.CustomerKey AS Customer_Key, 
    --      ,[GeographyKey]
    --      ,[CustomerAlternateKey]
    --      ,[Title]
    c.FirstName AS First_Name, 
    --      ,[MiddleName]
    c.LastName AS Last_Name, 
    c.FirstName + ' ' + c.LastName AS Full_Name, 
    -- Combined First and Last Name
    --      ,[NameStyle]
    --      ,[BirthDate]
    --      ,[MaritalStatus]
    --      ,[Suffix]
    c.Gender, 
    --      ,[EmailAddress]
    --      ,[YearlyIncome]
    --      ,[TotalChildren]
    --      ,[NumberChildrenAtHome]
    --      ,[EnglishEducation]
    --      ,[SpanishEducation]
    --      ,[FrenchEducation]
    --      ,[EnglishOccupation]
    --      ,[SpanishOccupation]
    --      ,[FrenchOccupation]
    --      ,[HouseOwnerFlag]
    --      ,[NumberCarsOwned]
    --      ,[AddressLine1]
    --      ,[AddressLine2]
    --      ,[Phone]
    c.DateFirstPurchase AS Date_First_Purchase, 
    --      ,[CommuteDistance]
    g.City AS Customer_City -- Joined in Customer City from Geography Table
  FROM 
    [AdventureWorksDW2019].dbo.DimCustomer as c 
    LEFT JOIN [AdventureWorksDW2019].dbo.dimgeography AS g ON g.GeographyKey = c.GeographyKey
), 


customer_02 as (
  select 
    Customer_Key, 
    First_name, 
    Last_name, 
    Full_name, 
    case when Gender = 'M' then 'Male' when Gender = 'F' then 'Female' end as Gender, 
    Date_First_Purchase, 
    Customer_City 
  from 
    customer_01
) 

select 
  * 
from 
  customer_02;








  -- Cleansed DIM_Date Table --

SELECT 
  [DateKey], 
  [FullDateAlternateKey] AS Date, 
  --[DayNumberOfWeek], 
  [EnglishDayNameOfWeek] AS Day, 
  --[SpanishDayNameOfWeek], 
  --[FrenchDayNameOfWeek], 
  --[DayNumberOfMonth], 
  --[DayNumberOfYear], 
  --[WeekNumberOfYear],
  [EnglishMonthName] AS Month, 
 LEFT([EnglishMonthName],3) as Month_Short,   
  --[SpanishMonthName], 
  --[FrenchMonthName], 
  [MonthNumberOfYear] AS Month_No, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS Year 
  --[CalendarSemester], 
  --[FiscalQuarter], 
  --[FiscalYear], 
  --[FiscalSemester] 
FROM 
 [AdventureWorksDW2019].[dbo].[DimDate]
WHERE CalendarYear >= 2019;







-- Cleansed DIM_Products Table --

WITH product_01 as (
  SELECT 
    p.ProductKey, 
    p.ProductAlternateKey as Product_Code, 
    --[ProductSubcategoryKey]
    --[WeightUnitMeasureCode]
    --[SizeUnitMeasureCode]
    p.EnglishProductName as Product_Name, 
    pc.EnglishProductCategoryName as Product_Category, 
    ps.EnglishProductSubcategoryName as Product_Subcategory, 
    --[SpanishProductName]
    --[FrenchProductName]
    --[StandardCost]
    --[FinishedGoodsFlag]
    p.Color as Product_Color, 
    --SafetyStockLevel]
    --[ReorderPoint]
    p.ListPrice as Product_Price, 
    p.Size as Product_Size, 
    --[SizeRange]
    --[Weight]
    --[DaysToManufacture]
    p.ProductLine as Product_Line, 
    --[DealerPrice]
    --[Class]
    --[Style]
    p.ModelName as Product_Model_Name, 
    --[LargePhoto]
    p.EnglishDescription as Product_Description, 
    --[FrenchDescription]
    --[ChineseDescription]
    --[ArabicDescription]
    --[HebrewDescription]
    --[ThaiDescription]
    --[GermanDescription]
    --[JapaneseDescription]
    --[TurkishDescription]
    --[StartDate]
    --[EndDate]
    p.Status as Product_Status 
  FROM 
    [AdventureWorksDW2019].[dbo].[DimProduct] as p 
    LEFT JOIN [AdventureWorksDW2019].[dbo].[DimProductCategory] as pc ON p.ProductKey = pc.ProductCategoryKey 
    LEFT JOIN [AdventureWorksDW2019].[dbo].[DimProductSubcategory] as ps ON p.ProductKey = ps.ProductSubcategoryKey
) 

product_02 as (
  select 
   ProductKey, 
    Product_Code, 
    Product_Name, 
    Product_Color, 
    Coalesce(Product_Category, Product_Subcategory), 
    Coalesce(Product_Subcategory, 'Not Available'), 
    Coalesce(Product_Price, 'Not Available'), 
    Coalesce(Product_Size, 'Not Available'), 
    Coalesce(Product_Line, 'Not Available'), 
    Coalesce(Product_Model_Name, 'Not Available'), 
    Coalesce(Product_Description, 'Not Available'), 
    Coalesce(Product_Status, 'Not Available') 
  from 
    product_01
) 

product_03 as (
  select 
    ProductKey, 
    Product_Code, 
    Product_Name, 
    CASE 
		WHEN Product_Color = 'NA' THEN 'Not Available' 
		else Product_Color 
		end, 
    Product_Category, 
    Product_Subcategory, 
    Product_Price, 
    Product_Size, 
    Product_Line, 
    Product_Model_Name, 
    Product_Description, 
    Product_Status 
  from 
    product_02
) 

select 
  * 
from 
  product_03;







-- Cleansed FactsInternetSales Table --

  SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 
  [SalesOrderNumber], 
  [SalesAmount] 
FROM 
  [dbo].[FactInternetSales]
WHERE 
	left(OrderDateKey,4)>= YEAR(GETDATE())-2		--Ensures we always only bring two years of date from extraction
ORDER BY OrderDateKey asc