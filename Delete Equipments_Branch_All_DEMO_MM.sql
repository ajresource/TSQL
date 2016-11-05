

DELETE   FROM  dbo.DEFERRED_TASK
DELETE     FROM dbo.TASK_OPERATION_LABOUR
DELETE   FROM  dbo.TASK_OPERATION_MISC
DELETE   FROM  dbo.TASK_OPERATION_PART
delete from dbo.TIMESHEET
DELETE   FROM  dbo.TASK_OPERATION
DELETE   FROM  dbo.TASK_DOCUMENT
DELETE FROM dbo.PURCHASE_ORDER
DELETE   FROM  dbo.TASK

---- DELETE DOWNTIME


DELETE   FROM   dbo.DOWN_TIME_ALLOCATION
DELETE   FROM  dbo.EVENT
DELETE FROM AGREEMENT_PART_PRICE

--- DELETE HISTORY

DELETE   FROM  dbo.tblWorkOrderSettlements
DELETE   FROM  dbo.tblWorkOrderOperations
DELETE   FROM  dbo.tblWorkOrderInvoices
DELETE	 FROM tblWorkOrderProjs 
DELETE   FROM  dbo.tblWorkOrders

-- DELETE USAGES 


DELETE FROM tblEqpPlanStartUsages
DELETE   FROM dbo.tblActualUsages
DELETE  FROM  dbo.tblRepUsages
DELETE from SCHEDULING_TASK
DELETE from PH_TRANSACTION_PROJECT
DELETE  FROM  dbo.tblRepActualCosts
DELETE  FROM  dbo.tblRepActualCosts_EqpProj
DELETE  FROM  dbo.tblRepBilling
DELETE  FROM  dbo.tblRepProjCosts
DELETE  FROM  dbo.tblRepProjCosts_EqpProj
DELETE  FROM  dbo.tblRepUsages

--------------------------------------DELETE ALL EQUIPMENT FROM BRANCH 'RUBISH BIN'----------------------------

SET NOCOUNT ON
GO

drop table #TobeDeleted 
DECLARE @Message VARCHAR(MAX)
DECLARE @MaxPlanningWOtoCreate int

SELECT @MaxPlanningWOtoCreate=ISNULL(Varchar_Value,1) FROM AMT_TYPED_VARIABLE WHERE Value_Name ='MaxPlanningWOtoCreate'
UPDATE AMT_TYPED_VARIABLE SET Varchar_Value = 0 WHERE Value_Name ='MaxPlanningWOtoCreate'

---SELECT * FROM tblBranches
SELECT EqpPlanId,FleetId,SiteId, BranchId
INTO #TobeDeleted 
FROM EQUIPMENT_HIERARCHY_V
--WHERE BranchId=24


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
		--PRINT @EquipmentId
		IF EXISTS (SELECT * FROM tblWorkOrders WHERE EqpPlanId=@EquipmentId)
		BEGIN
			DELETE FROM tblWorkOrderProjs WHERE WorkOrderId IN ( SELECT WorkorderId From tblWorkorders WHERE EqpPlanId = @EquipmentId)
			DELETE FROM tblWorkOrderInvoices WHERE WorkOrderId IN ( SELECT WorkorderId From tblWorkorders WHERE EqpPlanId = @EquipmentId)
			DELETE FROM tblWorkOrderOperations WHERE WorkOrderId IN ( SELECT WorkorderId From tblWorkorders WHERE EqpPlanId = @EquipmentId)
			DELETE FROM tblWorkOrderSettlements WHERE WorkOrderId IN ( SELECT WorkorderId From tblWorkorders WHERE EqpPlanId = @EquipmentId)
			DELETE FROM tblWorkorders WHERE EqpPlanId  = @EquipmentId
		END
		IF EXISTS (SELECT * FROM tblActualBillings WHERE EqpPlanID=@EquipmentId)
			BEGIN
			DELETE FROM tblActualBillings WHERE EqpPlanID = @EquipmentId
			END
			
		UPDATE tblEqpPlans SET ParentEqpPlanId = NULL WHERE ParentEqpPlanId = @EquipmentId
	
	DELETE  FROM dbo.MESSAGE_CMMEASUREMENT WHERE CMMeasurementID IN
	(SELECT CMMeasurementID FROM dbo.CM_MEASUREMENT WHERE EqpPlanId=@EquipmentId)
		DELETE FROM AR_TRANSACTION WHERE Eqp_Plan_Id=@EquipmentId
		DELETE FROM CM_MEASUREMENT WHERE EqpPlanId=@EquipmentId
		
		

		DELETE FROM PH_TRANSACTION_PROJECT WHERE PH_Tran_Header_Id IN 
		(
		SELECT PH_Tran_Header_Id  FROM PH_TRANSACTION_HEADER WHERE Eqp_Plant_Hire_Id IN 
		(SELECT Eqp_Plant_Hire_Id FROM PH_EQP_PLANT_HIRE WHere Eqp_Plan_id = @EquipmentId)
		)

	DELETE  FROM dbo.PH_PLANT_HIRE_RATE_DETAIL WHERE Plant_Hire_Rate_Id IN
	(SELECT Plant_Hire_Rate_Id FROM dbo.PH_EQP_PLANT_HIRE WHERE Eqp_Plan_id=@EquipmentId)
		
		delete FROM PH_TRANSACTION_USAGE WHERE PH_Tran_Header_Id IN
		(SELECT PH_Tran_Header_Id FROM PH_TRANSACTION_HEADER WHERE Plant_Hire_Rate_Id IN
	(SELECT Plant_Hire_Rate_Id FROM dbo.PH_EQP_PLANT_HIRE WHERE Eqp_Plan_id=@EquipmentId))
	
	DELETE FROM dbo.PH_REVENUE_ANALYSIS WHERE PHTransCostId IN
(SELECT PH_Trans_Cost_Id FROM  PH_TRANSACTION_COST WHERE PH_Tran_Header_Id IN
		(SELECT PH_Tran_Header_Id FROM PH_TRANSACTION_HEADER WHERE Plant_Hire_Rate_Id IN
	(SELECT Plant_Hire_Rate_Id FROM dbo.PH_EQP_PLANT_HIRE WHERE Eqp_Plan_id=@EquipmentId)))
	
		delete FROM PH_TRANSACTION_COST WHERE PH_Tran_Header_Id IN
		(SELECT PH_Tran_Header_Id FROM PH_TRANSACTION_HEADER WHERE Plant_Hire_Rate_Id IN
	(SELECT Plant_Hire_Rate_Id FROM dbo.PH_EQP_PLANT_HIRE WHERE Eqp_Plan_id=@EquipmentId))
	
	
	
	DELETE  FROM dbo.PH_TRANSACTION_HEADER WHERE Plant_Hire_Rate_Id IN
	(SELECT Plant_Hire_Rate_Id FROM dbo.PH_EQP_PLANT_HIRE WHERE Eqp_Plan_id=@EquipmentId)
		
		DELETE  FROM dbo.PH_PROJECT_CHARGE_SIMULATOR WHERE Plant_Hire_Rate_Id IN
	(SELECT Plant_Hire_Rate_Id FROM dbo.PH_EQP_PLANT_HIRE WHERE Eqp_Plan_id=@EquipmentId)
	
		DELETE FROM PH_PLANT_HIRE_RATE WHERE Eqp_Plant_Hire_Id IN 
		(SELECT Eqp_Plant_Hire_Id FROM PH_EQP_PLANT_HIRE WHere Eqp_Plan_id = @EquipmentId)
	

		DELETE FROM PH_TRANSACTION_HEADER WHERE Eqp_Plant_Hire_Id IN 
		(SELECT Eqp_Plant_Hire_Id FROM PH_EQP_PLANT_HIRE WHere Eqp_Plan_id = @EquipmentId)

		DELETE FROM PH_EQP_PLANT_HIRE WHere Eqp_Plan_id = @EquipmentId
 
		
		DELETE FROM MESSAGE_GROUP_LIST WHERE MessageID IN ( SELECT MessageID FROM MESSAGE WHERE StrategyTaskID IN (SELECT ProjTaskId from tblProjTasks WHERE EqpPlanId = @EquipmentId))
		DELETE FROM MESSAGE WHERE StrategyTaskID IN (SELECT ProjTaskId from tblProjTasks WHERE EqpPlanId = @EquipmentId)
		DELETE FROM CBM_FAILURE_MODE_ASSESSMENT WHERE ProjTaskId IN (SELECT ProjTaskId from tblProjTasks WHERE EqpPlanId = @EquipmentId)
		DELETE FROM PRODUCTION_STATISTICS_DATA WHERE EqpPlanId = @EquipmentId
		
		EXEC EQP_PLAN_DELETE_P @EqpPlanID= @EquipmentId, @Message=@Message OUTPUT
		
		IF ISNULL(@Message,'') <> ''
			PRINT CONVERT(VARCHAR(100),@EquipmentId) + ' = ' + @Message
			
	FETCH NEXT FROM CurEqp INTO @EquipmentId
END
CLOSE CurEqp
DEALLOCATE CurEqp
 
 
UPDATE AMT_TYPED_VARIABLE SET Varchar_Value = @MaxPlanningWOtoCreate WHERE Value_Name ='MaxPlanningWOtoCreate'

--DROP TABLE #TobeDeleted

DELETE FROM tblProjBillings WHERE ProjBillingId IN
(	SELECT PB.ProjBillingId FROM dbo.tblProjBillings PB INNER JOIN
	tblEqpProjs EP ON PB.EqpProjId=EP.EqpProjId 
	)
	
	
DELETE FROM tblProjBillingAmounts WHERE ProjBillingAmountId IN (
	SELECT ProjBillingAmountId  FROM dbo.tblProjBillingAmounts PBA INNER JOIN
	dbo.tblProjBillings PB ON PBA.ProjBillingID=PB.ProjBillingId INNER JOIN
	tblEqpProjs EP ON PB.EqpProjId=EP.EqpProjId 
	)