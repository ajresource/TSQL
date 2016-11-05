
declare @Message varchar(1000)
declare @WorkOrderId int

--select the records to be deleted
  SELECT       
   WorkOrderId  
  FROM           
   tblWorkOrders
  INNER JOIN 
   tblTaskTypes
  ON
   tblWorkorders.TaskTypeId = tblTaskTypes.TaskTypeID
  WHERE
   tblTaskTypes.Code = 'DL'


DECLARE cDelWorkOrder CURSOR READ_ONLY  
  FOR  
  SELECT       
   WorkOrderId  
  FROM           
   tblWorkOrders
  INNER JOIN 
   tblTaskTypes
  ON
   tblWorkorders.TaskTypeId = tblTaskTypes.TaskTypeID
  WHERE
   tblTaskTypes.Code = 'DL'

OPEN cDelWorkOrder  
FETCH NEXT FROM cDelWorkOrder INTO @WorkOrderID  

WHILE @@Fetch_Status = 0  
BEGIN  
	if (isnull(@WorkOrderID,0) <> 0)
	BEGIN
		exec usp_Del_WorkOrder
		NULL,
		@WorkOrderID,
		0,
		@Message OUTPUT

		print @message
	END

	FETCH NEXT FROM cDelWorkOrder INTO @WorkOrderID  
END

--close and deallocate the cursor  
CLOSE cDelWorkOrder  
DEALLOCATE cDelWorkOrder  


