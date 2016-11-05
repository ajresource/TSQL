SELECT * ,  1 as allday, 'Ontime ID: ' + Cast(TaskId as varchar) + ' - ' + Name + ' - BH: ' + CAST([Budgeted Hours]as varchar) + ' - AH: ' + CAST([Actual Hours Hours] as varchar) + ' - TC: ' + iCode as [Appointment Desc],  DATEADD(DAY,-[Budgeted Hours]/8,Convert(Datetime,Required_Date, 102)) as BudgetStartDate FROM 

(
-- ALL TASKS (YET TO BE COMPLETED, TASKS MISSED THE DEAD LINE )
select U.Email,u.firstname as [Assigned To],
T.TaskId,T.Name,PT.Name AS Priority,CT.Name as Category,WF.StepName,
CONVERT(DATE,TCF.Custom_213) AS Requested_Date,CONVERT(DATE,TCF.Custom_210) AS Required_Date,
DATEDIFF(MINUTE,CONVERT(datetime,T.CreatedDateTime),GETDATE())/(60*24)AS Task_Age,
CASE
 WHEN  CONVERT(INT,(DATEDIFF(MINUTE,CONVERT(datetime,TCF.Custom_210),GETDATE())/(60*24)))<1 THEN '0'
 ELSE CONVERT(VARCHAR,DATEDIFF(MINUTE,CONVERT(datetime,TCF.Custom_210),GETDATE())/(60*24)) END AS OverDue_Age,
ROUND((CASE 
 WHEN T.DurationUnitTypeId = 2 THEN T.EstimatedDuration*60
 ELSE T.EstimatedDuration END)/60,2) AS [Budgeted Hours],
 ROUND((CASE 
 WHEN T.ActualUnitTypeId = 2 THEN T.ActualDuration*60
 ELSE T.ActualDuration END)/60,2) AS [Actual Hours Hours], C.FirstName + ' ' + C.LastName [Reported By], t.completiondate as [Date Completed],tcf.Custom_249 as iProject, LEFT(tcf.Custom_249,4) as iCode
 from Tasks T 
inner join Users U ON T.AssignedToId=U.UserId
inner join WorkflowSteps WF ON WF.WorkflowStepId=T.WorkflowStepId
inner join PriorityTypes PT ON T.PriorityTypeId=PT.PriorityTypeId
inner join CategoryTypes CT ON T.CategoryTypeId=CT.CategoryTypeId
inner join TaskCustomFields TCF ON T.TaskId=TCF.TaskId
inner join Users C ON t.CreatedById = C.UserId
where   WF.StepName IN ('Assigned IT Task','On Hold IT Task','More Info Required') AND   CONVERT(DATE,TCF.Custom_210) < DATEADD(s,-1,DATEADD(WK, DATEDIFF(WK,0,GETDATE())+1,0))


UNION ALL

-- COMPLETED TASK CURRENT WEEK DUE
select U.Email,u.firstname as [Assigned To],
T.TaskId,T.Name,PT.Name AS Priority,CT.Name as Category,WF.StepName,
CONVERT(DATE,TCF.Custom_213) AS Requested_Date,CONVERT(DATE,TCF.Custom_210) AS Required_Date,
DATEDIFF(MINUTE,CONVERT(datetime,T.CreatedDateTime),GETDATE())/(60*24)AS Task_Age,
CASE
 WHEN  CONVERT(INT,(DATEDIFF(MINUTE,CONVERT(datetime,TCF.Custom_210),GETDATE())/(60*24)))<1 THEN '0'
 ELSE CONVERT(VARCHAR,DATEDIFF(MINUTE,CONVERT(datetime,TCF.Custom_210),GETDATE())/(60*24)) END AS OverDue_Age,
ROUND((CASE 
 WHEN T.DurationUnitTypeId = 2 THEN T.EstimatedDuration*60
 ELSE T.EstimatedDuration END)/60,2) AS [Budgeted Hours],
 ROUND((CASE 
 WHEN T.ActualUnitTypeId = 2 THEN T.ActualDuration*60
 ELSE T.ActualDuration END)/60,2) AS [Actual Hours Hours], C.FirstName + ' ' + C.LastName [Reported By], t.completiondate as [Date Completed],tcf.Custom_249 as iProject, LEFT(tcf.Custom_249,4) as iCode
 from Tasks T 
inner join Users U ON T.AssignedToId=U.UserId
inner join WorkflowSteps WF ON WF.WorkflowStepId=T.WorkflowStepId
inner join PriorityTypes PT ON T.PriorityTypeId=PT.PriorityTypeId
inner join CategoryTypes CT ON T.CategoryTypeId=CT.CategoryTypeId
inner join TaskCustomFields TCF ON T.TaskId=TCF.TaskId
inner join Users C ON t.CreatedById = C.UserId
where   WF.StepName IN ('Completed IT Task') AND    DATEDIFF( ww, CONVERT(DATE,TCF.Custom_210), GETDATE() ) = 0

UNION ALL
-- ALL FUTURE TASKS REQUIRED DATE THIS NEXT WEEK 
select U.Email,u.firstname as [Assigned To],
T.TaskId,T.Name,PT.Name AS Priority,CT.Name as Category,WF.StepName,
CONVERT(DATE,TCF.Custom_213) AS Requested_Date,CONVERT(DATE,TCF.Custom_210) AS Required_Date,
DATEDIFF(MINUTE,CONVERT(datetime,T.CreatedDateTime),GETDATE())/(60*24)AS Task_Age,
CASE
 WHEN  CONVERT(INT,(DATEDIFF(MINUTE,CONVERT(datetime,TCF.Custom_210),GETDATE())/(60*24)))<1 THEN '0'
 ELSE CONVERT(VARCHAR,DATEDIFF(MINUTE,CONVERT(datetime,TCF.Custom_210),GETDATE())/(60*24)) END AS OverDue_Age,
ROUND((CASE 
 WHEN T.DurationUnitTypeId = 2 THEN T.EstimatedDuration*60
 ELSE T.EstimatedDuration END)/60,2) AS [Budgeted Hours],
 ROUND((CASE 
 WHEN T.ActualUnitTypeId = 2 THEN T.ActualDuration*60
 ELSE T.ActualDuration END)/60,2) AS [Actual Hours Hours], C.FirstName + ' ' + C.LastName [Reported By], t.completiondate as [Date Completed],tcf.Custom_249 as iProject, LEFT(tcf.Custom_249,4) as iCode
 from Tasks T 
inner join Users U ON T.AssignedToId=U.UserId
inner join WorkflowSteps WF ON WF.WorkflowStepId=T.WorkflowStepId
inner join PriorityTypes PT ON T.PriorityTypeId=PT.PriorityTypeId
inner join CategoryTypes CT ON T.CategoryTypeId=CT.CategoryTypeId
inner join TaskCustomFields TCF ON T.TaskId=TCF.TaskId
inner join Users C ON t.CreatedById = C.UserId
where  WF.StepName NOT IN ('Completed IT Task')  AND  DATEDIFF( ww, CONVERT(DATE,TCF.Custom_210), GETDATE() ) < 0

) as Tbl

