USE [msdb]
GO

/****** Object:  Job [Sync_BMS]    Script Date: 06/28/2013 10:10:30 ******/
IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'Sync_BMS')
EXEC msdb.dbo.sp_delete_job @job_id=N'e12cc7d4-5397-4b7c-9bfc-fb3b632662ca', @delete_unused_schedule=1
GO

USE [msdb]
GO

/****** Object:  Job [Sync_BMS]    Script Date: 06/28/2013 10:10:30 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 06/28/2013 10:10:31 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Sync_BMS', 
		@enabled=1, 
		@notify_level_eventlog=3, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ISIPL\anjana.rupasinghege', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Sync_BMS]    Script Date: 06/28/2013 10:10:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Sync_BMS', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF EXISTS (select BMS.* from [Ontime].[dbo].Tasks T
RIGHT JOIN 
(SELECT P.ID,P.ProjectNo,P.BudgetOPITdays,P.ProjectTitle
FROM [BMS.ISIPL.LOCAL\SQLEXPRESS].[BMS2012].[dbo].[Projects] P
where P.BudgetOPITdays>0 AND P.ProjectStatus NOT IN (''Closed'',''On Hold'',''Abandoned'')) BMS
ON BMS.ID=T.TaskNumber
where T.TaskNumber IS NULL
)
BEGIN


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[zz_BMS_TASKS]'') AND type in (N''U''))
DROP TABLE zz_BMS_TASKS


select BMS.* 
INTO zz_BMS_TASKS
from [Ontime].[dbo].Tasks T
RIGHT JOIN 
(SELECT P.ID,P.ProjectNo,P.BudgetOPITdays,P.ProjectTitle,U.Username
FROM [BMS.ISIPL.LOCAL\SQLEXPRESS].[BMS2012].[dbo].[Projects] P
INNER JOIN [BMS.ISIPL.LOCAL\SQLEXPRESS].[BMS2012].[dbo].[Users] U ON P.Project_User=U.ID
where P.BudgetOPITdays>0 AND P.ProjectStatus NOT IN (''Closed'',''On Hold'',''Abandoned'')
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
select @ProjectTitle=@ProjectTitle+''-''+AccDEscription from isipl_projects where AccCode=@ProjectNo
SET @BudgetOPITdays=@BudgetOPITdays*24

select @UserID=UserID from users where LoginID=@Acountmgr
select @ID,@ProjectNo,@BudgetOPITdays,@ProjectTitle

exec spI_Tasks @TaskId=@p1 output,@LastUpdated=@p2 output,
@SubitemType=@p3 output,@TaskNumber=@ID,
@Name=@ProjectTitle,@Description=N''<div><b> </b></div>'',
@Notes=N'''',
@CategoryTypeId=0,
@PriorityTypeId=3,
@ProjectId=124,
@StartDate=''1899-01-01 00:00:00'',
@DueDate=''1899-01-01 00:00:00'',
@CompletionDate=''1899-01-01 00:00:00'',
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


select @Custom_249 = AccCode+''-''+AccDescription from isipl_projects where AccCode=@ProjectNo


INSERT INTO TaskCustomFields
select @p1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''Pending Approval'',NULL,getdate(),NULL,NULL,@Custom_249

select @p1

FETCH NEXT FROM theCursor3 INTO @ID 
END
CLOSE theCursor3
DEALLOCATE theCursor3


END

', 
		@database_name=N'Ontime', 
		@output_file_name=N'C:\AJ\BMS_Tasks', 
		@flags=2
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'BMS_SYNC', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=4, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130628, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'22239fa3-322b-4263-8702-5a61413a0408'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


