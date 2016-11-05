	 
DECLARE @EqpPlanId INT

DECLARE theCursor3 CURSOR FOR	
 
select EqpplanID from EQUIPMENT_HIERARCHY_V where Site='Sadiola-Sadiola' AND projection_Type_ID=1
AND EqpplanID NOT IN (868,870)

OPEN theCursor3
FETCH NEXT FROM theCursor3 INTO @EqpPlanId 
WHILE @@fetch_status = 0
BEGIN 

declare @p4 varchar(500)
set @p4=NULL
exec PH_TRANSACTION_DELETE_P @EqpPlanId=@EqpPlanId,
@StartPeriodDateTime='2012-12-01 00:00:00',
@EndPeriodDateTime='2012-12-31 00:00:00',@Message=@p4 output
select @p4

FETCH NEXT FROM theCursor3 INTO @EqpPlanId 
END
CLOSE theCursor3
DEALLOCATE theCursor3
