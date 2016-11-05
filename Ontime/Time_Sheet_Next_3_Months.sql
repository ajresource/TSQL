DECLARE @email varchar(255)
 

select U.FirstName,T.Name,CT.Name,WF.StepName,LEFT (TCF.Custom_210,11) AS Date1,ROUND((
CASE WHEN T.DurationUnitTypeId = 2 THEN T.EstimatedDuration*60
ELSE T.EstimatedDuration END)/60,2) AS Estimated_Duration,'' AS Customer,T.TaskID
 from Tasks T 
inner join Users U ON T.AssignedToId=U.UserId
inner join WorkflowSteps WF ON WF.WorkflowStepId=T.WorkflowStepId
inner join PriorityTypes PT ON T.PriorityTypeId=PT.PriorityTypeId
inner join CategoryTypes CT ON T.CategoryTypeId=CT.CategoryTypeId
inner join TaskCustomFields TCF ON T.TaskId=TCF.TaskId
where TCF.Custom_210 > '2014-10-01'
 
 
