/*For non-Builder std jobs the reference may not be the same. 
 The query can be run for non-builder std jobs only.
 */

UPDATE SJ  
SET   
Std_Job_Ref=dbo.STD_JOB_REF_F(SJ.Group_No,SJ.StdJob,SJ.ComponentCodeId,SJ.JobCodeId,  
SJ.ModifierCodeId,SJ.ApplicationCodeID,SJ.Job_Location_ID,SJ.Work_Application_ID,  
SJ.Job_Condition_ID,SJ.Cab_Type_ID,SJ.Serial_No_Prefix,SJ.Serial_No_Start,  
SJ.Serial_No_End,SJ.Currency_ID,SJ.ModelId,SJ.Simulation_Reference,  
SJ.Live_Job,SJ.Dummy_Job)
FROM
tblStdJobs SJ
     INNER JOIN
SYSTEM_SOURCE SS
     ON SJ.System_Source_ID=SS.System_Source_ID
WHERE SS.System_Source_Code<>'BUILDER'


