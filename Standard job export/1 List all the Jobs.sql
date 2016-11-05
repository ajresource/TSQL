DROP table #AllStdJobs
DROP table #StdJobs

select 
'''''' +  SJ.Std_Job_Ref + ''''',' AS Std_Job_Ref
INTO #StdJobs
from tblStdJobs SJ
INNER JOIN EQUIPMENT_HIERARCHY_V EQ ON SJ.ModelId=EQ.ModelId
Where EQ.BranchId=60

select  DISTINCT Std_Job_Ref INTO #AllStdJobs from #StdJobs

select TOP 800 * from #AllStdJobs

delete Top (500) from #AllStdJobs



DROP table #AllStdJobs
DROP table #StdJobs