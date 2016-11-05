
/******************************************************************************
	File: 	AMT_8_5_Schema_Changes.sql

	Description:	Changes the schema in  the database

**************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
01 Aug 11   GD			Added two columns to Import_Error table
01 Aug 11   GD          Fixed #2197
17 Aug 11   GD          added column for creating ERPWorkorder in connector
26 Aug 11   GD          Modified length of ErrorDescription in IMPORT_ERROR table
04 Sep 11   GD          E624 show external WO
14 Sep 11	TP			E615 Increased the size of the Cost_Responsibility_Code column
19 Sep 11   GD          Fixed #2481 changed the data type of ImportRecord Column
04 Oct 11	DA			E635 - Increase size for columns [Eqp_Class_Code], [Eqp_Class_Desc]
14 Oct 11   GD          Issue 2634 increased the length of description from 50 to 100 in tblapplication codes
**END OF HISTORY************************************************************************************************************/
SET QUOTED_IDENTIFIER ON	--should be always ON
GO
SET ANSI_NULLS ON			--should be always ON
GO
--=============================================================================


IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'AMT_VARIABLE' AND  COLUMN_NAME = 'ConnectorERPWorkorderCreate')
BEGIN
ALTER TABLE AMT_VARIABLE ADD [ConnectorERPWorkorderCreate] [bit] NOT NULL DEFAULT ((0))
END

/****** Object:  Table [dbo].[IMPORT_SOURCE]    Script Date: 08/10/2011 16:30:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IMPORT_SOURCE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IMPORT_SOURCE](
	[ImportSourceId] [int] NOT NULL,
	[ImportSourceName] [varchar](100) NULL,
 CONSTRAINT [PK_IMPORT_SOURCE] PRIMARY KEY CLUSTERED 
(
	[ImportSourceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

SET ANSI_PADDING OFF
GO



IF NOT EXISTS (SELECT * FROM IMPORT_SOURCE WHERE [ImportSourceId]=0)
INSERT INTO [dbo].[IMPORT_SOURCE]
           ([ImportSourceId]
           ,[ImportSourceName])
     VALUES
           (0,'File')
   
   IF NOT EXISTS (SELECT * FROM IMPORT_SOURCE WHERE [ImportSourceId]=1)

           INSERT INTO [dbo].[IMPORT_SOURCE]
           ([ImportSourceId]
           ,[ImportSourceName])
     VALUES
           (1,'Connector')

GO

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'IMPORT_ERROR' AND  COLUMN_NAME = 'ImportRecord')
BEGIN
ALTER TABLE IMPORT_ERROR ADD [ImportRecord] [xml] NULL
END

IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS   WHERE TABLE_NAME = 'IMPORT_ERROR' AND  COLUMN_NAME = 'ImportSourceId')
BEGIN
ALTER TABLE IMPORT_ERROR ADD [ImportSourceId] [int] NULL DEFAULT ((0))
END

--fixed Issue #2197

ALTER TABLE [dbo].[TASK_HEADER]
ALTER COLUMN [Task_Type] VARCHAR(50) NOT NULL

IF NOT EXISTS (SELECT *    FROM sys.foreign_keys     WHERE object_id = OBJECT_ID(N'dbo.[FK_IMPORT_ERROR_IMPORT_SOURCE]')    AND parent_object_id = OBJECT_ID(N'dbo.[IMPORT_ERROR]') )  
BEGIN
ALTER TABLE [dbo].[IMPORT_ERROR] ADD CONSTRAINT [FK_IMPORT_ERROR_IMPORT_SOURCE] FOREIGN KEY (  [ImportSourceId] ) REFERENCES [dbo].[IMPORT_SOURCE] ([ImportSourceId])
END

--E610
ALTER TABLE [dbo].[IMPORT_ERROR]
ALTER COLUMN [ErrorDescription] VARCHAR(8000)  NULL

IF NOT EXISTS (SELECT * FROM AMT_TYPED_VARIABLE WHERE [Value_Name]='Show_External_WO')
INSERT INTO [dbo].[AMT_TYPED_VARIABLE]
           ([Value_Name]
           ,[Varchar_Value]
           ,[Caption]
           ,[ConfigurationGroup])
     VALUES
           ('Show_External_WO'
           ,0
           ,'Show Open External Workorder functionality'
           ,NULL)
GO

--E615
ALTER TABLE dbo.COST_RESPONSIBILITY ALTER COLUMN Cost_Responsibility_Code VARCHAR (50) NOT NULL
GO

--2481
ALTER TABLE [dbo].[IMPORT_ERROR]
ALTER COLUMN [ImportRecord] VARCHAR(MAX) NULL
GO


--E635
ALTER TABLE [dbo].[EQP_CLASS]
ALTER COLUMN [Eqp_Class_Code] VARCHAR(50) NOT NULL
GO

ALTER TABLE [dbo].[MODEL_FAMILY]
ALTER COLUMN [Model_Family_Code] VARCHAR(50) NOT NULL
GO

--2634
ALTER TABLE [dbo].[tblApplicationCodes]
ALTER COLUMN [Description] VARCHAR(100) NULL
GO

