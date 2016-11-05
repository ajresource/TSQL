select EQ.Branch,EQ.Site,EQ.Fleet,EQ.EqpPlan,TH.Description AS Proj_Task_Header, CC.Code AS ComponentCode, CC.Description AS Component_Code_Description,SJ.StdJob,
CASE SJ.Live_job 
	WHEN 0 THEN 'Fixed'
	When 1 THEN 'Live'
END AS Job
from tblstdJobs SJ
inner join tblPricedjobs PJ on SJ.StdJobid=PJ.StdJobid
inner join tblProjtaskAmts PJA ON PJA.PricedJobId=PJ.PricedJobId
inner join tblProjtaskOpts PJO ON PJO.ProjTaskOptid=PJA.ProjTaskOptid
inner join tblProjtasks PJS on PJS.ProjtaskID=PJO.ProjTaskID
inner join EQUIPMENT_HIERARCHY_V EQ on EQ.EqpPlanID=PJS.EqpPlanID
inner join tblComponentcodes CC ON CC.ComponentCodeID= PJS.ComponentCOdeID 
inner join TASK_HEADER TH ON TH.Task_Header_Id=PJS.Task_Header_Id
where SJ.Live_job=0
order by EQ.EqpPlan

--select top 10 * from TASK_HEADER
