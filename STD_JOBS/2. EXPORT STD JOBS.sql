

IF EXISTS (select * from sys.tables where name='AJ_STD_JOB_LIST')
BEGIN DROP TABLE AJ_STD_JOB_LIST
END


select distinct  
SJ.Std_Job_Ref  AS Std_Job_Ref
INTO AJ_STD_JOB_LIST 
from tblStdJobs SJ
inner join tblPricedJobs PJ ON SJ.StdJobId=PJ.StdJobId
inner join tblProjTaskAmts PTA ON PJ.PricedJobId=PTA.PricedJobId
inner join tblProjTaskOpts PTO ON PTO.ProjTaskOptId=PTA.ProjTaskOptId
inner join tblProjTasks PT ON PT.ProjTaskId=PTO.ProjTaskId
INNER JOIN EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjId=PT.EqpProjId
where EQ.BranchId IN (4,124,146)


declare @p15 int
set @p15=500
exec AJ_KIRD_EXPORT_P @mode=0, 
@Branch='02-GRANTS',@Price_Group='USA DEFAULT',@isLive=1,
@isDummy=2,@NewSimulationRef='',
@NRecords=@p15 output
select @p15
