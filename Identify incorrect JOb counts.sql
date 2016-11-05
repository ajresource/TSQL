SELECT DE.EqpPlan, DE.Description, DE.Cnt
 , SOR.Description ,SOR.Cnt
 FROM 
aa_AATaskLinks TL 

INNER JOIN (

SELECT A.EqpPlanId, A.EqpPlan,A.ProjTaskId, A.Description, COUNT(DISTINCT PTA.ProjTaskAmtID) AS Cnt FROM aa_FinProjTask A
INNER JOIN tblProjTasks PT ON A.ProjTaskId = PT.ProjTaskId
INNER JOIN tblProjTaskOpts PTO ON PTO.ProjTaskId = PT.ProjTaskId
INNER JOIN tblProjTaskAmts PTA ON PTA.ProjTaskOptId = PTO.ProjTaskOptId
--WHERE A.EqpPlan = 'MH376' AND A.Description Like '7200%'
GROUP BY  A.EqpPlanId, A.EqpPlan,A.ProjTaskId, A.Description
) DE ON DE.ProjTaskId = TL.Dest
INNER JOIN 
(



SELECT A.EqpPlanId, A.EqpPlan,A.ProjTaskId, A.Description, COUNT(DISTINCT PTA.ProjTaskAmtID) AS Cnt FROM aa_BucProjTask A
INNER JOIN buc..tblProjTasks PT ON A.ProjTaskId = PT.ProjTaskId
INNER JOIN buc..tblProjTaskOpts PTO ON PTO.ProjTaskId = PT.ProjTaskId
INNER JOIN buc..tblProjTaskAmts PTA ON PTA.ProjTaskOptId = PTO.ProjTaskOptId
--WHERE A.EqpPlan = 'MH376' AND A.Description Like '7200%'
GROUP BY  A.EqpPlanId, A.EqpPlan,A.ProjTaskId, A.Description
) SOR ON SOR.ProjTaskId = TL.Sour
WHERE DE.Cnt <> SOR.Cnt



1024439, 2085061

SELECT * FROM aa_AATaskLinks WHERE Dest = 1024439

SELECT WES.ProjTaskId AS Dest, AUS.ProjTaskId AS Sour
INTO aa_AATaskLinks
FROM 
aa_FinProjTask WES 
INNER JOIN isipl_amt..tblProjTaskOpts PT ON PT.ProjTaskId = WES.ProjTaskId
 INNER JOIN aa_BucProjTask AUS
 ON AUS.EqpPlan = WES.EqpPlan AND AUS.EqpProjName = WES.EqpProjName
 AND AUS.Component_Code = WES.Component_Code
 AND AUS.Modifier_Code = WES.Modifier_Code
 AND AUS.Task_Type = WES.Task_Type
 AND AUS.Application_Code = WES.Application_Code