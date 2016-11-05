ALTER TABLE dbo.aa_downtime ADD
	id int NOT NULL IDENTITY (1, 1)
GO
ALTER TABLE dbo.aa_downtime ADD
	Task_ID int NULL
GO
ALTER TABLE dbo.aa_downtime ADD
	FinPeriod int NULL
GO
ALTER TABLE dbo.aa_downtime ADD
	Task_Operation_ID int NULL
GO
ALTER TABLE dbo.aa_downtime ADD CONSTRAINT
	PK_aa_downtime PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


ALTER TABLE aa_Downtime  ADD
 [Event_ID] [int] NULL,
 Eqp_Plan_ID INT NULL,
 TaskId INT NULL,
 	[Description] [varchar](500) NULL,
 	[Task_Type_ID] [int] NULL,
 	[Component_Code_ID] [int] NULL,
 	[Modifier_ID] [int] NULL,
 [Application_Code_ID] [int] NULL,
	[Occurrence_Type_Id] [int] NULL,
	[Priority_ID] [int] NULL,
	[Source_ID] [int] NULL,
	[Task_Status_ID] [int] NULL,
	[Date_Notified] [datetime] NULL,
	[Component_ID] [varchar](100) NULL,
	[Symptom_ID] [int] NULL,
	[Symptom_Notes] [varchar](8000) NULL,
	[Cause_ID] [int] NULL,
	[Cause_Notes] [varchar](8000) NULL,
	[Repair_Notes] [varchar](8000) NULL,
	[Group_No] [varchar](50) NULL,
	[Part_No] [varchar](50) NULL,
	[EMI_Ref] [varchar](50) NULL,
	--[Redo] [bit] NULL,
	[Task_Planned_Time_ID] [int] NULL,
	[Customer_Ref] [varchar](100) NULL,
	[Employee_ID] [int] NULL,
	[Expected_Duration] [float] NULL,
	[Expected_Labor_Hours] [float] NULL,
	[Planning_Notes] [varchar](8000) NULL,
	[Work_Order] [varchar](50) NULL,
	[Actual_Duration] [float] NULL,
	[Actual_Labor_Hrs] [float] NULL,
	[Primary_Cause] [bit] NULL,
	[Notes] [varchar](1000) NULL,
	[Task_Mode_ID] [int] NULL,
	[PartsStatusRequired] [bit] NULL,
	[PartsStatusOrdered] [bit] NULL,
	[PartsStatusReady] [bit] NULL,
	[Labour_Resources_Identified] [bit] NULL,
	[Location_Identified] [bit] NULL,
	[Tooling_Resources_Identified] [bit] NULL,
	[RaisedByID] [int] NULL,
	[Work_Order_ID] [int] NULL,
	[Strategy_Usage] [real] NULL,
	[Work_Group_ID] [int] NULL,
	[Strategy_QUOM_ID] [int] NULL,
	[Strategy_Proj_Task_Opt_ID] [int] NULL,
	[Planned_Proj_Task_Opt_ID] [int] NULL,
	[Strategy_Date] [datetime] NULL,
	[Strategy_Locked] [bit] NULL,
	[Last_Mod_By_User_ID] [int] NULL,
	[Last_Mod_Date] [datetime] NULL,
	[Create_By_User_ID] [int] NULL,
	[Create_Date] [datetime] NULL,
	[Repair_Code_Id] [int] NULL,
	[EM_Issue_Id] [int] NULL,
	[Task_Header_Id] [int] NULL,
	[Part_Description] [varchar](50) NULL,
	[Group_Description] [varchar](50) NULL,
	[SIMS_Code_Id] [int] NULL,
	[Rotable_Remove_Id] [int] NULL,
	[Rotable_Inuse_Id] [int] NULL,
	[Strategy_Repair_Description] [varchar](1000) NULL,
	[Sort_Order] [int] NULL,
	[WO_Create_Date] [datetime] NULL,
	[Performed_By_Date] [datetime] NULL,
	[Parts_Available_Date] [datetime] NULL,
	[Parts_Order_Details] [varchar](1000) NULL,
	[WO_Counter] [int] NULL,
	[Work_Order_Number_External] [varchar](50) NULL,
	[Cost_Bearer_ID] [int] NULL,
	[Task_Warranty] [bit] NULL,
	[Redo_Work_Order_ID] [int] NULL,
	[View_Warranty] [bit] NULL,
	[Health_Safety_Id] [int] NULL,
	[Break_Down] [bit] NULL,
	[Planned_Down_Time] [datetime] NULL,
	[Actual_Down_Time] [datetime] NULL,
	[Planned_Offset] [float] NULL,
	[Final_Change] [float] NULL,
	[Risk_Life_Left] [float] NULL,
	[Strategy_Frequency] [float] NULL,
	[Last_Performed] [float] NULL,
	[Last_Scheduled] [float] NULL,
	[Last_Performed_Date] [datetime] NULL,
	[Last_Scheduled_Date] [datetime] NULL,
	[Site_Id] [int] NULL,
	[Work_Location] [varchar](100) NULL,
	[Cost_Centre_Id] [int] NULL,
	[Branch_Id] [int] NULL,
	[Customer_Id] [int] NULL,
	[Part_Entry_Distribution_Code_Id] [int] NULL,
	[Def_Work_Group_Id] [int] NULL,
	[Parts_Cost_Expense_Id] [int] NULL,
	[Labour_Cost_Expense_Id] [int] NULL,
	[Misc_Cost_Expense_Id] [int] NULL,
	[Specific_Operation_Codes] [bit] NULL,
	[Work_Order_Date] [datetime] NULL,
	[Warranty_Claimable] [bit] NULL,
	[Reviewed_Employee_Id] [int] NULL,
	[Warranty_Notes] [varchar](500) NULL,
	[Warranty_Days] [float] NULL,
	[Warranty_Usage] [float] NULL,
	[Warranty_Days_Archived] [float] NULL,
	[Warranty_Usage_Acrhived] [float] NULL,
	[Warranty_Supplier_Id] [int] NULL,
	[Claim_Ref] [varchar](20) NULL,
	[Supplier_Ref] [varchar](20) NULL,
	[Summary_Description] [varchar](200) NULL,
	[Claim_Status_Id] [int] NULL,
	[Claimed_By_Employee_Id] [int] NULL,
	[Claime_Date] [datetime] NULL,
	[Claim_Description] [varchar](1000) NULL,
	[Job_Parts_Cost] [float] NULL,
	[Job_Labour_Cost] [float] NULL,
	[Job_Misc_Cost] [float] NULL,
	[Claimed_Parts_Cost] [float] NULL,
	[Claimed_Labour_Cost] [float] NULL,
	[Claimed_Misc_Cost] [float] NULL,
	[Rec_Parts_Cost] [float] NULL,
	[Rec_Labour_Cost] [float] NULL,
	[Rec_Misc_Cost] [float] NULL,
	[Labour_Entry_Distribution_Code_Id] [int] NULL,
	[Misc_Entry_Distribution_Code_Id] [int] NULL,
	[Supplier_Contact] [varchar](100) NULL,
	[Task_Authorised] [bit] NULL,
	[Task_Authorised_By_Id] [int] NULL,
	[Task_Authorised_Date] [datetime] NULL,
	[ActualOffset] [float] NULL,
	[AMTPlanningModeId] [int] NULL,
	[ChangeoutCategoryId] [int] NULL,
	[LifeConfirmed] [bit] NULL,
	[OriginalPartTypeId] [int] NULL,
	[SerialNoIn] [varchar](100) NULL,
	[SerialNoOut] [varchar](100) NULL,
	[IsOverwriteLife] [bit] NULL,
	[OverwriteLifeAchieved] [float] NULL,
	[TaskExported] [bit] NULL,
	[Task_Authorised_Amount] [float] NULL,
	[Task_Authorised_TolerancePct] [float] NULL,
	[ShutdownID] [int] NULL,
	[ConditionMonitoringIntervention] [bit] NULL,
	[FailedPartListPosition] [varchar](100) NULL,
	[FailedPartListGroup] [varchar](100) NULL,
	[FailedPartLifeAchieved] [float] NULL,
	[FailedGroupListPosition] [varchar](100) NULL,
	[FailedGroupPartsListGroup] [varchar](100) NULL,
	[WarrantyClaimByUserId] [int] NULL,
	[WarrantyClaimSystemDate] [datetime] NULL,
	[LastNotified] [datetime] NULL,
	[AuthorisationRequestByID] [int] NULL,
	[AuthorisationRequestDate] [datetime] NULL,
	[ResourceStatusReady] [bit]  NULL 
 
 
 GO
 
ALTER TABLE aa_Downtime ADD Responsibility_ID INT
GO

 
--STEP 1:
SELECT   DISTINCT AA.Equipment,AA.Model, AA.[Serial Number] 
--UPDATE AA SET AA.Equipment = AA.Equipment + '[1]'
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.EQUIPMENT_HIERARCHY_V AS EH ON AA.Equipment = EH.EqpPlan
WHERE     (EH.EqpPlan IS NULL)

UPDATE AA SET AA.Equipment = AA.Equipment + '[1]'
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.EQUIPMENT_HIERARCHY_V AS EH ON AA.Equipment = EH.EqpPlan
WHERE     (EH.EqpPlan IS NULL)

UPDATE AA SET AA.Eqp_Plan_Id = EH.EqpPlanId
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.EQUIPMENT_HIERARCHY_V AS EH ON AA.Equipment = EH.EqpPlan
                      
SELECT * FROM aa_downtime where  Eqp_Plan_Id IS NULL

 -- --STEP 2:************************************

SELECT     AA.ID, AA.Responsibility
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.RESPONSIBILITY AS R ON AA.Responsibility = R.Description
WHERE     (R.Responsibility_ID IS NULL)

UPDATE AA SET AA.Responsibility_ID = R.Responsibility_ID
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.RESPONSIBILITY AS R ON AA.Responsibility = R.Description


----STEP 3:************************************
SELECT     AA.ID, AA.[Task Type]
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.tblTaskTypes AS TT ON AA.[Task Type] = TT.Code
WHERE     (TT.TaskTypeID IS NULL)


UPDATE AA SET AA.Task_Type_ID = TT.TaskTypeID
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.tblTaskTypes AS TT ON AA.[Task Type] = TT.Code
                      
 ----STEP 4:************************************
 
 IF EXISTS (
SELECT     AA.[Comp Code]
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.tblComponentCodes AS CC ON AA.[Comp Code] = CC.Code
WHERE     (CC.ComponentCodeID IS NULL)
GROUP BY AA.[Comp Code]

)
BEGIN
	Declare @SubSysID int

	SELECT @SubSysID=SubSystemID
	FROM dbo.tblSubSystems
	WHERE Unassigned<>0

	INSERT INTO dbo.tblComponentCodes(SubSystemID,Code,Description,BudgetCode,
				LastModByUserId,LastModDate,CreateByUserId,CreateDate,Default_Record)
	SELECT     @SubSysID, AA.[Comp Code], AA.[Comp Code],0,0,getdate(),0,getdate(),0

	FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
						  dbo.tblComponentCodes AS CC ON AA.[Comp Code] = CC.Code
	WHERE     (CC.ComponentCodeID IS NULL)
	GROUP BY AA.[Comp Code]

END


UPDATE  AA SET AA.Component_Code_ID = CC.ComponentCodeID
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.tblComponentCodes AS CC ON AA.[Comp Code] = CC.Code

 ----STEP 5:************************************
  IF EXISTS (
 SELECT     AA.ID, AA.[Mod Code]
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.tblModifierCodes AS MC ON AA.[Mod Code] = MC.Code
WHERE     (MC.ModifierID IS NULL) AND AA.[Mod Code] IS NOT NULL
 )
 BEGIN
INSERT INTO tblModifierCodes(Code, Description, BudgetCode)
SELECT    DISTINCT AA.[Mod Code], AA.[Mod Code],1
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.tblModifierCodes AS MC ON AA.[Mod Code] = MC.Code
WHERE     (MC.ModifierID IS NULL) AND AA.[Mod Code] IS NOT NULL
END

Update AA SET AA.Modifier_ID = MC.ModifierID
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.tblModifierCodes AS MC ON AA.[Mod Code] = MC.Code
                      
----STEP 6:************************************
 
SELECT     AA.ID, AA.[Work order]
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.tblWorkorders AS WO ON '00' + AA.[Work order] = WO.PureWoNumber
WHERE     (WO.WorkorderID IS NULL) and AA.[Work order] IS NOT NULL


UPDATE aa_Downtime
SET  [Work order] = '00' +  [Work order]
WHERE   [Work order] IS NOT NULL

UPDATE AA
SET AA.[Work order] = NULL
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.tblWorkorders AS WO ON '00' + AA.[Work order] = WO.PureWoNumber
WHERE     (WO.WorkorderID IS NULL) and AA.[Work order] IS NOT NULL

 
 UPDATE AA
SET AA.Work_Order_ID = WO.WorkOrderId
--SELECT AA.[Work Order]
FROM         dbo.aa_downtime AS AA LEFT JOIN
                      dbo.tblWorkorders AS WO ON  AA.[Work order] = WO.PureWoNumber
 
 
 ----STEP 6:************************************                     
 

declare @priorityID int
select @priorityID=priority_ID
from PRIORITY
where default_record<>0

UPDATE AA SET AA.Priority_ID = ISNULL(TT.Priority_ID, @priorityID)
FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                      dbo.PRIORITY AS TT ON AA.PRIORITY = TT.Short_Description
                      
----STEP 7:************************************  
INSERT INTO   EVENT (Eqp_Plan_ID, Description, Event_Status_ID, Priority_ID, Work_Location_ID, Planned, Break_Down, Expected_Up_Time, Confirmed, 
                      Event_Prevention_ID, Planned_Down_Time, Planned_Down_Usage, Planned_Up_Time, Planned_Up_Usage, Actual_Down_Time, Actual_Down_Usage, 
                      Actual_Up_Time, Down_Delay_Hrs, Actual_Up_Usage, Event_Mode_ID, Has_Down_Time, New_Event, QUOM_ID, Last_Mod_By_User_ID, 
                      Last_Mod_Date, Create_By_User_ID, Create_Date, Test_Time)
SELECT 
	EH.EqpPlanId,
	AA.[Event Descr] AS Description,
	3 AS Event_Status_ID,
	AA.Priority_ID,
	NULL,
	AA.Planned, AA.Breakdown AS Break_Down,
	CASE WHEN [Actual Up Time] IS NULL THEN DATEADD(minute, ISNULL([Actual Hours], 0) * 60, [Actual Down Time]) 
			ELSE AA.[Actual Up Time] END AS Expected_Up_Time, 
        0 AS Confirmed, 
3 AS Event_Prevention_ID, 
 AA.[Actual Down Time] AS Planned_Down_Time, 
 0 AS Planned_Down_Usage, 
       CASE WHEN [Actual Up Time] IS NULL THEN DATEADD(minute, ISNULL([Actual Hours], 0) * 60, [Actual Down Time]) 
            ELSE AA.[Actual Up Time] END AS Planned_Up_Time, 
		0 AS Planned_Up_Usage, AA.[Actual Down Time] AS Actual_Down_Time, ISNULL(AA.[Actual Down Usage], 0) AS Actual_Down_Usage, 
		AA.[Actual Up Time] AS Actual_Up_Time, AA.ID AS Down_Delay_Hrs, 0 AS Actual_Up_Usage, 1 AS Event_Mode_ID, 1 AS Has_Down_Time, 
1 AS New_Event,
	1 AS QUOM_ID, 0 AS Last_Mod_By_User_ID, GETDATE() AS Last_Mod_Date, 0 AS Create_By_User_ID, 
		GETDATE() AS Create_Date, 0 AS Test_Time		
FROM 
aa_downtime AA 
	INNER JOIN EQUIPMENT_HIERARCHY_V EH on EH.EqpPlanId = AA.Eqp_Plan_ID
WHERE EH.Projection_Type_ID = 1

 
 UPDATE AA SET AA.Event_ID = TT.Event_ID
 FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                     dbo.EVENT AS TT ON AA.id = ISNULL( TT.Down_Delay_Hrs,0)
                     
----STEP 8:************************************  
--SELECT * FROM VARIANCE_CAUSE
INSERT INTO   dbo.DOWN_TIME_ALLOCATION (Event_ID, Task_Type_ID, Responsibility_ID, Planned_Hours, Actual_Hours, Primary_DTA, Last_Mod_By_User_ID, Last_Mod_Date, 
                      Create_By_User_ID, Create_Date, Variance_Cause_ID)
SELECT  
		AA.Event_ID, 
		Task_Type_ID, 
		Responsibility_ID,
			ROUND((CONVERT(float, E.Actual_Up_Time) - CONVERT(float, E.Actual_Down_Time)) * 24, 3) AS Planned_Hours, 
		ROUND((CONVERT(float, E.Actual_Up_Time) - CONVERT(float, E.Actual_Down_Time)) * 24, 3) AS Actual_Hours, 
		1 AS Primary_DTA,
		0 AS Last_Mod_By_User_ID, GETDATE() AS Last_Mod_Date, 0 AS Create_By_User_ID, 
		GETDATE() AS Create_Date, 63 AS Variance_Cause_ID
		
FROM        aa_downtime
AA INNER JOIN dbo.EVENT E ON E.Event_ID = AA.Event_ID

----STEP 9:************************************ 

BEGIN
UPDATE aa_downtime 
	SET Application_Code_ID = 0 , Occurrence_Type_Id = 1, Source_ID = 3, Task_Status_ID = 3, 
	Date_Notified = ISNULL([Notified Date],GETDATE()), Symptom_ID = 23, Cause_ID = 71, Repair_Code_Id = 0, Redo = 0
	,Task_Planned_Time_ID = 1, Expected_Duration = ISNULL( [Actual Duration],0), 
	Expected_Labor_Hours = ISNULL([Actual Labour Hours],0),
	Actual_Duration =  ISNULL( [Actual Duration],0),Primary_Cause = 1,
	 PartsStatusRequired = 1,	--AL: 10/09/09
	 PartsStatusOrdered =0,
	 PartsStatusReady  =0,
	 Labour_Resources_Identified =1,
	 Location_Identified  =1,
	 Tooling_Resources_Identified =1,Strategy_Locked = 0, Performed_By_Date =  [Actual Up Time], WO_Counter = 0,Task_Warranty =0,
	 View_Warranty = 0,Planned_Offset = 0, ActualOffset = 0, Specific_Operation_Codes = 1, Warranty_Days = 0 , Warranty_Usage = 0,ChangeoutCategoryId = 1,
	 ConditionMonitoringIntervention = 0,LifeConfirmed = 1,IsOverwriteLife= 0
	 
	 
	 
UPDATE AA 
SET 
AA.Break_Down = E.Break_Down,
AA.Planned_Down_Time = E.Planned_Down_Time, 
AA.Actual_Down_Time =E.Actual_Down_Time 
FROM aa_downtime AA INNER JOIN EVENT E ON E.Event_ID = AA.Event_ID
 
UPDATE AA SET AA.Task_Mode_ID = TT.Advanced_Planning
 FROM         dbo.aa_downtime AS AA LEFT OUTER JOIN
                     dbo.EQUIPMENT_HIERARCHY_V AS TT ON TT.EqpPlanId = AA.Eqp_Plan_ID
	
UPdate AA SET
 
	 AA.Site_Id=S.SiteId,
 	 AA.Branch_Id=S.BranchId, 
 	 AA.Cost_Bearer_ID=EP.Default_Cost_Bearer_ID, 
	 AA.Cost_Centre_ID=EP.Cost_Centre_ID, 
	 AA.Part_Entry_Distribution_Code_Id=EP.Parts_Entry_Distribution_Code_Id, 
	 AA.Labour_Entry_Distribution_Code_Id=EP.Labour_Entry_Distribution_Code_Id, 
	 AA.Misc_Entry_Distribution_Code_Id=EP.Misc_Entry_Distribution_Code_Id,
	 AA.Customer_id=EP.Customer_Id,
	 --Task_Mode_ID=CASE B.Enable_Auto_WO_Create WHEN 1 THEN @Task_Mode_AW ELSE @Task_Mode_GT END,
 	 AA.AMTPlanningModeId=EP.Advanced_Planning,
 	 AA.Work_Group_ID=WG.Work_Group_Id,
 	 AA.Def_Work_Group_Id = WG.Work_Group_ID
 
FROM   
aa_downtime AA INNER JOIN tblEqpPlans AS EP ON EP.EqpPlanId= AA.Eqp_Plan_ID
	INNER JOIN tblEquipment E ON E.EquipmentId=EP.EquipmentId
	INNER JOIN tblFleets F	ON EP.FleetId=F.FleetId
	INNER JOIN tblSites S ON F.SiteId=S.SiteId
	INNER JOIN tblBranches B ON S.BranchId=B.BranchId
	LEFT OUTER JOIN WORK_GROUP WG ON S.SiteId=WG.Site_Id AND (WG.Default_Record=1 OR WG.Default_Record IS NULL)
 
UPDATE DD SET 
		 DD.Component_Code_ID = AMTComponentCodeId, 
		 DD.Modifier_ID = AMTModifierId, 
		 DD.Task_Type_ID = AMTTaskTypeId, 
		 DD.Application_Code_ID = AMTApplicationCodeId, 
		 DD.Occurrence_Type_Id = AMTOccurrenceTypeId,
		 DD.Strategy_Date=AMTStartDate,
		 DD.Task_Header_Id= WO.Task_Header_Id
	FROM    
		tblWorkOrders WO INNER JOIN 
		aa_downtime DD  ON DD.Work_Order_ID = WO.WorkOrderId
	  
INSERT INTO dbo.TASK_HEADER WITH(UPDLOCK, ROWLOCK) (Description, Component_Code, Modifier_Code, Task_Type, Application_Code)
SELECT DISTINCT 
CC.Code + '.' + MC.Code + '.' + TT.Code + '.' + AC.Code + ' ' + CC.Description, 
CC.Code,MC.Code,TT.Code, AC.Code  
FROM aa_downtime AA 
	INNER JOIN tblComponentCodes CC ON CC.ComponentCodeID = AA.Component_Code_ID
	INNER JOIN tblTaskTypes TT ON TT.TaskTypeID = AA.Task_Type_ID
	INNER JOIN tblApplicationCodes AC ON AC.ApplicationCodeID = AA.Application_Code_ID
	INNER JOIN tblModifierCodes MC ON MC.ModifierID = AA.Modifier_ID
	LEFT JOIN TASK_HEADER TH ON TH.Component_Code = CC.Code AND TH.Modifier_Code = MC.Code AND TH.Application_Code = AC.Code
		AND TH.Task_Type = TT.Code
WHERE TH.Task_Header_Id IS NULL

UPDATE AA
SET AA.Task_Header_Id = TH.Task_Header_Id
 
FROM aa_downtime AA 
	INNER JOIN tblComponentCodes CC ON CC.ComponentCodeID = AA.Component_Code_ID
	INNER JOIN tblTaskTypes TT ON TT.TaskTypeID = AA.Task_Type_ID
	INNER JOIN tblApplicationCodes AC ON AC.ApplicationCodeID = AA.Application_Code_ID
	INNER JOIN tblModifierCodes MC ON MC.ModifierID = AA.Modifier_ID
	LEFT JOIN TASK_HEADER TH ON TH.Component_Code = CC.Code AND TH.Modifier_Code = MC.Code AND TH.Application_Code = AC.Code
		AND TH.Task_Type = TT.Code
		
END
	
 
 INSERT INTO TASK 
(
Event_ID, 
[Description], 
Eqp_Plan_ID, 
Task_Type_ID, 
Component_Code_ID, 
Modifier_ID, 
Application_Code_ID, 
Occurrence_Type_Id, 
Priority_ID, 
Source_ID, 
Task_Status_ID, 
Date_Notified, 
Component_ID, 
Symptom_ID, 
Symptom_Notes, 
Cause_ID, 
Cause_Notes, 
Repair_Code_ID, 
Repair_Notes, 
Group_No, 
Part_No, 
EMI_Ref, 
EM_Issue_Id,
Redo, 
Task_Planned_Time_ID, 
Customer_Ref, 
employee_ID, 
Expected_Duration, 
Expected_Labor_Hours, 
Planning_Notes, 
Actual_Duration, 
Primary_Cause, 
Notes,
Task_Mode_ID,
PartsStatusRequired,
PartsStatusOrdered,
PartsStatusReady,
Labour_Resources_Identified,
Location_Identified,
Tooling_Resources_Identified,
RaisedByID,
Work_Group_ID,
Strategy_Usage,
Strategy_QUOM_ID,
Strategy_Proj_Task_Opt_ID,
Planned_Proj_Task_Opt_ID,
Strategy_Date,
Strategy_Locked,
Part_Description,
Group_Description,
SIMS_Code_Id,
Last_Mod_By_User_ID,
Last_Mod_Date,
Create_By_User_ID,
Create_Date,
Task_Header_Id,
Strategy_Repair_Description,
Sort_Order,
WO_Create_Date,
Performed_By_Date,
 
WO_Counter,
Work_Order_Number_External,
Cost_Bearer_ID,
Task_Warranty,
Redo_Work_Order_ID,
View_Warranty,
Health_Safety_Id,
Break_Down,
Planned_Down_Time,
Actual_Down_Time,
Planned_Offset,
ActualOffset,
Final_Change,
Risk_Life_Left,
Strategy_Frequency,
Last_Performed,
Last_Scheduled,
Last_Performed_Date,
Last_Scheduled_Date,
Site_Id,
Work_Location,
Cost_Centre_Id,
Branch_Id,
Customer_Id,
Part_Entry_Distribution_Code_Id,
Def_Work_Group_Id,
Parts_Cost_Expense_Id,
Labour_Cost_Expense_Id,
Misc_Cost_Expense_Id,
Specific_Operation_Codes,
 Warranty_Days,
Warranty_Usage,
Labour_Entry_Distribution_Code_Id,
Misc_Entry_Distribution_Code_Id,
AMTPlanningModeId,
ChangeoutCategoryId,
LifeConfirmed,
OverwriteLifeAchieved
)

SELECT
AA.Event_ID ,
AA.[Task Descr],
AA.Eqp_Plan_ID,
AA.Task_Type_ID,
AA.Component_Code_ID,
AA.Modifier_ID,
AA.Application_Code_ID,
AA.Occurrence_Type_Id,
AA.Priority_ID,
AA.Source_ID,
AA.Task_Status_ID,
Date_Notified,
Component_ID, 
Symptom_ID,
Symptom_Notes,
Cause_ID,
Cause_Notes,
Repair_Code_Id,
Repair_Notes,
Group_No,
Part_No,
EMI_Ref, 
EM_Issue_Id,
Redo,
Task_Planned_Time_ID,
Customer_Ref,
Employee_ID,
Expected_Duration,
Expected_Labor_Hours,
Planning_Notes, 
Actual_Duration, 
Primary_Cause, 
Notes,
Task_Mode_ID,
PartsStatusRequired,
PartsStatusOrdered,
PartsStatusReady,
Labour_Resources_Identified,
Location_Identified,
Tooling_Resources_Identified,
RaisedByID,
Work_Group_ID,
Strategy_Usage,
Strategy_QUOM_ID,
Strategy_Proj_Task_Opt_ID,
Planned_Proj_Task_Opt_ID,
Strategy_Date,
Strategy_Locked,
Part_Description  ,
Group_Description,
SIMS_Code_Id ,
0 AS Create_By_User_ID,
getdate(),
0 AS Create_By_User_ID,
getdate(),
Task_Header_Id,
ISNULL(Strategy_Repair_Description, ''),
Sort_Order ,
WO_Create_Date,
Performed_By_Date,
 
WO_Counter,
Work_Order_Number_External,
Cost_Bearer_ID,
Task_Warranty,
Redo_Work_Order_ID,
 View_Warranty,
Health_Safety_Id, 
BreakDown,
Planned_Down_Time,
Actual_Down_Time,
Planned_Offset,
ActualOffset,
ISNULL( Final_Change,0),
ISNULL(Risk_Life_Left,0),
ISNULL(Strategy_Frequency,0),
 Last_Performed,
Last_Scheduled,
Last_Performed_Date,
Last_Scheduled_Date,
Site_Id,
Work_Location,
Cost_Centre_Id,
Branch_Id,
Customer_Id,
Part_Entry_Distribution_Code_Id,
Work_Group_ID,
 Parts_Cost_Expense_Id,
 Labour_Cost_Expense_Id,
 Misc_Cost_Expense_Id ,
 Specific_Operation_Codes,
 Warranty_Days,
 Warranty_Usage,
 Labour_Entry_Distribution_Code_Id,
 Misc_Entry_Distribution_Code_Id,
 AMTPlanningModeId,
 ChangeoutCategoryId,
 LifeConfirmed,
 AA.id

FROM aa_Downtime AA
 
 Update AA SET 
 AA.Task_Id = T.Task_ID
 FROM aa_downtime AA 
 INNER JOIN TASK T ON T.OverwriteLifeAchieved = AA.id 
 
 Update T SET 
 T.OverwriteLifeAchieved = NULL
 FROM aa_downtime AA 
 INNER JOIN TASK T ON  AA.Task_Id = T.Task_ID
 
 
 
 ----------- TASK OPERATION
 INSERT INTO TASK_OPERATION(
	Task_Id, Task_Operation, Component_Code_Id, Modifier_Code_Id, Job_Code_Id, 
	Work_Group_Id,   Cost_Bearer_Id, Cost_Centre_Id, 
	Parts_Cost_Expense_Id, Labour_Cost_Expense_Id, Misc_Cost_Expense_Id, 
	Parts_Entry_Distribution_Code_Id, Labour_Entry_Distribution_Code_Id, 
	Misc_Entry_Distribution_Code_Id, 
	Last_Mod_By_User_ID, Last_Mod_Date, Create_By_User_ID, Create_Date, 
	OperationOffset, SortOrder)

	SELECT     
	T.Task_Id, 
	dbo.XML_FRIENDLY_STRING_F(T.Description,0,0) AS Task_Operation, 
	T.Component_Code_Id, 
	T.Modifier_ID, 
	T.Repair_Code_Id AS Job_Code_Id, 
	NULLIF(T.Work_Group_ID,0) AS Work_Group_Id, 		 
	NULLIF(T.Cost_Bearer_Id,0) AS Cost_Bearer_Id,	
	 NULLIF(T.Cost_Centre_Id,0) AS Cost_Centre_Id , 
	 NULLIF(T.Parts_Cost_Expense_Id,0) AS Parts_Cost_Expense_Id, 
	 NULLIF(T.Labour_Cost_Expense_Id,0) AS Labour_Cost_Expense_Id  ,
	 NULLIF(T.Misc_Cost_Expense_Id,0) AS Misc_Cost_Expense_Id, 
	 NULLIF(T.Part_Entry_Distribution_Code_Id,0) AS Parts_Entry_Distribution_Code_Id, 
	NULLIF(T.Labour_Entry_Distribution_Code_Id,0) AS Labour_Entry_Distribution_Code_Id ,
	NULLIF(T.Misc_Entry_Distribution_Code_Id,0) AS Misc_Entry_Distribution_Code_Id, 
	--NULLIF(T.Proj_Task_Amt_Id,0) AS Proj_Task_Amt_Id, 
	--NULLIF(T.Std_Job_Op_Id,0) AS Std_Job_Op_Id, 
	0 AS Last_Mod_By_User_ID, GETDATE() AS Last_Mod_Date, 
	0 AS Create_By_User_ID, GETDATE() AS Create_Date, 
	AA.id AS OperationOffset,
	1 AS SortOrder
FROM TASK T 
INNER JOIN aa_downtime AA ON AA.Task_Id = T.Task_ID
 
  
 Update AA SET 
 AA.Task_Operation_Id = T.Task_Operation_Id
 FROM aa_downtime AA 
 INNER JOIN TASK_OPERATION T ON T.OperationOffset = AA.id 
 
  Update T SET 
	T.OperationOffset = 0
 FROM aa_downtime AA 
 INNER JOIN TASK_OPERATION T ON T.Task_Operation_Id = AA.Task_Operation_Id 
 
 
 -- TASK_OPERATION_LABOUR
 
UPDATE aa_downtime SET FinPeriod = dbo.TASK_JOBDATE_F( Task_ID,0,2)
  
 INSERT INTO TASK_OPERATION_LABOUR(
	 Task_Operation_Id, 
	 Work_Group_Id,  
	 Include_In_Total, 
	 Strategy_Labour_Hrs, 
	 Strategy_Labour_Rate, 
	Labour_Qty, 
	  Planned_Labour_Hrs, 
	  Planned_Labour_Rate,  
	Actual_Labour_Hrs, 
	Actual_Labour_Rate,
	 Labour_Offset, 
	 Last_Mod_By_User_ID, 
	Last_Mod_Date,
	 Create_By_User_ID, 
	 Create_Date, 
	 IsEditable,
	CostBearerID,
	CostCentreID,
	ExpenseElementID, 
	 
	ActualTotalSell,ActualTotalCost,
	 
	FinPeriod,CurrencyId,ExchangeRate)

	SELECT     
	TT.Task_Operation_Id AS Task_Operation_Id, 
	NULLIF(TT.Work_Group_Id,0) As Work_Group_Id ,
	1 AS Include_In_Total,
	0 AS Strategy_Labour_Hrs,
	0 AS Strategy_Labour_Rate, 
	0 AS Labour_Qty,
	--Employee_Id,
	0 AS Planned_Labour_Hrs,
	0 AS Planned_Labour_Rate, 	 
	0 AS Actual_Labour_Hrs, 
	0 AS Actual_Labour_Rate, 
	0 AS Labour_Offset, 
	0 AS Last_Mod_By_User_ID, 
	GETDATE() AS Last_Mod_Date, 
	0 AS Create_By_User_ID, 
	GETDATE() AS Create_Date, 
	1 AS IsEditable,
	T.Cost_Bearer_ID AS	CostBearerID,
	T.Cost_Centre_Id AS	CostCentreID,
	T.Labour_Cost_Expense_Id AS ExpenseElementID,
	0 AS ActualTotalSell,
	0 AS ActualTotalCost,
	AA.FinPeriod,
	1 AS CurrencyId,
	1 AS ExchangeRate
	FROM  
	aa_downtime AA 
	INNER JOIN TASK T ON T.Task_ID = AA.Task_ID  
	INNER JOIN TASK_OPERATION TT ON T.Task_ID = TT.Task_ID     
	 
	 
 GO
 
 SELECT MIN(Event_Id), MAX(Event_Id) FROM TASK T WHERE T.Task_ID IN (SELECT Task_ID from aa_downtime)
 
ALTER VIEW [dbo].[DATA_CLEANSING_EVENT_V]
AS
SELECT     Eqp_Plan_ID, Actual_Down_Time, Actual_Up_Time, Event_ID, Expected_Up_Time, Planned_Down_Time, Planned_Down_Usage, Planned_Up_Time, 
                      Planned_Up_Usage, Actual_Down_Usage, Actual_Up_Usage, Test_Time
FROM         dbo.EVENT
WHERE     (Event_Status_ID = 3) 
		AND (Event_ID >= 11577) AND Event_ID <= 167872 --*****Loaded Date (the loaded Event count should be equal to records returned by this view)


GO


--GO

--EXEC DATA_CLEANSING_EVENTS_P

--GO