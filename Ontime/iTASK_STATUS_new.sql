USE [Ontime]
GO

/****** Object:  Table [dbo].[iTASK_STATUS]    Script Date: 06/24/2013 14:03:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[iTASK_STATUS]') AND type in (N'U'))
DROP TABLE [dbo].[iTASK_STATUS]
GO

USE [Ontime]
GO

/****** Object:  Table [dbo].[iTASK_STATUS]    Script Date: 06/24/2013 14:03:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[iTASK_STATUS](
	[Task_Status_ID] [int] IDENTITY(1,1) NOT NULL,
	[TaskId]  [int] NOT NULL,
	[TaskNumber] [nvarchar](20) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [ntext] NULL,
	[Notes] [ntext] NULL,
	[CategoryTypeId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[CompletionDate] [datetime] NOT NULL,
	[IsCompleted] [bit] NOT NULL,
	[IsPublic] [bit] NOT NULL,
	[AssignedToId] [int] NOT NULL,
	[ReportedById] [int] NOT NULL,
	[CreatedById] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedById] [int] NOT NULL,
	[LastUpdatedDateTime] [datetime] NOT NULL,
	[LastUpdated] datetime NOT NULL,
	[Archived] [bit] NOT NULL,
	[EstimatedDuration] [real] NOT NULL,
	[DurationUnitTypeId] [int] NOT NULL,
	[ActualDuration] [real] NOT NULL,
	[ActualUnitTypeId] [int] NOT NULL,
	[WorkflowStepId] [int] NOT NULL,
	[PriorityTypeId] [int] NOT NULL,
	[RemainingDuration] [real] NOT NULL,
	[RemainingUnitTypeId] [int] NOT NULL,
	[ReleaseId] [int] NOT NULL,
	[StatusTypeId] [int] NOT NULL,
	[PubliclyViewable] [bit] NOT NULL,
	[ReportedByCustomerContactId] [int] NOT NULL,
	[PercentComplete] [tinyint] NOT NULL,
	[ParentId] [int] NOT NULL,
	[SubitemType] [int] NOT NULL,
	[AggregateEstimatedMinutes] [real] NOT NULL,
	[AggregateActualMinutes] [real] NOT NULL,
	[AggregateRemainingMinutes] [real] NOT NULL,
	[FamilyId] [int] NOT NULL,
	[Time_Stamp] datetime) 



