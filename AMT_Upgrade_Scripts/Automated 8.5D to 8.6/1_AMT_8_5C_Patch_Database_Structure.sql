
/******************************************************************************
	File: 	AMT_8_5C_Schema_Changes.sql

	Description:	Changes the schema in  the database

**************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
11 May 12   GD          4172 Add UI_USAGESTEPID_QUOM unique contraint to tblUsageStepAmts
07 May 12   JW          E804 Add DD and CC column to MODULAR_EVENT and HOLDING_EVENT table
 7-May-12	VV			E790 IMPORT_PROJECTION.Old_Ext_Id
 1 May 12	VV			Took out E786 changes and put them into data load script
 1 May 12	VV			E806  new fields in tblProjTasks AutocreateExternalWorkorders,
						AutocreatePlannedEvents
24-Apr-12	VV			E790 IMPORT_PROJECTION.Old_External_Identifier
18-04-12    GD          E786
16 Apr 12   SD          E789 NEXT_OCC_STRATEGY.PEXPartTypeId now FK to PART_CLASSIFICATION
11 Apr 12	V Vasylyeva	INVENTORY_PART,tblParts,tblProjTasks,PART_CLASSIFICATION
**END OF HISTORY************************************************************************************************************/
 
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'IMPORT_PROJECTION' AND  COLUMN_NAME = 'Old_Ext_Id')
BEGIN
 ALTER TABLE dbo.IMPORT_PROJECTION ADD
	Old_Ext_Id varchar(2000) NULL
END

GO

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'INVENTORY_PART' AND  COLUMN_NAME = 'QtyBeingRebuilt')
BEGIN

 ALTER TABLE [dbo].[INVENTORY_PART]
    ADD [QtyBeingRebuilt] INT  CONSTRAINT [DF_INVENTORY_PART_QtyBeingRebuilt] DEFAULT (0) NOT NULL,
        [RebuildSiteId]   INT            NULL,
        [Location]        VARCHAR (1000) NULL,
        [Comments]        VARCHAR (2000) NULL
        
END

GO
        
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'tblParts' AND  COLUMN_NAME = 'BudgetDeliveryTimeToWorkshop')
BEGIN
	ALTER TABLE [dbo].[tblParts]
    ADD [BudgetDeliveryTimeToWorkshop]  FLOAT CONSTRAINT [DF_tblParts_BudgetDeliveryTimeToWorkshop] DEFAULT ((0)) NOT NULL,
        [BudgetTimeWaitingForRebuild]   FLOAT CONSTRAINT [DF_tblParts_BudgetTimeWaitingForRebuild] DEFAULT ((0)) NOT NULL,
        [BudgetRebuildDuration]         FLOAT CONSTRAINT [DF_tblParts_BudgetRebuildDuration] DEFAULT ((0)) NOT NULL,
        [BudgetDeliveryTimeToWarehouse] FLOAT CONSTRAINT [DF_tblParts_BudgetDeliveryTimeToWarehouse] DEFAULT ((0)) NOT NULL,
        [BudgetTotalTurnTime]           FLOAT CONSTRAINT [DF_tblParts_BudgetTotalTurnTime] DEFAULT ((0)) NOT NULL,
        [DefaultComponentCodeId]        INT   NULL,
        [DefaultPartRatingId]           INT   NULL
        
        END

GO

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'tblProjTasks' AND  COLUMN_NAME = 'PartClassificationId')
BEGIN
	ALTER TABLE [dbo].[tblProjTasks]
    ADD [PartClassificationId]      INT NULL,
        [DefaultLocationForRebuild] INT NULL
END


GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PART_CLASSIFICATION]') AND type in (N'U'))
BEGIN

	CREATE TABLE [dbo].[PART_CLASSIFICATION] (
		[PartClassificationId] INT          IDENTITY (1, 1) NOT NULL,
		[PartClassification]   VARCHAR (50) NOT NULL,
		[CoreRetained] BIT NOT NULL DEFAULT (0)
		
		)

END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='PK_PART_CLASSIFICATION')
BEGIN   
    
		ALTER TABLE [dbo].[PART_CLASSIFICATION]
		ADD CONSTRAINT [PK_PART_CLASSIFICATION] PRIMARY KEY CLUSTERED ([PartClassificationId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
END

GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='FK_INVENTORY_PART_tblSites')
BEGIN  
	ALTER TABLE [dbo].[INVENTORY_PART] WITH NOCHECK
    ADD CONSTRAINT [FK_INVENTORY_PART_tblSites] FOREIGN KEY ([RebuildSiteId]) REFERENCES [dbo].[tblSites] ([SiteId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='FK_tblParts_PART_RATING')
BEGIN  
	ALTER TABLE [dbo].[tblParts] WITH NOCHECK
    ADD CONSTRAINT [FK_tblParts_PART_RATING] FOREIGN KEY ([DefaultPartRatingId]) REFERENCES [dbo].[PART_RATING] ([PartRatingId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='FK_tblParts_tblComponentCodes')
BEGIN  
	ALTER TABLE [dbo].[tblParts] WITH NOCHECK
    ADD CONSTRAINT [FK_tblParts_tblComponentCodes] FOREIGN KEY ([DefaultComponentCodeId]) REFERENCES [dbo].[tblComponentCodes] ([ComponentCodeID]) ON DELETE NO ACTION ON UPDATE NO ACTION;
END


GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='FK_tblProjTasks_PART_CLASSIFICATION')
BEGIN  

	ALTER TABLE [dbo].[tblProjTasks] WITH NOCHECK
    ADD CONSTRAINT [FK_tblProjTasks_PART_CLASSIFICATION] FOREIGN KEY ([PartClassificationId]) REFERENCES [dbo].[PART_CLASSIFICATION] ([PartClassificationId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
END

GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='FK_tblProjTasks_tblSites')
BEGIN  
	ALTER TABLE [dbo].[tblProjTasks] WITH NOCHECK
    ADD CONSTRAINT [FK_tblProjTasks_tblSites] FOREIGN KEY ([DefaultLocationForRebuild]) REFERENCES [dbo].[tblSites] ([SiteId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='FK_TASK_tblPartTypes')
BEGIN
	ALTER TABLE dbo.TASK
	DROP CONSTRAINT FK_TASK_tblPartTypes
	
END

GO

UPDATE TASK SET RebuildPartTypeId=NULL

GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='FK_TASK_PART_CLASSIFICATION')
BEGIN
	ALTER TABLE dbo.TASK ADD CONSTRAINT
	FK_TASK_PART_CLASSIFICATION FOREIGN KEY
	(
	RebuildPartTypeId
	) REFERENCES dbo.PART_CLASSIFICATION
	(
	PartClassificationId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
END

GO

/*E789*/
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME ='FK_NEXT_OCC_STRATEGY_PAY_TYPE')
BEGIN
	
	ALTER  TABLE [dbo].[NEXT_OCC_STRATEGY] DROP CONSTRAINT FK_NEXT_OCC_STRATEGY_PAY_TYPE

	/* Field does not need to be migrated - just data removed and re-used */
	Update [dbo].[NEXT_OCC_STRATEGY] set [PEXPartTypeId] = null;
	
	ALTER TABLE [dbo].[NEXT_OCC_STRATEGY] ADD  CONSTRAINT 
	FK_NEXT_OCC_STRATEGY_PART_CLASSIFICATION FOREIGN KEY
	(
	[PEXPartTypeId]
	) REFERENCES [dbo].[PART_CLASSIFICATION] 
	(
	[PartClassificationId]
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION
	
END

GO

--GD E786 18/04/12
 --IF NOT EXISTS (SELECT * FROM IMPORT_SOURCE WHERE [ImportSourceId]=2)

 --          INSERT INTO [dbo].[IMPORT_SOURCE]
 --          ([ImportSourceId]
 --          ,[ImportSourceName])
 --    VALUES
 --          (2,'WebService')
           
 --GO
 
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'tblProjTasks' AND  COLUMN_NAME = 'AutocreateExternalWorkorders')
BEGIN          
 ALTER TABLE tblProjTasks ADD
	AutocreateExternalWorkorders bit NOT NULL CONSTRAINT DF_tblProjTasks_AutocreateExternalWorkorders DEFAULT 0,
	AutocreatePlannedEvents bit NOT NULL CONSTRAINT DF_tblProjTasks_AutocreatePlannedEvents DEFAULT 0
	
END

GO

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'MODULAR_EVENT' AND  COLUMN_NAME = 'ComponentCode')
BEGIN          
 ALTER TABLE dbo.MODULAR_EVENT ADD
	ComponentCode varchar(10) NULL,
	TaskType varchar(50) NULL
	
END

GO

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'HOLDING_EVENT' AND  COLUMN_NAME = 'ComponentCode')
BEGIN          
 ALTER TABLE dbo.HOLDING_EVENT ADD
	ComponentCode varchar(10) NULL,
	TaskType varchar(50) NULL
	
END

GO

IF EXISTS (SELECT name FROM sysindexes WHERE name ='UI_USAGESTEPID_QUOM')
BEGIN
	DROP INDEX UI_USAGESTEPID_QUOM ON dbo.tblUsageStepAmts
END

GO

CREATE UNIQUE NONCLUSTERED INDEX UI_USAGESTEPID_QUOM ON dbo.tblUsageStepAmts
	(
	UsageStepId,
	UsageQUOMId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
