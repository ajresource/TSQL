update TASK
set Task_Mode_ID=2 where Task_Mode_ID=1

	 
DECLARE @TaskId INT

DECLARE WOCR CURSOR FOR

select Task_ID from TASK WHERE Work_Order IS NULL 

 
OPEN WOCR
FETCH NEXT FROM WOCR INTO @TaskId 
WHILE @@fetch_status = 0
BEGIN 

EXEC  TASK_AUTO_CREATE_WO_P @TaskID=@TaskId

 
FETCH NEXT FROM WOCR INTO @TaskId 
END
CLOSE WOCR
DEALLOCATE WOCR
