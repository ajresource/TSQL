use ontime
DECLARE @email varchar(255)

set @email='Anjana.Rupasinghege@isipl.com'
select * from (
select LEFT(iT.Time_Stamp,11) AS Date1,IP.AccCode+' '+IP.AccDescription AS Project,ROUND(iT.ActualDuration/60,2) AS Duration,'' AS Customer,iT.TaskID
 from iTASK_STATUS iT 
inner join Users U ON iT.AssignedToId=U.UserId
inner join WorkflowSteps WF ON WF.WorkflowStepId=iT.WorkflowStepId
inner join PriorityTypes PT ON iT.PriorityTypeId=PT.PriorityTypeId
inner join CategoryTypes CT ON iT.CategoryTypeId=CT.CategoryTypeId
inner join TaskCustomFields TCF ON iT.TaskId=TCF.TaskId
left join isipl_Projects IP ON IP.AccCode=LEFT(TCF.Custom_249,4)
where WF.StepName<>'Completed IT Task' 
AND
  DATEDIFF( mm, CONVERT(DATE,iT.Time_Stamp), GETDATE() ) = 0
  AND U.Email=@email 
  
UNION ALL
select LEFT(TCF.Custom_210,11) AS Date1,IP.AccCode+' '+IP.AccDescription AS Project,ROUND((
CASE WHEN T.ActualUnitTypeId = 2 THEN T.ActualDuration*60
ELSE T.ActualDuration END)/60,2) AS Duration,'' AS Customer,T.TaskID
 from Tasks T 
inner join Users U ON T.AssignedToId=U.UserId
inner join WorkflowSteps WF ON WF.WorkflowStepId=T.WorkflowStepId
inner join PriorityTypes PT ON T.PriorityTypeId=PT.PriorityTypeId
inner join CategoryTypes CT ON T.CategoryTypeId=CT.CategoryTypeId
inner join TaskCustomFields TCF ON T.TaskId=TCF.TaskId
left join isipl_Projects IP ON IP.AccCode=LEFT(TCF.Custom_249,4)
where WF.StepName='Completed IT Task' /*AND CT.name not in ('Operations')*/ 
AND
  DATEDIFF( mm, CONVERT(DATE,TCF.Custom_210), GETDATE() ) = 0
  AND U.Email=@email 
) A
order by A.Date1