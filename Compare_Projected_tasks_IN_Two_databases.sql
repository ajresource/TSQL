Select * from (
select PJ.ProjTaskId,EQ.EqpPlan,TH.Component_Code,TH.Modifier_Code,TH.Task_Type,TH.Application_Code, C.Currency,TH.Description,EQ.Eqp_Terminated  from BUCCAN..tblProjTasks PJ
inner join tblProjTaskOpts PTO ON PJ.ProjTaskId=PTO.ProjTaskId
inner join tblProjTaskAmts PTA ON PTO.ProjTaskOptId=PTA.ProjTaskOptId
inner join BUCCAN..TASK_HEADER TH on PJ.Task_Header_Id=TH.Task_Header_Id
inner join BUCCAN..EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjId=PJ.EqpProjId
inner join BUCCAN..tblCurrencies C ON PTA.CurrencyId=C.CurrencyID
where EQ.Projection_Type_ID IN (5) AND PJ.TaskTypeId<>1 ) A
LEFT JOIN 
(
select EQ.EqpPlan,TH.Component_Code,TH.Modifier_Code,TH.Task_Type,TH.Application_Code from FINCAN..tblProjTasks PJ
inner join FINCAN..TASK_HEADER TH on PJ.Task_Header_Id=TH.Task_Header_Id
inner join FINCAN..EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjId=PJ.EqpProjId
 ) B
ON A.EqpPlan=B.EqpPlan AND A.Component_Code=B.Component_Code AND A.Modifier_Code=B.Modifier_Code
AND A.Task_Type=B.Task_Type AND A.Application_Code=B.Application_Code
WHERE B.EqpPlan IS NULL AND A.Currency='CAD'