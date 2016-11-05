/******************************************************************************
	File: 	AMT85C_HOTFIX_20120529.sql

	
            
-------------------------------------------------------------------------------
DATE		BY	CCL		NOTES
-------------------------------------------------------------------------------
29 May 12	KN	#4201 
-------------------------------------------------------------------------------
******************************************************************************/

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_tblActualBillings_tblProjBillings')
	ALTER TABLE dbo.tblActualBillings DROP CONSTRAINT FK_tblActualBillings_tblProjBillings
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_TEST_TIME_tblProjBillings')
	ALTER TABLE dbo.TEST_TIME DROP CONSTRAINT FK_TEST_TIME_tblProjBillings
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_TEST_TIME_EVENT')
    ALTER TABLE dbo.TEST_TIME DROP CONSTRAINT FK_TEST_TIME_EVENT
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_TEST_TIME_tblCurrencies')
	ALTER TABLE dbo.TEST_TIME DROP CONSTRAINT FK_TEST_TIME_tblCurrencies
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_TEST_TIME_tblEqpProjs')
	ALTER TABLE dbo.TEST_TIME DROP CONSTRAINT FK_TEST_TIME_tblEqpProjs
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_TEST_TIME_tblExRates')
	ALTER TABLE dbo.TEST_TIME DROP CONSTRAINT FK_TEST_TIME_tblExRates
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_TEST_TIME_tblQUOMs')
	ALTER TABLE dbo.TEST_TIME DROP CONSTRAINT FK_TEST_TIME_tblQUOMs
GO


IF NOT EXISTS (SELECT * FROM information_schema.tables	WHERE table_type = 'base table' AND table_catalog=DB_NAME() and table_schema='dbo' and Table_Name='AMT_HOTFIX')
	CREATE TABLE AMT_HOTFIX(FixName nvarchar(MAX),Description nvarchar(MAX), DatabasePatchVersion varchar(15), DateApplied DateTime)
GO

DECLARE @FixName nVarchar(MAX),@dbasePatchVer varchar(15)
SET @FixName=N'AMT85C_HOTFIX_20120528.sql'

SELECT TOP 1 @dbasePatchVer=Database_Patch_Ver FROM AMT_VARIABLE


IF EXISTS(SELECT * FROM AMT_HOTFIX WHERE FixName=@FixName)
	UPDATE AMT_HOTFIX SET DateApplied=GetDate() WHERE FixName=@FixName
ELSE
	INSERT INTO AMT_HOTFIX VALUES(@FixName,N'',@dbasePatchVer,GetDate())
GO
