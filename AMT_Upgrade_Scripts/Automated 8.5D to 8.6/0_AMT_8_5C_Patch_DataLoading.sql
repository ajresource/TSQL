

/***************************************************************************************************************

	0_AMT_85C_Patch_DataLoading

	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
08 May 12	SD			E810 Add AMT SYSTEM TASK: Auto Create External Workorders
03 May 12	VV			E806 Amt_System_Task
01 May 12	KN			E809 DataFix Script to fix the sort order of historical DTA's
 1 May 12	GD			E786 
26-04-12	VV			E799 UpdateAdvancedSchedulingLogic in AMT_TYPED_VARIABLE

*END OF HISTORY*************************************************************************************************************/

IF NOT EXISTS(select * from AMT_SYSTEM_TASK where Task_Name='Autocreate Planned Events/Workorders')
BEGIN
	INSERT INTO AMT_SYSTEM_TASK(Task_Name, Task_Desc, is_Auto_Run, Start_Time, Frequency, 
	Frequency_UOM_Id, Last_Run_Time, is_System_Task, is_One_Run_Task, Priority,    Thread_Id, SQL_Routine)
	SELECT
	'Autocreate Planned Events/Workorders' AS Task_Name, 'Autocreate Planned Events/Workorders' AS Task_Desc, 
	0 AS is_Auto_Run, CAST('19500101' AS datetime) AS Start_Time, 1 AS Frequency, 
	4 AS Frequency_UOM_Id, NULL AS Last_Run_Time, 1 AS is_System_Task, 0 AS is_One_Run_Task, 3 AS Priority,
	0 AS Thread_Id, 'AUTOCREATE_PLANNED_EVENTS_P' AS SQL_Routine

END
GO

/*E810*/
IF NOT EXISTS(select * from AMT_SYSTEM_TASK where Task_Name='Auto Create External Workorders')
BEGIN
	INSERT INTO AMT_SYSTEM_TASK(Task_Name, Task_Desc, is_Auto_Run, Start_Time, Frequency, 
	Frequency_UOM_Id, Last_Run_Time, is_System_Task, is_One_Run_Task, Priority,    Thread_Id, SQL_Routine)
	SELECT
		'Auto Create External Workorders' AS Task_Name, 
		'Auto Create External Workorders' AS Task_Desc, 
		0 AS is_Auto_Run, 
		CAST('19500101' AS datetime) AS Start_Time, 
		20 AS Frequency, 
		2 AS Frequency_UOM_Id, 
		NULL AS Last_Run_Time, 
		1 AS is_System_Task, 
		0 AS is_One_Run_Task, 
		3 AS Priority,
		0 AS Thread_Id, 
		'External.AutocreateExternalWorkorders' AS SQL_Routine
END
GO

IF NOT EXISTS(SELECT Varchar_Value FROM AMT_TYPED_VARIABLE WHERE Value_Name = 'UpdateAdvancedSchedulingLogic')
	INSERT INTO AMT_TYPED_VARIABLE( Value_Name,Varchar_Value ) VALUES('UpdateAdvancedSchedulingLogic',1)

GO

 --GD E786 18/04/12
 IF NOT EXISTS (SELECT * FROM IMPORT_SOURCE WHERE [ImportSourceId]=2)

           INSERT INTO [dbo].[IMPORT_SOURCE]
           ([ImportSourceId]
           ,[ImportSourceName])
     VALUES
           (2,'WebService')
           
GO

 
Update DTA
SET
	DTA.Sort_Order = A.NewSortOrder
FROM  DOWN_TIME_ALLOCATION DTA
INNER JOIN 
(
SELECT 
	Event_Id,
	Down_Time_Allocation_ID, 
	Sort_order,
	ROW_NUMBER() OVER(PARTITION BY Event_ID ORDER BY Event_ID, ISNULL(Sort_order,0) ,Primary_DTA, Down_Time_Allocation_ID DESC ) -1 As NewSortOrder
FROM DOWN_TIME_ALLOCATION
) A 
ON A.Down_Time_Allocation_ID = DTA.Down_Time_Allocation_ID

GO
