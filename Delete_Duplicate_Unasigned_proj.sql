	 
DECLARE @ProjTaskId INT

DECLARE theCursor3 CURSOR FOR	

select 
min(pt.ProjTaskId) 
from
EQUIPMENT_HIERARCHY_V eh
inner join
tblProjTasks pt
on eh.EqpProjId=pt.EqpProjId
inner join
tblComponentCodes CC
on pt.ComponentCodeId=CC.ComponentCodeId
inner join
tblSubSystems SS
on pt.ComponentCodeId=SS.UnsCompCodeID
group by

eh.EqpPlanId,eh.EqpPlan,eh.ProjName,eh.Projection_Type_Name,CC.SubSystemID,pt.eqpProjid

,
SS.SubSystem,CC.Code
having COUNT(pt.ProjTaskId)>1
order by SS.SubSystem,eh.EqpPlan,eh.Projection_Type_Name,eh.ProjName

 
OPEN theCursor3
FETCH NEXT FROM theCursor3 INTO @ProjTaskId 
WHILE @@fetch_status = 0
BEGIN 
  Exec usp_Delete_Proj_Task @projTaskID= @ProjTaskId,@forceDelete = 1
  
  select @projTaskID
	 
FETCH NEXT FROM theCursor3 INTO @ProjTaskId 
END
CLOSE theCursor3
DEALLOCATE theCursor3
