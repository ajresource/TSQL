/******************************************************************************
	File: 	6_AMT_8_5C_Patch_Views.sql

	Description:	Creates the Views in the database

**************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
11 May 12	VV			Mod RPT_PM_WORK_HISTORY_V
07 May 12   SD          E811 MULTI_TASK_EDITOR_TASK_V, MULTI_TASK_EDITOR_TASK_FLD_ID_V
01 May 12	KN			E809	RPT_DAILY_DOWNTIME_LOG_DTA_V	
13 Apr 12   GD          E780   RPT_WORK_SCHEDULE_V
12/APR/12   SD		    E781 - Add PEX fields - MULTI_TASK_EDITOR_TASK_V, MULTI_TASK_EDITOR_TASK_FLD_ID_V
13 APR 12   SD			E778 - Add new PEX fields - PART_PRICE_DETAILS_V
**END OF HISTORY************************************************************************************************************/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RPT_PM_WORK_HISTORY_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[RPT_PM_WORK_HISTORY_V]
GO


/******************************************************************************
	Name: RPT_PM_WORK_HISTORY_V

	Called By: RPT_PM_WORK_HISTORY_P

	Desc: 	This provides a view of the PM Service history for a piece of equipment for its last 15 PM services.



              
	Auth: 	Thy Rith
	Date: 	15 Nov 2002
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	11 May 12	VV			#4168 The report should be based on the "PM Task" flag, 
							in the Task Type table
	11-Nov-08	VV			CR7702 Modified to use actual down date from tha tasks for
							"standard planning". Take QUOM from primary QUOM for equipment.
							Added Primary_QUOM_Id to the select statement
	25-Sep-08	AL			fixed previous fix as it was not saved properly
	19-Sep-08	DS			Enabled for "standard planning" (get Eqp from TASK instead of EVENT)
	17/09/08	AL		removed links to tblqualifier and tbluoms
	15 Nov 06	SI		Changed to support date based tasks
	28 Jan 2005	S Babeshko	Add Task TaskHeadDescription column from TASK_HEADER table
****************************************************************************** 

*/
CREATE VIEW [dbo].[RPT_PM_WORK_HISTORY_V]
AS
SELECT     dbo.tblComponentCodes.Code + '-' + dbo.tblComponentCodes.Description AS Component, 
/*VV 11-Nov-2008*/ISNULL(dbo.EVENT.Actual_Down_Time,dbo.TASK.Actual_Down_Time) AS Date, 

/*VV 11-Nov-2008 CASE WHEN EVENT.QUOM_ID IS NULL THEN 'Days' ELSE tblQUOMs.UOMShortDesc END AS UOM, */
CASE WHEN dbo.tblEqpPlans.Primary_QUOM_Id IS NULL THEN 'Days' ELSE tblQUOMs.UOMShortDesc END AS UOM,

dbo.TASK.Work_Order AS WorkOrder, 
                      dbo.tblEqpPlans.EqpPlanID, dbo.tblTaskTypes.Code AS TaskType, 
                      dbo.tblEqpPlans.EqpPlan + ' (' + dbo.tblEquipment.SerialNumber + ')' AS EqpPlan, dbo.tblFleets.Fleet, dbo.tblSites.Site, dbo.TASK.Task_Header_Id, 
                      dbo.TASK_HEADER.Description AS TaskHeadDescription,dbo.tblEqpPlans.Primary_QUOM_Id
FROM         dbo.TASK INNER JOIN
                      dbo.tblComponentCodes ON dbo.TASK.Component_Code_ID = dbo.tblComponentCodes.ComponentCodeID INNER JOIN
                      dbo.TASK_STATUS ON dbo.TASK.Task_Status_ID = dbo.TASK_STATUS.Task_Status_ID INNER JOIN
                      dbo.tblTaskTypes ON dbo.TASK.Task_Type_ID = dbo.tblTaskTypes.TaskTypeID INNER JOIN
                      dbo.tblEqpPlans ON dbo.TASK.Eqp_Plan_ID = dbo.tblEqpPlans.EqpPlanId LEFT OUTER JOIN
                      dbo.EVENT ON dbo.TASK.Event_ID = dbo.EVENT.Event_ID INNER JOIN
                      dbo.tblFleets ON dbo.tblEqpPlans.FleetId = dbo.tblFleets.FleetId INNER JOIN
                      dbo.tblSites ON dbo.tblFleets.SiteId = dbo.tblSites.SiteId INNER JOIN
                      dbo.tblEquipment ON dbo.tblEqpPlans.EquipmentId = dbo.tblEquipment.EquipmentId INNER JOIN
                      dbo.TASK_HEADER ON dbo.TASK.Task_Header_Id = dbo.TASK_HEADER.Task_Header_Id LEFT OUTER JOIN
                      dbo.tblQUOMs ON /* VV 11-Nov-08 dbo.EVENT.QUOM_ID = dbo.tblQUOMs.QUOMId*/
						dbo.tblEqpPlans.Primary_QUOM_Id=dbo.tblQUOMs.QUOMId
WHERE     /*VV #4168 (dbo.tblTaskTypes.Code = 'pm')*/
dbo.tblTaskTypes.PMTask=1
AND (dbo.TASK_STATUS.Task_Status_ID = 3) 
 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RPT_DAILY_DOWNTIME_LOG_DTA_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[RPT_DAILY_DOWNTIME_LOG_DTA_V]
GO


CREATE VIEW dbo.RPT_DAILY_DOWNTIME_LOG_DTA_V
AS
/******************************************************************************
	File: RPT_DAILY_DOWNTIME_LOG_DTA_V.sql
	Name:RPT_DAILY_DOWNTIME_LOG_DTA_V

	Called By: RPT_DAILY_DOWNTIME_LOG_DTA_V
	
	Desc: This view contains every DTA's Start Time and End Time.

	Auth: Koushik.Nagarajan
	Date: 01 May 2012
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------		--------		----------------------------------------
 
*******************************************************************************/
 
WITH CTEDTA
AS
(
	SELECT EventId, Sort_Order, (ActualDT) FROM RPT_DAILY_DOWNTIME_LOG_V  
)
 SELECT 
	 P.[Description], 
	 P.[Plan], 
	 P.BreakDown, 
	 P.DownDate, 
	 P.ActualUpDate, 
	 P.DownHours, 
	 P.Cause, 
	 P.Activity, 
	 P.Resp, 
	 P.PlanDT, 
	 P.ActualDT, 
	 P.Variance, 
	 P.VarianceCause, 
	 P.FleetId, 
	 P.SiteId, 
	 P.EqpPlanId, 
	 P.ModelId, 
	 P.TaskTypeId, 
	 P.Responsibility_ID, 
	 P.EventStatus, 
	 P.RespID, 
	 P.EventID, 
	 P.Primary_Cause, 
	 P.EquipPlan, 
	 P.Model, 
	 P.GroupBy, 
	 P.EMIssueId, 
	 P.BranchId, 
	 P.Notes, 
	 P.Sort_Order, 
	 P.Primary_DTA,
	 DATEADD(HOUR,SUM(cte.ActualDT)-P.ActualDT,DownDate) AS DTADownDate, 
	 DATEADD(HOUR,SUM(cte.ActualDT),DownDate) AS DTAUpDate
FROM 
	RPT_DAILY_DOWNTIME_LOG_V P
	JOIN CTEDTA cte ON P.EventId = cte.EventID AND CTE.Sort_Order <= P.Sort_Order
 GROUP BY 
 	 P.[Description], 
	 P.[Plan], 
	 P.BreakDown, 
	 P.DownDate, 
	 P.ActualUpDate, 
	 P.DownHours, 
	 P.Cause, 
	 P.Activity, 
	 P.Resp, 
	 P.PlanDT, 
	 P.ActualDT, 
	 P.Variance, 
	 P.VarianceCause, 
	 P.FleetId, 
	 P.SiteId, 
	 P.EqpPlanId, 
	 P.ModelId, 
	 P.TaskTypeId, 
	 P.Responsibility_ID, 
	 P.EventStatus, 
	 P.RespID, 
	 P.EventID, 
	 P.Primary_Cause, 
	 P.EquipPlan, 
	 P.Model, 
	 P.GroupBy, 
	 P.EMIssueId, 
	 P.BranchId, 
	 P.Notes, 
	 P.Sort_Order, 
	 P.Primary_DTA

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PART_PRICE_DETAILS_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[PART_PRICE_DETAILS_V]
GO

CREATE   VIEW dbo.PART_PRICE_DETAILS_V

/******************************************************************************
	File: 
	Name: PART_PRICE_DETAILS_V

	Called By: Parts Manager SPS

	Desc: 	      
             

	Auth: Koushik.Nagarajan
	Date: 30-June-2008
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	11 APR 12   SD			E778 - Add new PEX fields	
	15-Aug-08	KN			Removed Warranty Fields
	28-Aug-08	KN			Added fields for Parts Manager
	26-May-09	KN			PartType Only
******************************************************************************


*/

AS
 SELECT    
	P.PartId ,		
	P.Part, 
	P.PartDescription,
	P.Source_Of_Supply_ID ,
	SOS.Sos_Code +' - ' + SOS.SOS_Description AS SourceOfSupply,
	PT.PartTypeId,
	--PT.PartType +' ' + PT.PartTypeDesc AS PartType,
	PT.PartType AS PartType,
	PP.Price_Group_Id,
	PG.Price_Group,
	PP.CurrencyID, C.Currency,
  	PP.LastModDate AS LastPriceUpdate,
	PP.Full_Credit_Sell,
	PP.Partial_Credit_Sell,
	PP.Part_Sell,
	P.PartSuperseded, 
	SOS.Sos_Code,
	PP.Part_Cost,
	PP.Full_Credit_Cost,
	PP.Partial_Credit_Cost,
	PP.PartPriceId,
	P.BudgetDeliveryTimeToWorkshop,
    P.BudgetTimeWaitingForRebuild,
    P.BudgetRebuildDuration,
    P.BudgetDeliveryTimeToWarehouse,
    P.BudgetTotalTurnTime,
    P.DefaultComponentCodeId AS DefaultComponentCodeId,
    CC.Description AS DefaultComponent,
    P.DefaultPartRatingId AS DefaultPartRatingId,
    PR.PartRating AS DefaultPartRating  
FROM         
		tblParts P  
	INNER JOIN tblPartPrices PP ON P.PartId = PP.PartId 
	INNER JOIN tblPartTypes PT ON P.Part_Type_ID = PT.PartTypeId 
	INNER JOIN SOURCE_OF_SUPPLY SOS ON P.Source_Of_Supply_ID = SOS.Source_Of_Supply_ID	 
	INNER JOIN dbo.PRICE_GROUP PG ON PG.Price_Group_ID = PP.Price_Group_ID
	INNER JOIN dbo.tblCurrencies C ON C.CurrencyID = PP.CurrencyID
	LEFT OUTER JOIN tblComponentCodes CC ON P.DefaultComponentCodeId = CC.ComponentCodeID
	LEFT OUTER JOIN PART_RATING PR ON P.DefaultPartRatingId = PR.PartRatingId	
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[MULTI_TASK_EDITOR_TASK_V]'))
DROP VIEW [dbo].[MULTI_TASK_EDITOR_TASK_V]

GO

create VIEW [dbo].[MULTI_TASK_EDITOR_TASK_V]

/******************************************************************************
	Name: MULTI_TASK_EDITOR_TASK_V

	Called By: MULTI_TASK_EDITOR_GET_P

	Desc: 	

	Auth: 	Veronika Vasylyeva
		
	Date: 	2 Apr 2008
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	12/04/12    SD		    E781 - Add PEX fields
	
OLD HISTORY
-----------
	
	17/09/08	AL			removed links to tblqualifier and tbluoms
	31/03/09	AL			CR7965: Added PctPurchasePart,PctPurchaseLabour,PctPurchaseMisc,PctPurchaseNewPart,SalesResponsibility
	23/07/09	KN			Added Comp Stru/Perf stra
	12-Jul-10	V Vasylyeva	CR9019: CBD
	 7 Oct 10	V Vasylyeva	E316 PartRating
	 4 Apr 11	G Wang		Add AutoGenerateWOS
******************************************************************************
*/
AS

SELECT
PT.ProjTaskId, CC.Code + ' - ' + CC.Description AS Component_Code,
MC.Code + ' - ' + MC.Description AS Modifier_Code, TT.Code + ' - ' + TT.Description AS Task_Type, 
AC.Code + ' - ' + AC.Description AS Task_Counter, PT.Task_Description AS [Description], 
CASE WHEN PT.Unscheduled<>0 THEN 'Unassigned' 
WHEN PT.ParentTaskId>0 THEN 'Repair Reserve'
WHEN PT.Planning_Task=1 THEN 'Planning'
ELSE 'Non Planning' END AS Task_Mode,
CASE PT.Planning_Task WHEN 1 THEN PT.Planning_Lead_Time ELSE NULL END AS Planning_Lead_Time, 
OC.Operational_Criticality,M.ManufacturerDesc AS Manufacturer,
CASE WHEN Rotable_Part_Id>0 THEN NULL ELSE P.Part + ' - ' + P.PartDescription END AS Primary_Part_Number, 
PT.Group_Number, PT.Warranty_Period_Days AS Warranty_Days, PT.Warranty_Period_Usage AS Warranty_Usage, 
CAST(CASE WHEN PT.UsageQUOMId>0 THEN 0 ELSE 1 END AS bit) AS Date_Based,
QUOM.UOMShortDesc AS UOM, 
CASE WHEN PT.Unscheduled<>0 THEN NULL ELSE PTO.First END AS First_Occurrence, 
PTO.Frequency, 
CASE WHEN PT.Unscheduled<>0 THEN NULL ELSE NULLIF(PT.Final,0) END AS Not_After,
ISNULL(PT.ProjTotalEsc,0) AS Task_Cost,
PT.ComponentCodeId AS ComponentCodeId_NV,PT.ModifierId AS ModifierId_NV,PT.TaskTypeId AS TaskTypeId_NV,
S.SystemId AS SystemId_NV,S.System AS System_NV,SS.SubSystemId AS SubSystemId_NV,SS.SubSystem AS SubSystem_NV,
PT.UsageQUOMId AS QUOMId_NV,QUOM.UOMShortDesc AS QUOM_NV,PT.ApplicationCodeId AS ApplicationCodeId_NV,
--AL: 31/03/09
PT.PctPurchasePart,PT.PctPurchaseLabour,PT.PctPurchaseMisc,PT.PctPurchaseNewPart,
E.Surname + ', ' + E.First_Name AS SalesResponsibility,
MS.Maintenance_Strategy AS Performance_Strategy, 
CS.Component_Structure,/*VV CR9019*/PT.CBDTask,/*VV E316*/PAR.PartRating,
PT.PartRatingId AS PartRatingId_NV,/*GW*/PT.AutoGenerateWOS,
/*E781*/
tblSites.Site AS DefaultLocationForRebuild,
pc.PartClassification
FROM         
		tblProjTasks AS PT INNER JOIN
		tblProjTaskOpts AS PTO ON PT.ProjTaskId = PTO.ProjTaskId INNER JOIN
		tblComponentCodes AS CC ON PT.ComponentCodeId = CC.ComponentCodeID INNER JOIN
		tblSubSystems AS SS ON CC.SubSystemID = SS.SubSystemID INNER JOIN
		tblSystems AS S ON SS.SystemID = S.SystemID INNER JOIN
		tblApplicationCodes AS AC ON PT.ApplicationCodeId = AC.ApplicationCodeID INNER JOIN
		tblModifierCodes AS MC ON PT.ModifierId = MC.ModifierID INNER JOIN
		tblTaskTypes AS TT ON PT.TaskTypeId = TT.TaskTypeID INNER JOIN
		tblManufacturers AS M ON PT.ManufacturerId = M.ManufacturerId LEFT OUTER JOIN
		tblQUOMs AS QUOM ON PT.UsageQUOMId = QUOM.QUOMId LEFT OUTER JOIN
		OPERATIONAL_CRITICALITY AS OC ON PT.Operational_Criticality_Id = OC.Operational_Criticality_Id LEFT OUTER JOIN
		tblParts AS P ON PT.Part_Id = P.PartId LEFT OUTER JOIN
		EMPLOYEE E ON PT.SalesResponsibilityID=E.Employee_ID LEFT OUTER JOIN 
		PART_RATING PAR ON PT.PartRatingId=PAR.PartRatingId LEFT OUTER JOIN
		MAINTENANCE_STRATEGY MS ON MS.Maintenance_Strategy_Id = PT.Maintenance_Strategy_Id LEFT OUTER JOIN
		(SELECT     
			CS.RCMComponentStructureId, M.Model+':'+CC.Code+':'+MC.Code+':'+TT.Code+':'+AC.Code+':'+ISNULL(CS.[Group],'') AS Component_Structure
		FROM RCM_COMPONENT_STRUCTURE CS
			INNER JOIN tblModels M ON CS.ModelId=M.ModelId
			INNER JOIN tblComponentCodes CC ON CS.ComponentCodeId=CC.ComponentCodeId
			INNER JOIN tblModifierCodes MC ON CS.ModifierCodeId=MC.ModifierId
			INNER JOIN tblApplicationCodes AC ON CS.ApplicationCodeID=AC.ApplicationCodeId
			INNER JOIN tblTaskTypes TT	ON CS.TaskTypeId=TT.TaskTypeId
		 ) CS ON CS.RCMComponentStructureId = PT.RCMComponentStructureId

		/*E781*/
		LEFT OUTER JOIN tblSites ON tblSites.SiteId = PT.DefaultLocationForRebuild
		LEFT OUTER JOIN PART_CLASSIFICATION pc ON pc.PartClassificationId = PT.PartClassificationId



GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MULTI_TASK_EDITOR_TASK_FLD_ID_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[MULTI_TASK_EDITOR_TASK_FLD_ID_V]
GO


create VIEW [dbo].[MULTI_TASK_EDITOR_TASK_FLD_ID_V]

/******************************************************************************
	Name: MULTI_TASK_EDITOR_TASK_FLD_ID_V

	Called By: MULTI_TASK_EDITOR_GET_P

	Desc: 	

	Auth: 	Veronika Vasylyeva
		
	Date: 	8 Apr 2008
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	12/04/12    SD		    E781 - Add PEX fields
	
OLD HISTORY
-----------	

	31/03/09	AL			CR7965: Added PctPurchasePart,PctPurchaseLabour,PctPurchaseMisc,PctPurchaseNewPart,SalesResponsibility
	23/07/2009	KN			Added CompStru / perfStra
	12-Jul-10	V Vasylyeva	CR9019: CBD
	 7 Oct 10	V vasylyeva	E316: PartRating
	 4 Apr 11   G Wang		Add AutoGenerateWOS
******************************************************************************
*/
AS


SELECT     
ComponentCodeId AS Component_Code, ModifierId AS Modifier_Code, TaskTypeId AS Task_Type, 
ApplicationCodeId AS Task_Counter, 
Task_Description AS [Description],CAST(0 AS int) AS Task_Mode, 
Planning_Lead_Time AS Planning_Lead_Time, Operational_Criticality_Id AS Operational_Criticality, 
ManufacturerId AS Manufacturer, Part_Id AS Primary_Part_Number, Group_Number AS Group_Number, 
Warranty_Period_Days AS Warranty_Days, Warranty_Period_Usage AS Warranty_Usage, UsageQUOMId AS UOM, 
[First] AS First_Occurrence, 
Frequency AS Frequency, Final AS Not_After, CAST(0 AS bit) AS Date_Based, CAST(0 AS float) AS Task_Cost,
--AL: 31/03/09
PctPurchasePart,PctPurchaseLabour,PctPurchaseMisc,PctPurchaseNewPart,SalesResponsibilityID AS SalesResponsibility,
Maintenance_Strategy_Id AS  Performance_Strategy,
RCMComponentStructureId AS Component_Structure,/*VV CR9019*/CBDTask,/*VV E316*/PartRatingId AS PartRating,/*GW*/AutoGenerateWOS,
/*SD E781*/
DefaultLocationForRebuild, PartClassificationId AS PartClassification

FROM tblProjTasks WHERE ProjTaskId=-1

GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RPT_WORK_SCHEDULE_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[RPT_WORK_SCHEDULE_V]
GO


create  VIEW dbo.RPT_WORK_SCHEDULE_V

AS

/******************************************************************************
	File: RPT_WORK_SCHEDULE_V.sql
	Name: RPT_WORK_SCHEDULE_V

	Called By: 

	Desc: 1. 
             

	Auth: Thy Rith
	Date: 07-NOV-2002
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------	
12 Apr 12   GD          E780 
22 Jul 11	V Vasylyeva	E602: Serialised Component
12 Nov 09	AL			CR8308: Added tblProjTasks.Task_Header_ID
22 Oct 09	AL			CR8414: New Component Tracking method
05 Feb 09	KN			Added EqpLocation
17/09/08	AL			removed links to tblqualifier and tbluoms
25 Jun 08	V Vasylyeva	CR7053 Changed tblParts.PartDescription to tblParts.Part
24 Apr 08   YS			Got rid of check for Current Projection
11 Apr 08   YS			Added Task Counter
29 Nov 06	AL			Removed sum for life used
15 Nov 06	SI			Changed to support date based tasks
26 Jul 06	KN			Added Life Used Column
15 Apr 04	H Singh		Planning Task fix (moved to tblProjtasks table)
17 Dec 2003	HS			Part Number and Rotable Srial Number is added
******************************************************************************/

SELECT     dbo.tblComponentCodes.Code + ' ' + dbo.tblComponentCodes.Description AS Component, dbo.tblEqpPlans.EqpPlan, dbo.tblModifierCodes.Code AS Modifier, 
                      dbo.tblOccurrenceTypes.OccurrenceType, ISNULL(dbo.WORK_SCHEDULE_DATE_LOCKED_V.PlanDateLocked, 0) AS StrategyLocked, 
                      dbo.tblProjTaskOccs.OccDate AS DueDate, CASE WHEN tblProjTasks.UsageQUOMId IS NULL THEN 'Days' ELSE tblQUOMs.UOMShortDesc END AS QUOM, 
                      dbo.tblProjTasks.Frequency AS ProjInterval, dbo.tblSystems.SystemID, dbo.tblEqpPlans.EqpPlanId, dbo.tblProjTasks.EqpProjId, dbo.tblModifierCodes.ModifierID, 
                      dbo.tblComponentCodes.ComponentCodeID AS CompCodeID, dbo.tblProjTasks.ProjTaskId, dbo.tblBranches.BranchId, dbo.tblSites.SiteId, dbo.tblFleets.FleetId, 
                      dbo.tblModels.ModelId, dbo.tblProjTaskOccs.OccDate, dbo.tblTaskTypes.TaskTypeID, SUM(dbo.RPT_WORK_SCHEDULE_PROJ_TASK_V.TotalEsc) AS ProjCost, 
                      SUM(dbo.RPT_WORK_SCHEDULE_PROJ_TASK_V.TotalLabor) AS ProjLabHours, SUM(dbo.RPT_WORK_SCHEDULE_PROJ_TASK_V.TotalDuration) AS ProjDuration, 
                      dbo.tblSystems.CostTypeID, dbo.tblTaskTypes.Code AS TaskType, dbo.tblBranches.DealerId, dbo.tblSubSystems.SubSystemID, 
                      dbo.tblEqpProjs.Projection_Header_ID AS ProjHeaderId, dbo.tblProjTaskOccs.OccUsage AS Usage, CASE WHEN tblProjTasks.Rotable_Part_Id IS NULL 
                      THEN CASE WHEN RPT_COMP_STATUS_WO_DETAILS_V.LCDWONumber IS NULL 
                      THEN /*VV E602*/COMPONENT_SERIALISED.ComponentSerialNo ELSE RPT_COMP_STATUS_WO_DETAILS_V.SerialNoIn END ELSE ROTABLE_INUSE.Rotable_Item_Id END AS RotableItemId,
                       dbo.tblParts.Part AS PartDescription, dbo.ROTABLE_PART.Part_Number, (CASE WHEN tblProjTasks.LastOccDate IS NULL 
                      THEN dbo.GET_USAGE_FROM_DATE_F(tblEqpProjs.EqpProjId, tblProjTasks.UsageQUOMId, GetDate()) ELSE dbo.GET_USAGE_FROM_DATE_F(tblEqpProjs.EqpProjId, 
                      tblProjTasks.UsageQUOMId, GetDate()) - ISNULL(tblProjTasks.LastOcc, 0) END) AS LifeUsed, dbo.tblApplicationCodes.ApplicationCodeID AS TaskCounterID, 
                      dbo.tblApplicationCodes.Code AS TaskCounter, dbo.tblEqpPlans.Eqp_Location_Id, dbo.tblProjTasks.Task_Header_Id,                      
                      dbo.tblProjTasks.PartRatingId,
                      CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL (dbo.NEXT_OCC_STRATEGY.PEXPartTypeId,dbo.tblProjTasks.PartClassificationId) ELSE dbo.tblProjTasks.PartClassificationId END AS PartClassificationId,
                      CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(dbo.NEXT_OCC_STRATEGY.PEXRebuildLocationId,dbo.tblProjTasks.DefaultLocationForRebuild) ELSE dbo.tblProjTasks.DefaultLocationForRebuild END AS RebuildLocationId,
                      CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(NextDuePartCl.PartClassification , PC.PartClassification) ELSE PC.PartClassification END AS PartClassification,
                      PR.PartRating,
                      CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(NextDueRL.Site , BaseDetailsRL.Site) ELSE BaseDetailsRL.Site END AS RebuildLocation,
                      CASE WHEN dbo.tblProjTasks.Rotable_Part_Id>0 THEN dbo.tblProjTasks.Rotable_Part_Id ELSE CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(dbo.NEXT_OCC_STRATEGY.PEXPartId,dbo.tblProjTasks.Part_Id) ELSE dbo.tblProjTasks.Part_Id END END AS Part_Id,
                      CASE WHEN tblProjTasks.Rotable_Part_Id > 0 THEN dbo.ROTABLE_PART.Part_Number  ELSE CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(NextDueParts.Part , tblParts.Part) ELSE tblParts.Part END END  AS PrimaryPartDescr,                                           
                      dbo.tblProjTasks.ReviewStatusID,                      
                      SS.SalesStatusId,                        
                      RS.ReviewStatusDesc,
                      SS.SalesStatus
                     
FROM         dbo.tblQUOMs RIGHT OUTER JOIN
                      dbo.tblModifierCodes RIGHT OUTER JOIN
                      dbo.tblSubSystems INNER JOIN
                      dbo.tblComponentCodes ON dbo.tblSubSystems.SubSystemID = dbo.tblComponentCodes.SubSystemID INNER JOIN
                      dbo.tblSystems ON dbo.tblSubSystems.SystemID = dbo.tblSystems.SystemID RIGHT OUTER JOIN
                      dbo.tblEquipment INNER JOIN
                      dbo.tblProjTaskOccs INNER JOIN
                      dbo.tblProjTasks ON dbo.tblProjTaskOccs.EqpPlanId = dbo.tblProjTasks.EqpPlanId AND dbo.tblProjTaskOccs.EqpProjId = dbo.tblProjTasks.EqpProjId AND 
                      dbo.tblProjTaskOccs.ProjTaskId = dbo.tblProjTasks.ProjTaskId INNER JOIN
                      dbo.tblEqpPlans INNER JOIN
                      dbo.tblEqpProjs ON dbo.tblEqpPlans.EqpPlanId = dbo.tblEqpProjs.EqpPlanId ON dbo.tblProjTaskOccs.EqpProjId = dbo.tblEqpProjs.EqpProjId AND 
                      dbo.tblProjTaskOccs.EqpPlanId = dbo.tblEqpPlans.EqpPlanId INNER JOIN
                      dbo.tblSites INNER JOIN
                      dbo.tblBranches ON dbo.tblSites.BranchId = dbo.tblBranches.BranchId INNER JOIN
                      dbo.tblFleets ON dbo.tblSites.SiteId = dbo.tblFleets.SiteId ON dbo.tblEqpPlans.FleetId = dbo.tblFleets.FleetId ON 
                      dbo.tblEquipment.EquipmentId = dbo.tblEqpPlans.EquipmentId INNER JOIN
                      dbo.tblModels ON dbo.tblEquipment.ModelId = dbo.tblModels.ModelId INNER JOIN
                      dbo.RPT_WORK_SCHEDULE_PROJ_TASK_V ON dbo.tblProjTasks.ProjTaskId = dbo.RPT_WORK_SCHEDULE_PROJ_TASK_V.ProjTaskId LEFT OUTER JOIN
                      /*VV E602*/dbo.COMPONENT_SERIALISED ON dbo.tblProjTasks.StartingSerialNoId = dbo.COMPONENT_SERIALISED.ComponentSerialisedId ON 
                      dbo.tblComponentCodes.ComponentCodeID = dbo.tblProjTasks.ComponentCodeId LEFT OUTER JOIN
                      dbo.tblParts ON dbo.tblProjTasks.Part_Id = dbo.tblParts.PartId LEFT OUTER JOIN
                      dbo.ROTABLE_PART ON dbo.tblProjTasks.Rotable_Part_Id = dbo.ROTABLE_PART.Rotable_Part_Id ON 
                      dbo.tblModifierCodes.ModifierID = dbo.tblProjTasks.ModifierId ON dbo.tblQUOMs.QUOMId = dbo.tblProjTasks.UsageQUOMId LEFT OUTER JOIN
                      dbo.WORK_SCHEDULE_DATE_LOCKED_V ON dbo.tblProjTaskOccs.ProjTaskId = dbo.WORK_SCHEDULE_DATE_LOCKED_V.ProjTaskId AND 
                      dbo.tblProjTaskOccs.OccDate = dbo.WORK_SCHEDULE_DATE_LOCKED_V.OccDate LEFT OUTER JOIN
                      dbo.tblProjTaskOpts ON dbo.tblProjTaskOccs.ProjTaskOptId = dbo.tblProjTaskOpts.ProjTaskOptId LEFT OUTER JOIN
                      dbo.tblTaskTypes ON dbo.tblProjTasks.TaskTypeId = dbo.tblTaskTypes.TaskTypeID LEFT OUTER JOIN
                      dbo.tblOccurrenceTypes ON dbo.tblProjTaskOpts.OccurrenceTypeId = dbo.tblOccurrenceTypes.OccurrenceTypeId LEFT OUTER JOIN
                      dbo.tblApplicationCodes ON dbo.tblProjTasks.ApplicationCodeId = dbo.tblApplicationCodes.ApplicationCodeID LEFT OUTER JOIN
                      dbo.RPT_COMP_STATUS_WO_DETAILS_V ON dbo.tblProjTasks.ProjTaskId = dbo.RPT_COMP_STATUS_WO_DETAILS_V.ProjTaskId LEFT OUTER JOIN
                      dbo.ROTABLE_INUSE INNER JOIN
                      dbo.ROTABLE_ITEM_LATEST_STATUS_V ON dbo.ROTABLE_ITEM_LATEST_STATUS_V.Rotable_Item_Id = dbo.ROTABLE_INUSE.Rotable_Item_Id AND 
                      dbo.ROTABLE_ITEM_LATEST_STATUS_V.StartDate = dbo.ROTABLE_INUSE.Start_Date ON dbo.tblProjTasks.ProjTaskId = dbo.ROTABLE_INUSE.Proj_Task_Id LEFT JOIN
                      dbo.NEXT_OCC_STRATEGY ON tblProjTasks.ProjTaskId = NEXT_OCC_STRATEGY.Proj_Task_Id LEFT JOIN 
                      PART_CLASSIFICATION PC ON PC.PartClassificationId = tblProjTasks.PartClassificationId LEFT JOIN 
                      dbo.PART_RATING PR ON PR.PartRatingId = tblProjTasks.PartRatingId LEFT JOIN 
                      dbo.REVIEW_STATUS RS ON RS.ReviewStatusID = dbo.tblProjTasks.ReviewStatusID LEFT JOIN
                      dbo.SALES_STATUS SS ON SS.SalesStatusId = dbo.NEXT_OCC_STRATEGY.SalesStatusId LEFT JOIN                      
					  dbo.tblParts NextDueParts ON dbo.NEXT_OCC_STRATEGY.PEXPartId = NextDueParts.PartId LEFT JOIN  
                      dbo.tblSites NextDueRL ON NextDueRL.SiteId = dbo.NEXT_OCC_STRATEGY.PEXRebuildLocationId  LEFT JOIN 
                      dbo.PART_CLASSIFICATION NextDuePartCl ON  NextDuePartCl.PartClassificationId = dbo.NEXT_OCC_STRATEGY.PEXPartTypeId LEFT JOIN
                      dbo.tblSites BaseDetailsRL ON  BaseDetailsRL.SiteId = dbo.tblProjTasks.DefaultLocationForRebuild
                         
WHERE     (dbo.tblProjTasks.Planning_Task <> 0)
GROUP BY dbo.tblComponentCodes.Code + ' ' + dbo.tblComponentCodes.Description, dbo.tblEqpPlans.EqpPlan, dbo.tblModifierCodes.Code, 
                      dbo.tblOccurrenceTypes.OccurrenceType, dbo.tblProjTaskOccs.OccDate, CASE WHEN tblProjTasks.UsageQUOMId IS NULL 
                      THEN 'Days' ELSE tblQUOMs.UOMShortDesc END, dbo.tblProjTasks.Frequency, dbo.tblSystems.SystemID, dbo.tblEqpPlans.EqpPlanId, dbo.tblProjTasks.EqpProjId, 
                      dbo.tblModifierCodes.ModifierID, dbo.tblComponentCodes.ComponentCodeID, dbo.tblProjTasks.ProjTaskId, dbo.tblBranches.BranchId, dbo.tblSites.SiteId, 
                      dbo.tblFleets.FleetId, dbo.tblModels.ModelId, dbo.tblTaskTypes.TaskTypeID, ISNULL(dbo.WORK_SCHEDULE_DATE_LOCKED_V.PlanDateLocked, 0), 
                      dbo.tblSystems.CostTypeID, dbo.tblTaskTypes.Code, dbo.tblBranches.DealerId, dbo.tblSubSystems.SubSystemID, dbo.tblEqpProjs.Projection_Header_ID, 
                      dbo.tblProjTaskOccs.OccUsage, CASE WHEN tblProjTasks.Rotable_Part_Id IS NULL THEN CASE WHEN RPT_COMP_STATUS_WO_DETAILS_V.LCDWONumber IS NULL
                       THEN /*VV E602*/COMPONENT_SERIALISED.ComponentSerialNo ELSE RPT_COMP_STATUS_WO_DETAILS_V.SerialNoIn END ELSE ROTABLE_INUSE.Rotable_Item_Id END, 
                      dbo.tblParts.Part, dbo.ROTABLE_PART.Part_Number, dbo.tblEqpProjs.EqpProjId, dbo.tblProjTasks.UsageQUOMId, dbo.tblProjTasks.LastOccDate, 
                      dbo.tblProjTasks.LastOcc, dbo.tblApplicationCodes.Description, dbo.tblApplicationCodes.Code, dbo.tblApplicationCodes.ApplicationCodeID, 
                      dbo.tblEqpPlans.Eqp_Location_Id, dbo.tblProjTasks.Task_Header_Id ,
						dbo.tblProjTasks.PartRatingId,
						CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL (dbo.NEXT_OCC_STRATEGY.PEXPartTypeId,dbo.tblProjTasks.PartClassificationId) ELSE dbo.tblProjTasks.PartClassificationId END ,
						CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(dbo.NEXT_OCC_STRATEGY.PEXRebuildLocationId,dbo.tblProjTasks.DefaultLocationForRebuild) ELSE dbo.tblProjTasks.DefaultLocationForRebuild END ,
						CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(NextDuePartCl.PartClassification , PC.PartClassification) ELSE PC.PartClassification END ,
						PR.PartRating,
						CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(NextDueRL.Site , BaseDetailsRL.Site) ELSE BaseDetailsRL.Site END ,
						CASE WHEN dbo.tblProjTasks.Rotable_Part_Id>0 THEN dbo.tblProjTasks.Rotable_Part_Id ELSE CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(dbo.NEXT_OCC_STRATEGY.PEXPartId,dbo.tblProjTasks.Part_Id) ELSE dbo.tblProjTasks.Part_Id END END ,
						CASE WHEN tblProjTasks.Rotable_Part_Id > 0 THEN dbo.ROTABLE_PART.Part_Number  ELSE CASE WHEN tblProjTaskOccs.OccDate = dbo.tblProjTasks.NextOccDate THEN ISNULL(NextDueParts.Part , tblParts.Part) ELSE tblParts.Part END END ,
						dbo.tblProjTasks.ReviewStatusID,                      
						SS.SalesStatusId,                        
						RS.ReviewStatusDesc,
						SS.SalesStatus
						
GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[MULTI_TASK_EDITOR_TASK_V]'))
DROP VIEW [dbo].[MULTI_TASK_EDITOR_TASK_V]

GO

create VIEW [dbo].[MULTI_TASK_EDITOR_TASK_V]

/******************************************************************************
	Name: MULTI_TASK_EDITOR_TASK_V

	Called By: MULTI_TASK_EDITOR_GET_P

	Desc: 	

	Auth: 	Veronika Vasylyeva
		
	Date: 	2 Apr 2008
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	07-May-12   SD          E811 - Change Column Headings so that Multi-task editor can show correct grid column headings	
    02/05/12	SD			E811 - Add fields AutocreateExternalWorkorders & AutocreatePlannedEvents
	12/04/12    SD		    E781 - Add PEX fields
	
OLD HISTORY
-----------
	
	17/09/08	AL			removed links to tblqualifier and tbluoms
	31/03/09	AL			CR7965: Added PctPurchasePart,PctPurchaseLabour,PctPurchaseMisc,PctPurchaseNewPart,SalesResponsibility
	23/07/09	KN			Added Comp Stru/Perf stra
	12-Jul-10	V Vasylyeva	CR9019: CBD
	 7 Oct 10	V Vasylyeva	E316 PartRating
	 4 Apr 11	G Wang		Add AutoGenerateWOS
******************************************************************************
*/
AS

SELECT
PT.ProjTaskId, CC.Code + ' - ' + CC.Description AS Component_Code,
MC.Code + ' - ' + MC.Description AS Modifier_Code, TT.Code + ' - ' + TT.Description AS Task_Type, 
AC.Code + ' - ' + AC.Description AS Task_Counter, PT.Task_Description AS [Description], 
CASE WHEN PT.Unscheduled<>0 THEN 'Unassigned' 
WHEN PT.ParentTaskId>0 THEN 'Repair Reserve'
WHEN PT.Planning_Task=1 THEN 'Planning'
ELSE 'Non Planning' END AS Task_Mode,
CASE PT.Planning_Task WHEN 1 THEN PT.Planning_Lead_Time ELSE NULL END AS Planning_Lead_Time, 
OC.Operational_Criticality,M.ManufacturerDesc AS Manufacturer,
CASE WHEN Rotable_Part_Id>0 THEN NULL ELSE P.Part + ' - ' + P.PartDescription END AS Primary_Part_Number, 
PT.Group_Number, PT.Warranty_Period_Days AS Warranty_Days, PT.Warranty_Period_Usage AS Warranty_Usage, 
CAST(CASE WHEN PT.UsageQUOMId>0 THEN 0 ELSE 1 END AS bit) AS Date_Based,
QUOM.UOMShortDesc AS UOM, 
CASE WHEN PT.Unscheduled<>0 THEN NULL ELSE PTO.First END AS First_Occurrence, 
PTO.Frequency, 
CASE WHEN PT.Unscheduled<>0 THEN NULL ELSE NULLIF(PT.Final,0) END AS Not_After,
ISNULL(PT.ProjTotalEsc,0) AS Task_Cost,
PT.ComponentCodeId AS ComponentCodeId_NV,PT.ModifierId AS ModifierId_NV,PT.TaskTypeId AS TaskTypeId_NV,
S.SystemId AS SystemId_NV,S.System AS System_NV,SS.SubSystemId AS SubSystemId_NV,SS.SubSystem AS SubSystem_NV,
PT.UsageQUOMId AS QUOMId_NV,QUOM.UOMShortDesc AS QUOM_NV,PT.ApplicationCodeId AS ApplicationCodeId_NV,
--AL: 31/03/09
PT.PctPurchasePart,PT.PctPurchaseLabour,PT.PctPurchaseMisc,PT.PctPurchaseNewPart,
E.Surname + ', ' + E.First_Name AS SalesResponsibility,
MS.Maintenance_Strategy AS Performance_Strategy, 
CS.Component_Structure,/*VV CR9019*/PT.CBDTask,/*VV E316*/PAR.PartRating,
PT.PartRatingId AS PartRatingId_NV,/*GW*/PT.AutoGenerateWOS,
/*E781*/
tblSites.Site AS DefaultLocationForRebuild,
pc.PartClassification,
/*E811*/
PT.AutocreateExternalWorkorders  AS AutoCreateExternalWorkorders,
PT.AutocreatePlannedEvents AS [AutoCreatePlannedEvents/Workorders]
FROM         
		tblProjTasks AS PT INNER JOIN
		tblProjTaskOpts AS PTO ON PT.ProjTaskId = PTO.ProjTaskId INNER JOIN
		tblComponentCodes AS CC ON PT.ComponentCodeId = CC.ComponentCodeID INNER JOIN
		tblSubSystems AS SS ON CC.SubSystemID = SS.SubSystemID INNER JOIN
		tblSystems AS S ON SS.SystemID = S.SystemID INNER JOIN
		tblApplicationCodes AS AC ON PT.ApplicationCodeId = AC.ApplicationCodeID INNER JOIN
		tblModifierCodes AS MC ON PT.ModifierId = MC.ModifierID INNER JOIN
		tblTaskTypes AS TT ON PT.TaskTypeId = TT.TaskTypeID INNER JOIN
		tblManufacturers AS M ON PT.ManufacturerId = M.ManufacturerId LEFT OUTER JOIN
		tblQUOMs AS QUOM ON PT.UsageQUOMId = QUOM.QUOMId LEFT OUTER JOIN
		OPERATIONAL_CRITICALITY AS OC ON PT.Operational_Criticality_Id = OC.Operational_Criticality_Id LEFT OUTER JOIN
		tblParts AS P ON PT.Part_Id = P.PartId LEFT OUTER JOIN
		EMPLOYEE E ON PT.SalesResponsibilityID=E.Employee_ID LEFT OUTER JOIN 
		PART_RATING PAR ON PT.PartRatingId=PAR.PartRatingId LEFT OUTER JOIN
		MAINTENANCE_STRATEGY MS ON MS.Maintenance_Strategy_Id = PT.Maintenance_Strategy_Id LEFT OUTER JOIN
		(SELECT     
			CS.RCMComponentStructureId, M.Model+':'+CC.Code+':'+MC.Code+':'+TT.Code+':'+AC.Code+':'+ISNULL(CS.[Group],'') AS Component_Structure
		FROM RCM_COMPONENT_STRUCTURE CS
			INNER JOIN tblModels M ON CS.ModelId=M.ModelId
			INNER JOIN tblComponentCodes CC ON CS.ComponentCodeId=CC.ComponentCodeId
			INNER JOIN tblModifierCodes MC ON CS.ModifierCodeId=MC.ModifierId
			INNER JOIN tblApplicationCodes AC ON CS.ApplicationCodeID=AC.ApplicationCodeId
			INNER JOIN tblTaskTypes TT	ON CS.TaskTypeId=TT.TaskTypeId
		 ) CS ON CS.RCMComponentStructureId = PT.RCMComponentStructureId

		/*E781*/
		LEFT OUTER JOIN tblSites ON tblSites.SiteId = PT.DefaultLocationForRebuild
		LEFT OUTER JOIN PART_CLASSIFICATION pc ON pc.PartClassificationId = PT.PartClassificationId



GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MULTI_TASK_EDITOR_TASK_FLD_ID_V]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[MULTI_TASK_EDITOR_TASK_FLD_ID_V]
GO


create VIEW [dbo].[MULTI_TASK_EDITOR_TASK_FLD_ID_V]

/******************************************************************************
	Name: MULTI_TASK_EDITOR_TASK_FLD_ID_V

	Called By: MULTI_TASK_EDITOR_GET_P

	Desc: 	

	Auth: 	Veronika Vasylyeva
		
	Date: 	8 Apr 2008
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	07-May-12   SD          E811 - Change Column Headings so that Multi-task editor can show correct grid column headings
	02/05/12	SD			E811 - Add fields AutocreateExternalWorkorders & AutocreatePlannedEvents
	12/04/12    SD		    E781 - Add PEX fields
	
OLD HISTORY
-----------	

	31/03/09	AL			CR7965: Added PctPurchasePart,PctPurchaseLabour,PctPurchaseMisc,PctPurchaseNewPart,SalesResponsibility
	23/07/2009	KN			Added CompStru / perfStra
	12-Jul-10	V Vasylyeva	CR9019: CBD
	 7 Oct 10	V vasylyeva	E316: PartRating
	 4 Apr 11   G Wang		Add AutoGenerateWOS
******************************************************************************
*/
AS


SELECT     
ComponentCodeId AS Component_Code, ModifierId AS Modifier_Code, TaskTypeId AS Task_Type, 
ApplicationCodeId AS Task_Counter, 
Task_Description AS [Description],CAST(0 AS int) AS Task_Mode, 
Planning_Lead_Time AS Planning_Lead_Time, Operational_Criticality_Id AS Operational_Criticality, 
ManufacturerId AS Manufacturer, Part_Id AS Primary_Part_Number, Group_Number AS Group_Number, 
Warranty_Period_Days AS Warranty_Days, Warranty_Period_Usage AS Warranty_Usage, UsageQUOMId AS UOM, 
[First] AS First_Occurrence, 
Frequency AS Frequency, Final AS Not_After, CAST(0 AS bit) AS Date_Based, CAST(0 AS float) AS Task_Cost,
--AL: 31/03/09
PctPurchasePart,PctPurchaseLabour,PctPurchaseMisc,PctPurchaseNewPart,SalesResponsibilityID AS SalesResponsibility,
Maintenance_Strategy_Id AS  Performance_Strategy,
RCMComponentStructureId AS Component_Structure,/*VV CR9019*/CBDTask,/*VV E316*/PartRatingId AS PartRating,/*GW*/AutoGenerateWOS,
/*SD E781*/
DefaultLocationForRebuild, PartClassificationId AS PartClassification,
/*E811*/
AutocreateExternalWorkorders AS AutoCreateExternalWorkorders, AutocreatePlannedEvents AS [AutoCreatePlannedEvents/Workorders]
FROM tblProjTasks WHERE ProjTaskId=-1





GO
