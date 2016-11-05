DECLARE @TaskID INT
DECLARE @Custome_210 Datetime
set @Custome_210='2014-08-29 00:00:00.000'

While @Custome_210<'2014-12-31'
BEGIN

INSERT INTO [dbo].[Tasks]
           ([TaskNumber]
           ,[Name]
           ,[Description]
           ,[Notes]
           ,[CategoryTypeId]
           ,[ProjectId]
           ,[StartDate]
           ,[DueDate]
           ,[CompletionDate]
           ,[IsCompleted]
           ,[IsPublic]
           ,[AssignedToId]
           ,[ReportedById]
           ,[CreatedById]
           ,[CreatedDateTime]
           ,[LastUpdatedById]
           ,[LastUpdatedDateTime]
           ,[Archived]
           ,5
           ,[DurationUnitTypeId]
           ,0
           ,[ActualUnitTypeId]
           ,[WorkflowStepId]
           ,[PriorityTypeId]
           ,[RemainingDuration]
           ,[RemainingUnitTypeId]
           ,[ReleaseId]
           ,[StatusTypeId]
           ,[PubliclyViewable]
           ,[ReportedByCustomerContactId]
           ,[PercentComplete]
           ,[ParentId]
           ,[SubitemType]
           ,[AggregateEstimatedMinutes]
           ,[AggregateActualMinutes]
           ,[AggregateRemainingMinutes]
           ,[EstimatedDurationMinutes]
           ,[ActualDurationMinutes]
           ,[RemainingDurationMinutes])
SELECT 
			[TaskNumber]
           ,'SLA Server Maintenance'
           ,'<strong>AMT Maintenance &amp; SLA Reports (IT Eng Responsible for Servers and Backups)</strong><br /><br />New_Crest<br />Sms_Reatal<br />Peabody<br /><br /><strong>AMT Maintenance &amp; SLA Reports (All the requirements as per SLA)</strong><br />BWE<br />KPUC'
           ,[Notes]
           ,[CategoryTypeId]
           ,[ProjectId]
           ,[StartDate]
           ,[DueDate]
           ,[CompletionDate]
           ,[IsCompleted]
           ,[IsPublic]
           ,[AssignedToId]
           ,[ReportedById]
           ,[CreatedById]
           ,[CreatedDateTime]
           ,[LastUpdatedById]
           ,[LastUpdatedDateTime]
           ,[Archived]
           ,[EstimatedDuration]
           ,[DurationUnitTypeId]
           ,[ActualDuration]
           ,[ActualUnitTypeId]
           ,[WorkflowStepId]
           ,[PriorityTypeId]
           ,[RemainingDuration]
           ,[RemainingUnitTypeId]
           ,[ReleaseId]
           ,[StatusTypeId]
           ,[PubliclyViewable]
           ,[ReportedByCustomerContactId]
           ,[PercentComplete]
           ,[ParentId]
           ,[SubitemType]
           ,[AggregateEstimatedMinutes]
           ,[AggregateActualMinutes]
           ,[AggregateRemainingMinutes]
           ,240
           ,0
           ,[RemainingDurationMinutes]
  FROM [dbo].[Tasks] 
where TaskId=2043

select @TaskID=MAX(TaskId) from Tasks where Name='SLA Server Maintenance'

INSERT INTO [dbo].[TaskCustomFields]
           ([TaskId]
           ,[Custom_202]
           ,[Custom_203]
           ,[Custom_204]
           ,[Custom_206]
           ,[Custom_207]
           ,[Custom_208]
           ,[Custom_209]
           ,[Custom_210]
           ,[Custom_211]
           ,[Custom_212]
           ,[Custom_213]
           ,[Custom_229]
           ,[Custom_230]
           ,[Custom_249])
SELECT @TaskID
      ,[Custom_202]
      ,[Custom_203]
      ,[Custom_204]
      ,[Custom_206]
      ,[Custom_207]
      ,[Custom_208]
      ,[Custom_209]
      ,@Custome_210
      ,[Custom_211]
      ,[Custom_212]
      ,@Custome_210
      ,[Custom_229]
      ,[Custom_230]
      ,[Custom_249]
  FROM [dbo].[TaskCustomFields] where TaskId=2043

select @Custome_210
SET @Custome_210=DATEADD(ww,1,@Custome_210)

END

--select MAX(TaskId) from Tasks where Name='SLA Server Maintenance'

--delete from Tasks where TaskId=2046