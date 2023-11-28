# Data warehouse ETL pipeline 

## How to run the project
###  Create the database for staging area and data warehouse
Execute sql files respectively in `sql_script` folder,
  - `CO4031_Staging.sql`
  - `Data-Warehouse_v2.sql`


### Run ETL pipeline
1. Click on `Integration Services Project.sln` to open project,			
2.  Configure OLE DB connection manager 
	- in `Staging.dtsx` package, connect to CompanyX and Staging database,
	- in `StagingToDWH.dtsx` package, connect to Staging and Warehouse database,
3. On Controller.dtsx, right click -> Execute package

