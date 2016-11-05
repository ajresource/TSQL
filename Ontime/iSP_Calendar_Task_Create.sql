USE [Ontime]
GO

/****** Object:  StoredProcedure [dbo].[iSP_Calendar_Task_Create]    Script Date: 07/13/2013 18:31:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[iSP_Calendar_Task_Create]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[iSP_Calendar_Task_Create]
GO

USE [Ontime]
GO

/****** Object:  StoredProcedure [dbo].[iSP_Calendar_Task_Create]    Script Date: 07/13/2013 18:31:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[iSP_Calendar_Task_Create]

 @ProjectNo VARCHAR(200),
 @BudgetHours REAL,
 @Title VARCHAR(MAX),
 @RequiredbyDate VARCHAR(200),
 @username VARCHAR(255),
 @comments VARCHAR(MAX)=NULL


AS 
	 
declare @p1 int
set @p1=NULL
declare @p2 binary(8)
set @p2=NULL
declare @p3 int
set @p3=NULL

DECLARE @Today datetime
DECLARE @RequiredbyDate1 datetime
DECLARE @UserID INT 
DECLARE @CommentDate VARCHAR(25) 
DECLARE @User VARCHAR(200)
DECLARE @comments1 VARCHAR(MAX)






select @Today=getdate()

SET @username=LTRIM(RTRIM(@username))

select @UserID=UserID from users where LoginID=RIGHT(@username,LEN(@username)-6)



exec spI_Tasks @TaskId=@p1 output,@LastUpdated=@p2 output,
@SubitemType=@p3 output,
@TaskNumber='112211',
@Name=@Title,
@Description=N'',
@Notes=N'',
@CategoryTypeId=24,
@PriorityTypeId=3,
@ProjectId=124,
@StartDate='1899-01-01 00:00:00',
@DueDate='1899-01-01 00:00:00',
@CompletionDate='1899-01-01 00:00:00',
@IsCompleted=0,
@IsPublic=1,
@ReportedById=@UserID,
@AssignedToId=11,
@CreatedById=1,
@CreatedDateTime=@Today,
@LastUpdatedById=1,
@LastUpdatedDateTime=@Today,
@Archived=0,
@EstimatedDuration=@BudgetHours,
@DurationUnitTypeId=2,
@ActualDuration=0,
@ActualUnitTypeId=0,
@WorkflowStepId=43,
@RemainingDuration=0,
@RemainingUnitTypeId=0,
@ReleaseId=0,
@StatusTypeId=8,
@PubliclyViewable=0,
@ReportedByCustomerContactId=0,
@PercentComplete=0,
@ParentId=0


select @ProjectNo = AccCode+'-'+AccDescription from isipl_projects where AccCode=@ProjectNo


IF @RequiredbyDate IS NOT NULL
BEGIN

set  @RequiredbyDate=convert(datetime,@RequiredbyDate,101) 
set @RequiredbyDate1=convert(datetime,@RequiredbyDate,103)
--SET @RequiredbyDate1=DATEADD(SECOND,-1,@RequiredbyDate1)
/*
IF RIGHT(@RequiredbyDate1,7)='12:00AM' --OR RIGHT(@RequiredbyDate1,7)='11:59PM'
BEGIN
--select 'YES'
SET @RequiredbyDate1=DATEADD(SECOND,-1,@RequiredbyDate1)
--select @RequiredbyDate1
END

--select @RequiredbyDate1
*/
END


INSERT INTO TaskCustomFields
select @p1,NULL,NULL,NULL,'Internal','Non Planned',NULL,NULL,@RequiredbyDate1,'Pending Approval',0,getdate(),NULL,NULL,@ProjectNo

IF @comments IS NOT NULL
BEGIN

SELECT @CommentDate=CONVERT(VARCHAR(25), GetDate(),100)
select @User=U.FirstName+' '+U.LastName from Users U where U.USerID=@UserID
set @comments1=' '
set @comments1=@comments1+'<div>  
<b>Changed by '+@User+' on '+@CommentDate+'</b></div> 
<div>  <br /> 
'+ISNULL(@comments,'')+'
</div>'
select @comments,@comments1,@CommentDate,@User


update Tasks set DEscription=@comments1 where TaskID=@p1
END