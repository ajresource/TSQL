/*
This script updates duplicate Std Job Reference for non-builder Std Jobs.

Builder Std Jobs cannot be fixed with this script because the Std Job reference
is created differently.

 */
 
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[z_StdJobDuplicates]') AND type in (N'U'))
DROP TABLE [dbo].z_StdJobDuplicates
GO


 IF EXISTS(select SJ.Std_Job_Ref,COUNT(SJ.StdJobId) 
from 
tblStdJobs SJ
	 INNER JOIN
SYSTEM_SOURCE SS
     ON SJ.System_Source_ID=SS.System_Source_ID
WHERE SS.System_Source_Code<>'BUILDER'

group by SJ.Std_Job_Ref having COUNT(SJ.StdJobId)>1)

BEGIN

	select S.StdJobId, S.Std_Job_Ref,S.StdJob,
	ROW_NUMBER() Over (partition by S.Std_Job_Ref order by S.StdJobId) AS CopyNumber
	into z_StdJobDuplicates
	from 
	tblStdJobs S
		INNER JOIN
	SYSTEM_SOURCE SS
		 ON S.System_Source_ID=SS.System_Source_ID
	WHERE SS.System_Source_Code<>'BUILDER'

	order by S.Std_Job_Ref,S.StdJobId

	--SELECT S.StdJob + ' Copy('+CAST(Z.CopyNumber-1 AS varchar(50))+')'
	UPDATE S SET S.StdJob=S.StdJob + ' Copy('+CAST(Z.CopyNumber-1 AS varchar(50))+')'
	FROM
	tblStdJobs S
		INNER JOIN
	z_StdJobDuplicates Z
		ON S.StdJobId=Z.StdJobId
	WHERE Z.CopyNumber>1

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

END

/*Check just in case. If this query returns duplicates run the script again*/
select SJ.Std_Job_Ref,COUNT(SJ.StdJobId) 
from 
tblStdJobs SJ
	 INNER JOIN
SYSTEM_SOURCE SS
     ON SJ.System_Source_ID=SS.System_Source_ID
WHERE SS.System_Source_Code<>'BUILDER'

group by SJ.Std_Job_Ref having COUNT(SJ.StdJobId)>1