select  B.WorkOrderID,B.WorkorderNumber,
B.AMTJobStatus_ID as AMT_87,A.AMTJobStatus_ID AS TMS
INTO zz_WOSupdate
from TMS_AMT_Toll..tblWorkOrders A  
inner join isipl_AMT_Toll_87_20130918..tblWorkOrders B ON A.EqpplanID=B.EqpPlanID AND A.Task_Header_ID=B.Task_Header_ID 
AND A.WorkOrderNumber=B.WorkOrderNumber
where A.LastModDate > '2013-09-05 12:05:00' AND  B.LastModDate<'2013-09-12 22:30:00'
AND 
 A.AMTJobStatus_ID<>B.AMTJobStatus_ID
 AND A.AMTJobStatus_ID IN (2,1)
 AND  B.AMTJobStatus_ID NOT IN (2)
 

UPDATE B
SET B.AMTJobStatus_ID=A.AMTJobStatus_ID
from TMS_AMT_Toll..tblWorkOrders A  
inner join isipl_AMT_Toll_87_20130918..tblWorkOrders B ON A.EqpplanID=B.EqpPlanID AND A.Task_Header_ID=B.Task_Header_ID 
AND A.WorkOrderNumber=B.WorkOrderNumber
where A.LastModDate > '2013-09-05 12:05:00' AND  B.LastModDate<'2013-09-12 22:30:00'
AND 
 A.AMTJobStatus_ID<>B.AMTJobStatus_ID
 AND A.AMTJobStatus_ID IN (2,1)
 AND  B.AMTJobStatus_ID NOT IN (2)
 