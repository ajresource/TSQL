select EQ.EqpPlan,PT.Projection_Type_Name,PJ.ProjTaskID,CC.Code AS Component_Code,MC.Code AS Modifier_Code,TT.Code as Task_Type,AC.Code AS Task_Counter from tblProjTasks PJ
INNER JOIN tblProjTaskOpts PTO ON PJ.ProjTaskId=PTO.ProjTaskId
inner join tblProjTaskAmts PTA ON PTO.ProjTaskOptId=PTA.ProjTaskOptId
inner join tblPricedJobs PJS ON PTA.PricedJobId=PJS.PricedJobId
inner join tblStdJobs SJ ON PJS.StdJobId=SJ.StdJobId
inner join tblComponentCodes CC ON PJ.ComponentCodeId=CC.ComponentCodeID
inner join tblModifierCodes MC ON PJ.ModifierId=MC.ModifierID
inner join tblTaskTypes TT ON PJ.TaskTypeId=TT.TaskTypeID
inner join tblApplicationCodes AC ON PJ.ApplicationCodeId=AC.ApplicationCodeID
inner join EQUIPMENT_HIERARCHY_V EQ ON PJ.EqpProjId=EQ.EqpProjId
inner join PROJECTION_TYPE PT ON PT.Projection_Type_ID=EQ.Projection_Type_ID
where SJ.Cab_Type_ID=0
order by EQ.EqpPlan