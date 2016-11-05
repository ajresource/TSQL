declare @p1 int
set @p1=NULL
declare @p2 binary(8)
set @p2=NULL
declare @p3 int
set @p3=NULL
exec spI_Tasks @TaskId=@p1 output,@LastUpdated=@p2 output,
@SubitemType=@p3 output,@TaskNumber='1484',
@Name=N'test AJ123',@Description=N'<div><b> </b></div>',
@Notes=N'',
@CategoryTypeId=0,
@PriorityTypeId=3,
@ProjectId=124,
@StartDate='1899-01-01 00:00:00',
@DueDate='1899-01-01 00:00:00',
@CompletionDate='1899-01-01 00:00:00',
@IsCompleted=0,
@IsPublic=1,
@ReportedById=22,
@AssignedToId=11,
@CreatedById=22,
@CreatedDateTime='2013-06-27 11:59:40.430',
@LastUpdatedById=22,
@LastUpdatedDateTime='2013-06-27 11:59:40.430',
@Archived=0,
@EstimatedDuration=25,
@DurationUnitTypeId=2,
@ActualDuration=0,
@ActualUnitTypeId=0,
@WorkflowStepId=43,
@RemainingDuration=0,
@RemainingUnitTypeId=0,
@ReleaseId=0,
@StatusTypeId=1,
@PubliclyViewable=0,
@ReportedByCustomerContactId=0,
@PercentComplete=0,
@ParentId=0
select @p1, @p2, @p3