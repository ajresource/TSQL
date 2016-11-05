select B.Branch,EQ.Branch from tblProjTasks PT 
inner join tblProjTaskOpts PTO ON PT.ProjTaskId=PTO.ProjTaskId
inner join tblProjTaskAmts PTA ON PTA.ProjTaskOptId=PTO.ProjTaskOptId
inner join tblPricedJobs PJ ON PTA.PricedJobId=PJ.PricedJobId
inner join tblBranches B ON B.BranchId=PJ.BranchId
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjId=PT.EqpProjId
where B.Branch<>EQ.Branch AND PJ.Price_Group_ID<>EQ.Price_Group_ID

select B.Branch,EQ.Branch from tblProjTasks PT 
inner join tblProjTaskOpts PTO ON PT.ProjTaskId=PTO.ProjTaskId
inner join tblProjTaskAmts PTA ON PTA.ProjTaskOptId=PTO.ProjTaskOptId
inner join tblPricedJobs PJ ON PTA.PricedJobId=PJ.PricedJobId
inner join tblBranches B ON B.BranchId=PJ.BranchId
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjId=PT.EqpProjId
where PJ.Price_Group_ID<>EQ.Price_Group_ID


select count(*) from tblProjTasks