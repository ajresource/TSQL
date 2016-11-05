
--DROP TABLE isipl_amt..zzAJ_projtaskmap_Geita

select B.ProjTaskId as S_projtaskID, A.ProjTaskId AS D_ProjtaskID, B.EqpPlan,B.EqpProjName,B.Component_Code,B.Modifier_Code,B.Task_Type,B.Application_Code,B.Description 
into isipl_amt..zzAJ_projtaskmap_Geita
from
(SELECT  

	EP.EqpPlanId,
	EPL.EqpPlan,
	EP.EqpProjId,
	EP.EqpProjName,
	TH.Component_Code,
	TH.Modifier_Code,
	TH.Application_Code,
	TH.Task_Type,
	TH.Description,
 	PT.ProjTaskId 
 	--INTO zzAJ_DProjTask
 
FROM 
	 isipl_amt..tblProjTasks PT 
INNER JOIN isipl_amt..TASK_HEADER TH ON TH.Task_Header_Id = PT.Task_Header_Id
INNER JOIN isipl_amt..tblEqpProjs EP ON EP.EqpProjId = PT.EqpProjId
INNER JOIN isipl_amt..tblEqpplans EPL ON EPL.EqpPlanId = PT.EqpPlanId
INNER JOIN isipl_amt_Geita..tblEqpplans E ON EPL.EqpPlan = E.EqpPlan 
WHERE EP.Projection_Type_ID = 1  --AND PT.TaskTypeId <> 1
) A

inner JOIN 

(
 SELECT 
 
	EP.EqpPlanId,
	EPL.EqpPlan,
	EP.EqpProjId,
	EP.EqpProjName,
	TH.Component_Code,
	TH.Modifier_Code,
	TH.Application_Code,
	TH.Task_Type,
	TH.Description,
 	PT.ProjTaskId,
 	PT.NextOcc,PT.NextOccDate,PT.Last_Change_Date,PT.Last_Change_Usage, 
 	PT.LastOcc, PT.LastOccDate
	--INTO isipl_amt..zzAJ_SProjTask
FROM isipl_amt_Geita..tblProjTasks PT 
INNER JOIN isipl_amt_Geita..TASK_HEADER TH ON TH.Task_Header_Id = PT.Task_Header_Id
INNER JOIN isipl_amt_Geita..tblEqpProjs EP ON EP.EqpProjId = PT.EqpProjId
INNER JOIN isipl_amt_Geita..tblEqpplans EPL ON EPL.EqpPlanId = PT.EqpPlanId
WHERE EP.Projection_Type_ID = 1 --AND PT.TaskTypeId <> 1
) B 
ON  A.EqpPlan=B.EqpPlan
AND A.Component_Code=B.Component_Code
AND A.Modifier_Code=B.Modifier_Code
AND A.Task_Type=B.Task_Type
AND A.Application_Code=B.Application_Code


---------------------------------------------


update PT
Set PT.AMT_Last_Sched_Date=PT1.AMT_Last_Sched_Date,
PT.AMT_Last_Sched_Occ=PT1.AMT_Last_Sched_Occ,
PT.AMT_WO_Last_Occ=PT1.AMT_WO_Last_Occ,
PT.AMT_WO_Last_Occ_date=PT1.AMT_WO_Last_Occ_date,
PT.NextOcc=PT1.NextOcc,
PT.ReviewDate=PT1.ReviewDate,
PT.ReviewStatusID=PT1.ReviewStatusID
 from isipl_amt..tblProjTasks PT
inner join isipl_amt..zzAJ_projtaskmap_Geita ZZ ON PT.ProjTaskId=ZZ.D_ProjtaskID
inner join isipl_amt_Geita..tblProjTasks PT1 ON PT1.ProjTaskId=ZZ.S_projtaskID
where PT.AMT_Last_Sched_Date<>PT1.AMT_Last_Sched_Date
OR PT.AMT_Last_Sched_Occ<>PT1.AMT_Last_Sched_Occ
OR PT.AMT_WO_Last_Occ<>PT1.AMT_WO_Last_Occ
OR PT.NextOcc<>PT1.NextOcc
OR PT.ReviewDate<>PT1.ReviewDate
OR PT.AMT_WO_Last_Occ_date<>PT1.AMT_WO_Last_Occ_date
OR PT.ReviewStatusID<>PT1.ReviewStatusID



--OR PT.ReviewStatusID<>PT1.ReviewStatusID

select 
 PT.AMT_Last_Sched_Date,PT1.AMT_Last_Sched_Date,
PT.AMT_Last_Sched_Occ,PT1.AMT_Last_Sched_Occ,
PT.AMT_WO_Last_Occ,PT1.AMT_WO_Last_Occ,
PT.AMT_WO_Last_Occ_date,PT1.AMT_WO_Last_Occ_date,
PT.NextOcc,PT1.NextOcc,
PT.ReviewDate,PT1.ReviewDate,
PT.ReviewStatusID,PT1.ReviewStatusID
 from isipl_amt..tblProjTasks PT
inner join isipl_amt..zzAJ_projtaskmap_Geita ZZ ON PT.ProjTaskId=ZZ.D_ProjtaskID
inner join isipl_amt_Geita..tblProjTasks PT1 ON PT1.ProjTaskId=ZZ.S_projtaskID
where PT.AMT_Last_Sched_Date<>PT1.AMT_Last_Sched_Date
OR PT.AMT_Last_Sched_Occ<>PT1.AMT_Last_Sched_Occ
OR PT.AMT_WO_Last_Occ<>PT1.AMT_WO_Last_Occ
OR PT.NextOcc<>PT1.NextOcc
OR PT.ReviewDate<>PT1.ReviewDate
OR PT.AMT_WO_Last_Occ_date<>PT1.AMT_WO_Last_Occ_date
OR PT.ReviewStatusID<>PT1.ReviewStatusID