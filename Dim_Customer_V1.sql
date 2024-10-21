-- Cleansed DIM_Customers Table --
SELECT 
	c.customerkey AS CustomerKey,
      --,[GeographyKey]
      --,[CustomerAlternateKey]
      --,[Title]
	c.firstname AS [Full Name],
      --,[MiddleName]
    c.lastname AS [Last Name],
	c.firstname + ' ' + lastname AS [Full Name],
      --,[NameStyle]
      --,[BirthDate]
      --,[MaritalStatus]
      --,[Suffix]
CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
      --,[EmailAddress]
      --,[YearlyIncome]
      --,[TotalChildren]
      --,[NumberChildrenAtHome]
      --,[EnglishEducation]
      --,[SpanishEducation]
      --,[FrenchEducation]
      --,[EnglishOccupation]
      --,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
      --,[NumberCarsOwned]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[Phone]
     c.datefirstpurchase AS DataFirstPurchase,
      --,[CommuteDistance]
g.city AS [Customer City] -- Joined in Customer City from Geography Table
 FROM 
	dbo.DimCustomer AS c
	LEFT JOIN dbo.DimGeography AS g ON g.geographykey = c.geographykey
ORDER BY 
	CustomerKey ASC -- ordered List by CustomerKey
 
