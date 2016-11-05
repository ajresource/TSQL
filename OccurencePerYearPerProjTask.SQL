select EQ.EqpPlan,EQ.ProjName,TH.Description,A.Yr,A.Cnt from tblProjTasks PT 
INNER JOIN
(select  PTO.ProjTaskId,YEAR(OccDate) AS Yr,COUNT(*) as Cnt from tblProjTasks PT
INNER JOIN tblProjTaskOccs PTO ON PT.ProjTaskId=PTO.ProjTaskId
group by PTO.ProjTaskId, YEAR(OccDate)) A ON PT.ProjTaskId=A.ProjTaskId
INNER JOIN TASK_HEADER TH ON TH.Task_HEader_ID=PT.Task_HEader_ID
INNER JOIN EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjId=PT.EqpProjID
where A.Cnt>400
order by  EQ.EqpPlan,EQ.ProjName,TH.Description,A.Yr,A.Cnt