/******************************************************************************
	File: 	4_AMT_8_5C_Patch_Function.sql

	Description:	Creates the Functions in the database

**************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
11 May 12   GD			Mod E786 CHECK_IMPORT_DATA_F
07 May 12   SD		    Mod  E811 - Add fields AutocreateExternalWorkorders & AutocreatePlannedEvents
30 Apr 12   JW			Mod: WO_DOWN_TIME_F
23 Apr 12	VV			Add: ADD_DAYS_F
17 Apr 12	KN			Mod: GET_PREVIOUS_PR_EOL_DATE_F
16 Apr 12	TW			Add: LIST_TO_TABLE_3_F
12/Apr/12   SD		    Mod  E781 - Add PEX fields MULTI_TASK_EDITOR_FLD_FORMAT_F
05 Apr 12	VV			Add: MAX_DATE_2_F
							 MIN_DATE_2_F
							 SHIFT_TIME_F
							
**END OF HISTORY************************************************************************************************************/

SET QUOTED_IDENTIFIER ON	--should be always ON
GO
SET ANSI_NULLS ON			--should be always ON
GO
--=============================================================================

if exists (select * from dbo.sysobjects where id = object_id(N'ADD_DAYS_F') and xtype in (N'FN', N'IF', N'TF'))
drop function ADD_DAYS_F
GO

create FUNCTION [dbo].[ADD_DAYS_F](@Date datetime,@Days float)

RETURNS int
AS
/******************************************************************************
	
	Name: ADD_DAYS_F

	Desc: 
	
              
	Auth: Veronika Vasylyeva
	Date: 12 Apr 12
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------

*******************************************************************************/

BEGIN
	DECLARE @ReturnDownTime datetime
				
	SET @ReturnDownTime=CAST(CAST(@Date AS float)+@Days AS datetime)
	
	RETURN(YEAR(@ReturnDownTime)*10000+MONTH(@ReturnDownTime)*100+DAY(@ReturnDownTime))

END

GO

if exists (select * from dbo.sysobjects where id = object_id(N'GET_PREVIOUS_PR_EOL_DATE_F') and xtype in (N'FN', N'IF', N'TF'))
drop function GET_PREVIOUS_PR_EOL_DATE_F
GO

create FUNCTION [dbo].[GET_PREVIOUS_PR_EOL_DATE_F]  
	(
		@ProjTaskId INT,
		@AMTStartDate DATETIME, 
		@SerialNoOut int
	)

RETURNS DATETIME
AS
/******************************************************************************
	
	Name: GET_PREVIOUS_PR_EOL_DATE_F

	Desc: Get previous End of life for a Partial Repair Scenario
              
	Auth: Koushik.Nagarajan	
	Date: 17-Feb-2008
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
17 Apr 2012	K Nagarajan	3661: Calculate PartialRemove logic
21 Jul 2011	V Vasylyeva	E602: Serialised Component 
*******************************************************************************/

BEGIN
DECLARE @Return DATETIME
 
	SET @Return = (SELECT 
					TOP 1  PREV_DATE_WO.AmtStartDate									
			FROM		
				tblWorkorderProjs PREV_DATE_WP WITH (NOLOCK)
				INNER JOIN tblWorkorders PREV_DATE_WO WITH (NOLOCK) ON PREV_DATE_WO.WorkOrderId = PREV_DATE_WP.WorkOrderId
				INNER JOIN TASK PREV_DATE_T WITH (NOLOCK) ON PREV_DATE_T.Work_Order_ID = PREV_DATE_WP.WorkOrderId 			
				INNER JOIN tblProjTasks PT WITH (NOLOCK) ON PT.ProjTaskId =PREV_DATE_WP.ProjTaskId
				INNER JOIN tblEqpProjs EP WITH (NOLOCK) ON EP.EqpProjId = PT.EqpProjId	
			WHERE 
				 EP.Projection_Header_ID = 1 	 AND
				PREV_DATE_WO.WorkOrderId = PREV_DATE_WO.AMTParentWorkOrderId
				AND ISNULL(PREV_DATE_WO.CurrentWorkOrder, 0) <> 0
				AND PREV_DATE_WO.AMTJobStatus_Id <> 3				
				AND PREV_DATE_WO.AmtStartDate < @AMTStartDate
				AND ISNULL(PREV_DATE_T.ChangeoutCategoryId,1) = 1
				AND PREV_DATE_WP.UsageSinceLastOccurrence IS NOT NULL				
				--AND PREV_DATE_WP.ProjTaskId = @ProjTaskId
				/*VV E602*/				
				AND PREV_DATE_T.SerialNoOutId = @SerialNoOut 
 			 ORDER BY PREV_DATE_WO.AmtStartDate DESC
 )

RETURN @Return
END

GO

if exists (select * from dbo.sysobjects where id = object_id(N'SHIFT_TIME_F') and xtype in (N'FN', N'IF', N'TF'))
drop function SHIFT_TIME_F
GO

create FUNCTION [dbo].[SHIFT_TIME_F]  
(@ShiftStartTime Datetime, @Date Datetime)

RETURNS DateTime

AS
/******************************************************************************
	
	Name: SHIFT_TIME_F

	Desc: 
            
	Auth: Veronika Vasylyeva
	Date: 30 Mar 2012
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------

*******************************************************************************/

BEGIN
	DECLARE @PrevDate datetime  
	
	SET @Date=CONVERT(varchar(10),@Date,121)

	IF ISNULL(@ShiftStartTime,0) <> 0  
    BEGIN  
  
		SET @PrevDate = @Date  

		SET @Date = CONVERT(varchar(10),@Date,121) + ' ' + CONVERT(varchar,@ShiftStartTime,114)  

		IF (CONVERT(float, @Date) - CONVERT(float, @PrevDate)) * 24 > 12  
		BEGIN  
			SET @Date = DATEADD(d, -1, @Date)  
		END  
    END  

	RETURN @Date
END

GO

if exists (select * from dbo.sysobjects where id = object_id(N'MIN_DATE_2_F') and xtype in (N'FN', N'IF', N'TF'))
drop function MIN_DATE_2_F
GO

CREATE FUNCTION [dbo].[MIN_DATE_2_F] (@Date1 datetime, @Date2 datetime)
RETURNS datetime
AS
/******************************************************************************
	
	Name: MIN_DATE_2_F

	Desc: Returns Min date out of 2 dates
              
	Auth: Veronika Vasylyeva
	Date: 3 Apr 2012
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------

*******************************************************************************/

BEGIN
	
	RETURN(CASE WHEN @Date1>@Date2 THEN @Date2 ELSE @Date1 END)

END

GO

if exists (select * from dbo.sysobjects where id = object_id(N'MAX_DATE_2_F') and xtype in (N'FN', N'IF', N'TF'))
drop function MAX_DATE_2_F
GO

CREATE FUNCTION [dbo].[MAX_DATE_2_F] (@Date1 datetime, @Date2 datetime)
RETURNS datetime
AS
/******************************************************************************
	
	Name: MIN_DATE_2_F

	Desc: Returns Min date out of 2 dates
              
	Auth: Veronika Vasylyeva
	Date: 3 Apr 2012
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------

*******************************************************************************/

BEGIN
	
	RETURN(CASE WHEN @Date1>@Date2 THEN @Date1 ELSE @Date2 END)

END

GO

if exists (select * from dbo.sysobjects where id = object_id(N'MULTI_TASK_EDITOR_FLD_FORMAT_F') and xtype in (N'FN', N'IF', N'TF'))
drop function MULTI_TASK_EDITOR_FLD_FORMAT_F
GO

create     FUNCTION [dbo].[MULTI_TASK_EDITOR_FLD_FORMAT_F]() 
/******************************************************************************
	
	Name: drop function MULTI_TASK_EDITOR_FLD_FORMAT_F

	Desc: Returns FORMAT of the Fields for Multi-task Editor

              
	Auth: Veronika Vasylyeva
	Date:   Apr 2008
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
12/04/12    SD		    E781 - Add PEX fields
	
OLD HISTORY
-----------
31/03/09	AL			CR7965: Added PctPurchasePart,PctPurchaseLabour,PctPurchaseMisc,PctPurchaseNewPart,SalesResponsibility
23/07/09	KN			Added Perf Stra/ Comp Stru
12-Jul-10	V Vasylyeva	CR9019: CBD
 7 Oct 10	V Vasylyeva	E316: PartRating
 4 Apr 11   G Wang		Add AutoGenerateWOS
*******************************************************************************/
RETURNS @FldTable table ( Component_Code int , Modifier_Code int , Task_Type int , Task_Counter int , [Description] int , 
Task_Mode int , Planning_Lead_Time int , Operational_Criticality int , Manufacturer int , Primary_Part_Number int , 
Group_Number int , Warranty_Days int , Warranty_Usage int , UOM int , First_Occurrence int , Frequency int , Not_After int , 
Date_Based int,EqpPlan int,Task_Cost int,Job_Code int , Currency int , Cost_Source int , Cost_Bearer int , Cost_Centre int , Work_Group int , 
Part_Type int , [OH&S] int , Pricing_Date int , Consumable_Qty int ,[Consumable_Top_Up_%] int , Consumable_Price int , 
Job_Parts_Cost int , Job_Labour_Cost int , Job_Misc_Cost int , Parts_Exp_Element int , Labour_Exp_Element int , 
Misc_Exp_Element int , Parts_EDC int , Labour_EDC int , Misc_EDC int , Labour_Type int , Job_Labour_Hours int , 
Labour_Activity int , Job_Duration int,
--AL: 31/03/09
PctPurchasePart int,PctPurchaseLabour int,PctPurchaseMisc int,PctPurchaseNewPart int,SalesResponsibility int, 
Performance_Strategy int,Component_Structure int, Standard_Job int,/*VV CR9019*/CBDTask int,
/*VV E316*/PartRating int,/*GW*/AutoGenerateWOS int,
/*E781*/
DefaultLocationForRebuild int, PartClassification int) 

AS  
BEGIN

--Format constants. If negative - negative numbers van be entered
--1 int
--2 2 dec places
--3 bool
--4 string
--5 search ctl
--6 1 dec place
--7 date
--8 combobox



INSERT INTO @FldTable(Component_Code, Modifier_Code, Task_Type, Task_Counter, [Description], Task_Mode, 
Planning_Lead_Time, Operational_Criticality, Manufacturer, Primary_Part_Number, Group_Number, Warranty_Days, 
Warranty_Usage, UOM, First_Occurrence, Frequency, Not_After, Date_Based,EqpPlan,Task_Cost,
Job_Code, Currency, Cost_Source, Cost_Bearer, Cost_Centre, Work_Group, Part_Type, [OH&S], Pricing_Date, Consumable_Qty, 
[Consumable_Top_Up_%], Consumable_Price, Job_Parts_Cost, Job_Labour_Cost, Job_Misc_Cost, Parts_Exp_Element, 
Labour_Exp_Element, Misc_Exp_Element, Parts_EDC, Labour_EDC, Misc_EDC, Labour_Type, Job_Labour_Hours, Labour_Activity, 
Job_Duration,
--AL: 31/03/09
PctPurchasePart,PctPurchaseLabour,PctPurchaseMisc,PctPurchaseNewPart,SalesResponsibility,Performance_Strategy,
Component_Structure, Standard_Job,/*VV CR9019*/CBDTask,/*VV E316*/PartRating,/*GW*/AutoGenerateWOS,
/*E781*/
DefaultLocationForRebuild, PartClassification)
                      
SELECT
5 AS Component_Code, 5 AS Modifier_Code, 5 AS Task_Type, 5 AS Task_Counter, 4 AS [Description], 5 AS Task_Mode, 
1 AS Planning_Lead_Time, 5 AS Operational_Criticality, 5 AS Manufacturer, 5 AS Primary_Part_Number, 4 AS Group_Number, 
1 AS Warranty_Days, 1 AS Warranty_Usage, 5 AS UOM, 1 AS First_Occurrence, 1 AS Frequency, 1 AS Not_After, 3 AS Date_Based,
4 AS EqpPlan,2 AS Task_Cost,
5 AS Job_Code, 5 AS Currency, 5 AS Cost_Source, 5 AS Cost_Bearer, 5 AS Cost_Centre, 5 AS Work_Group, 5 AS Part_Type, 
5 AS [OH&S], 7 AS Pricing_Date, -2 AS Consumable_Qty, -6 AS [Consumable_Top_Up_%], -2 AS Consumable_Price, 
-2 AS Job_Parts_Cost, -2 AS Job_Labour_Cost, -2 AS Job_Misc_Cost, 5 AS Parts_Exp_Element, 
5 AS Labour_Exp_Element, 5 AS Misc_Exp_Element, 5 AS Parts_EDC, 5 AS Labour_EDC, 5 AS Misc_EDC, 5 AS Labour_Type, 
6 AS Job_Labour_Hours, 5 AS Labour_Activity, 6 AS Job_Duration,
--AL: 31/03/09
1 AS PctPurchasePart,1 AS PctPurchaseLabour,1 AS PctPurchaseMisc,1 AS PctPurchaseNewPart,5 AS SalesResponsibility,
5 AS Performance_Strategy,5 AS Component_Structure, 5 AS Standard_Job,3 AS CBDTask,/*VV E316*/5 AS PartRating,/*GW*/3 AS AutoGenerateWOS,
/*E781*/
5 AS DefaultLocationForRebuild, 5 AS PartClassification
RETURN
END
	
	
GO





if exists (select * from dbo.sysobjects where id = object_id(N'LIST_TO_TABLE_3_F') and xtype in (N'FN', N'IF', N'TF'))
drop function LIST_TO_TABLE_3_F
GO

CREATE  FUNCTION [dbo].[LIST_TO_TABLE_3_F]
(@values_list	varchar(MAX), @separator varchar(50)) 
/******************************************************************************
	
	Name: LIST_TO_TABLE_3_F

	Desc: Takes coma separated list of STRING values
	      Returns table
              
	Auth: Alex Lassauniere
	Date: 20 Oct 2008
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
13/04/12	TW			#3738 Add separator as param
29/06/09	AL			remove cast to int 

*******************************************************************************/
RETURNS @values_table		table
			(list_item	varchar(MAX))
AS  
BEGIN

DECLARE	@pos int,
		@pos_next	int,
		@list_item	varchar(MAX)


IF len( @values_list ) > 0
BEGIN
	SET @pos = 1
	SET @pos_next  =  CHARINDEX( @separator , @values_list , @pos )

	IF @pos_next = 0 
	BEGIN
		SET @list_item = @values_list

		INSERT INTO @values_table (list_item)
		VALUES (@list_item)
	END
	IF @pos_next > 0
	BEGIN
	WHILE	@pos_next != 0
		BEGIN
			SET @list_item = SUBSTRING( @values_list , @pos , @pos_next - @pos )
			INSERT INTO @values_table (list_item)
			VALUES (@list_item)

			SET @pos = @pos_next + len(@separator)
			SET @pos_next = CHARINDEX( @separator , @values_list , @pos + 1 )

			IF @pos_next = 0
			BEGIN
				SET @list_item = SUBSTRING( @values_list , @pos , LEN(@values_list) - @pos + 1 )
				
				INSERT INTO @values_table (list_item)
				VALUES (@list_item)
			END
		END
	END
END


RETURN 

END

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[WO_DOWN_TIME_F]') and xtype in (N'FN', N'IF', N'TF'))
drop function WO_DOWN_TIME_F
GO

create FUNCTION [dbo].[WO_DOWN_TIME_F](@DownTime datetime,@Offset float)

RETURNS datetime
AS
/******************************************************************************
	
	Name: WO_DOWN_TIME_F

	Desc: Calculates down time for workorder
	
              
	Auth: Veronika Vasylyeva
	Date: 23 Jul 2010
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
30 Apr 12	JW			3970 Split the Offset to solve the data overflow

*******************************************************************************/

BEGIN
	DECLARE @ReturnDownTime DATETIME
	
	SET @ReturnDownTime = DATEADD(HOUR, FLOOR(@Offset), @DownTime)  			
	SET @ReturnDownTime = DATEADD(SECOND, ROUND((@Offset-FLOOR(@Offset))*3600.00,0),@ReturnDownTime)
	
	RETURN(@ReturnDownTime)

END

GO

if exists (select * from dbo.sysobjects where id = object_id(N'MULTI_TASK_EDITOR_FLD_FORMAT_F') and xtype in (N'FN', N'IF', N'TF'))
drop function MULTI_TASK_EDITOR_FLD_FORMAT_F
GO

create     FUNCTION [dbo].[MULTI_TASK_EDITOR_FLD_FORMAT_F]() 
/******************************************************************************
	
	Name: drop function MULTI_TASK_EDITOR_FLD_FORMAT_F

	Desc: Returns FORMAT of the Fields for Multi-task Editor

              
	Auth: Veronika Vasylyeva
	Date:   Apr 2008
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
23/07/09	KN			Added Perf Stra/ Comp Stru
12-Jul-10	V Vasylyeva	CR9019: CBD
 7 Oct 10	V Vasylyeva	E316: PartRating
 4 Apr 11   G Wang		Add AutoGenerateWOS
*******************************************************************************/
RETURNS @FldTable table ( Component_Code int , Modifier_Code int , Task_Type int , Task_Counter int , [Description] int , 
Task_Mode int , Planning_Lead_Time int , Operational_Criticality int , Manufacturer int , Primary_Part_Number int , 
Group_Number int , Warranty_Days int , Warranty_Usage int , UOM int , First_Occurrence int , Frequency int , Not_After int , 
Date_Based int,EqpPlan int,Task_Cost int,Job_Code int , Currency int , Cost_Source int , Cost_Bearer int , Cost_Centre int , Work_Group int , 
Part_Type int , [OH&S] int , Pricing_Date int , Consumable_Qty int ,[Consumable_Top_Up_%] int , Consumable_Price int , 
Job_Parts_Cost int , Job_Labour_Cost int , Job_Misc_Cost int , Parts_Exp_Element int , Labour_Exp_Element int , 
Misc_Exp_Element int , Parts_EDC int , Labour_EDC int , Misc_EDC int , Labour_Type int , Job_Labour_Hours int , 
Labour_Activity int , Job_Duration int,
--AL: 31/03/09
PctPurchasePart int,PctPurchaseLabour int,PctPurchaseMisc int,PctPurchaseNewPart int,SalesResponsibility int, 
Performance_Strategy int,Component_Structure int, Standard_Job int,/*VV CR9019*/CBDTask int,
/*VV E316*/PartRating int,/*GW*/AutoGenerateWOS int,
/*E781*/
DefaultLocationForRebuild int, PartClassification int, 
/*E811*/
AutocreateExternalWorkorders int, [AutoCreatePlannedEvents/Workorders] int) 

AS  
BEGIN

--Format constants. If negative - negative numbers van be entered
--1 int
--2 2 dec places
--3 bool
--4 string
--5 search ctl
--6 1 dec place
--7 date
--8 combobox



INSERT INTO @FldTable(Component_Code, Modifier_Code, Task_Type, Task_Counter, [Description], Task_Mode, 
Planning_Lead_Time, Operational_Criticality, Manufacturer, Primary_Part_Number, Group_Number, Warranty_Days, 
Warranty_Usage, UOM, First_Occurrence, Frequency, Not_After, Date_Based,EqpPlan,Task_Cost,
Job_Code, Currency, Cost_Source, Cost_Bearer, Cost_Centre, Work_Group, Part_Type, [OH&S], Pricing_Date, Consumable_Qty, 
[Consumable_Top_Up_%], Consumable_Price, Job_Parts_Cost, Job_Labour_Cost, Job_Misc_Cost, Parts_Exp_Element, 
Labour_Exp_Element, Misc_Exp_Element, Parts_EDC, Labour_EDC, Misc_EDC, Labour_Type, Job_Labour_Hours, Labour_Activity, 
Job_Duration,
--AL: 31/03/09
PctPurchasePart,PctPurchaseLabour,PctPurchaseMisc,PctPurchaseNewPart,SalesResponsibility,Performance_Strategy,
Component_Structure, Standard_Job,/*VV CR9019*/CBDTask,/*VV E316*/PartRating,/*GW*/AutoGenerateWOS,
/*E781*/
DefaultLocationForRebuild, PartClassification, 
/*E811*/
AutocreateExternalWorkorders, [AutoCreatePlannedEvents/Workorders])
                      
SELECT
5 AS Component_Code, 5 AS Modifier_Code, 5 AS Task_Type, 5 AS Task_Counter, 4 AS [Description], 5 AS Task_Mode, 
1 AS Planning_Lead_Time, 5 AS Operational_Criticality, 5 AS Manufacturer, 5 AS Primary_Part_Number, 4 AS Group_Number, 
1 AS Warranty_Days, 1 AS Warranty_Usage, 5 AS UOM, 1 AS First_Occurrence, 1 AS Frequency, 1 AS Not_After, 3 AS Date_Based,
4 AS EqpPlan,2 AS Task_Cost,
5 AS Job_Code, 5 AS Currency, 5 AS Cost_Source, 5 AS Cost_Bearer, 5 AS Cost_Centre, 5 AS Work_Group, 5 AS Part_Type, 
5 AS [OH&S], 7 AS Pricing_Date, -2 AS Consumable_Qty, -6 AS [Consumable_Top_Up_%], -2 AS Consumable_Price, 
-2 AS Job_Parts_Cost, -2 AS Job_Labour_Cost, -2 AS Job_Misc_Cost, 5 AS Parts_Exp_Element, 
5 AS Labour_Exp_Element, 5 AS Misc_Exp_Element, 5 AS Parts_EDC, 5 AS Labour_EDC, 5 AS Misc_EDC, 5 AS Labour_Type, 
6 AS Job_Labour_Hours, 5 AS Labour_Activity, 6 AS Job_Duration,
--AL: 31/03/09
1 AS PctPurchasePart,1 AS PctPurchaseLabour,1 AS PctPurchaseMisc,1 AS PctPurchaseNewPart,5 AS SalesResponsibility,
5 AS Performance_Strategy,5 AS Component_Structure, 5 AS Standard_Job,3 AS CBDTask,/*VV E316*/5 AS PartRating,/*GW*/3 AS AutoGenerateWOS,
/*E781*/
5 AS DefaultLocationForRebuild, 5 AS PartClassification,
/*E811*/
3 AS AutoCreateExternalWorkorders, 3 AS [AutoCreatePlannedEvents/Workorders]
RETURN
END
	
	
GO
 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CHECK_IMPORT_DATA_F]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[CHECK_IMPORT_DATA_F]
GO

create FUNCTION [dbo].[CHECK_IMPORT_DATA_F]  
/* Param List */
(@TypeId int,@FieldName varchar(max), @FieldLen int,@Value varchar(max),@CheckPositive bit)
RETURNS varchar(max)
AS
/******************************************************************************
	
	Name: CHECK_IMPORT_DATA_F

	Desc: 
			
              
	Auth: Veronika Vasylyeva
	Date: 29 Jul 2008
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
02 May 12   GD          E786
*******************************************************************************/

BEGIN
	
	DECLARE @Message varchar(max)
	SET @Message=''
	
	DECLARE @TypeVarchar int
	DECLARE @TypeInt int
	DECLARE @TypeFloat int
	DECLARE @TypeBit int
	DECLARE	@TypeDateInt int
	DECLARE @TypeDateTime INT

	SET @TypeVarchar =1
	SET @TypeInt =2
	SET @TypeFloat =3
	SET @TypeBit =4
	SET	@TypeDateInt =5
	SET @TypeDateTime = 6

	--Check varchar length
	IF @TypeId= @TypeVarchar
	BEGIN
		IF LEN(@Value)>@FieldLen 
		BEGIN
			SET @Message=@FieldName+ ' length is greater than '+CAST(@FieldLen AS varchar(50))+'; '
			RETURN @Message
		END
	END
	
	--Check all numeric values
	IF @TypeId IN(@TypeInt, @TypeFloat,@TypeBit,@TypeDateInt)
	BEGIN
		-- Default for '' or NULL is 0
		IF LTRIM(RTRIM(@Value))='' OR @Value IS NULL RETURN @Message

		IF ISNUMERIC(@Value)=0 
		BEGIN
			SET  @Message=@FieldName+ ' is not in correct format; '
			RETURN @Message
		END
	END

	--Check if can be negative
	IF @TypeId IN( @TypeFloat,@TypeDateInt) AND @CheckPositive=1
	BEGIN
		IF SIGN(CAST(@Value as float))=-1
		BEGIN
			SET  @Message=@FieldName+ ' cannot be negative; '
			RETURN @Message
		END
	END

	--Check integers
	IF @TypeId =@TypeInt
	BEGIN
		IF FLOOR(CAST(@Value as float))<>CAST(@Value as float) 
		BEGIN
			SET @Message=@FieldName+ ' is not integer; '
			RETURN @Message
		END
	END
	
	--Check bit
	IF @TypeId =@TypeBit
	BEGIN
		IF CAST(@Value as float) NOT IN (0,1) 
		BEGIN
			SET @Message=@FieldName+ ' is not in correct format; '
			RETURN @Message
		END
	END
	
	IF @TypeId =@TypeDateInt
	BEGIN
		IF FLOOR(CAST(@Value as float))<>CAST(@Value as float) OR LEN(@Value)<>8 
		BEGIN
			SET  @Message=@FieldName+ ' is not in correct format; '
			RETURN @Message
		END

		--Check date
		IF ISDATE(LEFT(@Value,4)+'-'+RIGHT(LEFT(@Value,6),2)+'-'+RIGHT(@Value,2))=0 
		BEGIN
			SET  @Message=@FieldName+ ' is not in correct format; '
			RETURN @Message
		END
		
	END
	
	IF @TypeId = @TypeDateTime
	BEGIN
		IF ISDATE(@Value) NOT IN (1) 
		BEGIN
			SET @Message=@FieldName+ ' is not in correct format; '
			RETURN @Message
		END
	END

	RETURN @Message

END

GO