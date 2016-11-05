/******************************************************************************
	File: 	5_AMT_8_5_Patch_Views.sql

 
**************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
15 Aug 11	DS			REPAIR_CODE
12 Sep 11   GD          Mod: RPT_TASK_INTERROGATION_V,RPT_TASK_INTERROGATION_FIELDS_V						
26 Oct 11	DA			Mod: RPT_LABOUR_HOURS_FAST_V	
08 Nov	11	KN			Mod: IC_EXTRACT_DIM_WORKORDER_V				
**END OF HISTORY************************************************************************************************************/
SET QUOTED_IDENTIFIER ON	--should be always ON
GO
SET ANSI_NULLS ON			--should be always ON
GO
--=============================================================================


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IC_EXTRACT_DIM_WORKORDER_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[IC_EXTRACT_DIM_WORKORDER_V]
GO

/******************************************************************************
	Name: IC_EXTRACT_DIM_WORKORDER_V

	Called By: AMT IC ETL Packages

	Desc: 	      
             

	Auth: Darryl Smith
	Date: 06-Aug-2008
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	09/09/09	K Nagarajan	Modified Completely for AMT 8.4 IC Enhancements
	14/10/09	K Nagarajan	Added EqpPlanid
	05/08/10	K Nagarajan	 Issue #196: Fixed the length 1000
	08/11/11	K Nagarajan	Issue #2737: Fix Length only in AMT 8.5 
******************************************************************************

*/
create VIEW [dbo].[IC_EXTRACT_DIM_WORKORDER_V]
AS
 

SELECT 
	T.Task_Id AS WorkorderKey,
	T.Description,
	WO.WorkorderNumber,
	T.Customer_Ref AS CustomerRef,
	LEFT(T.Symptom_Notes,1000)  AS SymptomComment,
	LEFT(T.Repair_Notes,1000) AS RepairComment,
	LEFT(T.Cause_Notes,1000) AS CauseComment,	
	T.Part_No AS FailedPartNo,
	CONVERT(VARCHAR(50),T.Part_Description) AS FailedPartNoDescription,
	T.FailedPartListPosition,
	T.FailedPartListGroup,
	T.FailedPartLifeAchieved,
	T.Group_No AS FailedGroupNo,
	CONVERT(VARCHAR(50),T.Group_Description) AS FailedGroupNoDescription,
	T.FailedGroupListPosition,
	T.FailedGroupPartsListGroup ,
	T.Eqp_Plan_Id,
	T.Date_Notified
FROM 
	TASK T
 	LEFT JOIN tblWorkorders WO ON WO.WorkOrderId = T.Work_Order_ID
--WHERE T.Task_Status_ID IN (2,3)


GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[REPAIR_CODE]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[REPAIR_CODE]
GO


CREATE  VIEW dbo.REPAIR_CODE
AS
/******************************************************************************
	
	Name: REPAIR_CODE

	Called By: 

	Desc: 	      
             

	Auth: Veronika Vasylyeva
	Date: 
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	15-Aug-2011	D Smith		#2293: Removed Budget Code restriction (just return all Job Codes)
	05-sEP-2005	V Vasylyeva	Added default record
******************************************************************************
*/
SELECT     JobCodeID AS Repair_Code_ID, Code AS Short_Description, Description, Default_Record
FROM         dbo.tblJobCodes
GO



/****** Object:  View [dbo].[RPT_TASK_INTERROGATION_V]    Script Date: 09/12/2011 09:56:34 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[RPT_TASK_INTERROGATION_V]'))
DROP VIEW [dbo].[RPT_TASK_INTERROGATION_V]
GO

/****** Object:  View [dbo].[RPT_TASK_INTERROGATION_V]    Script Date: 09/12/2011 09:56:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create   VIEW [dbo].[RPT_TASK_INTERROGATION_V]
/******************************************************************************
	
	Name: RPT_TASK_INTERROGATION_V

	Called By: RPT_TASK_INTERROGATION_P

	Created By: Veronika Vasylyeva
	Create Date: 26-Feb-2004
	

	
	
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	12 Sep 11   GD          E142: Added Repair and Part Description Field 
	30 Mar 10	AL			CR8865: Added Health_Safety_ID
	22-Dec-08	A Lassaun.	CR7798: Changed TASK.RaisedByID + Added RaisedByID
	31-Oct-08	V Vasylyeva	Added Raised_By,Customer_Ref
	17/09/08	AL			removed links to tblqualifier and tbluoms
	 8 Nov 07	V Vasylyeva	changed join to TASK_PLANNED_TIME to left join
	22 Nov 06	KN			Added PerformAtID
	14 Nov 06	SI			Changed to support date based tasks
	27-Jul-2006	K nagarajan	Added PerformAt, Task Duration, Task Part Number
	18-Jul-2006	V Vasylyeva	Event Duration as varchar
	29-Nov-04	S Babeshko	Added UNION from deferred task and select 
								Planned_Up_Time and Planned_Down_Time when 
								Event_status_id is deferred.
	05-Mar-04	V Vasylyeva	Added Event Duration
	03-Mar-04	V Vasylyeva	Added Task Priority
*******************************************************************************/
AS
SELECT T.Task_ID,
	B.DealerId, B.BranchId, S.SiteId, F.FleetId, M.ModelId, EQ.EquipmentId, 
	EP.EqpPlanId, EP.EqpPlan AS [Equipment Plan], C.ContractId, SYS.CostTypeID, SYS.SystemID, 
	SYS.System,SSYS.SubSystemID,SSYS.SubSystem, CC.ComponentCodeID, MC.ModifierID, 
	AC.ApplicationCodeID,TT.TaskTypeID, OT.OccurrenceTypeId, T.Strategy_Proj_Task_Opt_ID, 
	(CASE 
	WHEN T.Strategy_Proj_Task_Opt_ID IS NULL THEN 'No'
	ELSE 'Yes' END) AS [Task: Strategy], 
	T.Task_Status_ID,
	T.Primary_Cause, 
	(CASE T.Primary_Cause WHEN 0 THEN 'No' Else 'Yes' End) AS [Task: Primary], 
	TS.Description AS [Task: Status], CA.Description AS [Task: Cause], 
	P.Description AS [Task: Priority], SO.Description AS [Task: Source], 
	SY.Description AS [Task: Symptom],
	E.Actual_Up_Time,E.Actual_Down_Time,
	CONVERT(varchar, E.Actual_Up_Time,106) AS [Event: Actual Up], 
	CONVERT(varchar, E.Actual_Down_Time,106) AS [Event: Actual Down], 
	JC.Code + '- ' + JC.Description AS [Task: Repair Code], 
	T.Work_Order AS [Task: Work Order], 
	WG.Description AS [Task: Work Group], 
	RTRIM(LTRIM(E.Description)) AS [Event: Description], 
	CAST(T.Strategy_Usage AS varchar) 
	+ ' ' + CASE WHEN T.Strategy_QUOM_ID IS NULL THEN 'Days' ELSE QUOM.UOMShortDesc END AS [Task: Strategy Usage], 
	CONVERT(varchar, T.Strategy_Date, 106) AS [Task: Strategy Date], 
	CC.Code + ' - ' + CC.Description AS [Task: Component Code], 
	MC.Code + ' - ' + MC.Description AS [Task: Modifier Code], 
	AC.Code + ' - ' + AC.Description AS [Task: Task Counter], 
	TT.Code + ' - ' + TT.Description AS [Task: Task Type], 
	OT.OccurrenceType + ' - ' + OT.OccurrenceTypeDesc AS [Task: Occurence Type], 
	(CASE E.Planned WHEN 0 THEN 'No' ELSE 'Yes' END) AS [Event: Planned], 
	(CASE E.Break_Down  WHEN 0 THEN 'No' ELSE 'Yes' END) AS [Event: Breakdown], 
	CAST(T.EM_Issue_Id AS varchar) AS [Task: EM Issue], 
	RTRIM(LTRIM(T.Description)) AS [Task: Description],

	CAST(CAST((CAST(E.Actual_Up_Time AS float)-CAST(E.Actual_Down_Time AS float))*24 AS Decimal(38,2)) AS varchar(100)) AS [Event: Duration],

	E.Event_Status_ID,
	TPT.[Description] AS [Task: Perform at],
	T.Actual_Duration AS [Task: Task Duration],
	T.Part_No AS  [Task: Part Number],
	T.Part_Description AS  [Task: Part Description] ,--E142
	T.Task_Planned_Time_ID AS PerformAtID,
	--AL: 22/12/08
	--T.Raised_By AS [Task: Raised By],
	EMP.Surname + ', ' + EMP.First_Name AS [Task: Raised By], T.RaisedByID,
	T.Customer_Ref AS [Task: Customer Reference],
	T.Health_Safety_Id,	--AL: 30/03/10,
	T.Repair_Notes AS [Task: Repair Description] --GD E142
	
FROM         
	EVENT_STATUS AS ES INNER JOIN
	EVENT AS E ON ES.Event_Status_ID = E.Event_Status_ID RIGHT OUTER JOIN
	PRIORITY AS P INNER JOIN
	tblJobCodes AS JC INNER JOIN
	TASK AS T INNER JOIN
	tblEqpPlans AS EP ON T.Eqp_Plan_ID = EP.EqpPlanId INNER JOIN
	tblComponentCodes AS CC ON T.Component_Code_ID = CC.ComponentCodeID INNER JOIN
	tblApplicationCodes AS AC ON T.Application_Code_ID = AC.ApplicationCodeID INNER JOIN
	tblEquipment AS EQ ON EP.EquipmentId = EQ.EquipmentId INNER JOIN
	tblFleets AS F ON EP.FleetId = F.FleetId INNER JOIN
	tblModels AS M ON EQ.ModelId = M.ModelId INNER JOIN
	tblModifierCodes AS MC ON T.Modifier_ID = MC.ModifierID INNER JOIN
	tblOccurrenceTypes AS OT ON T.Occurrence_Type_Id = OT.OccurrenceTypeId INNER JOIN
	tblSites AS S ON F.SiteId = S.SiteId INNER JOIN
	tblSubSystems AS SSYS ON CC.SubSystemID = SSYS.SubSystemID INNER JOIN
	tblSystems AS SYS ON SSYS.SystemID = SYS.SystemID INNER JOIN
	tblBranches AS B ON S.BranchId = B.BranchId INNER JOIN
	TASK_STATUS AS TS ON T.Task_Status_ID = TS.Task_Status_ID INNER JOIN
	CAUSE AS CA ON T.Cause_ID = CA.Cause_ID INNER JOIN
	SYMPTOM AS SY ON T.Symptom_ID = SY.Symptom_ID ON JC.JobCodeID = T.Repair_Code_Id INNER JOIN
	tblTaskTypes AS TT ON T.Task_Type_ID = TT.TaskTypeID ON P.Priority_ID = T.Priority_ID LEFT OUTER JOIN
	SOURCE AS SO ON T.Source_ID = SO.Source_ID ON E.Event_ID = T.Event_ID LEFT OUTER JOIN
	tblQUOMs AS QUOM ON T.Strategy_QUOM_ID = QUOM.QUOMId LEFT OUTER JOIN
	WORK_GROUP AS WG ON T.Work_Group_ID = WG.Work_Group_ID LEFT OUTER JOIN
	tblContracts AS C ON EP.ContractId = C.ContractId LEFT OUTER JOIN
	TASK_PLANNED_TIME AS TPT ON T.Task_Planned_Time_ID = TPT.Task_Planned_Time_ID LEFT OUTER JOIN
	EMPLOYEE EMP ON T.RaisedByID=EMP.Employee_ID	--AL: 22/12/08

UNION ALL

SELECT T.Task_ID,
	B.DealerId, B.BranchId, S.SiteId, F.FleetId, M.ModelId, EQ.EquipmentId, 
	EP.EqpPlanId, EP.EqpPlan, C.ContractId, SYS.CostTypeID, SYS.SystemID, 
	SYS.System,SSYS.SubSystemID,SSYS.SubSystem, CC.ComponentCodeID, MC.ModifierID, 
	AC.ApplicationCodeID,TT.TaskTypeID, OT.OccurrenceTypeId, T.Strategy_Proj_Task_Opt_ID, 
	(CASE 
	WHEN T.Strategy_Proj_Task_Opt_ID IS NULL THEN 'No'
	ELSE 'Yes' END), 
	DIF.Task_Status_ID,
	DIF.Primary_Cause, 
	(CASE T.Primary_Cause WHEN 0 THEN 'No' Else 'Yes' End), 
	TS.Description, CA.Description, 
	P.Description, SO.Description, 
	SY.Description,
	(CASE WHEN E.Event_status_id = 5 THEN E.Planned_Up_Time ELSE E.Actual_Up_Time END),
	(CASE WHEN E.Event_status_id = 5 THEN E.Planned_Down_Time ELSE E.Actual_Down_Time END),
	CONVERT(varchar, (CASE WHEN E.Event_status_id = 5 THEN E.Planned_Up_Time ELSE E.Actual_Up_Time END),106), 
	CONVERT(varchar, (CASE WHEN E.Event_status_id = 5 THEN E.Planned_Down_Time ELSE E.Actual_Down_Time END),106), 
	JC.Code + '- ' + JC.Description, 
	T.Work_Order, 
	WG.Description, 
	RTRIM(LTRIM(E.Description)), 
	CAST(T.Strategy_Usage AS varchar) 
	+ ' ' + CASE WHEN T.Strategy_QUOM_ID IS NULL THEN 'Days' ELSE QUOM.UOMShortDesc END, 
	CONVERT(varchar, T.Strategy_Date, 106), 
	CC.Code + ' - ' + CC.Description, 
	MC.Code + ' - ' + MC.Description, 
	AC.Code + ' - ' + AC.Description, 
	TT.Code + ' - ' + TT.Description, 
	OT.OccurrenceType + ' - ' + OT.OccurrenceTypeDesc, 
	(CASE E.Planned WHEN 0 THEN 'No' ELSE 'Yes' END), 
	(CASE E.Break_Down  WHEN 0 THEN 'No' ELSE 'Yes' END), 
	CAST(T.EM_Issue_Id AS varchar), 
	RTRIM(LTRIM(T.Description)),
	CAST(CAST((CAST(E.Actual_Up_Time AS float)-CAST(E.Actual_Down_Time AS float))*24 AS Decimal(38,2)) AS varchar(100)),
	E.Event_Status_ID,
	TPT.[Description] AS [Task: Perform at],
	T.Actual_Duration AS [Task: Task Duration],
	T.Part_No AS  [Task: Part Number],
	--GD E142
	T.Part_Description AS  [Task: Part Description],
	T.Task_Planned_Time_ID AS PerformAtID,
	--AL: 22/12/08
	--T.Raised_By AS [Task: Raised By],
	EMP.Surname + ', ' + EMP.First_Name AS [Task: Raised By], T.RaisedByID,
	T.Customer_Ref AS [Task: Customer Reference],
	T.Health_Safety_Id,	--AL: 30/03/10
	T.Repair_Notes AS [Task: Repair Description] --GD E142
	
FROM         
	EVENT_STATUS AS ES INNER JOIN
	EVENT AS E ON ES.Event_Status_ID = E.Event_Status_ID RIGHT OUTER JOIN
	PRIORITY AS P INNER JOIN
	tblJobCodes AS JC INNER JOIN
	DEFERRED_TASK AS DIF INNER JOIN
	TASK AS T ON DIF.Task_ID = T.Task_ID INNER JOIN
	tblEqpPlans AS EP ON T.Eqp_Plan_ID = EP.EqpPlanId INNER JOIN
	tblComponentCodes AS CC ON T.Component_Code_ID = CC.ComponentCodeID INNER JOIN
	tblApplicationCodes AS AC ON T.Application_Code_ID = AC.ApplicationCodeID INNER JOIN
	tblEquipment AS EQ ON EP.EquipmentId = EQ.EquipmentId INNER JOIN
	tblFleets AS F ON EP.FleetId = F.FleetId INNER JOIN
	tblModels AS M ON EQ.ModelId = M.ModelId INNER JOIN
	tblModifierCodes AS MC ON T.Modifier_ID = MC.ModifierID INNER JOIN
	tblOccurrenceTypes AS OT ON T.Occurrence_Type_Id = OT.OccurrenceTypeId INNER JOIN
	tblSites AS S ON F.SiteId = S.SiteId INNER JOIN
	tblSubSystems AS SSYS ON CC.SubSystemID = SSYS.SubSystemID INNER JOIN
	tblSystems AS SYS ON SSYS.SystemID = SYS.SystemID INNER JOIN
	tblBranches AS B ON S.BranchId = B.BranchId INNER JOIN
	TASK_STATUS AS TS ON DIF.Task_Status_ID = TS.Task_Status_ID INNER JOIN
	CAUSE AS CA ON T.Cause_ID = CA.Cause_ID INNER JOIN
	SYMPTOM AS SY ON T.Symptom_ID = SY.Symptom_ID ON JC.JobCodeID = T.Repair_Code_Id INNER JOIN
	tblTaskTypes AS TT ON T.Task_Type_ID = TT.TaskTypeID ON P.Priority_ID = T.Priority_ID LEFT OUTER JOIN
	SOURCE AS SO ON T.Source_ID = SO.Source_ID ON E.Event_ID = DIF.Event_ID LEFT OUTER JOIN
	tblQUOMs AS QUOM ON T.Strategy_QUOM_ID = QUOM.QUOMId LEFT OUTER JOIN
	WORK_GROUP AS WG ON T.Work_Group_ID = WG.Work_Group_ID LEFT OUTER JOIN
	tblContracts AS C ON EP.ContractId = C.ContractId LEFT OUTER JOIN
	TASK_PLANNED_TIME AS TPT ON T.Task_Planned_Time_ID = TPT.Task_Planned_Time_ID LEFT OUTER JOIN
	EMPLOYEE EMP ON T.RaisedByID=EMP.Employee_ID	--AL: 22/12/08

GO

/****** Object:  View [dbo].[RPT_TASK_INTERROGATION_FIELDS_V]    Script Date: 09/12/2011 14:16:49 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[RPT_TASK_INTERROGATION_FIELDS_V]'))
DROP VIEW [dbo].[RPT_TASK_INTERROGATION_FIELDS_V]
GO

/****** Object:  View [dbo].[RPT_TASK_INTERROGATION_FIELDS_V]    Script Date: 09/12/2011 14:16:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [dbo].[RPT_TASK_INTERROGATION_FIELDS_V]
/******************************************************************************
	
	Name: RPT_TASK_INTERROGATION_FIELDSV

	Called By: RPT_TASK_INTERROGATION_FIELDS_P

	Created By: Veronika Vasylyeva
	Create Date: 27-Feb-2004
	

	
	
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	12 Sep 11   G Dhillon        E142: Added Repair and Part Description Field 
	31-Oct-08	V Vasylyeva	Added Raised_By,Customer_Ref
	27-Jul-2006	K nagarajan	Added PerformAt, Task Duration, Task Part Number
	05-Mar-2004	V Vasylyeva	Added [Event: Duration]
*******************************************************************************/
AS
SELECT     
[Task: Strategy], 
[Task: Primary], 
[Task: Status], 
[Task: Cause], 
[Task: Priority], 
[Task: Source], 
[Task: Symptom], 
[Task: Repair Code], 
[Task: Work Order], 
[Task: Work Group], 
[Task: Strategy Usage], 
[Task: Strategy Date], 
[Task: Component Code], 
[Task: Modifier Code], 
[Task: Task Counter], 
[Task: Task Type], 
[Task: Occurence Type], 
[Task: EM Issue], 
[Task: Perform at],
[Task: Task Duration],
[Task: Part Number],
[Task: Part Description],
[Task: Raised By],
[Task: Customer Reference],
[Task: Repair Description],
[Event: Actual Up], 
[Event: Actual Down], 
[Event: Description], 
[Event: Planned], 
[Event: Breakdown],
[Event: Duration]
FROM  RPT_TASK_INTERROGATION_V

GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RPT_LABOUR_HOURS_FAST_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[RPT_LABOUR_HOURS_FAST_V]
GO


/******************************************************************************
	Name: RPT_LABOUR_HOURS_FAST_V

	Called By: Stored Procedure  RPT_LABOUR_HOURS_P

	Desc: 	Combines Labour Hours by Workorder (not task)
              
	Auth: 	H Singh 
	Date: 	4 March 2003
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	25 Oct 11		DA		Bug fix# 2557 - Grouping by Sum of labour hours
	--------	--------	----------------------------------------
*******************************************************************************/

CREATE VIEW dbo.RPT_LABOUR_HOURS_FAST_V
AS
SELECT     TOP 100 PERCENT ep.EqpPlan, pt.ComponentCodeId, pt.ModifierId, pt.TaskTypeId, pt.ApplicationCodeId, SUM(ISNULL(ac.LabourHours, 0)) as LabourHours, ep.FleetId, e.ModelId, 
                      ep.EquipmentId, pt.EqpProjId, pt.ProjTaskId, ep.EqpPlanId, ep.ContractId, F.SiteId, S.BranchId, B.DealerId, SS.SubSystemID, SYS.SystemID, 
                      SYS.CostTypeID, ac.CostBearerID AS CostBearerId, 0 AS AMTParentWorkOrderId, 0 AS AMTStatusId, CONVERT(datetime, LEFT(ac.CalenderPeriod, 4) 
                      + '-' + RIGHT(ac.CalenderPeriod, 2) + '-01') AS AMTStartDate, 0 AS AMTOccurrenceTypeId
FROM         dbo.tblSubSystems SS INNER JOIN
                      dbo.tblSystems SYS ON SS.SystemID = SYS.SystemID INNER JOIN
                      dbo.tblComponentCodes CC ON SS.SubSystemID = CC.SubSystemID INNER JOIN
                      dbo.tblProjTasks pt INNER JOIN
                      dbo.tblEquipment e INNER JOIN
                      dbo.tblEqpPlans ep ON e.EquipmentId = ep.EquipmentId ON pt.EqpPlanId = ep.EqpPlanId INNER JOIN
                      dbo.tblEqpProjs P ON pt.EqpProjId = P.EqpProjId AND pt.EqpPlanId = P.EqpPlanId INNER JOIN
                      dbo.tblSites S INNER JOIN
                      dbo.tblBranches B ON S.BranchId = B.BranchId INNER JOIN
                      dbo.tblFleets F ON S.SiteId = F.SiteId ON ep.FleetId = F.FleetId ON CC.ComponentCodeID = pt.ComponentCodeId INNER JOIN
                      dbo.tblRepActualCosts ac ON pt.EqpProjId = ac.EqpProjID AND pt.ProjTaskId = ac.ProjTaskID
WHERE     (ISNULL(P.CurrentProj, 0) <> 0)
GROUP BY ep.EqpPlan, ep.EqpPlanId, ep.FleetId, e.ModelId, pt.EqpProjId, pt.ProjTaskId, pt.ComponentCodeId, pt.ModifierId, pt.TaskTypeId, pt.ApplicationCodeId, 
                      ep.EquipmentId, ep.ContractId, F.SiteId, S.BranchId, B.DealerId, SS.SubSystemID, SYS.SystemID, SYS.CostTypeID, 
                      ac.CalenderPeriod, ac.CostBearerID

GO