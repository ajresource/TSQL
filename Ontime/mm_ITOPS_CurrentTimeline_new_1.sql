USE [Ontime]
GO

/****** Object:  View [dbo].[mm_ITOPS_CurrentTimeline]    Script Date: 07/12/2013 11:44:55 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[mm_ITOPS_CurrentTimeline]'))
DROP VIEW [dbo].[mm_ITOPS_CurrentTimeline]
GO

USE [Ontime]
GO

/****** Object:  View [dbo].[mm_ITOPS_CurrentTimeline]    Script Date: 07/12/2013 11:44:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[mm_ITOPS_CurrentTimeline]
AS


SELECT DISTINCT Email,[Assigned To],TaskId,Name,Priority,ISNULL(Category,'N/A') as Category,StepName,Requested_Date,
CASE 
WHEN [Budgeted Hours]<8 AND ( DATEPART(hOUR,Required_Date)>19 OR  DATEPART(hOUR,Required_Date)=0)
THEN 
DATEADD(HOUR,19,CONVERT(DATETIME,LEFT(Required_Date,11),20))
ELSE 
Required_Date
END  AS Required_Date
,Task_Age,OverDue_Age,[Budgeted Hours],[Actual Hours Hours],[Reported By],[Date Completed],iProject,iCode, 
CASE 
WHEN [Budgeted Hours]>=8
THEN 
'1'
ELSE 
'0' 
END AS allday, 
'#' + Cast(TaskId as varchar) + ' | ' + Name + ' | BH: ' + CAST([Budgeted Hours]as varchar) + ' | AH: ' + CAST([Actual Hours Hours] as varchar) + ' | TC: ' + isNULL(iCode,'N/A') as [Appointment Desc],  

DATEADD(HOUR,

CASE 
WHEN [Budgeted Hours]<8 
THEN 
-[Budgeted Hours]
ELSE 
-[Budgeted Hours]*3
END 

,Convert(Datetime,CASE 
WHEN [Budgeted Hours]<8 AND ( DATEPART(hOUR,Required_Date)>19 OR  DATEPART(hOUR,Required_Date)=0)
THEN 
DATEADD(HOUR,19,CONVERT(DATETIME,LEFT(Required_Date,11),20))
ELSE 
Required_Date
END ,101)) as BudgetStartDate ,
CASE WHEN [Budgeted Hours] = 0 THEN 0 ELSE CASE WHEN StepName IN ('Completed IT Task', 'Waiting On Approval', 'Open IT Task') and ([Actual Hours Hours] = 0  OR [Budgeted Hours] = 0) THEN 0 ELSE
[Actual Hours Hours]/[Budgeted Hours]*100 END END AS PercentComplete,
CASE
WHEN  StepName = 'Completed IT Task' 
THEN 
'2' 
WHEN StepName = 'Waiting On Approval'
THEN
'3'
WHEN StepName = 'Open IT Task'
THEN
'4'
WHEN StepName = 'On Hold IT Task'
THEN
'8'
WHEN StepName = 'More Info Required'
THEN
'9'
WHEN StepName = 'Abandoned'
THEN
'5'
ELSE 
CASE WHEN Category = 'Operations'
THEN
 '1'
 ELSE
 '0'
 END
 END
  
as [Label]


,'Timesheet Code: ' +CAST(isNULL(iCode,'N/A') as Varchar) + ' Project Description: ' + CAST(isNULL(iProject,'N/A') as Varchar) + ' Reported By: ' + isNULL([Reported By],'N/A') + ' Budgeted Hours: ' + CAST([Budgeted Hours]as Varchar) as AppointmentDescription


FROM 

(
-- ALL TASKS (YET TO BE COMPLETED, TASKS MISSED THE DEAD LINE )
select U.Email,u.firstname as [Assigned To],
T.TaskId,T.Name, /*CONVERT(varchar(MAX),T.description) as tdesc,*/PT.Name AS Priority,CT.Name as Category,WF.StepName,
CONVERT(DATE,TCF.Custom_213) AS Requested_Date,Convert(Datetime,isNULL(TCF.Custom_210,GETDATE()),101) AS Required_Date,
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
inner join Users C ON t.ReportedById = C.UserId
/*where   WF.StepName IN ('Assigned IT Task','On Hold IT Task','More Info Required','Waiting On Approval','Abandoned') AND   CONVERT(DATE,TCF.Custom_210) < DATEADD(s,-1,DATEADD(WK, DATEDIFF(WK,0,GETDATE())+1,0))


UNION ALL

-- COMPLETED TASK CURRENT WEEK DUE
select U.Email,u.firstname as [Assigned To],
T.TaskId,T.Name,/*CONVERT(varchar(max),T.description) as tdesc,*/PT.Name AS Priority,CT.Name as Category,WF.StepName,
CONVERT(DATE,TCF.Custom_213) AS Requested_Date,Convert(Datetime,isNULL(TCF.Custom_210,GETDATE()),101) AS Required_Date,
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
inner join Users C ON t.ReportedById = C.UserId
where   WF.StepName IN ('Completed IT Task') --AND    DATEDIFF( ww, CONVERT(DATE,TCF.Custom_210), GETDATE() ) = 0

UNION ALL
-- ALL FUTURE TASKS REQUIRED DATE THIS NEXT WEEK 
select U.Email,u.firstname as [Assigned To],
T.TaskId,T.Name,/*CONVERT(varchar(MAX),T.description) as tdesc,*/ISNULL(PT.Name,0) AS Priority,ISNULL(CT.Name,0) as Category,WF.StepName,
CONVERT(DATE,TCF.Custom_213) AS Requested_Date,Convert(Datetime,isNULL(TCF.Custom_210,GETDATE()),101) AS Required_Date,
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
left join PriorityTypes PT ON T.PriorityTypeId=PT.PriorityTypeId
left join CategoryTypes CT ON T.CategoryTypeId=CT.CategoryTypeId
inner join TaskCustomFields TCF ON T.TaskId=TCF.TaskId
inner join Users C ON t.ReportedById = C.UserId
where  WF.StepName NOT IN ('Completed IT Task', 'Open IT Task')  AND  DATEDIFF( ww, CONVERT(DATE,TCF.Custom_210), GETDATE() ) < 0



UNION ALL

-- OPEN IT TASKS
select U.Email,u.firstname as [Assigned To],
T.TaskId,T.Name,/*CONVERT(varchar(MAX),T.description) as tdesc,*/PT.Name AS Priority,'N/A' as Category,WF.StepName,
CONVERT(DATE,TCF.Custom_213) AS Requested_Date,Convert(Datetime,isNULL(TCF.Custom_210,GETDATE()),101) AS Required_Date,
DATEDIFF(MINUTE,CONVERT(datetime,T.CreatedDateTime),GETDATE())/(60*24)AS Task_Age,
CASE
 WHEN  CONVERT(INT,(DATEDIFF(MINUTE,CONVERT(datetime,TCF.Custom_210),GETDATE())/(60*24)))<1 THEN '0'
 ELSE CONVERT(VARCHAR,DATEDIFF(MINUTE,CONVERT(datetime,isNULL(TCF.Custom_210,0)),GETDATE())/(60*24)) END AS OverDue_Age,
'8' AS [Budgeted Hours],
 ROUND((CASE 
 WHEN T.ActualUnitTypeId = 2 THEN T.ActualDuration*60
 ELSE T.ActualDuration END)/60,2) AS [Actual Hours Hours], isNULL(C.FirstName + ' ' + C.LastName, 'Maroun Maroun') AS [Reported By], t.completiondate as [Date Completed], CASE WHEN tcf.Custom_249 = '' THEN 'N/A' ELSE tcf.Custom_249 END as iProject, CASE WHEN LEFT(tcf.Custom_249,4) = '' THEN 'N/A' ELSE LEFT(tcf.Custom_249,4) END as iCode
 from Tasks T 
inner join Users U ON T.AssignedToId=U.UserId
left join WorkflowSteps WF ON WF.WorkflowStepId=T.WorkflowStepId
left join PriorityTypes PT ON T.PriorityTypeId=PT.PriorityTypeId
left join CategoryTypes CT ON T.CategoryTypeId=CT.CategoryTypeId
left join TaskCustomFields TCF ON T.TaskId=TCF.TaskId
left join Users C ON t.ReportedById = C.UserId
where   WF.StepName IN ('Open IT Task') --AND    DATEDIFF( ww, CONVERT(DATE,TCF.Custom_210), GETDATE() ) = 0*/


) as Tbl
















GO


