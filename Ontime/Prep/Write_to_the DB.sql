DECLARE @TaskId INT

DECLARE SyncTasks CURSOR FOR	

select TaskID from iTasks
 
OPEN SyncTasks 
FETCH NEXT FROM SyncTasks INTO @TaskId 
WHILE @@fetch_status = 0
BEGIN 


DECLARE  @TaskNumber nvarchar(20)
DECLARE  @Name nvarchar(200)
DECLARE  @Description VARCHAR(MAX)
DECLARE  @Notes VARCHAR(MAX)
DECLARE  @CategoryTypeId int
DECLARE  @ProjectId int
DECLARE  @StartDate datetime
DECLARE  @DueDate datetime
DECLARE  @CompletionDate datetime
DECLARE  @IsCompleted bit
DECLARE  @IsPublic bit
DECLARE  @AssignedToId int
DECLARE  @CreatedById int
DECLARE  @CreatedDateTime datetime
DECLARE  @LastUpdatedById int
DECLARE  @LastUpdatedDateTime datetime
DECLARE  @Archived bit
DECLARE  @EstimatedDuration real
DECLARE  @DurationUnitTypeId int
DECLARE  @ActualDuration real
DECLARE  @ActualUnitTypeId int
DECLARE  @WorkflowStepId int
DECLARE  @PriorityTypeId int
DECLARE  @RemainingDuration [real]
DECLARE  @RemainingUnitTypeId [int]
DECLARE  @ReleaseId [int]
DECLARE  @StatusTypeId [int]
DECLARE  @PubliclyViewable [int]
DECLARE  @ReportedByCustomerContactId [int]
DECLARE  @ReportedById [int]
DECLARE  @PercentComplete [tinyint]
DECLARE  @ParentId [int]
DECLARE  @Custom_209 nvarchar(50) = null
DECLARE  @Custom_213 datetime  = null 
DECLARE  @Custom_212 float  = null 
DECLARE  @Custom_202 nvarchar(50)  = null 
DECLARE  @Custom_206 nvarchar(50)  = null 
DECLARE  @Custom_229 nvarchar(50)  = null 
DECLARE  @Custom_207 nvarchar(50)  = null 
DECLARE  @Custom_208 nvarchar(5)  = null 
DECLARE  @Custom_249 nvarchar(50)  = null 
DECLARE  @Custom_230 float  = null 
DECLARE  @Custom_204 nvarchar(50)  = null 
DECLARE  @Custom_210 datetime  = null 
DECLARE  @Custom_203 nvarchar(50)  = null 
DECLARE  @Custom_211 nvarchar(50)  = null 
			


SELECT
@TaskID=[TaskId],
@TaskNumber=[TaskNumber],
@Name=[Name],
@Description=[Description],
@Notes=[Notes],
@CategoryTypeId=[CategoryTypeId],
@ProjectId=[ProjectId],
@StartDate=[StartDate],
@DueDate=[DueDate],
@CompletionDate=[CompletionDate],
@IsCompleted=[IsCompleted],
@IsPublic=[IsPublic],
@AssignedToId=[AssignedToId],
@CreatedById=[CreatedById],
@CreatedDateTime=[CreatedDateTime],
@LastUpdatedById=[LastUpdatedById],
@LastUpdatedDateTime=[LastUpdatedDateTime],
@ReportedById=[ReportedById],
@Archived=[Archived],
@EstimatedDuration=[EstimatedDuration],
@DurationUnitTypeId=[DurationUnitTypeId],
@ActualDuration=[ActualDuration],
@ActualUnitTypeId=[ActualUnitTypeId],
@WorkflowStepId=[WorkflowStepId],
@PriorityTypeId=[PriorityTypeId],
@RemainingDuration=[RemainingDuration],
@RemainingUnitTypeId=[RemainingUnitTypeId],
@ReleaseId=[ReleaseId],
@StatusTypeId=[StatusTypeId],
@PubliclyViewable=[PubliclyViewable],
@ReportedByCustomerContactId=[ReportedByCustomerContactId],
@PercentComplete=[PercentComplete],
@ParentId=[ParentId]
  FROM [Ontime].[dbo].[iTasks] where TaskID=@TaskId
  
SELECT 
@Custom_202=Custom_202,
@Custom_203=Custom_203,
@Custom_204=Custom_204,
@Custom_206=Custom_206,
@Custom_207=Custom_207,
@Custom_208=Custom_208,
@Custom_209=Custom_209,
@Custom_210=Custom_210,
@Custom_211=Custom_211,
@Custom_212=Custom_212,
@Custom_213=Custom_213,
@Custom_229=Custom_229,
@Custom_230=Custom_230,
@Custom_249=Custom_249
 FROM [Ontime].[dbo].[iTaskCustomFields] where TaskID=@TaskId
  
  
 EXEC  [spU_Tasks]
 @TaskId =@TaskId ,
 @TaskNumber = @TaskNumber ,
 @Name= @Name,
 @Description= @Description,
 @Notes= @Notes,
 @CategoryTypeId= @CategoryTypeId,
 @ProjectId= @ProjectId,
 @StartDate= @StartDate,
 @DueDate= @DueDate,
 @CompletionDate= @CompletionDate,
 @IsCompleted= @IsCompleted,
 @IsPublic= @IsPublic,
 @AssignedToId= @AssignedToId,
 @CreatedById= @CreatedById,
 @CreatedDateTime= @CreatedDateTime,
 @LastUpdatedById= @LastUpdatedById,
 @LastUpdatedDateTime= @LastUpdatedDateTime,
 @Archived= @Archived,
 @EstimatedDuration= @EstimatedDuration,
 @DurationUnitTypeId= @DurationUnitTypeId,
 @ActualDuration= @ActualDuration,
 @ActualUnitTypeId= @ActualUnitTypeId,
 @WorkflowStepId= @WorkflowStepId,
 @PriorityTypeId= @PriorityTypeId,
 @RemainingDuration= @RemainingDuration,
 @RemainingUnitTypeId= @RemainingUnitTypeId,
 @ReleaseId= @ReleaseId,
 @StatusTypeId= @StatusTypeId,
 @PubliclyViewable= @PubliclyViewable,
 @ReportedByCustomerContactId= @ReportedByCustomerContactId,
 @ReportedById= @ReportedById,
 @PercentComplete= @PercentComplete,
 @ParentId= @ParentId


EXEC [spU_TaskCustomFields] 
@TaskID=@TaskID,
@Custom_202=@Custom_202,
@Custom_203=@Custom_203,
@Custom_204=@Custom_204,
@Custom_206=@Custom_206,
@Custom_207=@Custom_207,
@Custom_208=@Custom_208,
@Custom_209=@Custom_209,
@Custom_210=@Custom_210,
@Custom_211=@Custom_211,
@Custom_212=@Custom_212,
@Custom_213=@Custom_213,
@Custom_229=@Custom_229,
@Custom_230=@Custom_230,
@Custom_249=@Custom_249


FETCH NEXT FROM SyncTasks INTO @TaskId 
END
CLOSE SyncTasks 
DEALLOCATE SyncTasks 