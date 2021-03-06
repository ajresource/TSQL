USE [Ontime]
GO
/****** Object:  StoredProcedure [dbo].[iSP_Calendar_Sync]    Script Date: 07/08/2013 18:15:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[iSP_Calendar_Sync]

@TaskID INT ,
@Email VARCHAR(200) =NULL,
@RequiredbyDate Varchar(200)=NULL,
@BudgetHours REAL=NULL,
@WorkFlowStep VARCHAR(200) =NULL,
@CompletedDate Varchar(200)=NULL,
@Comments nvarchar(MAX)=NULL,
@ActualHours REAL=NULL,
@CompletedByUserEmail  VARCHAR(200)=NULL
AS

DECLARE @AssignedTo varchar(200)
DECLARE @ReportedBy varchar(200)
DECLARE @EmailDetailsXML VARCHAR(MAX)
DECLARE @NewAssignedtoID INT=0
DECLARE @RequiredbyDate1 datetime
DECLARE @OriginalEmail VARCHAR(200) =NULL
DECLARE @CompletedDate1 datetime
DECLARE @Comments1 nvarchar(MAX)
declare @CommentDate VARCHAR(25)
DECLARE @CompletedByUser  VARCHAR(200)=NULL


-- INSERT TASK

IF NOT EXISTS (select * from iTasks where TaskID=@TaskID)
BEGIN
INSERT INTO iTasks
SELECT [TaskId]
      ,[TaskNumber]
      ,[Name]
      ,[Description]
      ,[Notes]
      ,ISNULL([CategoryTypeId],24)
      ,ISNULL([ProjectId],124)
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
      ,[LastUpdated]
      ,[Archived]
      ,[EstimatedDuration]
      ,[DurationUnitTypeId]
      ,[ActualDuration]
      ,[ActualUnitTypeId]
      ,[WorkflowStepId]
      ,ISNULL([PriorityTypeId],3)
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
      ,[FamilyId]
  FROM [Ontime].[dbo].[Tasks] where TaskID=799
  /*-------------------------------------------------------------------------*/
  INSERT INTO [iTaskCustomFields]
  SELECT  [TaskId]
      ,[Custom_202]
      ,[Custom_203]
      ,[Custom_204]
      ,ISNULL([Custom_206],'Internal')
      ,ISNULL([Custom_207],'Non Planned')
      ,[Custom_208]
      ,[Custom_209]
      ,[Custom_210]
      ,ISNULL([Custom_211],'Not Approved')
      ,[Custom_212]
      ,[Custom_213]
      ,[Custom_229]
      ,[Custom_230]
      ,ISNULL([Custom_249],'1210-IT Infrastructure')
  FROM [Ontime].[dbo].[TaskCustomFields] where TaskId=@TaskID

END


set @CompletedDate1=convert(datetime,@CompletedDate,101)

select @OriginalEmail=U.Email from iTasks T
inner join Users U ON T.AssignedtoID=U.UserID
where TaskID=@TaskID
select @NewAssignedtoID=UserID from Users where Email=@Email 


--ABANDONED TASKS BETWEEN USERS 
IF @WorkFlowStep='Abandoned'
BEGIN


SELECT @CommentDate=CONVERT(VARCHAR(25), GetDate(),100)
select @CompletedByUser=U.FirstName+' '+U.LastName from Users U where U.Email=ISNULL(@CompletedByUserEmail,'maroun.maroun@isipl.com')
select @comments1=CAST([Description] AS nvarchar(max) )  from iTasks where TaskID=@TaskID

set @comments1=@comments1+'<div>  
<b>Abandoned by '+@CompletedByUser+' on '+@CommentDate+'</b></div> 
<div>  <br /> 
'+ISNULL(@comments,'Task Abandoned')+'
</div>'

update iTasks
set WorkflowStepID=73, Description=@comments1
where TaskID=@TaskID
RETURN 
END

--WAITING ON APPROVAL 
IF @WorkFlowStep='Waiting On Approval'
BEGIN

DECLARE @CategoryTypeID INT

SELECT @CategoryTypeID=ISNULL(CategoryTypeID,24) from iTasks where TaskID=@TaskID

SELECT @CommentDate=CONVERT(VARCHAR(25), GetDate(),100)
select @CompletedByUser=U.FirstName+' '+U.LastName from Users U where U.Email=ISNULL(@CompletedByUserEmail,'maroun.maroun@isipl.com')
select @comments1=CAST([Description] AS nvarchar(max) )  from iTasks where TaskID=@TaskID

set @comments1=@comments1+'<div>  
<b>Changed by '+@CompletedByUser+' on '+@CommentDate+'</b></div> 
<div>  <br /> 
'+ISNULL(@comments,'Task is Waiting On Approval')+'
</div>'


update iTasks
set WorkflowStepID=46,  Description=@comments1,CategoryTypeID=@CategoryTypeID
where TaskID=@TaskID

update iTaskCustomFields
set Custom_211='Not Approved'
where TaskID=@TaskID

--RETURN 
END


-- MOVE TASKS BETWEEN USERS 
IF @Email IS NOT NULL
BEGIN
Update iTasks 
SET AssignedtoID=ISNULL(@NewAssignedtoID,0) 
where TaskID=@TaskID
END


-- ASSIGN A OPEN TASK TO A USER
IF @WorkFlowStep='Open IT Task'
BEGIN
update iTasks
set CategoryTypeID=24, WorkFlowStepID=45
where TaskID=@TaskID

update iTaskCustomFields
set Custom_211='Approved'
where TaskID=@TaskID
END

-- ON HOLD TASK
IF @WorkFlowStep='On Hold IT Task'
BEGIN
update iTasks
set  WorkFlowStepID=20
where TaskID=@TaskID

update iTaskCustomFields
set Custom_229='Backlog'
where TaskID=@TaskID
END


-- HOLD A IT TASK

IF @WorkFlowStep='Assigned IT Task'
BEGIN
update iTasks
set WorkFlowStepID=45
where TaskID=@TaskID

update iTaskCustomFields
set Custom_229=''
where TaskID=@TaskID
END

-- COMPLETE IT TASK

IF @ActualHours IS NULL
BEGIN
SELECT @ActualHours=
	CASE	WHEN ActualUnitTypeId=1
			THEN ActualDuration/60 
			ELSE ActualDuration 
	END
FROM iTasks WHERE TaskID=@TaskID
END

IF @WorkFlowStep='Completed IT Task'
BEGIN 


SELECT @CommentDate=CONVERT(VARCHAR(25), GetDate(),100)
select @CompletedByUser=U.FirstName+' '+U.LastName from Users U where U.Email=ISNULL(@CompletedByUserEmail,'maroun.maroun@isipl.com')
select @comments1=CAST([Description] AS nvarchar(max) )  from iTasks where TaskID=@TaskID

set @comments1=@comments1+'<div>  
<b>Completed by '+@CompletedByUser+' on '+@CommentDate+'</b></div> 
<div>  <br /> 
'+ISNULL(@comments,'Task Completed')+'
</div>'


UPDATE iTasks
set CompletionDate=@CompletedDate1,
	ActualDuration=@ActualHours,
	ActualUnitTypeID=2,
	WorkflowStepID=21,
	Description=@comments1
WHERE TaskID=@TaskID
END


-- EXPAND THE TASK ON THE GRID


IF @BudgetHours IS NOT NULL
BEGIN
update iTasks
SET EstimatedDuration=@BudgetHours, DurationUnitTypeID=2
where TaskID=@TaskID
END


-- CHANGE THE REQUIRED BY DATE 
/*REMOVE A SECOND FROM THE DATE(CALANDER FORMATTING)*/
IF @RequiredbyDate IS NOT NULL
BEGIN

set  @RequiredbyDate=convert(datetime,@RequiredbyDate,101) 
set @RequiredbyDate1=convert(datetime,@RequiredbyDate,103)

SET @RequiredbyDate1=DATEADD(SECOND,-1,@RequiredbyDate1)
update iTaskCustomFields
set Custom_210=@RequiredbyDate1
where TaskId=@TaskID
END




-- SEND AN EMAIL
