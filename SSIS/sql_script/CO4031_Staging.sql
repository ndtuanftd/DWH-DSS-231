USE [master]
GO
/****** Object:  Database [CO4031_Staging]    Script Date: 18/11/2023 ******/
CREATE DATABASE [CO4031_Staging]

USE [CO4031_Staging]
GO


/****** Object:  Schema [Person]    Script Date: 25-09-2021 13:26:13 ******/
CREATE SCHEMA [Person]
GO

/****** Object:  Schema [Product]    Script Date: 25-09-2021 13:26:13 ******/
CREATE SCHEMA [Product]
GO

/****** Object:  Schema [Sales]    Script Date: 25-09-2021 13:26:13 ******/
CREATE SCHEMA [Sales]	
GO



/**/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[Business_Entity](
	[ModifiedDate] [datetime] NULL,
	[BusinessEntityID] [int] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [Person].[Person]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Person].[Person](
	[BusinessEntityID] [int] NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] [bit] NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL,
	[AdditionalContactInfo] [xml] NULL,
	[Demographics] [xml] NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
)
GO

--ALTER TABLE [Person].[Person] ADD  CONSTRAINT [DF_Person_NameStyle]  DEFAULT ((0)) FOR [NameStyle]
--GO

--ALTER TABLE [Person].[Person] ADD  CONSTRAINT [DF_Person_EmailPromotion]  DEFAULT ((0)) FOR [EmailPromotion]
--GO

--ALTER TABLE [Person].[Person] ADD  CONSTRAINT [DF_Person_rowguid]  DEFAULT (newid()) FOR [rowguid]
--GO

--ALTER TABLE [Person].[Person] ADD  CONSTRAINT [DF_Person_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
--GO

--ALTER TABLE [Person].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID] FOREIGN KEY([BusinessEntityID])
--REFERENCES [Person].[BusinessEntity] ([BusinessEntityID])
--GO

--ALTER TABLE [Person].[Person] CHECK CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID]
--GO

--ALTER TABLE [Person].[Person]  WITH CHECK ADD  CONSTRAINT [CK_Person_EmailPromotion] CHECK  (([EmailPromotion]>=(0) AND [EmailPromotion]<=(2)))
--GO

--ALTER TABLE [Person].[Person] CHECK CONSTRAINT [CK_Person_EmailPromotion]
--GO

--ALTER TABLE [Person].[Person]  WITH CHECK ADD  CONSTRAINT [CK_Person_PersonType] CHECK  (([PersonType] IS NULL OR (upper([PersonType])='GC' OR upper([PersonType])='SP' OR upper([PersonType])='EM' OR upper([PersonType])='IN' OR upper([PersonType])='VC' OR upper([PersonType])='SC')))
--GO

--ALTER TABLE [Person].[Person] CHECK CONSTRAINT [CK_Person_PersonType]
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key for Person records.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'BusinessEntityID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'PersonType'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = The data in FirstName and LastName are stored in western style (first name, last name) order.  1 = Eastern style (last name, first name) order.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'NameStyle'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 0' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'CONSTRAINT',@level2name=N'DF_Person_NameStyle'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A courtesy title. For example, Mr. or Ms.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Title'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'First name of the person.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'FirstName'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Middle name or middle initial of the person.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'MiddleName'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last name of the person.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'LastName'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Surname suffix. For example, Sr. or Jr.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Suffix'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 = Contact does not wish to receive e-mail promotions, 1 = Contact does wish to receive e-mail promotions from AdventureWorks, 2 = Contact does wish to receive e-mail promotions from AdventureWorks and selected partners. ' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'EmailPromotion'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of 0' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'CONSTRAINT',@level2name=N'DF_Person_EmailPromotion'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Additional contact information about the person stored in xml format. ' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'AdditionalContactInfo'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Personal information such as hobbies, and income collected from online shoppers. Used for sales analysis.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'Demographics'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'rowguid'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of NEWID()' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'CONSTRAINT',@level2name=N'DF_Person_rowguid'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date and time the record was last updated.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default constraint value of GETDATE()' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'CONSTRAINT',@level2name=N'DF_Person_ModifiedDate'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Primary key (clustered) constraint' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'CONSTRAINT',@level2name=N'PK_Person_BusinessEntityID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Human beings involved with AdventureWorks: employees, customer contacts, and vendor contacts.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign key constraint referencing BusinessEntity.BusinessEntityID.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'CONSTRAINT',@level2name=N'FK_Person_BusinessEntity_BusinessEntityID'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [EmailPromotion] >= (0) AND [EmailPromotion] <= (2)' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'CONSTRAINT',@level2name=N'CK_Person_EmailPromotion'
--GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Check constraint [PersonType] is one of SC, VC, IN, EM or SP.' , @level0type=N'SCHEMA',@level0name=N'Person', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'CONSTRAINT',@level2name=N'CK_Person_PersonType'
--GO





/****** Object:  Table [Person].[Address]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[Address](
	[BusinessEntityID] [int] NULL,
	[AddressID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[AddressLine1] [nvarchar](60) NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](30) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[StateProvinceID] [int] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Person].[AddressType]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[AddressType](
	[AddressTypeID] [int] NULL,
	[BusinessEntityID] [int] NULL,
	[Name] [nvarchar](50) NULL,
	
	[ModifiedDate] [datetime] NULL,
) ON [PRIMARY]
GO

/****** Object:  Table [Person].[CountryRegion]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[CountryRegion](
	[CountryRegionCode] [nvarchar](3) NULL,
	[Name] [nvarchar](50) NULL,
	
	[ModifiedDate] [datetime] NULL,
) ON [PRIMARY]
GO


/****** Object:  Table [Person].[StateProvince]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[StateProvince](
	[StateProvinceID] [int] NULL,
	[StateProvinceCode] [nvarchar](3) NULL,
	[CountryRegionCode] [nvarchar](3) NULL,
	[IsOnlyStateProvinceFlag] [tinyint] NULL,
	[Name] [nvarchar](50) NULL,
	[TerritoryID] [int] NULL,
	
	[ModifiedDate] [datetime] NULL,
) ON [PRIMARY]
GO


/****** Object:  Table [Product].[Product]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Product].[Product](
	[ProductID] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[ProductNumber] [nvarchar](25) NULL,
	[MakeFlag] [bit] NULL,
	[FinishedGoodsFlag] [bit] NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NULL,
	[ReorderPoint] [smallint] NULL,
	[StandardCost] [money] NULL,
	[ListPrice] [money] NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nvarchar](3) NULL,
	[WeightUnitMeasureCode] [nvarchar](3) NULL,
	[Weight] [numeric](8, 2) NULL,
	[DaysToManufacture] [int] NULL,
	[ProductLine] [nvarchar](2) NULL,
	[Class] [nvarchar](2) NULL,
	[Style] [nvarchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [int] NULL,
	[SellEndDate] [int] NULL,
	[DiscontinuedDate] [datetime] NULL,
	
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO


/****** Object:  Table [Product].[ProductSubCategory]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Product].[ProductSubCategory](
	[ProductSubcategoryID] [int] NULL,
	[ProductCategoryID] [int] NULL,
	[Name] [nvarchar](50) NULL
) ON [PRIMARY]

GO


/****** Object:  Table [Product].[ProductSubCategory]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Product].[ProductModel](
	[ProductModelID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CatalogDescription] [nvarchar](max) NULL,
	[Instructions] [nvarchar](max) NULL,
	
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [Product].[ProductSubCategory]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Product].[ProductCategory](
	[ProductCategoryID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [Product].[ProductSubCategory]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Product].[Culture](
	[CultureID] [nvarchar](6) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [Product].[ProductSubCategory]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Product].[ProductModelProductDescriptionCulture](
	[ProductModelID] [int] NOT NULL,
	[ProductDescriptionID] [int] NOT NULL,
	[CultureID] [nvarchar](6) NOT NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]

GO



/****** Object:  Table [Sales].[Customer]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Sales].[Customer](
	[CustomerID] [int] NULL,
	[PersonID] [int] NULL,
	[StoreID] [int] NULL,
	[TerritoryID] [int] NULL,
	[AccountNumber] [varchar](10) NULL,
	
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [Sales].[Store]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[Store](
	
	[ModifiedDate] [datetime] NULL,
	[Name] [nvarchar](50) NULL,
	[Demographics] [xml] NULL,
	[BusinessEntityID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [erp].[SalesTerritory]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[SalesTerritory](
	[TerritoryID] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[CountryRegionCode] [nvarchar](3) NULL,
	[Group] [nvarchar](50) NULL
) ON [PRIMARY]

GO


/****** Object:  Table [erp].[SalesTerritoryHistory]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[SalesTerritoryHistory](
	[BusinessEntityID] [int] NULL,
	[TerritoryID] [int] NULL,
	[StartDate] [int] NULL,
	[EndDate] [int] NULL,
	
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [erp].[SalesOrderHeader]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[SalesOrderHeader](
	[SalesOrderId] [int] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [int] NOT NULL, --
	[DueDate] [int] NULL,
	[ShipDate] [int] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag] [bit] NOT NULL,
	[SalesOrderNumber] [nvarchar](25) NOT NULL,
	[PurchaseOrderNumber] [nvarchar](25) NULL,
	[AccountNumber] [nvarchar](15) NULL,
	[CustomerID] [int] NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NULL,
	[ShipToAddressID] [int] NULL,
	[ShipMethodID] [int] NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NULL,
	[TaxAmt] [money] NULL,
	[Feight] [money] NULL,
	[TotalDue] [money] NULL,
	[Comment] [nvarchar](128),
	
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO




/****** Object:  Table [Sales].[SalesOrderDetail]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[SpecialOffer](
	[SpecialOfferID] [int] NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[DiscountPct] [smallmoney] NOT NULL,
	[Type] [nvarchar](50) NOT NULL ,
	[Category] [nvarchar](50) NOT NULL ,
	[StartDate] [int] NOT NULL,
	[EndDate] [int] NULL,
	[MinQty] [int] NOT NULL,
	[MazQty] [int] NULL,
	[rowguid] [uniqueidentifier] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO



/****** Object:  Table [Sales].[SalesOrderDetail]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[SpecialOfferProduct](
	[SpecialOfferID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[rowguid] [uniqueidentifier] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO



/****** Object:  Table [Sales].[SalesOrderDetail]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[SalesOrderDetail](
	[SalesOrderID] [int] NULL,
	[SalesOrderDetailID] [int] NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[OrderQty] [smallint] NULL,
	[ProductID] [int] NULL,
	[SpecialOfferID] [int] NULL,
	[UnitPrice] [money] NULL,
	[UnitPriceDiscount] [money] NULL,
	[LineTotal] [numeric](38, 6) NULL,
	
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO


/****** Object:  Table [Sales].[SalesOrderHeaderSalesReason]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[SalesOrderHeaderSalesReason](
	[SalesOrderID] [int] NULL,
	[SalesReasonID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO


/****** Object:  Table [Sales].[SalesReason]    Script Date: 25-09-2021 13:26:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[SalesReason](
	[SalesReasonID] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[ReasonType] [nvarchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]

GO
