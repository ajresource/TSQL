SET NOCOUNT ON
GO

 
DECLARE @Message VARCHAR(MAX)
DECLARE @MaxPlanningWOtoCreate int

SELECT @MaxPlanningWOtoCreate=ISNULL(Varchar_Value,1) FROM AMT_TYPED_VARIABLE WHERE Value_Name ='MaxPlanningWOtoCreate'

SELECT EqpPlanId,FleetId,SiteId, BranchId
INTO #TobeDeleted 
FROM EQUIPMENT_HIERARCHY_V
WHERE Projection_Type_ID=1 AND
EqpPlan IN ('708')


DECLARE @EventId INT
DECLARE @Error INT
DECLARE CurEVENT CURSOR FAST_FORWARD FOR
SELECT Event_ID From EVENT WHERE Eqp_Plan_Id IN (SELECT EqpPlanID FROM #TobeDeleted)
OPEN CurEVENT
FETCH NEXT FROM CurEVENT INTO @EventId
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT 'here'
	SET @Message = ''			
	EXEC EVENT_DELETE_P @Event_ID= @EventId,@Error=@Error, @Error_Message=@Message OUTPUT
	IF ISNULL(@Message,'') <> ''
		PRINT @Message
	FETCH NEXT FROM CurEVENT INTO @EventId
END
CLOSE CurEVENT
DEALLOCATE CurEVENT



DECLARE @EquipmentId INT

DECLARE CurEqp CURSOR FAST_FORWARD FOR
SELECT EqpPlanId FROM #TobeDeleted WHERE EqpPlanId IS NOT NULL
OPEN CurEqp
FETCH NEXT FROM CurEqp INTO @EquipmentId
WHILE @@FETCH_STATUS = 0
BEGIN
		SET @Message = ''
	
		IF EXISTS (SELECT * FROM tblWorkOrders WHERE EqpPlanId=@EquipmentId)
		BEGIN
			DELETE FROM tblWorkOrderProjs WHERE WorkOrderId IN ( SELECT WorkorderId From tblWorkorders WHERE EqpPlanId = @EquipmentId)
			DELETE FROM tblWorkOrderInvoices WHERE WorkOrderId IN ( SELECT WorkorderId From tblWorkorders WHERE EqpPlanId = @EquipmentId)
			DELETE FROM tblWorkOrderOperations WHERE WorkOrderId IN ( SELECT WorkorderId From tblWorkorders WHERE EqpPlanId = @EquipmentId)
			DELETE FROM tblWorkOrderSettlements WHERE WorkOrderId IN ( SELECT WorkorderId From tblWorkorders WHERE EqpPlanId = @EquipmentId)
		
				
	IF EXISTS(SELECT  Task_Id FROM TASK WHERE Eqp_Plan_Id=@EquipmentId)    
		BEGIN    
    
		UPDATE MESSAGE    
		SET EQSTaskID=NULL    
    
		FROM    
		[MESSAGE] M    
		INNER JOIN    
		TASK T    
		ON M.EQSTaskID=T.Task_ID    
		 WHERE T.Eqp_Plan_Id=@EquipmentId    

		DECLARE @TaskOperationId varchar(max)    
     
		SET @TaskOperationId=''    
    
		SELECT @TaskOperationId = (SELECT CAST(O.Task_Operation_Id AS varchar)+',' FROM    
		TASK_OPERATION O    
		INNER JOIN    
		TASK T    
		ON O.Task_Id=T.Task_Id    
		WHERE T.Eqp_Plan_Id=@EquipmentId    
		FOR XML PATH('') )    
    
		SET @TaskOperationId=ISNULL(@TaskOperationId,'')    
		IF @TaskOperationId<>''    
		BEGIN    
		EXEC TASK_OPERATION_DELETE_P @idDelete=@TaskOperationId,@Message=@Message OUTPUT    
     
		END    
     

		DELETE PO    
		FROM     
		PURCHASE_ORDER PO    
		 Inner Join    
		TASK T    
		On T.Task_ID=PO.Task_ID    
		 WHERE T.Eqp_Plan_Id=@EquipmentId    
    
		DELETE TD    
		FROM     
		TASK_DOCUMENT TD    
		 Inner Join    
		TASK T    
		On T.Task_ID=TD.Task_ID    
		WHERE T.Eqp_Plan_Id=@EquipmentId    
    
		DELETE TD    
		FROM     
		ATTACHED_DOCUMENT_TASK TD    
		Inner Join    
		TASK T    
		On T.Task_ID=TD.TaskID    
		WHERE T.Eqp_Plan_Id=@EquipmentId    
    
  
		DELETE TD    
		FROM     
		TASK_DOCUMENT TD    
		Inner Join    
		TASK T    
		On T.Task_ID=TD.Task_ID    
		WHERE T.Eqp_Plan_Id=@EquipmentId    
    
		DELETE TD    
		FROM     
		TASK_EXTERNAL_DOCUMENT TD    
		Inner Join    
		TASK T    
		On T.Task_ID=TD.TaskID    
		WHERE T.Eqp_Plan_Id=@EquipmentId    
     
		DELETE TASK WHERE Eqp_Plan_Id=@EquipmentId    

		END 
	DELETE FROM tblWorkorders WHERE EqpPlanId  = @EquipmentId
END 
	
			
	FETCH NEXT FROM CurEqp INTO @EquipmentId
END
CLOSE CurEqp
DEALLOCATE CurEqp
 

DROP TABLE #TobeDeleted