--SELECT Std_Job_Ref
--INTO zz_Dup
--FROM dbo.tblStdJobs 
--WHERE Live_Job=1
--GROUP BY Std_Job_Ref
--HAVING COUNT(*) > 1
USE BucCAN
SELECT DISTINCT SJ.StdJobId,SJ.Std_Job_Ref, PJ.LabourCost, PJ.PartsCost, PJ.MiscCost, PJ.TotalCost, tblEquipment.SerialNumber, CC.Code
FROM  dbo.tblPricedJobs PJ INNER JOIN
               tblProjTaskAmts ON PJ.PricedJobId = tblProjTaskAmts.PricedJobId INNER JOIN
               tblProjTaskOpts ON tblProjTaskAmts.ProjTaskOptId = tblProjTaskOpts.ProjTaskOptId INNER JOIN
               tblProjTasks ON tblProjTaskOpts.ProjTaskId = tblProjTasks.ProjTaskId AND tblProjTaskOpts.ProjTaskOptId = tblProjTasks.PlanTaskOptId INNER JOIN
               tblStdJobs SJ ON PJ.StdJobId = SJ.StdJobId INNER JOIN
               tblEqpPlans ON tblProjTasks.EqpPlanId = tblEqpPlans.EqpPlanId INNER JOIN
               tblEquipment ON tblEqpPlans.EquipmentId = tblEquipment.EquipmentId INNER JOIN
               dbo.tblComponentCodes CC ON tblProjTasks.ComponentCodeId=CC.ComponentCodeID
WHERE 
SJ.Std_Job_Ref IN (SELECT Std_Job_Ref FROM dbo.tblStdJobs  GROUP BY Std_Job_Ref,Live_Job HAVING COUNT(*) > 1)
              