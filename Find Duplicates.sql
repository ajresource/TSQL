--DROP TABLE zz_Dup_Projtask

--SELECT EqpProjId, Task_Header_Id 
 
--FROM tblProjTasks 
--GROUP BY EqpProjId, Task_Header_Id 
--having COUNT(*)>1
--ORDER BY COUNT(*) DESc

SELECT PJ.ProjTaskId,PJ.EqpProjId,PJ.ComponentCodeId,PJ.ModifierId,PJ.ApplicationCodeId, PJ.TaskTypeId,PJ.Task_Header_Id, PJ.ProjTotal,PJ.ProjTotalEsc FROM tblProjtasks PJ INNER JOIN 
zz_Dup_Projtask DUP ON PJ.Task_Header_Id=DUP.Task_Header_Id AND PJ.EqpProjId=DUP.EqpProjId
ORDER BY PJ.EqpProjId,PJ.ComponentCodeId,PJ.ModifierId,PJ.ApplicationCodeId, PJ.TaskTypeId,PJ.Task_Header_Id


SELECT PT.EqpProjId, PT.Task_Header_Id , EH.Branch, EH.Site, EH.Fleet, EH.EqpPlan, EH.ProjName, TH.Description, TH.Component_Code, TH.Modifier_Code, TH.Task_Type, TH.Application_Code AS TaskCounter
 , PT.Frequency, PT.First, PT.ProjTotal
FROM tblProjTasks PT
INNER JOIN EQUIPMENT_HIERARCHY_V EH ON EH.EqpProjid = PT.EqpProjId
INNER JOIN TASK_HEADER TH ON TH.Task_Header_Id = PT.Task_Header_Id
 
 INNER JOIN 
 (
 SELECT EqpProjId, Task_Header_Id 
 
FROM tblProjTasks 
GROUP BY EqpProjId, Task_Header_Id 
having COUNT(*)>1 AND MIN(Frequency) = Max(Frequency)
) A  ON A.EqpProjId = PT.EqpProjId AND A.Task_Header_Id = PT.Task_Header_Id
ORDER BY  EH.Branch, EH.Site, EH.Fleet, EH.EqpPlan, EH.ProjName, TH.Description



SELECT PT.EqpProjId, PT.Task_Header_Id , EH.Branch, EH.Site, EH.Fleet, EH.EqpPlan, EH.ProjName, TH.Description, TH.Component_Code, TH.Modifier_Code, TH.Task_Type, TH.Application_Code AS TaskCounter
 , PT.Frequency, PT.First, PT.ProjTotal
FROM tblProjTasks PT
INNER JOIN EQUIPMENT_HIERARCHY_V EH ON EH.EqpProjid = PT.EqpProjId
INNER JOIN TASK_HEADER TH ON TH.Task_Header_Id = PT.Task_Header_Id
 
 INNER JOIN 
 (
 SELECT EqpProjId, Task_Header_Id 
 
FROM tblProjTasks 
GROUP BY EqpProjId, Task_Header_Id 
having COUNT(*)>1 AND MIN(Frequency) <> Max(Frequency)
) A  ON A.EqpProjId = PT.EqpProjId AND A.Task_Header_Id = PT.Task_Header_Id
ORDER BY  EH.Branch, EH.Site, EH.Fleet, EH.EqpPlan, EH.ProjName, TH.Description


--SELECT * FROM tblWorkorderProjs
--WHERE ProjTaskId 
--IN 
--(
-- SELECT MIN(ProjTaskId)
 
--FROM tblProjTasks 
--GROUP BY EqpProjId, Task_Header_Id 
--having COUNT(*)>1 AND MIN(Frequency) <> Max(Frequency)
--UNION ALL
-- SELECT Max(ProjTaskId)
 
--FROM tblProjTasks 
--GROUP BY EqpProjId, Task_Header_Id 
--having COUNT(*)>1 AND MIN(Frequency) <> Max(Frequency)
--)




--SELECT * FROM tblWorkorderProjs
--WHERE ProjTaskId 
--IN 
--(
-- SELECT MIN(ProjTaskId)
 
--FROM tblProjTasks 
--GROUP BY EqpProjId, Task_Header_Id 
--having COUNT(*)>1 AND MIN(Frequency) = Max(Frequency)
--UNION ALL
-- SELECT Max(ProjTaskId)
 
--FROM tblProjTasks 
--GROUP BY EqpProjId, Task_Header_Id 
--having COUNT(*)>1 AND MIN(Frequency) = Max(Frequency)
--)
