/******************************************************************************
	File: 	7_AMT_8_5C_Patch_Tr.sql

 
**************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
 4 May 12	VV			Mod PROJ_TASK_AMT_DIRTY_SET_T
03 May 12   GD          Mod E796 TASK_T
17 Apr 12	KN			Add: DIRTY_TOTAL_LIFE_SET_T

**END OF HISTORY************************************************************************************************************/
SET QUOTED_IDENTIFIER ON	--should be always ON
GO
SET ANSI_NULLS ON			--should be always ON
GO
--=============================================================================
 IF EXISTS (SELECT name FROM sysobjects WHERE name = 'PROJ_TASK_AMT_DIRTY_SET_T' AND type = 'TR')
   DROP TRIGGER PROJ_TASK_AMT_DIRTY_SET_T
GO

create TRIGGER PROJ_TASK_AMT_DIRTY_SET_T ON tblProjTaskAmts
/******************************************************************************
	File: 
	Name: 

	Called By: 

	Desc: 

	Auth: 	Sergey Ivanov
	Date: 	10 Aug 2006
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
 3 May 2012	V Vasylyeva	#4097 Set dirty flags when PartsPricingFactor, LabourPricingFactor, MiscPricingFactor, 
						PreparationTime, LabourHoursFactor, DurationFactor change
 5 Mar 2012	V Vasylyeva	#3638: Set dirty flags when record is deleted
20 Oct 2011	D Smith		#2530: Set dirty flags when change Labour Activity
 9 Jun 2010	V Vasylyeva	CR8964: Update Last_Mod_Date
18 Jun 2008	V Vasylyeva	Set DirtyProjCosts if StdJobPartsMargin changes
8-Jan-2008	V Vasylyeva	Set dirtyrepairreserve	
2-Jan-2008	V Vasylyeva	Set dirty proj costs for RR tasks
*********************************
**********************************************/
FOR INSERT, UPDATE, DELETE AS

DECLARE @ProjTypeArc int
SET @ProjTypeArc=4

DECLARE @UseStdJobPartsMargin bit
DECLARE @CalcBudCostFromStdJobMargin bit


IF 	UPDATE(CurrencyId)
	OR UPDATE(LaborHours)
	OR UPDATE(Duration)
	OR UPDATE(PartsCost)
	OR UPDATE(LaborCost)
	OR UPDATE(MiscCost)
	OR UPDATE(LaborShare)
	OR UPDATE(Avg_No_People)
	OR UPDATE(Avg_Daily_Work_Hrs)
	OR UPDATE(Avg_Travel_Hrs)
	OR UPDATE(Travel_Recovery_Rate_L)
	OR UPDATE(Crane_Cost)
	OR UPDATE(Pct_Freight)
	OR UPDATE(Travel_Distance)
	OR UPDATE(Travel_Recovery_Rate_V)
	OR UPDATE(Misc_Trip_Cost)
	OR UPDATE(Parts_Cost_Expense_ID)
	OR UPDATE(Labour_Cost_Expense_ID)
	OR UPDATE(Misc_Cost_Expense_ID)
	OR UPDATE(Cost_Centre_ID)
	OR UPDATE(Cost_Bearer_ID)
	OR UPDATE(Pricing_Date)
	OR UPDATE(Labour_Activity_ID)
	OR UPDATE(StdJobPartsMargin)
	/*VV #4097*/
	OR UPDATE(PartsPricingFactor)
	OR UPDATE(LabourPricingFactor)
	OR UPDATE(MiscPricingFactor)
	OR UPDATE(PreparationTime)
	OR UPDATE(LabourHoursFactor)
	OR UPDATE(DurationFactor) 
	/*VV #3638*/
	OR NOT EXISTS(SELECT DELETED.ProjTaskOptId FROM DELETED)
	OR NOT EXISTS(SELECT INSERTED.ProjTaskOptId FROM INSERTED)
BEGIN
	
	SELECT @UseStdJobPartsMargin =UseStdJobPartsMargin,
	@CalcBudCostFromStdJobMargin=CASE WHEN UseStdJobPartsMargin=0 THEN 0 ELSE CalcBudCostFromStdJobMargin END
FROM AMT_VARIABLE


	UPDATE	prtsk
	SET	Dirty_Proj_Cost = 1
	FROM	tblProjTasks prtsk WITH (NOLOCK)
		LEFT JOIN tblEqpProjs epr WITH (NOLOCK) ON epr.EqpProjId = prtsk.EqpProjId
		LEFT JOIN tblProjTaskOpts pto WITH (NOLOCK) ON pto.ProjTaskId = prtsk.ProjTaskId
	WHERE	pto.ProjTaskOptId IN (	SELECT	ISNULL(INSERTED.ProjTaskOptId, DELETED.ProjTaskOptId)
					FROM	DELETED 
						FULL HASH JOIN INSERTED ON INSERTED.ProjTaskAmtId = DELETED.ProjTaskAmtId
						LEFT JOIN tblProjTaskOpts pto WITH (NOLOCK) ON pto.ProjTaskOptId = INSERTED.ProjTaskOptId
						LEFT JOIN tblProjTasks prtsk WITH (NOLOCK) ON prtsk.ProjTaskId = pto.ProjTaskId
						LEFT JOIN tblEqpProjs epr WITH (NOLOCK) ON epr.EqpProjId = prtsk.EqpProjId
					WHERE	ISNULL(DELETED.CurrencyId, -1) <> ISNULL(INSERTED.CurrencyId, -1)
						OR ISNULL(DELETED.LaborHours, -1) <> ISNULL(INSERTED.LaborHours, -1)
						OR ISNULL(DELETED.Duration, -1) <> ISNULL(INSERTED.Duration, -1)
						OR ISNULL(DELETED.PartsCost, -1) <> ISNULL(INSERTED.PartsCost, -1)
						OR ISNULL(DELETED.LaborCost, -1) <> ISNULL(INSERTED.LaborCost, -1)
						OR ISNULL(DELETED.MiscCost, -1) <> ISNULL(INSERTED.MiscCost, -1)
						OR ISNULL(DELETED.LaborShare, -1) <> ISNULL(INSERTED.LaborShare, -1)
						OR ISNULL(DELETED.Avg_No_People, -1) <> ISNULL(INSERTED.Avg_No_People, -1)
						OR ISNULL(DELETED.Avg_Daily_Work_Hrs, -1) <> ISNULL(INSERTED.Avg_Daily_Work_Hrs, -1)
						OR ISNULL(DELETED.Avg_Travel_Hrs, -1) <> ISNULL(INSERTED.Avg_Travel_Hrs, -1)
						OR ISNULL(DELETED.Travel_Recovery_Rate_L, -1) <> ISNULL(INSERTED.Travel_Recovery_Rate_L, -1)
						OR ISNULL(DELETED.Crane_Cost, -1) <> ISNULL(INSERTED.Crane_Cost, -1)
						OR ISNULL(DELETED.Pct_Freight, -1) <> ISNULL(INSERTED.Pct_Freight, -1)
						OR ISNULL(DELETED.Travel_Distance, -1) <> ISNULL(INSERTED.Travel_Distance, -1)
						OR ISNULL(DELETED.Travel_Recovery_Rate_V, -1) <> ISNULL(INSERTED.Travel_Recovery_Rate_V, -1)
						OR ISNULL(DELETED.Misc_Trip_Cost, -1) <> ISNULL(INSERTED.Misc_Trip_Cost, -1)
						OR ISNULL(DELETED.Parts_Cost_Expense_ID, -1) <> ISNULL(INSERTED.Parts_Cost_Expense_ID, -1)
						OR ISNULL(DELETED.Labour_Cost_Expense_ID, -1) <> ISNULL(INSERTED.Labour_Cost_Expense_ID, -1)
						OR ISNULL(DELETED.Misc_Cost_Expense_ID, -1) <> ISNULL(INSERTED.Misc_Cost_Expense_ID, -1)
						OR ISNULL(DELETED.Cost_Centre_ID, -1) <> ISNULL(INSERTED.Cost_Centre_ID, -1)
						OR ISNULL(DELETED.Cost_Bearer_ID, -1) <> ISNULL(INSERTED.Cost_Bearer_ID, -1)
						/*VV 18 Jun 2008*/
						OR (epr.Projection_Type_ID IN (1,3,5) AND @UseStdJobPartsMargin=1 AND ISNULL(DELETED.StdJobPartsMargin, -1) <> ISNULL(INSERTED.StdJobPartsMargin, -1))
						OR (epr.Projection_Type_ID IN (2,6,7) AND @CalcBudCostFromStdJobMargin=1 AND ISNULL(DELETED.StdJobPartsMargin, -1) <> ISNULL(INSERTED.StdJobPartsMargin, -1))
						
						OR (ISNULL(DELETED.Pricing_Date, '1900-01-01') <> ISNULL(INSERTED.Pricing_Date, '1900-01-01') 
							AND NOT (epr.Projection_Type_ID IN (1,3,5) AND INSERTED.PricedJobId IS NOT NULL))
							
						OR ISNULL(DELETED.Labour_Activity_ID, -1) <> ISNULL(INSERTED.Labour_Activity_ID, -1)
						/*VV #3638*/
						OR ISNULL(DELETED.ProjTaskAmtId, -1) <> ISNULL(INSERTED.ProjTaskAmtId, -1)
						/*VV #4097*/
						OR ISNULL(DELETED.PartsPricingFactor, -1) <> ISNULL(INSERTED.PartsPricingFactor, -1)
						OR ISNULL(DELETED.LabourPricingFactor, -1) <> ISNULL(INSERTED.LabourPricingFactor, -1)
						OR ISNULL(DELETED.MiscPricingFactor, -1) <> ISNULL(INSERTED.MiscPricingFactor, -1)
						OR ISNULL(DELETED.PreparationTime, -1) <> ISNULL(INSERTED.PreparationTime, -1)
						OR ISNULL(DELETED.LabourHoursFactor, -1) <> ISNULL(INSERTED.LabourHoursFactor, -1)
						OR ISNULL(DELETED.DurationFactor, -1) <> ISNULL(INSERTED.DurationFactor, -1) 
		)
		AND epr.Projection_Type_ID <> 4 --Archived
		AND prtsk.Dirty_Proj_Cost = 0
	OPTION (FORCE ORDER)
END
	
	/*VV 8/01/08*/
IF 	UPDATE(CurrencyId)
	OR UPDATE(LaborHours)
	OR UPDATE(Duration)
	OR UPDATE(PartsCost)
	OR UPDATE(LaborCost)
	OR UPDATE(MiscCost)
	OR UPDATE(LaborShare)
	OR UPDATE(Avg_No_People)
	OR UPDATE(Avg_Daily_Work_Hrs)
	OR UPDATE(Avg_Travel_Hrs)
	OR UPDATE(Travel_Recovery_Rate_L)
	OR UPDATE(Crane_Cost)
	OR UPDATE(Pct_Freight)
	OR UPDATE(Travel_Distance)
	OR UPDATE(Travel_Recovery_Rate_V)
	OR UPDATE(Misc_Trip_Cost)
	OR UPDATE(Pricing_Date)
	OR UPDATE(Labour_Activity_ID)
	/*VV #4097*/
	OR UPDATE(PartsPricingFactor)
	OR UPDATE(LabourPricingFactor)
	OR UPDATE(MiscPricingFactor)
	OR UPDATE(PreparationTime)
	OR UPDATE(LabourHoursFactor)
	OR UPDATE(DurationFactor) 
	/*VV #3638*/
	OR NOT EXISTS(SELECT DELETED.ProjTaskOptId FROM DELETED)
	OR NOT EXISTS(SELECT INSERTED.ProjTaskOptId FROM INSERTED)
BEGIN
	UPDATE tblProjTasks SET DirtyRepairReserve=1
	FROM	tblProjTasks prtsk WITH (NOLOCK)
		LEFT JOIN tblEqpProjs epr WITH (NOLOCK) ON epr.EqpProjId = prtsk.EqpProjId
		LEFT JOIN tblProjTaskOpts pto WITH (NOLOCK) ON pto.ProjTaskId = prtsk.ParentTaskId
	WHERE	pto.ProjTaskOptId IN (	SELECT	ISNULL(INSERTED.ProjTaskOptId, DELETED.ProjTaskOptId)
					FROM	DELETED 
						FULL HASH JOIN INSERTED ON INSERTED.ProjTaskAmtId = DELETED.ProjTaskAmtId
						LEFT JOIN tblProjTaskOpts pto WITH (NOLOCK) ON pto.ProjTaskOptId = INSERTED.ProjTaskOptId
						LEFT JOIN tblProjTasks prtsk WITH (NOLOCK) ON prtsk.ParentTaskId = pto.ProjTaskId
						LEFT JOIN tblEqpProjs epr WITH (NOLOCK) ON epr.EqpProjId = prtsk.EqpProjId
					WHERE	ISNULL(DELETED.CurrencyId, -1) <> ISNULL(INSERTED.CurrencyId, -1)
						OR ISNULL(DELETED.LaborHours, -1) <> ISNULL(INSERTED.LaborHours, -1)
						OR ISNULL(DELETED.Duration, -1) <> ISNULL(INSERTED.Duration, -1)
						OR ISNULL(DELETED.PartsCost, -1) <> ISNULL(INSERTED.PartsCost, -1)
						OR ISNULL(DELETED.LaborCost, -1) <> ISNULL(INSERTED.LaborCost, -1)
						OR ISNULL(DELETED.MiscCost, -1) <> ISNULL(INSERTED.MiscCost, -1)
						OR ISNULL(DELETED.LaborShare, -1) <> ISNULL(INSERTED.LaborShare, -1)
						OR ISNULL(DELETED.Avg_No_People, -1) <> ISNULL(INSERTED.Avg_No_People, -1)
						OR ISNULL(DELETED.Avg_Daily_Work_Hrs, -1) <> ISNULL(INSERTED.Avg_Daily_Work_Hrs, -1)
						OR ISNULL(DELETED.Avg_Travel_Hrs, -1) <> ISNULL(INSERTED.Avg_Travel_Hrs, -1)
						OR ISNULL(DELETED.Travel_Recovery_Rate_L, -1) <> ISNULL(INSERTED.Travel_Recovery_Rate_L, -1)
						OR ISNULL(DELETED.Crane_Cost, -1) <> ISNULL(INSERTED.Crane_Cost, -1)
						OR ISNULL(DELETED.Pct_Freight, -1) <> ISNULL(INSERTED.Pct_Freight, -1)
						OR ISNULL(DELETED.Travel_Distance, -1) <> ISNULL(INSERTED.Travel_Distance, -1)
						OR ISNULL(DELETED.Travel_Recovery_Rate_V, -1) <> ISNULL(INSERTED.Travel_Recovery_Rate_V, -1)
						OR ISNULL(DELETED.Misc_Trip_Cost, -1) <> ISNULL(INSERTED.Misc_Trip_Cost, -1)
						/*if parent task is linked to std job and its pricing date changes do not set the flag
						  The pricing date for the parent task is reset in rep proj cost calc 
						*/
						OR (ISNULL(DELETED.Pricing_Date, '1900-01-01') <> ISNULL(INSERTED.Pricing_Date, '1900-01-01') AND NOT (epr.Projection_Type_ID IN (1,3,5) AND INSERTED.PricedJobId IS NOT NULL) ) 

						OR ISNULL(DELETED.Labour_Activity_ID, -1) <> ISNULL(INSERTED.Labour_Activity_ID, -1)
						/*VV #3638*/
						OR ISNULL(DELETED.ProjTaskAmtId, -1) <> ISNULL(INSERTED.ProjTaskAmtId, -1)
						/*VV #4097*/
						OR ISNULL(DELETED.PartsPricingFactor, -1) <> ISNULL(INSERTED.PartsPricingFactor, -1)
						OR ISNULL(DELETED.LabourPricingFactor, -1) <> ISNULL(INSERTED.LabourPricingFactor, -1)
						OR ISNULL(DELETED.MiscPricingFactor, -1) <> ISNULL(INSERTED.MiscPricingFactor, -1)
						OR ISNULL(DELETED.PreparationTime, -1) <> ISNULL(INSERTED.PreparationTime, -1)
						OR ISNULL(DELETED.LabourHoursFactor, -1) <> ISNULL(INSERTED.LabourHoursFactor, -1)
						OR ISNULL(DELETED.DurationFactor, -1) <> ISNULL(INSERTED.DurationFactor, -1) 
		)
		AND epr.Projection_Type_ID <> 4 --Archived
		AND prtsk.ParentTaskId>0
		AND prtsk.AutomaticUpdate=1
		AND prtsk.DirtyRepairReserve = 0
		
	OPTION (FORCE ORDER)
END

UPDATE PT SET Last_Mod_Date=GETDATE()

FROM	
tblProjTasks PT WITH (NOLOCK)
	INNER JOIN 
tblProjTaskOpts pto WITH (NOLOCK) 
	ON pto.ProjTaskId = pt.ProjTaskId
WHERE	pto.ProjTaskOptId IN (	
	SELECT	ISNULL(INSERTED.ProjTaskOptId, DELETED.ProjTaskOptId)
	FROM	
	DELETED 
		FULL HASH JOIN 
	INSERTED 
		ON INSERTED.ProjTaskAmtId = DELETED.ProjTaskAmtId)


GO

 IF EXISTS (SELECT name FROM sysobjects WHERE name = 'DIRTY_TOTAL_LIFE_SET_T' AND type = 'TR')
   DROP TRIGGER DIRTY_TOTAL_LIFE_SET_T
GO

create TRIGGER [dbo].[DIRTY_TOTAL_LIFE_SET_T] ON [dbo].[TASK]
/******************************************************************************
	File: 
	Name: 

	Called By: 

	Desc: 

	Auth: 	Koushik.Nagarajan
	Date: 	21 Dec 2007
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
17 Apr 12	K Nagarajan	3661: Partial Remove Dirty Set
19-Jul-11	V Vasylyeva	E602: Serialised Component
15/04/10	AL			CR8893: perf enhancements
*******************************************************************************/
FOR INSERT, UPDATE, DELETE AS
	
--print 'Trigger 1: ' + convert(varchar,getdate(),114)

IF 	UPDATE(Work_Order_Id) 
	OR UPDATE(ChangeoutCategoryId) OR UPDATE(LifeConfirmed) OR UPDATE(SerialNoOutId) OR UPDATE(SerialNoInId)
	OR (EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM INSERTED))
BEGIN
		SELECT	ISNULL(INSERTED.Task_Id, DELETED.Task_Id) AS Task_ID, 
				ISNULL(INSERTED.SerialNoOutId, DELETED.SerialNoOutId) AS SerialNoOutId,
				ISNULL(INSERTED.Work_Order_Id, DELETED.Work_Order_Id) AS Work_Order_Id
		INTO #TT
		FROM	
			DELETED 
			FULL HASH JOIN INSERTED ON INSERTED.Task_Id = DELETED.Task_Id
		WHERE	
			(
				ISNULL(DELETED.Work_Order_Id, -1) <> ISNULL(INSERTED.Work_Order_Id, -1) OR 
				ISNULL(DELETED.ChangeoutCategoryId, -1) <> ISNULL(INSERTED.ChangeoutCategoryId, -1)	OR 
				ISNULL(DELETED.LifeConfirmed, -1) <> ISNULL(INSERTED.LifeConfirmed, -1)  OR
				ISNULL(DELETED.SerialNoOutId, '') <> ISNULL(INSERTED.SerialNoOutId, '')   OR
				ISNULL(DELETED.SerialNoInId, '') <> ISNULL(INSERTED.SerialNoInId, '')  
			)  
			
		-- SWING IN/OUT
		SELECT	WP.ProjTaskId, WO.AmtStartDate,
				(SELECT TOP 1  I_WO.AmtStartDate
				FROM		
					tblWorkorderProjs I_WP WITH (NOLOCK)
					INNER JOIN tblWorkorders I_WO WITH (NOLOCK) ON I_WP.WorkOrderId = I_WO.WorkOrderId
					LEFT JOIN TASK I_T WITH (NOLOCK) ON I_WP.WorkOrderId=I_T.Work_Order_ID		
				WHERE 
					I_WP.ProjTaskId = WP.ProjTaskId 
					AND I_WO.AmtStartDate > WO.AmtStartDate 
					AND ISNULL(I_T.ChangeoutCategoryId,1) = 1
				 ORDER BY I_WO.AmtStartDate
			) AS NextAMTStartDate
		INTO #TT1
		FROM 
			tblWorkOrderProjs WP WITH (NOLOCK)
 			INNER JOIN (SELECT Work_Order_Id FROM #TT WHERE Work_Order_Id IS NOT NULL) T ON WP.WorkOrderId = T.Work_Order_Id 
			INNER JOIN tblWorkOrders WO WITH (NOLOCK) ON WP.WorkOrderId = WO.WorkOrderId
		WHERE  
				WP.DirtyTotalLife = 0


		UPDATE WP
			SET WP.DirtyTotalLife = 1
		FROM tblWorkOrderProjs WP WITH (NOLOCK)
		INNER JOIN tblWorkOrders WO WITH (NOLOCK) ON WO.WorkOrderId = WP.WorkOrderId
		INNER JOIN #TT1 TT ON  TT.ProjTaskId = WP.ProjTaskId AND 
								WO.AmtStartDate >= TT.AmtStartDate AND
								WO.AmtStartDate <= ISNULL(TT.NextAMTStartDate, WO.AmtStartDate)

		
--print 'Trigger 2: ' + convert(varchar,getdate(),114)
		
		-- PARTIAL REMOVE
		UPDATE WP
			SET WP.DirtyTotalLife = 1
		FROM 
			tblWorkOrderProjs WP WITH (NOLOCK)
 		 
		WHERE  
				WP.WorkOrderId IN (SELECT T.Work_Order_Id FROM #TT TE INNER JOIN TASK T ON T.SerialNoOutId = TE.SerialNoOutId) AND
				WP.DirtyTotalLife = 0 

				
		DROP TABLE #TT,#TT1
	 
END
--print 'Trigger 3: ' + convert(varchar,getdate(),114)

GO


IF EXISTS (SELECT name FROM sysobjects WHERE name = 'TASK_T' AND type = 'TR')
   DROP TRIGGER TASK_T
GO

create TRIGGER TASK_T ON TASK
/******************************************************************************
	File: 
	Name: 

	Called By: 

	Desc: Set flag 

	Auth: 	Veronika Vasylyeva
	Date: 	10 Mar 2010
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
*********************************
23 Apr 12   GD          E796

**********************************************/
FOR INSERT, UPDATE AS


IF 	UPDATE(Task_Status_ID) OR UPDATE(Planned_Offset) OR UPDATE(Expected_Duration) 
OR UPDATE(Actual_Duration) OR UPDATE(ActualOffset) OR UPDATE(Planned_Down_Time) 
OR UPDATE(Actual_Down_Time) OR UPDATE(Description) OR UPDATE(Priority_ID) 
OR UPDATE(Component_Code_ID) OR UPDATE(Modifier_ID) OR UPDATE(Task_Type_ID) OR UPDATE(Application_Code_ID)
BEGIN
	
	UPDATE T SET SendWOStatus = 1 FROM	
	INSERTED I
		FULL JOIN
	DELETED D
		ON I.Task_ID=D.Task_ID
		INNER JOIN
	TASK T 
		ON I.Task_ID=T.Task_ID
	WHERE (I.Task_Status_ID IN(1,2,6)/*O,IP,YTS*/ OR
	(I.Task_Status_ID=3/*C*/ AND D.Task_Status_ID<>3/*C*/)
	OR I.Task_Status_ID=5/*A*/ AND D.Task_Status_ID<>5/*A*/)
	AND 
	(
		I.Task_Status_ID<>D.Task_Status_ID
		OR I.Planned_Offset<>D.Planned_Offset
		OR I.Expected_Duration<>D.Expected_Duration
		OR I.Actual_Duration<>D.Actual_Duration
		OR I.ActualOffset<>D.ActualOffset
		OR dbo.FORMAT_DAY_MONTH_YEAR_HRS_MIN_F(ISNULL(I.Planned_Down_Time,'1900-01-01'))<>dbo.FORMAT_DAY_MONTH_YEAR_HRS_MIN_F(ISNULL(D.Planned_Down_Time,'1900-01-01'))
		OR dbo.FORMAT_DAY_MONTH_YEAR_HRS_MIN_F(ISNULL(I.Actual_Down_Time,'1900-01-01'))<>dbo.FORMAT_DAY_MONTH_YEAR_HRS_MIN_F(ISNULL(D.Actual_Down_Time,'1900-01-01'))
		OR ISNULL(I.Description,'') <> ISNULL(D.Description,'')
		OR ISNULL(I.Priority_ID ,'')<> ISNULL(D.Priority_ID,'')
		OR ISNULL(I.Component_Code_ID,'')<> ISNULL(D.Component_Code_ID,'')
		OR ISNULL(I.Modifier_ID,'') <> ISNULL(D.Modifier_ID,'')
		OR ISNULL(I.Task_Type_ID,'')  <> ISNULL(D.Task_Type_ID,'')
		OR ISNULL(I.Application_Code_ID,'') <> ISNULL(D.Application_Code_ID,'') 
	)
			
END



GO

