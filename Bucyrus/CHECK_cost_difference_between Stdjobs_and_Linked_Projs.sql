select EQ.Branch,EQ.Site,EQ.Fleet,EQ.Eqpplan,
TH.DEscription AS Strategy_Task,
SJ.Std_Job_Ref,JC.Code AS Job_Code,
PTA.PartsCost AS Strategy_Parts,
SJ.Parts_Cost AS Std_Parts,
PTA.LaborCost AS Strategy_Labour,
SJ.Labour_Cost AS Std_Labour,
PTA.MiscCost AS Strategy_Misc,
SJ.Misc_Cost AS Std_Misc 
from tblProjTasks PT
inner join tblProjTaskOpts PTO ON PT.ProjTaskID=PTO.ProjTaskID
inner join tblProjTaskAmts PTA ON PTA.ProjTaskOptID=PTO.ProjTaskOptID
inner join tblPricedjobs PJ ON PJ.PricedJobID=PTA.PricedJobID
inner join tblStdjobs SJ ON PJ.StdJobID=SJ.StdJobID
inner join TASK_HEADER TH ON TH.Task_Header_ID=PT.Task_Header_ID
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpprojID=PT.EqpprojID
inner join tblJobCodes JC ON JC.JobCodeID=PTA.JobCodeID
where (PTA.PartsCost<>SJ.PArts_Cost OR 
PTA.LaborCost<>SJ.LAbour_COst OR
PTA.MiscCost<>SJ.Misc_Cost) AND EQ.Projection_Type_ID=1
order by EQ.Eqpplan,TH.DEscription,SJ.Std_Job_Ref


--select * from tblProjTaskAMts