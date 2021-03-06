USE [Ontime]
GO
/****** Object:  Trigger [dbo].[iTASK_STATUS_TRIGGER]    Script Date: 06/24/2013 14:05:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[iTASK_STATUS_TRIGGER] ON [dbo].[Tasks]
FOR INSERT,UPDATE
AS 
BEGIN
DECLARE @ActualUnitTypeId INT
DECLARE @TaskId INT
DECLARE @ActualDuration REAL=0
DECLARE @TotalActualDuration REAL=0
DECLARE @TimeStamp datetime
select @TimeStamp=GETDATE()
SELECT @TaskId=TaskId, @ActualDuration=(CASE WHEN ActualUnitTypeId = 2 THEN ActualDuration*60
ELSE ActualDuration END),@ActualUnitTypeId=ActualUnitTypeId FROM inserted 
SELECT @TotalActualDuration=SUM(ActualDuration) 
FROM iTASK_STATUS 
WHERE TaskId=@TaskId
GROUP BY TaskId
INSERT INTO iTASK_STATUS
select [TaskId],
	[TaskNumber],
	[Name],
	[Description],
	[Notes],
	[CategoryTypeId],
	[ProjectId],
	[StartDate],
	[DueDate],
	[CompletionDate],
	[IsCompleted],
	[IsPublic],
	[AssignedToId],
	[ReportedById],
	[CreatedById],
	[CreatedDateTime],
	[LastUpdatedById],
	[LastUpdatedDateTime],
	[LastUpdated],
	[Archived],
	[EstimatedDuration],
	[DurationUnitTypeId],
	@ActualDuration-@TotalActualDuration as [ActualDuration],
	2 AS [ActualUnitTypeId],
	[WorkflowStepId],
	[PriorityTypeId],
	[RemainingDuration],
	[RemainingUnitTypeId],
	[ReleaseId],
	[StatusTypeId],
	[PubliclyViewable],
	[ReportedByCustomerContactId],
	[PercentComplete],
	[ParentId],
	[SubitemType],
	[AggregateEstimatedMinutes],
	[AggregateActualMinutes],
	[AggregateRemainingMinutes],
	[FamilyId],
	@TimeStamp
	from Tasks
	WHERE TaskId=@TaskId

delete from iTASK_STATUS where ActualDuration=0
END
