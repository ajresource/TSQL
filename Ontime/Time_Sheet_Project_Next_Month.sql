DECLARE @email varchar(255)
 
set @email='Anjana.Rupasinghege@isipl.com'

select LEFT (TCF.Custom_210,11) AS Date1,IP.AccCode+' '+IP.AccDescription AS Project,ROUND((
CASE WHEN T.DurationUnitTypeId = 2 THEN T.EstimatedDuration*60
ELSE T.EstimatedDuration END)/60,2) AS Estimated_Duration,'' AS Customer,T.TaskID
 from Tasks T 
inner join Users U ON T.AssignedToId=U.UserId
inner join WorkflowSteps WF ON WF.WorkflowStepId=T.WorkflowStepId
inner join PriorityTypes PT ON T.PriorityTypeId=PT.PriorityTypeId
inner join CategoryTypes CT ON T.CategoryTypeId=CT.CategoryTypeId
inner join TaskCustomFields TCF ON T.TaskId=TCF.TaskId
left join isipl_Projects IP ON (IP.AccCode+'-'+IP.AccDescription)=TCF.Custom_249
where WF.StepName<>'Completed IT Task' /*AND CT.name not in ('Operations')*/ 
AND
 TCF.Custom_210 > getdate()
 
 
