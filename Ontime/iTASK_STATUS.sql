
/****** Object:  Table [dbo].[iTASK_STATUS]    Script Date: 06/21/2013 15:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[iTASK_STATUS]') AND type in (N'U'))
DROP TABLE [dbo].[iTASK_STATUS]
GO


/****** Object:  Table [dbo].[iTASK_STATUS]    Script Date: 06/21/2013 15:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[iTASK_STATUS](
	[Task_Status_ID] [int] IDENTITY(1,1) NOT NULL,
	[TaskId] [int] NULL,
	[ActualDuration] [real] NULL,
	[ActualUnitTypeId] [int] NULL,
	[Time_Stamp] [datetime] NULL
) ON [PRIMARY]

GO


