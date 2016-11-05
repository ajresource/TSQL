IF EXISTS (select BMS.* from [Ontime].[dbo].Tasks T
RIGHT JOIN 
(SELECT P.ID,P.ProjectNo,P.BudgetOPITdays,P.ProjectTitle
FROM [BMS.ISIPL.LOCAL\SQLEXPRESS].[BMS2012].[dbo].[Projects] P
where P.BudgetOPITdays>0 AND P.ProjectStatus NOT IN ('Closed','On Hold','Abandoned')) BMS
ON BMS.ID=T.TaskNumber
where T.TaskNumber IS NULL
)
BEGIN


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zz_BMS_TASKS]') AND type in (N'U'))
DROP TABLE zz_BMS_TASKS


select BMS.* 
INTO zz_BMS_TASKS
from [Ontime].[dbo].Tasks T
RIGHT JOIN 
(SELECT P.ID,P.ProjectNo,P.BudgetOPITdays,P.ProjectTitle,U.Username
FROM [BMS.ISIPL.LOCAL\SQLEXPRESS].[BMS2012].[dbo].[Projects] P
INNER JOIN [BMS.ISIPL.LOCAL\SQLEXPRESS].[BMS2012].[dbo].[Users] U ON P.Project_User=U.ID
where P.BudgetOPITdays>0 AND P.ProjectStatus NOT IN ('Closed','On Hold','Abandoned')
) BMS
ON BMS.ID=T.TaskNumber
where T.TaskNumber IS NULL

	 
declare @p1 int
set @p1=NULL
declare @p2 binary(8)
set @p2=NULL
declare @p3 int
set @p3=NULL

DECLARE @Today datetime
DECLARE @ID INT
DECLARE @ProjectNo VARCHAR(10)
DECLARE @BudgetOPITdays REAL
DECLARE @ProjectTitle VARCHAR(MAX)
DECLARE @Custom_249 VARCHAR(50)
DECLARE @Acountmgr VARCHAR(255)

DECLARE @UserID INT


DECLARE theCursor3 CURSOR FOR

select ID from zz_BMS_TASKS

OPEN theCursor3
FETCH NEXT FROM theCursor3 INTO @ID 
WHILE @@fetch_status = 0
BEGIN 

select @Today=getdate()
select @ProjectNo=ZZ.ProjectNo,@BudgetOPITdays=ZZ.BudgetOPITdays,@ProjectTitle=ZZ.ProjectTitle,@Acountmgr=ZZ.Username from zz_BMS_TASKS ZZ where ID=@ID
select @ProjectTitle=@ProjectTitle+'-'+AccDEscription from isipl_projects where AccCode=@ProjectNo
SET @BudgetOPITdays=@BudgetOPITdays*24

select @UserID=UserID from users where LoginID=@Acountmgr
select @ID,@ProjectNo,@BudgetOPITdays,@ProjectTitle

exec spI_Tasks @TaskId=@p1 output,@LastUpdated=@p2 output,
@SubitemType=@p3 output,@TaskNumber=@ID,
@Name=@ProjectTitle,@Description=N'<div><b> </b></div>',
@Notes=N'',
@CategoryTypeId=0,
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
@EstimatedDuration=@BudgetOPITdays,
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


select @Custom_249 = AccCode+'-'+AccDescription from isipl_projects where AccCode=@ProjectNo


INSERT INTO TaskCustomFields
select @p1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Pending Approval',NULL,getdate(),NULL,NULL,@Custom_249

select @p1

FETCH NEXT FROM theCursor3 INTO @ID 
END
CLOSE theCursor3
DEALLOCATE theCursor3


END

