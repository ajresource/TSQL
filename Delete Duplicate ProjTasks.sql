	 
DECLARE @ProjTaskId INT

DECLARE theCursor3 CURSOR FOR	

SELECT ProjTaskId AS ProjTaskId FROM tblProjTasks PJ
inner join TASK_HEADER TH ON PJ.Task_Header_ID=TH.Task_Header_ID
Where TH.Modifier_Code='0'


 
OPEN theCursor3
FETCH NEXT FROM theCursor3 INTO @ProjTaskId 
WHILE @@fetch_status = 0
BEGIN 
  Exec usp_Delete_Proj_Task @projTaskID= @ProjTaskId,@forceDelete = 1
	 
FETCH NEXT FROM theCursor3 INTO @ProjTaskId 
END
CLOSE theCursor3
DEALLOCATE theCursor3
