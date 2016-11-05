
/****** Object:  StoredProcedure [dbo].[AJ_KIRD_IMPORT_P]    Script Date: 01/31/2013 22:30:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AJ_KIRD_IMPORT_P]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AJ_KIRD_IMPORT_P]
GO

/****** Object:  StoredProcedure [dbo].[AJ_KIRD_IMPORT_P]    Script Date: 01/31/2013 22:30:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[AJ_KIRD_IMPORT_P]        
/******************************************************************************        
         
 Name: KIRD_IMPORT_P        
        
 Called By:         
        
 Desc:         
        
 Auth:  AJ     
 Date:        
*******************************************************************************        
  Change History        
*******************************************************************************        
Date:  Author:  Description:        
-------- -------- ----------------------------------------       
      
*******************************************************************************/        
 /* Param List */        
--@doc text, 
@fromdbname varchar(100),         
@mode int=0, -- 0-import, 1-generate tables for UI          
@isCodeMap bit=0,          
--FILTERS !!!          
@Model varchar(10)='',          
@ComponentCode varchar(10)='',          
@JobCode varchar(10)='',          
@Currency varchar(3)='',          
@SimulationRef varchar(175)='',          
@isExisting int=2, -- 0-not exist, 1-exist, 2-all          
@JobIDs text='', -- IDs of jobs to import ('01','03','12')          
-- New Values          
@NewSimulationRef varchar(175)='',          
@isLive int=1, -- 0-fixed, 1-Live, 2-both          
@NewCurrency varchar(3)='',          
@NewRate float=0,          
@NRecords int = 0 OUTPUT,        
--GD 22 05 May 12  E835        
@SetTaskCounter Bit =0           
          
AS          
  

   
          
/** VV 14-Jun-2006 ****/          
DECLARE @CurrentDate varchar (50)          
          
SET @CurrentDate=convert(varchar,getdate(),106)          
          
/** end VV 14-Jun-2006****/          
          
SET @NewSimulationRef=LTRIM(RTRIM(@NewSimulationRef))          
SET @NewCurrency=LTRIM(RTRIM(@NewCurrency))          
          
DECLARE @NewCurrencyID int          
SET @NewCurrencyID=0          
IF @NewCurrency<>''          
 SELECT @NewCurrencyID=CurrencyID FROM tblCurrencies WHERE Currency=@NewCurrency          
          
IF (@NewCurrency<>'') AND (@Currency='')          
BEGIN          
 RAISERROR ('If you change ''Currency'' you must provide original ''Currency'' as a filter', 16, 1)            
 RETURN          
END          
IF (@NewSimulationRef<>'') AND (@SimulationRef='')          
BEGIN          
 RAISERROR ('If you change ''Simulation Reference'' you must provide original ''Simulation Reference'' as a filter', 16, 1)            
 RETURN          
END          
          
          
CREATE table #isLive (Live_Job int NOT NULL)          
INSERT #isLive VALUES(0)          
INSERT #isLive VALUES(1)          
          
DECLARE @live1 int, @live2 int          
SET @live1=0          
SET @live2=0          
IF @isLive>0 -- 0-fixed, 1-Live, 2-both          
   SET @live2=1          
IF @isLive=1          
   SET @live1=1          
/*SELECT Cab_Type_Code, il.Live_Job           
FROM CAB_TYPE          
 LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2*/          
          
CREATE TABLE #I_STD_JOB_HEADER (          
 Std_Job_Header_ID varchar (500) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Std_Job_Header_ID)) <> '') PRIMARY KEY CLUSTERED,          
 Std_Job_Description varchar (500) COLLATE database_default NOT NULL ,          
 Model varchar (20) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Model)) <> ''),          
 Serial_No_Prefix varchar (50) COLLATE database_default NULL ,          
 Serial_No_Start varchar (50) COLLATE database_default NULL ,          
 Serial_No_End varchar (50) COLLATE database_default NULL ,          
 Live_Job bit NULL DEFAULT 1,          
 Dummy_Job bit NULL DEFAULT 0,          
 System_Source varchar (20) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(System_Source)) <> ''),          
 Component_Code varchar (50) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Component_Code)) <> ''),          
 /*VV CR8375*/          
 Modifier_Code varchar (50) COLLATE database_default NULL ,          
 Job_Code varchar (50) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Job_Code)) <> ''),          
 Task_Type varchar (10) COLLATE database_default NULL ,          
 Occurrence_Type varchar (10) COLLATE database_default NULL ,          
 Option_Pobability float NULL ,          
 Job_Default_Option bit NULL DEFAULT 1,          
 --VV 14-Apr-2009 Increased application code to 50 char          
 Application_Code varchar (100) COLLATE database_default NULL ,          
 Work_Application varchar (5) COLLATE database_default NULL ,          
 Job_Condition varchar (50) COLLATE database_default NULL ,          
 Cab_Type varchar (5) COLLATE database_default NULL ,          
 Job_Location varchar (50) COLLATE database_default NULL ,          
 Pricing_Branch varchar (50) COLLATE database_default NULL ,          
 Price_Group varchar (50) COLLATE database_default NULL ,          
 Currency varchar (3) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Currency)) <> ''),          
 Overwrite_Costs bit NULL DEFAULT 0,          
 Job_Quantity int NULL DEFAULT 1,          
 Parts_Usage_Factor float NULL DEFAULT 1,          
 Parts_Cost float NOT NULL ,          
 Labour_Cost float NOT NULL ,          
 Misc_Cost float NOT NULL ,         
 --E1030      
 --Parts_Cost_Cost float  NULL ,          
 --Labour_Cost_Cost float  NULL ,          
 --Misc_Cost_Cost float  NULL ,        
        
 Labour_Hrs float NOT NULL ,          
 Simulation_Reference varchar (175) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Simulation_Reference)) <> ''),          
 Simulation_Description varchar (500) COLLATE database_default NULL ,          
 Group_No varchar (50) COLLATE database_default NULL ,          
 Use_Rotable bit NULL DEFAULT 0,          
 Supplier varchar (20) COLLATE database_default NULL ,          
 Rotable_Part_Number varchar (50) COLLATE database_default NULL ,          
 Default_First float NULL DEFAULT 0,          
 Default_Interval float NULL DEFAULT 0,          
 Unit_Of_Measure varchar (50) COLLATE database_default NULL ,          
 Company varchar (50) COLLATE database_default NULL ,          
 Branch varchar (50) COLLATE database_default NULL ,          
 Site varchar (50) COLLATE database_default NULL ,          
 Fleet varchar (50) COLLATE database_default NULL ,          
 Equipment varchar (50) COLLATE database_default NULL ,          
 Serial_Number varchar (50) COLLATE database_default NULL ,          
 Projection_Type varchar (50) COLLATE database_default NULL ,          
 Planning_Task bit NOT NULL ,          
 Lead_Time_Days float NULL ,          
 Not_After float NULL ,          
 Last_Change_Date datetime NULL ,          
 Last_Change_Usage float NULL ,          
 Use_Std_Job bit NULL ,          
 Pricing_Date datetime DEFAULT (getdate()) ,          
 Part_Type varchar (50) COLLATE database_default NULL ,          
 Labour_Activity varchar (50) COLLATE database_default NULL,          
 StdJobRef varchar(500) COLLATE DATABASE_DEFAULT NULL          
)          
          
CREATE TABLE #I_STD_JOB_OPERATION (          
 Std_Job_Operation_ID varchar (50) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Std_Job_Operation_ID)) <> '') PRIMARY KEY CLUSTERED,          
 Std_Job_Header_ID varchar (500) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Std_Job_Header_ID)) <> ''), --REFERENCES #I_STD_JOB_HEADER (Std_Job_Header_ID),          
 Name varchar (500) COLLATE database_default NULL ,          
 Component_Code varchar (50) COLLATE database_default NULL,          
 Job_Code varchar (50) COLLATE database_default NULL,          
 Duration_Hours float NULL DEFAULT (0),          
 Group_No varchar (50) COLLATE database_default NULL          
)          
CREATE TABLE #I_STD_JOB_PARTS (          
 Std_Job_Operation_ID varchar (50) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Std_Job_Operation_ID)) <> ''), --REFERENCES #I_STD_JOB_OPERATION(Std_Job_Operation_ID),          
 Part_Number varchar (50) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Part_Number)) <> ''),          
 Part_Source_Of_Supply varchar (50) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Part_Source_Of_Supply)) <> ''),          
 Part_Description varchar (50) COLLATE database_default NULL ,          
 Part_Type varchar (10) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Part_Type)) <> ''),          
 Part_Unit_Cost float NULL,          
 Part_Unit_Sell float NULL,          
 Part_Quantity float NULL DEFAULT (0),          
 Part_Probability float NULL DEFAULT (100),          
 Core_Credit varchar (10) COLLATE database_default NULL DEFAULT 'PARTIAL',          
 Full_Credit_Cost float NULL ,          
 Full_Credit_Sell float NULL ,          
 Partial_Credit_Cost float NULL ,          
 Partial_Credit_Sell float NULL           
)          
CREATE TABLE #I_STD_JOB_LABOUR (          
 Std_Job_Operation_ID varchar (50) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Std_Job_Operation_ID)) <> ''), --REFERENCES #I_STD_JOB_OPERATION(Std_Job_Operation_ID),          
 Labour_Activity varchar (50) COLLATE database_default NULL ,          
 Description varchar (50) COLLATE database_default NULL ,          
 Cost_Rate float NULL ,          
 Sell_Rate float NULL ,          
 Hours float NULL DEFAULT (0)          
)          
CREATE TABLE #I_STD_JOB_MISC (          
 Std_Job_Operation_ID varchar (50) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Std_Job_Operation_ID)) <> ''), --REFERENCES #I_STD_JOB_OPERATION(Std_Job_Operation_ID),          
 Description varchar (50) COLLATE database_default NULL ,          
 Cost float NULL DEFAULT (0),          
 Sell float NULL DEFAULT (0)          
)          
          
--DECLARE @idoc int          
          
--EXEC sp_xml_preparedocument @idoc OUTPUT, @doc          
 -- SELECT * FROM #I_STD_JOB_HEADER          
 EXEC ('
 INSERT #I_STD_JOB_HEADER          
  SELECT          
  LTRIM(RTRIM(isjh.Std_Job_Header_ID)) AS Std_Job_Header_ID,          
  LTRIM(RTRIM(isjh.Std_Job_Description)) AS Std_Job_Description,          
  LTRIM(RTRIM(isjh.Model)) AS Model,          
  LTRIM(RTRIM(isjh.Serial_No_Prefix)) AS Serial_No_Prefix,          
  LTRIM(RTRIM(isjh.Serial_No_Start)) AS Serial_No_Start,          
  LTRIM(RTRIM(isjh.Serial_No_End)) AS Serial_No_End,          
  CASE WHEN isjh.Live_Job IS NULL THEN 1 ELSE isjh.Live_Job END AS Live_Job,          
  CASE WHEN isjh.Dummy_Job IS NULL THEN 0 ELSE isjh.Dummy_Job END AS Dummy_Job,          
  LTRIM(RTRIM(isjh.System_Source)) AS System_Source,          
  LTRIM(RTRIM(isjh.Component_Code)) AS Component_Code,          
  LTRIM(RTRIM(isjh.Modifier_Code)) AS Modifier_Code,          
  LTRIM(RTRIM(isjh.Job_Code)) AS Job_Code,          
  LTRIM(RTRIM(isjh.Task_Type)) AS Task_Type,          
  LTRIM(RTRIM(isjh.Occurrence_Type)) AS Occurrence_Type,          
  isjh.Option_Pobability AS Option_Pobability,          
  CASE WHEN isjh.Job_Default_Option IS NULL THEN 1 ELSE isjh.Job_Default_Option END AS Job_Default_Option,          
  LTRIM(RTRIM(isjh.Application_Code)) AS Application_Code,          
  LTRIM(RTRIM(isjh.Work_Application)) AS Work_Application,          
  LTRIM(RTRIM(isjh.Job_Condition)) AS Job_Condition,          
  LTRIM(RTRIM(isjh.Cab_Type)) AS Cab_Type,          
  LTRIM(RTRIM(isjh.Job_Location)) AS Job_Location,          
  LTRIM(RTRIM(isjh.Pricing_Branch)) AS Pricing_Branch,          
  LTRIM(RTRIM(isjh.Price_Group)) AS Price_Group,          
  LTRIM(RTRIM(isjh.Currency)) AS Currency,          
  CASE WHEN isjh.Overwrite_Costs IS NULL THEN 0 ELSE isjh.Overwrite_Costs END AS Overwrite_Costs,          
  CASE WHEN isjh.Job_Quantity IS NULL OR isjh.Job_Quantity<1 THEN 1 ELSE isjh.Job_Quantity END AS Job_Quantity,          
  CASE WHEN isjh.Parts_Usage_Factor IS NULL THEN 1 ELSE isjh.Parts_Usage_Factor END AS Parts_Usage_Factor,          
  isjh.Parts_Cost,          
  isjh.Labour_Cost,          
  isjh.Misc_Cost,        
  --E1030      
 --isjh.Parts_Cost_Cost,         
  --isjh.Labour_Cost_Cost,          
  --isjh.Misc_Cost_Cost,                
  isjh.Labour_Hrs,          
  LTRIM(RTRIM(isjh.Simulation_Reference)) AS Simulation_Reference,          
  LTRIM(RTRIM(isjh.Simulation_Description)) AS Simulation_Description,          
  LTRIM(RTRIM(isjh.Group_No)) AS Group_No,          
  CASE WHEN isjh.Use_Rotable IS NULL THEN 0 ELSE isjh.Use_Rotable END AS Use_Rotable,          
  LTRIM(RTRIM(isjh.Supplier)) AS Supplier,          
  LTRIM(RTRIM(isjh.Rotable_Part_Number)) AS Rotable_Part_Number,          
  CASE WHEN isjh.Default_First IS NULL THEN 0 ELSE isjh.Default_First END AS Default_First,          
  CASE WHEN isjh.Default_Interval IS NULL THEN 0 ELSE isjh.Default_Interval END AS Default_Interval,          
  LTRIM(RTRIM(isjh.Unit_Of_Measure)) AS Unit_Of_Measure,          
  LTRIM(RTRIM(isjh.Company)) AS Company,          
  LTRIM(RTRIM(isjh.Branch)) AS Branch,          
  LTRIM(RTRIM(isjh.Site)) AS Site,          
  LTRIM(RTRIM(isjh.Fleet)) AS Fleet,          
  LTRIM(RTRIM(isjh.Equipment)) AS Equipment,          
  LTRIM(RTRIM(isjh.Serial_Number)) AS Serial_Number,          
  LTRIM(RTRIM(isjh.Projection_Type)) AS Projection_Type,          
  isjh.Planning_Task,          
  isjh.Lead_Time_Days,          
  isjh.Not_After,          
  isjh.Last_Change_Date,          
  isjh.Last_Change_Usage,          
  isjh.Use_Std_Job,          
  CASE WHEN isjh.Pricing_Date IS NULL OR isjh.Pricing_Date=''1900-01-01'' THEN getdate() ELSE isjh.Pricing_Date END AS Pricing_Date,          
  LTRIM(RTRIM(isjh.Part_Type)) AS Part_Type,          
  LTRIM(RTRIM(isjh.Labour_Activity)) AS Labour_Activity,          
  NULL AS StdJobRef          
 --FROM I_STD_JOB_HEADER isjh          
   FROM '+@fromdbname+'..I_STD_JOB_HEADER  isjh    
  -- do not import records with not existing model          
 WHERE  LTRIM(RTRIM(isjh.Model)) IN (SELECT Model FROM tblModels)          
  -- do not import records with not existing Currency          
  AND LTRIM(RTRIM(isjh.Currency)) IN (SELECT Currency FROM tblCurrencies)          
  -- Filters          
  /*AND (LTRIM(RTRIM(isjh.Model))=@Model OR ISNULL(@Model,'')='')          
  AND (LTRIM(RTRIM(isjh.Component_Code))=@ComponentCode OR ISNULL(@ComponentCode,'')='')          
  AND (LTRIM(RTRIM(isjh.Job_Code))=@JobCode OR ISNULL(@JobCode,'')='')          
  AND (LTRIM(RTRIM(isjh.Currency))=@Currency OR ISNULL(@Currency,'')='')          
  AND (LTRIM(RTRIM(isjh.Simulation_Reference))=@SimulationRef OR ISNULL(@SimulationRef,'')='') */' )        
  /*          
  AND ( (LTRIM(RTRIM(isjh.Std_Job_Header_ID)) NOT IN          
   ( SELECT Std_Job_Ref FROM tblStdJobs sjh WHERE Std_Job_Ref=isjh.Std_Job_Header_ID           
    AND ((Live_Job=@isLive AND @isLive<2) OR (Live_Job<@isLive AND @isLive=2))          
   ) AND @isExisting=0)           
   OR          
   (LTRIM(RTRIM(isjh.Std_Job_Header_ID)) IN          
   ( SELECT Std_Job_Ref FROM tblStdJobs sjh WHERE Std_Job_Ref=isjh.Std_Job_Header_ID           
    AND ((Live_Job=@isLive AND @isLive<2) OR (Live_Job<@isLive AND @isLive=2))          
   ) AND @isExisting=1) OR          
   @isExisting>1)          
  */          
          
           
 IF (@mode<>1) AND (@JobIDs IS NOT NULL) AND (@JobIDs NOT LIKE '')          
  EXEC ('DELETE #I_STD_JOB_HEADER WHERE Std_Job_Header_ID NOT IN ('+@JobIDs+')')          
  EXEC ('        
 INSERT #I_STD_JOB_OPERATION          
 SELECT           
  LTRIM(RTRIM(Std_Job_Operation_ID)),          
  LTRIM(RTRIM(Std_Job_Header_ID)),          
  LTRIM(RTRIM(Name)),          
  LTRIM(RTRIM(Component_Code)),          
  LTRIM(RTRIM(Job_Code)),          
  CASE WHEN Duration_Hours IS NULL THEN 0 ELSE Duration_Hours END,          
  LTRIM(RTRIM(Group_No))                
  FROM  '+@fromdbname+'..I_STD_JOB_OPERATION
 WHERE Std_Job_Header_ID IN (SELECT Std_Job_Header_ID FROM #I_STD_JOB_HEADER)')          
          
 --StdJobs should have at least 1 operation          
 DELETE #I_STD_JOB_HEADER WHERE Std_Job_Header_ID NOT IN (SELECT Std_Job_Header_ID FROM #I_STD_JOB_OPERATION)          

EXEC ('          
 INSERT #I_STD_JOB_PARTS          
 SELECT           
  LTRIM(RTRIM(Std_Job_Operation_ID)),          
  LTRIM(RTRIM(Part_Number)),          
  LTRIM(RTRIM(Part_Source_Of_Supply)),          
  LTRIM(RTRIM(Part_Description)),          
  LTRIM(RTRIM(Part_Type)),          
  CASE WHEN Part_Unit_Cost IS NULL THEN 0 ELSE Part_Unit_Cost END,          
  CASE WHEN Part_Unit_Sell IS NULL THEN 0 ELSE Part_Unit_Sell END,          
  CASE WHEN Part_Quantity IS NULL THEN 0 ELSE Part_Quantity END,          
  CASE WHEN Part_Probability IS NULL THEN 100 ELSE Part_Probability END,          
  CASE WHEN ISNULL(LTRIM(RTRIM(Core_Credit)),'''')='''' THEN ''PARTIAL'' ELSE LTRIM(RTRIM(Core_Credit)) END,          
  CASE WHEN Full_Credit_Cost IS NULL THEN Part_Unit_Cost ELSE Full_Credit_Cost END,          
  CASE WHEN Full_Credit_Sell IS NULL THEN Part_Unit_Sell ELSE Full_Credit_Sell END,          
  CASE WHEN Partial_Credit_Cost IS NULL THEN Part_Unit_Cost ELSE Partial_Credit_Cost END,          
  CASE WHEN Partial_Credit_Sell IS NULL THEN Part_Unit_Sell ELSE Partial_Credit_Sell END          
       FROM '+@fromdbname+'..I_STD_JOB_PARTS
 WHERE Std_Job_Operation_ID IN (SELECT Std_Job_Operation_ID FROM #I_STD_JOB_OPERATION)')          
 
 EXEC ('         
 INSERT #I_STD_JOB_LABOUR          
 SELECT           
  LTRIM(RTRIM(Std_Job_Operation_ID)),          
  LTRIM(RTRIM(Labour_Activity)),          
  LTRIM(RTRIM(Description)),          
  Cost_Rate,          
  Sell_Rate,          
  CASE WHEN Hours IS NULL THEN 0 ELSE Hours END          
 FROM '+@fromdbname+'..I_STD_JOB_LABOUR          
 WHERE Std_Job_Operation_ID IN (SELECT Std_Job_Operation_ID FROM #I_STD_JOB_OPERATION)')         
          
EXEC (' INSERT #I_STD_JOB_MISC          
 SELECT           
  LTRIM(RTRIM(Std_Job_Operation_ID)),          
  LTRIM(RTRIM(Description)),          
  CASE WHEN Cost IS NULL THEN 0 ELSE Cost END,          
  CASE WHEN Sell IS NULL THEN 0 ELSE Sell END          
 FROM '+@fromdbname+'..I_STD_JOB_MISC     
 WHERE Std_Job_Operation_ID IN (SELECT Std_Job_Operation_ID FROM #I_STD_JOB_OPERATION)')          
          
          
-- generate tables for UI          
IF @mode=1          
BEGIN          
 SELECT Std_Job_Header_ID, Model, Serial_No_Prefix+Serial_No_Start+Serial_No_End as SerialNo, Std_Job_Description,           
  CASE WHEN @NewSimulationRef='' THEN isjh.Simulation_Reference ELSE @NewSimulationRef END as Simulation_Reference,           
  CASE WHEN EXISTS(SELECT Std_Job_Ref FROM tblStdJobs sjh WHERE Std_Job_Ref=isjh.Std_Job_Header_ID           
    AND ((Live_Job=@isLive AND @isLive<2) OR (Live_Job<@isLive AND @isLive=2))          
    /*AND ((sjh.Simulation_Reference=LTRIM(RTRIM(isjh.Simulation_Reference)) AND @NewSimulationRef='') OR          
         (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/ )          
   THEN 1 ELSE 0 END as isExist,          
  Group_No, Component_Code, Job_Code          
 FROM #I_STD_JOB_HEADER isjh          
 ORDER BY 2,3,4          
          
 SELECT DISTINCT Model          
 FROM I_STD_JOB_HEADER isjh          
 WHERE  LTRIM(RTRIM(isjh.Model)) IN (SELECT Model FROM tblModels)          
  AND LTRIM(RTRIM(isjh.Currency)) IN (SELECT Currency FROM tblCurrencies)          
  AND ISNULL(Model,'')<>''          
 ORDER BY 1          
          
 SELECT DISTINCT Component_Code          
 FROM I_STD_JOB_HEADER isjh          
 WHERE  LTRIM(RTRIM(isjh.Model)) IN (SELECT Model FROM tblModels)          
  AND LTRIM(RTRIM(isjh.Currency)) IN (SELECT Currency FROM tblCurrencies)          
  AND ISNULL(Component_Code,'')<>''          
 ORDER BY 1          
          
 SELECT DISTINCT Job_Code          
 FROM I_STD_JOB_HEADER isjh          
 WHERE  LTRIM(RTRIM(isjh.Model)) IN (SELECT Model FROM tblModels)          
  AND LTRIM(RTRIM(isjh.Currency)) IN (SELECT Currency FROM tblCurrencies)          
  AND ISNULL(Job_Code,'')<>''          
 ORDER BY 1          
          
 SELECT DISTINCT Currency          
 FROM I_STD_JOB_HEADER isjh          
 WHERE  LTRIM(RTRIM(isjh.Model)) IN (SELECT Model FROM tblModels)          
  AND LTRIM(RTRIM(isjh.Currency)) IN (SELECT Currency FROM tblCurrencies)          
  AND ISNULL(Currency,'')<>''          
 ORDER BY 1          
          
 SELECT DISTINCT Simulation_Reference          
 FROM I_STD_JOB_HEADER isjh          
 WHERE  LTRIM(RTRIM(isjh.Model)) IN (SELECT Model FROM tblModels)          
  AND LTRIM(RTRIM(isjh.Currency)) IN (SELECT Currency FROM tblCurrencies)          
  AND ISNULL(Simulation_Reference,'')<>''          
 ORDER BY 1          
          
 SELECT cur1.Currency, cur1.Currency+' - '+cur1.CurrencyDesc as CurrencyDesc, exr1.ExRate/exr2.ExRate as ExRate          
 FROM tblCurrencies cur1          
  LEFT JOIN tblCurrencies cur2 ON cur2.Currency=@Currency          
  LEFT JOIN tblExRateCurrencies exr1 ON exr1.CurrencyID=cur1.CurrencyID AND exr1.ExRateID=0          
  LEFT JOIN tblExRateCurrencies exr2 ON exr2.CurrencyID=cur2.CurrencyID AND exr2.ExRateID=0          
 ORDER BY 1          
          
 -- new Component Codes          
 SELECT DISTINCT isjh.Component_Code          
 FROM #I_STD_JOB_HEADER isjh          
 LEFT JOIN tblComponentCodes cc ON isjh.Component_Code=cc.Code          
 WHERE  LTRIM(RTRIM(isjh.Model)) IN (SELECT Model FROM tblModels)          
  AND LTRIM(RTRIM(isjh.Currency)) IN (SELECT Currency FROM tblCurrencies)          
  AND ISNULL(isjh.Component_Code,'')<>''          
  AND @isCodeMap=0 AND cc.ComponentCodeID IS NULL          
 ORDER BY 1          
          
END          
          
--EXEC sp_xml_removedocument @idoc          
          
IF @mode=1          
 RETURN          
          
---------------------------------------------------------------          
-- getting default values          
DECLARE @gccDefcc int          
DECLARE @gccDefccCode varchar(50)       
SELECT TOP 1 @gccDefcc=AMT_Component_Code_Id,@gccDefccCode=CC.Code          
FROM           
GLOBAL_COMPONENT_CODES GCC          
 LEFT JOIN          
tblComponentCodes CC          
 ON GCC.AMT_Component_Code_Id=CC.ComponentCodeID          
WHERE GCC.Default_Record<>0          
          
DECLARE @mdDef int          
DECLARE @mdDefCode varchar(50)          
SELECT TOP 1 @mdDef=ModifierID,@mdDefCode=Code FROM tblModifierCodes WHERE Default_Record<>0          
          
DECLARE @ptDef int          
SELECT TOP 1 @ptDef=PartTypeId FROM tblPartTypes WHERE PartTypeDefault<>0          
          
DECLARE @ttDef int          
SELECT TOP 1 @ttDef=TaskTypeId FROM tblTaskTypes WHERE Default_Record<>0          
          
DECLARE @quomDef int          
SELECT TOP 1 @quomDef=QUOMId FROM tblQUOMs WHERE QUOMDefault<>0          
          
DECLARE @acDef int          
DECLARE @acDefCode varchar(50)          
SELECT TOP 1 @acDef=ApplicationCodeID,@acDefCode=Code FROM tblApplicationCodes WHERE Default_Record<>0          
          
DECLARE @otDef int          
SELECT TOP 1 @otDef=OccurrenceTypeId FROM tblOccurrenceTypes WHERE Default_Record<>0          
          
DECLARE @laDef int          
SELECT TOP 1 @laDef=LabourActivityId FROM tblLabourActivities WHERE LabourActivityId=0          
          
DECLARE @jcDef int          
DECLARE @jcDefCode varchar(50)          
SELECT TOP 1 @jcDef=JobCodeID,@jcDefCode=Code FROM tblJobCodes WHERE Default_Record<>0          
          
----------------------------------------------------------------          
          
-- Add System_Source if it's a new one          
   INSERT SYSTEM_SOURCE          
 (System_Source_Code, Last_Mod_By_User_ID, Last_Mod_Date,           
 Create_By_User_ID, Create_Date)          
 SELECT DISTINCT sjh.System_Source, 0, GETDATE(), 0, GETDATE()          
 FROM #I_STD_JOB_HEADER sjh          
 WHERE sjh.System_Source NOT IN (SELECT System_Source_Code FROM SYSTEM_SOURCE) AND ISNULL(sjh.System_Source,'')<>''         
          
-- Add Component Code if it's a new one          
DECLARE @subSystemId int          
SELECT @subSystemId = SubSystemID FROM tblSubSystems WHERE Unassigned <> 0          
IF @isCodeMap=0 AND @subSystemId > 0          
   INSERT tblComponentCodes          
 (SubSystemID, Code, [Description], BudgetCode,           
 LastModByUserId, LastModDate, CreateByUserId, CreateDate, Default_Record)          
 SELECT DISTINCT @subSystemId , sjh.Component_Code, sjh.Component_Code, 0, 0, GETDATE(), 0, GETDATE(), 0          
 FROM #I_STD_JOB_HEADER sjh          
 WHERE sjh.Component_Code NOT IN (SELECT Code FROM tblComponentCodes) AND ISNULL(sjh.Component_Code,'')<>''          
          
-- Add ModifierCode if it's a new one          
   INSERT tblModifierCodes          
 (Code, Description, LastModByUserId, LastModDate,           
 CreateByUserId, CreateDate)          
 SELECT DISTINCT sjh.Modifier_Code, sjh.Modifier_Code, 0, GETDATE(), 0, GETDATE()          
 FROM #I_STD_JOB_HEADER sjh          
 WHERE sjh.Modifier_Code NOT IN (SELECT Code FROM tblModifierCodes) AND ISNULL(sjh.Modifier_Code,'')<>''          
          
-- Add JobCode if it's a new one          
DECLARE @GlobalJobCodeId int          
SET @GlobalJobCodeId = 0          
SELECT TOP 1 @GlobalJobCodeId=Global_Job_Id FROM GLOBAL_JOB_CODES WHERE Default_Record<>0          
IF @isCodeMap=0 AND @GlobalJobCodeId>0          
   INSERT tblJobCodes          
 (Code, Description, LastModByUserId, LastModDate,           
 CreateByUserId, CreateDate, Global_Job_Code_Id)          
 SELECT DISTINCT sjh.Job_Code, sjh.Job_Code, 0, GETDATE(), 0, GETDATE(), @GlobalJobCodeId          
 FROM #I_STD_JOB_HEADER sjh          
 WHERE sjh.Job_Code NOT IN (SELECT Code FROM tblJobCodes) AND ISNULL(sjh.Job_Code,'')<>''          
          
          
-- Add Job_Location if it's a new one          
   INSERT JOB_LOCATION          
 (Job_Location_Code, Last_Mod_By_User_ID, Last_Mod_Date,           
 Create_By_User_ID, Create_Date)          
 SELECT DISTINCT sjh.Job_Location, 0, GETDATE(), 0, GETDATE()          
FROM #I_STD_JOB_HEADER sjh          
 WHERE sjh.Job_Location NOT IN (SELECT Job_Location_Code FROM JOB_LOCATION) AND ISNULL(sjh.Job_Location,'')<>''          
          
-- Add Work_Application if it's a new one          
   INSERT WORK_APPLICATION          
 (Work_Application_Code, Last_Mod_By_User_ID, Last_Mod_Date,           
 Create_By_User_ID, Create_Date)          
 SELECT DISTINCT sjh.Work_Application, 0, GETDATE(), 0, GETDATE()          
 FROM #I_STD_JOB_HEADER sjh          
 WHERE sjh.Work_Application NOT IN (SELECT Work_Application_Code FROM WORK_APPLICATION) AND ISNULL(sjh.Work_Application,'')<>''          
          
-- Add Job_Condition if it's a new one          
   INSERT JOB_CONDITION          
 (Job_Condition_Code, Last_Mod_By_User_ID, Last_Mod_Date,           
 Create_By_User_ID, Create_Date)          
 SELECT DISTINCT sjh.Job_Condition, 0, GETDATE(), 0, GETDATE()          
 FROM #I_STD_JOB_HEADER sjh          
 WHERE sjh.Job_Condition NOT IN (SELECT Job_Condition_Code FROM JOB_CONDITION) AND ISNULL(sjh.Job_Condition,'')<>''          
          
-- Add Cab_Type if it's a new one          
   INSERT CAB_TYPE          
 (Cab_Type_Code, Last_Mod_By_User_ID, Last_Mod_Date,           
 Create_By_User_ID, Create_Date)          
 SELECT DISTINCT sjh.Cab_Type, 0, GETDATE(), 0, GETDATE()          
 FROM #I_STD_JOB_HEADER sjh          
 WHERE sjh.Cab_Type NOT IN (SELECT Cab_Type_Code FROM CAB_TYPE) AND ISNULL(sjh.Cab_Type,'')<>''          
          
-- Add tblManufacturers if it's a new one          
   INSERT tblManufacturers          
 (Manufacturer, ManufacturerDesc, LastModByUserId, LastModDate, CreateByUserId, CreateDate, Manufacturer_Code)          
 SELECT DISTINCT sjh.Supplier, sjh.Supplier, 0, GETDATE(), 0, GETDATE(), SUBSTRING(sjh.Supplier,1,2)          
 FROM #I_STD_JOB_HEADER sjh          
 WHERE sjh.Supplier NOT IN (SELECT Manufacturer FROM tblManufacturers) AND ISNULL(sjh.Supplier,'')<>''          
           
 /*VV CR8864*/          
 INSERT INTO tblCostPartsEscalations(CostEscalationId,ManufacturerId,PartsEscalation,CumPartsEscalation)          
 SELECT A.CostEscalationId,A.ManufacturerId,1 AS PartsEscalation,1 AS CumPartsEscalation          
 FROM          
 (SELECT CE.CostEscalationId,M.ManufacturerId          
 FROM            
 tblCostEscalations CE          
  CROSS JOIN          
 tblManufacturers M) A          
  LEFT JOIN          
 tblCostPartsEscalations CPE          
  ON A.CostEscalationId=CPE.CostEscalationId          
  AND A.ManufacturerId=CPE.ManufacturerId          
 WHERE CPE.ManufacturerId IS NULL          
          
-- #I_STD_JOB_OPERATION          
          
-- Add JobCode if it's a new one          
IF @isCodeMap=0 AND @GlobalJobCodeId>0          
   INSERT tblJobCodes          
 (Code, Description, LastModByUserId, LastModDate,           
 CreateByUserId, CreateDate, Global_Job_Code_Id)          
 SELECT DISTINCT sjo.Job_Code, sjo.Job_Code, 0, GETDATE(), 0, GETDATE(), @GlobalJobCodeId          
 FROM #I_STD_JOB_OPERATION sjo          
 WHERE sjo.Job_Code NOT IN (SELECT Code FROM tblJobCodes) AND ISNULL(sjo.Job_Code,'')<>''          
          
-- Add Component Code if it's a new one          
IF @isCodeMap=0 AND @subSystemId > 0          
   INSERT tblComponentCodes          
 (SubSystemID, Code, [Description], BudgetCode,           
 LastModByUserId, LastModDate, CreateByUserId, CreateDate, Default_Record)          
 SELECT DISTINCT @subSystemId , sjo.Component_Code, sjo.Component_Code, 0, 0, GETDATE(), 0, GETDATE(), 0          
 FROM #I_STD_JOB_OPERATION sjo          
 WHERE sjo.Component_Code NOT IN (SELECT Code FROM tblComponentCodes) AND ISNULL(sjo.Component_Code,'')<>''          
          
-- #I_STD_JOB_PARTS          
          
          
-- Add Source_Of_Supply if it's a new one          
 INSERT SOURCE_OF_SUPPLY          
 (Sos_Code, Sos_Description, Last_Mod_By_User_ID, Last_Mod_Date,           
 Create_By_User_ID, Create_Date)          
 SELECT DISTINCT sjp.Part_Source_Of_Supply, sjp.Part_Source_Of_Supply, 0, GETDATE(), 0, GETDATE()    
 FROM #I_STD_JOB_PARTS sjp          
 WHERE sjp.Part_Source_Of_Supply NOT IN (SELECT Sos_Code FROM SOURCE_OF_SUPPLY) AND ISNULL(sjp.Part_Source_Of_Supply,'')<>''          
          
-- Add Part if it's a new one          
   INSERT tblParts          
 (Part, PartDescription, Part_Type_ID, Source_Of_Supply_ID, LastModByUserId, LastModDate,           
 CreateByUserId, CreateDate)          
 SELECT DISTINCT sjp.Part_Number, ISNULL(sjp.Part_Description,'NONE'),  --KN 17 Nov 2008          
  CASE WHEN pt.PartTypeId IS NULL THEN @ptDef ELSE pt.PartTypeId END,           
  sos.Source_Of_Supply_ID, 0, GETDATE(), 0, GETDATE()          
 FROM #I_STD_JOB_PARTS sjp          
  LEFT JOIN tblPartTypes pt ON pt.PartType=sjp.Part_Type          
  LEFT JOIN SOURCE_OF_SUPPLY sos ON sos.Sos_Code=sjp.Part_Source_Of_Supply          
  LEFT JOIN tblParts p ON p.Part=sjp.Part_Number AND p.Source_Of_Supply_ID=sos.Source_Of_Supply_ID          
 --WHERE sjp.Part_Number NOT IN (SELECT Part FROM tblParts) AND ISNULL(sjp.Part_Number,'')<>''          
 WHERE p.PartId IS NULL AND sos.Sos_Code IS NOT NULL          
           
           
--Add Task Counter if option SetTaskCounter was selected by UI         
IF(@SetTaskCounter = 1)        
 BEGIN        
  INSERT INTO tblApplicationCodes(Code, [Description], BudgetCode, LastModByUserId, LastModDate, CreateByUserId, CreateDate)        
  SELECT DISTINCT sjh.Application_Code, sjh.Application_Code, 1, 0, GETDATE(), 0, GETDATE()        
  FROM #I_STD_JOB_HEADER sjh          
  WHERE sjh.Application_Code NOT IN (SELECT Code FROM tblApplicationCodes) AND ISNULL(sjh.Application_Code,'')<>''          
 END        
          
           
/*VV CR8357 Change Std Job Reference*/          
          
UPDATE isjh SET StdJobRef=          
CASE isjh.System_Source WHEN'BUILDER' THEN Std_Job_Header_ID ELSE          
ISNULL(isjh.Group_No,'')+'.'+          
ISNULL(CASE WHEN @isCodeMap=0 THEN cc.Code ELSE ISNULL(CCG.Code,@gccDefccCode) END,'')+'.'+          
ISNULL(CASE WHEN @isCodeMap=0 THEN ISNULL(jc.Code,@jcDefCode) ELSE ISNULL(jc2.Code,@jcDefCode) END,'')+'.'+          
ISNULL(ISNULL(mc.Code,@mdDefCode),'')+'.'+ISNULL(ISNULL(ac.Code,@acDefCode),'')+'.'+          
ISNULL(JL.Job_Location_Code,'')+'.'+ISNULL(WA.Work_Application_Code,'')+'.'+          
ISNULL(jcon.Job_Condition_Code,'')+'.'+ISNULL(CT.Cab_Type_Code,'')+'.'+          
ISNULL(isjh.Serial_No_Prefix,'')+'.'+ISNULL(isjh.Serial_No_Start,'')+'.'+ISNULL(isjh.Serial_No_End,'')+'.'+          
ISNULL(CASE WHEN @NewCurrencyID=0 THEN cur.Currency ELSE @NewCurrency END,'')+'.'+          
ISNULL(Mod.Model,'')+'.'+         
ISNULL(CASE WHEN @NewSimulationRef='' THEN isjh.Simulation_Reference ELSE @NewSimulationRef END,'')+'.'+          
CAST(ISNULL(isjh.Dummy_Job,0) AS varchar(50))+'.'+CAST(ISNULL(il.Live_Job,1) AS varchar(50))+'.'+          
ISNULL(isjh.Std_Job_Description,'') END          
FROM #I_STD_JOB_HEADER isjh          
 LEFT JOIN #isLive il ON (il.Live_Job=@live1 OR il.Live_Job=@live2) AND il.Live_Job=isjh.Live_Job --AL: 29/03/10          
 LEFT JOIN tblModels mod ON isjh.Model=mod.Model          
 LEFT JOIN tblCurrencies cur ON isjh.Currency=cur.Currency          
 LEFT JOIN tblQUOMs quom ON isjh.Unit_Of_Measure=quom.Short_Desc          
 LEFT JOIN SYSTEM_SOURCE ss ON isjh.System_Source=ss.System_Source_Code          
 LEFT JOIN tblComponentCodes cc ON isjh.Component_Code=cc.Code          
 LEFT JOIN GLOBAL_COMPONENT_CODES gcc ON isjh.Component_Code=gcc.Global_Component_Code          
 LEFT JOIN tblComponentCodes CCG ON gcc.AMT_Component_Code_Id=CCG.ComponentCodeID          
 LEFT JOIN tblModifierCodes mc ON isjh.Modifier_Code=mc.Code          
 LEFT JOIN tblJobCodes jc ON isjh.Job_Code=jc.Code          
 LEFT JOIN GLOBAL_JOB_CODES gjc ON isjh.Job_Code=gjc.Global_Job_Code          
 LEFT JOIN tblJobCodes jc2 ON jc2.JobCodeID=          
  (SELECT TOP 1 jc3.JobCodeID           
  FROM tblJobCodes jc3 WHERE jc3.Global_Job_Code_Id=gjc.Global_Job_Id AND jc3.Default_Record=gjc.Default_Record)          
 LEFT JOIN tblTaskTypes tt ON isjh.Task_Type=tt.Code          
 LEFT JOIN tblApplicationCodes ac ON isjh.Application_Code=ac.Code          
 LEFT JOIN tblOccurrenceTypes ot ON isjh.Occurrence_Type=ot.OccurrenceType          
 LEFT JOIN JOB_LOCATION jl ON isjh.Job_Location=jl.Job_Location_Code          
 LEFT JOIN WORK_APPLICATION wa ON isjh.Work_Application=wa.Work_Application_Code          
 LEFT JOIN JOB_CONDITION jcon ON isjh.Job_Condition=jcon.Job_Condition_Code          
 LEFT JOIN CAB_TYPE ct ON isjh.Cab_Type=ct.Cab_Type_Code          
 LEFT JOIN PROJECTION_TYPE prtp ON prtp.Projection_Type_Name=isjh.Projection_Type          
 LEFT JOIN tblPartTypes pt ON isjh.Part_Type=pt.PartType          
 LEFT JOIN GLOBAL_PART_TYPES gpt ON isjh.Part_Type=gpt.Global_Part_Type          
 LEFT JOIN tblPartTypes pt2 ON pt2.PartTypeId=          
  (SELECT TOP 1 pt3.PartTypeId           
  FROM tblPartTypes pt3 WHERE pt3.Global_Part_Type_Id=gpt.Global_Part_Type_Id AND ABS(pt3.PartTypeDefault)=ABS(gpt.Default_Record))          
 LEFT JOIN tblLabourActivities la ON isjh.Labour_Activity=la.ActivityCode          
 LEFT JOIN tblManufacturers man ON man.Manufacturer=isjh.Supplier          
 LEFT JOIN ROTABLE_PART rp ON isjh.Rotable_Part_Number=rp.Part_Number          
 LEFT JOIN tblParts p ON isjh.Rotable_Part_Number=p.Part          
           
/*VV #3834IF EXISTS(SELECT Std_Job_Header_ID, COUNT(StdJobRef) FROM #I_STD_JOB_HEADER GROUP BY Std_Job_Header_ID           
 HAVING COUNT(StdJobRef)>1)*/          
IF EXISTS(SELECT StdJobRef, COUNT(Std_Job_Header_ID) FROM #I_STD_JOB_HEADER GROUP BY  StdJobRef           
 HAVING COUNT(Std_Job_Header_ID)>1)          
BEGIN          
          
 DECLARE @Mgs varchar(max)          
           
 /*VV #3834          
 SET @Mgs='Duplicate Standard Jobs: '          
 SELECT @Mgs=@Mgs+Std_Job_Header_ID+', ' FROM #I_STD_JOB_HEADER           
 GROUP BY Std_Job_Header_ID HAVING COUNT(StdJobRef)>1          
 */          
 SET @Mgs='Duplicate Standard Jobs: '          
 SELECT @Mgs=@Mgs+MIN(Std_Job_Header_ID)+', ' FROM #I_STD_JOB_HEADER           
 GROUP BY StdJobRef HAVING COUNT(Std_Job_Header_ID)>1          
 SET @Mgs=LEFT(@Mgs,LEN(@Mgs)-LEN(', '))          
           
 RAISERROR (@Mgs, 16, 1)            
 RETURN          
END          
          
          
--=============================================================          
--================  Adding Standard Jobs ======================          
--=============================================================          
          
/*@isExisting int=2, -- 0-not exist, 1-exist, 2-all*/          
IF @isExisting IN(1,2)          
BEGIN          
 UPDATE sjh          
 SET sjh.StdJob=isjh.Std_Job_Description,          
  sjh.ModelId=mod.ModelId,          
  sjh.Serial_No_Prefix=isjh.Serial_No_Prefix,          
  sjh.Serial_No_Start=isjh.Serial_No_Start,          
  sjh.Serial_No_End=isjh.Serial_No_End,          
  sjh.Live_Job=ISNULL(il.Live_Job,1),          
  sjh.Dummy_Job=ISNULL(isjh.Dummy_Job,0),          
  sjh.System_Source_ID=ss.System_Source_ID,          
  sjh.ComponentCodeId=CASE WHEN @isCodeMap=0 THEN cc.ComponentCodeID ELSE (CASE WHEN gcc.AMT_Component_Code_Id IS NOT NULL THEN gcc.AMT_Component_Code_Id ELSE @gccDefcc END) END,          
  sjh.ModifierCodeId=ISNULL(mc.ModifierID,@mdDef),          
  sjh.JobCodeId=CASE WHEN @isCodeMap=0 THEN ISNULL(jc.JobCodeID,@jcDef)          
    ELSE ISNULL(jc2.JobCodeId,@jcDef) END,          
  sjh.TaskTypeId=ISNULL(tt.TaskTypeID,@ttDef),          
  sjh.ApplicationCodeID=ISNULL(ac.ApplicationCodeID,@acDef),          
  sjh.Occurrence_Type_Id=ISNULL(ot.OccurrenceTypeId,@otDef),          
  sjh.Option_Pobability=CASE WHEN isjh.Option_Pobability>=0 AND isjh.Option_Pobability<=1 THEN ISNULL(isjh.Option_Pobability,1) ELSE 1 END,          
  sjh.Job_Default_Option=ISNULL(isjh.Job_Default_Option,1),          
  sjh.Job_Location_ID=jl.Job_Location_ID,          
  sjh.Work_Application_ID=wa.Work_Application_ID,          
  sjh.Job_Condition_ID=jcon.Job_Condition_ID,          
  sjh.Cab_Type_ID=ct.Cab_Type_ID,     
  sjh.LastModByUserId=0,          
  sjh.LastModDate=getdate(),          
  sjh.Pricing_Branch=isjh.Pricing_Branch,          
  sjh.Price_Group=isjh.Price_Group,          
  sjh.Currency_ID=(CASE WHEN @NewCurrencyID=0 THEN cur.CurrencyID ELSE @NewCurrencyID END),          
  sjh.Overwrite_Costs=ISNULL(isjh.Overwrite_Costs,0),          
  sjh.Job_Quantity=CASE WHEN isjh.Job_Quantity<=2 THEN ISNULL(isjh.Job_Quantity,1) ELSE 1 END,          
  sjh.Parts_Usage_Factor=ISNULL(isjh.Parts_Usage_Factor,1),          
  sjh.Parts_Cost=CASE WHEN @NewCurrencyID=0 THEN           
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Parts_Cost*isjh.Job_Quantity ELSE isjh.Parts_Cost END          
    ELSE          
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Parts_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Parts_Cost*@NewRate END          
    END,          
  sjh.Labour_Cost=CASE WHEN @NewCurrencyID=0 THEN           
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Labour_Cost*isjh.Job_Quantity ELSE isjh.Labour_Cost END          
    ELSE          
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Labour_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Labour_Cost*@NewRate END          
    END,          
  sjh.Misc_Cost=CASE WHEN @NewCurrencyID=0 THEN           
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Misc_Cost*isjh.Job_Quantity ELSE isjh.Misc_Cost END          
    ELSE          
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Misc_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Misc_Cost*@NewRate END          
    END,       
  --E1030        
  --sjh.Parts_Cost_Cost =CASE WHEN @NewCurrencyID=0 THEN           
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Parts_Cost_Cost*isjh.Job_Quantity ELSE isjh.Parts_Cost_Cost  END          
  --  ELSE          
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Parts_Cost_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Parts_Cost_Cost*@NewRate END          
  --  END,          
  --sjh.Labour_Cost_Cost =CASE WHEN @NewCurrencyID=0 THEN           
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Labour_Cost_Cost*isjh.Job_Quantity ELSE isjh.Labour_Cost_Cost  END          
  --  ELSE          
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Labour_Cost_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Labour_Cost_Cost*@NewRate END          
  --  END,          
  --sjh.Misc_Cost_Cost =CASE WHEN @NewCurrencyID=0 THEN           
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Misc_Cost_Cost*isjh.Job_Quantity ELSE isjh.Misc_Cost_Cost  END          
  --  ELSE          
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Misc_Cost_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Misc_Cost_Cost*@NewRate END          
  --  END,        
             
  sjh.Labour_Hrs=isjh.Labour_Hrs,          
  sjh.Simulation_Reference=CASE WHEN @NewSimulationRef='' THEN isjh.Simulation_Reference ELSE @NewSimulationRef END,          
  sjh.Simulation_Description=CASE WHEN ISNULL(isjh.Simulation_Description,'')='' THEN isjh.Simulation_Reference ELSE isjh.Simulation_Description END,          
  sjh.Group_No=isjh.Group_No,          
  sjh.Use_Rotable=ISNULL(isjh.Use_Rotable,0),          
  sjh.Rotable_Part_Id=CASE WHEN sjh.Use_Rotable=1 THEN rp.Rotable_Part_Id ELSE p.PartId END,          
  sjh.Default_First=ISNULL(isjh.Default_First,0),          
  sjh.Default_Interval=ISNULL(isjh.Default_Interval,0),          
  sjh.QUOM_ID=ISNULL(quom.QUOMId, @quomDef),          
  sjh.Company=isjh.Company,          
  sjh.Branch=isjh.Branch,          
  sjh.Site=isjh.Site,          
  sjh.Fleet=isjh.Fleet,          
  sjh.Equipment=isjh.Equipment,          
  sjh.Serial_Number=isjh.Serial_Number,          
  sjh.Projection_Type=prtp.Projection_Type_ID, --isjh.Projection_Type,          
  sjh.Planning_Task=isjh.Planning_Task,          
  sjh.Lead_Days=ISNULL(isjh.Lead_Time_Days,60),          
  sjh.Not_After=ISNULL(isjh.Not_After,0),          
  sjh.Last_Change_Date=isjh.Last_Change_Date,          
  sjh.Last_Change_Usage=ISNULL(isjh.Last_Change_Usage,0),          
  sjh.Use_Std_Job=ISNULL(isjh.Use_Std_Job,0),          
  sjh.Pricing_Date=ISNULL(isjh.Pricing_Date,getdate()),          
  sjh.Part_Type_ID=CASE WHEN @isCodeMap=0 THEN ISNULL(pt.PartTypeId,@ptDef)          
     ELSE ISNULL(pt2.PartTypeId,@ptDef) END,          
  sjh.Labour_Activity_ID=ISNULL(la.LabourActivityId,@laDef),          
  sjh.Manufacturer_Id=man.ManufacturerId          
 FROM #I_STD_JOB_HEADER isjh          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /* VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblModels mod ON isjh.Model=mod.Model          
  LEFT JOIN tblCurrencies cur ON isjh.Currency=cur.Currency          
  LEFT JOIN tblQUOMs quom ON isjh.Unit_Of_Measure=quom.Short_Desc          
  LEFT JOIN SYSTEM_SOURCE ss ON isjh.System_Source=ss.System_Source_Code          
  LEFT JOIN tblComponentCodes cc ON isjh.Component_Code=cc.Code          
  LEFT JOIN GLOBAL_COMPONENT_CODES gcc ON isjh.Component_Code=gcc.Global_Component_Code          
  LEFT JOIN tblModifierCodes mc ON isjh.Modifier_Code=mc.Code          
  LEFT JOIN tblJobCodes jc ON isjh.Job_Code=jc.Code          
  LEFT JOIN GLOBAL_JOB_CODES gjc ON isjh.Job_Code=gjc.Global_Job_Code          
  LEFT JOIN tblJobCodes jc2 ON jc2.JobCodeID=          
   (SELECT TOP 1 jc3.JobCodeID           
   FROM tblJobCodes jc3 WHERE jc3.Global_Job_Code_Id=gjc.Global_Job_Id AND jc3.Default_Record=gjc.Default_Record)          
  LEFT JOIN tblTaskTypes tt ON isjh.Task_Type=tt.Code          
  LEFT JOIN tblApplicationCodes ac ON isjh.Application_Code=ac.Code          
  LEFT JOIN tblOccurrenceTypes ot ON isjh.Occurrence_Type=ot.OccurrenceType          
  LEFT JOIN JOB_LOCATION jl ON isjh.Job_Location=jl.Job_Location_Code          
  LEFT JOIN WORK_APPLICATION wa ON isjh.Work_Application=wa.Work_Application_Code          
  LEFT JOIN JOB_CONDITION jcon ON isjh.Job_Condition=jcon.Job_Condition_Code          
  LEFT JOIN CAB_TYPE ct ON isjh.Cab_Type=ct.Cab_Type_Code          
  LEFT JOIN PROJECTION_TYPE prtp ON prtp.Projection_Type_Name=isjh.Projection_Type          
  LEFT JOIN tblPartTypes pt ON isjh.Part_Type=pt.PartType          
  LEFT JOIN GLOBAL_PART_TYPES gpt ON isjh.Part_Type=gpt.Global_Part_Type          
  LEFT JOIN tblPartTypes pt2 ON pt2.PartTypeId=          
   (SELECT TOP 1 pt3.PartTypeId           
   FROM tblPartTypes pt3 WHERE pt3.Global_Part_Type_Id=gpt.Global_Part_Type_Id AND ABS(pt3.PartTypeDefault)=ABS(gpt.Default_Record))          
  LEFT JOIN tblLabourActivities la ON isjh.Labour_Activity=la.ActivityCode          
  LEFT JOIN tblManufacturers man ON man.Manufacturer=isjh.Supplier          
  LEFT JOIN ROTABLE_PART rp ON isjh.Rotable_Part_Number=rp.Part_Number          
  LEFT JOIN tblParts p ON isjh.Rotable_Part_Number=p.Part          
 WHERE sjh.Std_Job_Ref IS NOT NULL          
           
          
 SET @NRecords=@@ROWCOUNT           
          
END          
          
/*@isExisting int=2, -- 0-not exist, 1-exist, 2-all*/          
IF @isExisting IN(0,2)          
BEGIN          
 INSERT tblStdJobs          
  (Std_Job_Ref,          
  StdJob,          
  ModelId,          
  Serial_No_Prefix,          
  Serial_No_Start,          
  Serial_No_End,          
  Live_Job,          
  Dummy_Job,          
  System_Source_ID,          
  ComponentCodeId,          
  ModifierCodeId,          
  JobCodeId,          
  TaskTypeId,          
  ApplicationCodeID,          
  Occurrence_Type_Id,          
  Option_Pobability,          
  Job_Default_Option,          
  Job_Location_ID,          
  Work_Application_ID,          
  Job_Condition_ID,          
  Cab_Type_ID,          
  LastModByUserId,          
  LastModDate,          
  CreatedByUserId,          
  CreateDate,          
  Pricing_Branch,          
  Price_Group,          
  Currency_ID,          
  Overwrite_Costs,          
  Job_Quantity,          
  Parts_Usage_Factor,          
  Parts_Cost,          
  Labour_Cost,          
  Misc_Cost,       
  -- E1030      
  --Parts_Cost_Cost ,          
  --Labour_Cost_Cost ,          
  --Misc_Cost_Cost,      
           
  Labour_Hrs,          
  Simulation_Reference,          
  Simulation_Description,          
  Group_No,          
  Use_Rotable,          
  Rotable_Part_Id,          
  Default_First,          
  Default_Interval,          
  QUOM_ID,          
  Company,          
  Branch,          
  Site,          
  Fleet,          
  Equipment,          
  Serial_Number,          
  Projection_Type,          
  Planning_Task,          
  Lead_Days,          
  Not_After,          
  Last_Change_Date,          
  Last_Change_Usage,          
  Use_Std_Job,          
  Pricing_Date,          
  Part_Type_ID,          
  Labour_Activity_ID,          
  Manufacturer_Id)          
 SELECT            
  isjh.StdJobRef,          
  isjh.Std_Job_Description,          
  mod.ModelId,          
  isjh.Serial_No_Prefix,          
  isjh.Serial_No_Start,          
  isjh.Serial_No_End,          
  ISNULL(il.Live_Job,1),          
  ISNULL(isjh.Dummy_Job,0),          
  ss.System_Source_ID,          
  CASE WHEN @isCodeMap=0 THEN cc.ComponentCodeID ELSE (CASE WHEN gcc.AMT_Component_Code_Id IS NOT NULL THEN gcc.AMT_Component_Code_Id ELSE @gccDefcc END) END,          
  ISNULL(mc.ModifierID,@mdDef),          
  CASE WHEN @isCodeMap=0 THEN ISNULL(jc.JobCodeID,@jcDef)          
    ELSE ISNULL(jc2.JobCodeId,@jcDef) END,          
  ISNULL(tt.TaskTypeID,@ttDef),          
  ISNULL(ac.ApplicationCodeID,@acDef),     
  ISNULL(ot.OccurrenceTypeId,@otDef),          
  CASE WHEN isjh.Option_Pobability>=0 AND isjh.Option_Pobability<=1 THEN ISNULL(isjh.Option_Pobability,1) ELSE 1 END,          
  ISNULL(isjh.Job_Default_Option,1),          
  jl.Job_Location_ID,          
  wa.Work_Application_ID,          
  jcon.Job_Condition_ID,          
  ct.Cab_Type_ID,          
  0,          
  getdate(),          
  0,          
  getdate(),          
  isjh.Pricing_Branch,          
  isjh.Price_Group,          
  CASE WHEN @NewCurrencyID=0 THEN cur.CurrencyID ELSE @NewCurrencyID END,          
  ISNULL(isjh.Overwrite_Costs,0),          
  CASE WHEN isjh.Job_Quantity<=2 THEN ISNULL(isjh.Job_Quantity,1) ELSE 1 END,          
  ISNULL(isjh.Parts_Usage_Factor,1),          
  CASE WHEN @NewCurrencyID=0 THEN           
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Parts_Cost*isjh.Job_Quantity ELSE isjh.Parts_Cost END          
    ELSE          
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Parts_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Parts_Cost*@NewRate END          
    END,          
  CASE WHEN @NewCurrencyID=0 THEN           
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Labour_Cost*isjh.Job_Quantity ELSE isjh.Labour_Cost END          
    ELSE          
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Labour_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Labour_Cost*@NewRate END          
    END,          
  CASE WHEN @NewCurrencyID=0 THEN           
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Misc_Cost*isjh.Job_Quantity ELSE isjh.Misc_Cost END          
    ELSE          
     CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Misc_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Misc_Cost*@NewRate END          
    END,        
  --E1030        
  --CASE WHEN @NewCurrencyID=0 THEN           
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Parts_Cost_Cost*isjh.Job_Quantity ELSE isjh.Parts_Cost_Cost END          
  --  ELSE          
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Parts_Cost_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Parts_Cost_Cost*@NewRate END          
  --  END,          
  --CASE WHEN @NewCurrencyID=0 THEN           
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Labour_Cost_Cost *isjh.Job_Quantity ELSE isjh.Labour_Cost_Cost END          
  --  ELSE          
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Labour_Cost_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Labour_Cost_Cost*@NewRate END          
  --  END,          
  --CASE WHEN @NewCurrencyID=0 THEN           
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Misc_Cost_Cost *isjh.Job_Quantity ELSE isjh.Misc_Cost_Cost END          
  --  ELSE          
  --   CASE WHEN isjh.Overwrite_Costs=1 AND isjh.Job_Quantity>2 THEN isjh.Misc_Cost_Cost*isjh.Job_Quantity*@NewRate ELSE isjh.Misc_Cost_Cost*@NewRate END          
  --  END,            
          
  isjh.Labour_Hrs,          
  CASE WHEN @NewSimulationRef='' THEN isjh.Simulation_Reference ELSE @NewSimulationRef END,          
  CASE WHEN ISNULL(isjh.Simulation_Description,'')='' THEN isjh.Simulation_Reference ELSE isjh.Simulation_Description END,          
  isjh.Group_No,          
  ISNULL(isjh.Use_Rotable,0),          
  CASE WHEN sjh.Use_Rotable=1 THEN rp.Rotable_Part_Id ELSE p.PartId END,          
  ISNULL(isjh.Default_First,0),          
  ISNULL(isjh.Default_Interval,0),          
  ISNULL(quom.QUOMId, @quomDef),          
  isjh.Company,          
  isjh.Branch,          
  isjh.Site,          
  isjh.Fleet,          
  isjh.Equipment,          
  isjh.Serial_Number,          
  prtp.Projection_Type_ID, --isjh.Projection_Type,          
  isjh.Planning_Task,          
  ISNULL(isjh.Lead_Time_Days,60),          
  ISNULL(isjh.Not_After,0),          
  isjh.Last_Change_Date,          
  ISNULL(isjh.Last_Change_Usage,0),          
  ISNULL(isjh.Use_Std_Job,0),          
  ISNULL(isjh.Pricing_Date,getdate()),          
  CASE WHEN @isCodeMap=0 THEN ISNULL(pt.PartTypeId,@ptDef)          
     ELSE ISNULL(pt2.PartTypeId,@ptDef) END,          
  ISNULL(la.LabourActivityId,@laDef),          
  man.ManufacturerId          
 --SELECT *          
 FROM #I_STD_JOB_HEADER isjh          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /* VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblModels mod ON isjh.Model=mod.Model          
  LEFT JOIN tblCurrencies cur ON isjh.Currency=cur.Currency          
  LEFT JOIN tblQUOMs quom ON isjh.Unit_Of_Measure=quom.Short_Desc          
  LEFT JOIN SYSTEM_SOURCE ss ON isjh.System_Source=ss.System_Source_Code          
  LEFT JOIN tblComponentCodes cc ON isjh.Component_Code=cc.Code          
  LEFT JOIN GLOBAL_COMPONENT_CODES gcc ON isjh.Component_Code=gcc.Global_Component_Code          
  LEFT JOIN tblModifierCodes mc ON isjh.Modifier_Code=mc.Code          
  LEFT JOIN tblJobCodes jc ON isjh.Job_Code=jc.Code          
  LEFT JOIN GLOBAL_JOB_CODES gjc ON isjh.Job_Code=gjc.Global_Job_Code          
  LEFT JOIN tblJobCodes jc2 ON jc2.JobCodeID=          
   (SELECT TOP 1 jc3.JobCodeID           
   FROM tblJobCodes jc3 WHERE jc3.Global_Job_Code_Id=gjc.Global_Job_Id AND jc3.Default_Record=gjc.Default_Record)          
  LEFT JOIN tblTaskTypes tt ON isjh.Task_Type=tt.Code          
  LEFT JOIN tblApplicationCodes ac ON isjh.Application_Code=ac.Code          
  LEFT JOIN tblOccurrenceTypes ot ON isjh.Occurrence_Type=ot.OccurrenceType          
  LEFT JOIN JOB_LOCATION jl ON isjh.Job_Location=jl.Job_Location_Code          
  LEFT JOIN WORK_APPLICATION wa ON isjh.Work_Application=wa.Work_Application_Code          
  LEFT JOIN JOB_CONDITION jcon ON isjh.Job_Condition=jcon.Job_Condition_Code          
  LEFT JOIN CAB_TYPE ct ON isjh.Cab_Type=ct.Cab_Type_Code          
  LEFT JOIN PROJECTION_TYPE prtp ON prtp.Projection_Type_Name=isjh.Projection_Type          
  LEFT JOIN tblPartTypes pt ON isjh.Part_Type=pt.PartType          
  LEFT JOIN GLOBAL_PART_TYPES gpt ON isjh.Part_Type=gpt.Global_Part_Type          
  LEFT JOIN tblPartTypes pt2 ON pt2.PartTypeId=          
   (SELECT TOP 1 pt3.PartTypeId           
   FROM tblPartTypes pt3 WHERE pt3.Global_Part_Type_Id=gpt.Global_Part_Type_Id AND ABS(pt3.PartTypeDefault)=ABS(gpt.Default_Record))          
  LEFT JOIN tblLabourActivities la ON isjh.Labour_Activity=la.ActivityCode          
  LEFT JOIN tblManufacturers man ON man.Manufacturer=isjh.Supplier          
  LEFT JOIN ROTABLE_PART rp ON isjh.Rotable_Part_Number=rp.Part_Number          
  LEFT JOIN tblParts p ON isjh.Rotable_Part_Number=p.Part          
 WHERE sjh.Std_Job_Ref IS NULL          
          
 SET @NRecords=@NRecords+@@ROWCOUNT           
          
END          
          
-----------------          
 DELETE tblStdJobOperationParts          
 --SELECT *          
 FROM #I_STD_JOB_HEADER isjh          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /*VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobId=sjh.StdJobId          
  LEFT JOIN tblStdJobOperationParts sjop ON sjop.StdJobOperationId=sjo.StdJobOperationId          
          
 DELETE STD_JOB_OPERATION_LABOUR          
 FROM #I_STD_JOB_HEADER isjh          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /*AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobId=sjh.StdJobId          
  LEFT JOIN STD_JOB_OPERATION_LABOUR sjol ON sjol.Std_Job_Operation_ID=sjo.StdJobOperationId          
          
 DELETE STD_JOB_OPERATION_MISC          
 FROM #I_STD_JOB_HEADER isjh          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /* VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobId=sjh.StdJobId          
  LEFT JOIN STD_JOB_OPERATION_MISC sjom ON sjom.Std_Job_Operation_ID=sjo.StdJobOperationId          
          
          
 DELETE tblStdJobOperations          
 --SELECT *          
 FROM #I_STD_JOB_HEADER isjh          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /*VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobId=sjh.StdJobId          
          
          
 INSERT tblStdJobOperations          
  (Std_Job_Operation_Ref,          
  StdJobId,          
  StdJobOperation,          
  ComponentCodeId,          
  JobCodeId,          
  DurationHours,          
  Group_No,          
  ModifierCodeId,          
  ApplicationCodeId,          
  LastModByUserId,          
  LastModDate,          
  CreatedByUserId,          
  CreateDate,          
  TaskTypeId,          
  Job_Location_ID,          
  Work_Application_ID,          
  Job_Condition_ID,          
  Cab_Type_ID)          
 SELECT            
  isjo.Std_Job_Operation_ID,      
  sjh.StdJobId,          
  CASE WHEN ISNULL(isjo.Name,'')='' THEN sjh.StdJob ELSE isjo.Name END,          
  CASE WHEN ISNULL(isjo.Component_Code,'')='' THEN sjh.ComponentCodeId ELSE (CASE WHEN @isCodeMap=0 THEN cc.ComponentCodeID ELSE (CASE WHEN gcc.AMT_Component_Code_Id IS NOT NULL THEN gcc.AMT_Component_Code_Id ELSE @gccDefcc END) END) END,          
  CASE WHEN ISNULL(isjo.Job_Code,'')='' THEN sjh.JobCodeId ELSE (CASE WHEN @isCodeMap=0 THEN ISNULL(jc.JobCodeID,@jcDef) ELSE ISNULL(jc2.JobCodeId,@jcDef) END) END,          
  CASE WHEN isjh.Job_Quantity<=2 THEN ISNULL(isjo.Duration_Hours,0) ELSE ISNULL(isjo.Duration_Hours,0)*isjh.Job_Quantity END,          
  isjo.Group_No,          
  sjh.ModifierCodeId,          
  sjh.ApplicationCodeID,          
  0,          
  getdate(),          
  0,          
  getdate(),          
  sjh.TaskTypeId,          
  sjh.Job_Location_ID,          
  sjh.Work_Application_ID,          
  sjh.Job_Condition_ID,          
  sjh.Cab_Type_ID          
 FROM #I_STD_JOB_OPERATION isjo          
  LEFT JOIN  #I_STD_JOB_HEADER isjh ON isjo.Std_Job_Header_ID=isjh.Std_Job_Header_ID          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /*VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobId=sjh.StdJobId          
  LEFT JOIN tblComponentCodes cc ON isjo.Component_Code=cc.Code          
  LEFT JOIN GLOBAL_COMPONENT_CODES gcc ON isjo.Component_Code=gcc.Global_Component_Code          
  LEFT JOIN tblJobCodes jc ON isjo.Job_Code=jc.Code          
  LEFT JOIN GLOBAL_JOB_CODES gjc ON isjo.Job_Code=gjc.Global_Job_Code          
  LEFT JOIN tblJobCodes jc2 ON jc2.JobCodeID=          
   (SELECT TOP 1 jc3.JobCodeID           
   FROM tblJobCodes jc3 WHERE jc3.Global_Job_Code_Id=gjc.Global_Job_Id AND jc3.Default_Record=gjc.Default_Record)          
 WHERE sjo.Std_Job_Operation_Ref IS NULL           
  AND sjh.Std_Job_Ref IS NOT NULL  -- not import if there is no job header          
          
          
 UPDATE sjh2         SET Duration_Hrs=(select CASE WHEN sum(DurationHours) IS NULL THEN 0 ELSE sum(DurationHours) END FROM tblStdJobOperations sjo1 WHERE sjo1.StdJobId=sjh2.StdJobId )          
 FROM tblStdJobs sjh2          
 WHERE sjh2.StdJobId IN (          
   SELECT sjh.StdJobId          
   FROM  #I_STD_JOB_HEADER isjh           
    LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
    LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
     /*VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
          (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  )          
          
-----------------          
          
 INSERT tblStdJobOperationParts          
  (Std_Job_Operation_Part_Ref,          
  PartId,          
  StdJobOperationId,          
  Quantity,          
  Probability,          
  Use_Credit_Price,          
  Full_Credit,          
  LastModByUserId,          
  LastModDate,          
  CreatedByUserId,          
  CreateDate)          
 SELECT            
  isjo.Std_Job_Operation_ID,          
  p.PartId,          
  sjo.StdJobOperationId,          
  CASE WHEN Part_Quantity IS NULL THEN 0 ELSE (CASE WHEN isjh.Job_Quantity<=2 THEN Part_Quantity ELSE Part_Quantity*isjh.Job_Quantity END) END,          
  CASE WHEN Part_Probability IS NULL OR Part_Probability<0 OR Part_Probability>100 THEN 100 ELSE Part_Probability END,          
  CASE WHEN isjp.Core_Credit='PARTIAL' OR isjp.Core_Credit='FULL' THEN 1 ELSE 0 END,          
  CASE isjp.Core_Credit WHEN 'FULL' THEN 1 ELSE 0 END,          
  0,          
  getdate(),          
  0,          
  getdate()          
 --SELECT *         
 FROM #I_STD_JOB_PARTS isjp          
  LEFT JOIN SOURCE_OF_SUPPLY sos ON sos.Sos_Code=isjp.Part_Source_Of_Supply          
  LEFT JOIN tblParts p ON p.Part=isjp.Part_Number AND p.Source_Of_Supply_ID=sos.Source_Of_Supply_ID          
  LEFT JOIN #I_STD_JOB_OPERATION isjo ON isjp.Std_Job_Operation_ID=isjo.Std_Job_Operation_ID          
  LEFT JOIN #I_STD_JOB_HEADER isjh ON isjo.Std_Job_Header_ID=isjh.Std_Job_Header_ID          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /*VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobId=sjh.StdJobId AND sjo.Std_Job_Operation_Ref=isjp.Std_Job_Operation_ID          
          
--VV 8/8/8          
DECLARE @ExchRateNewCurr float          
          
IF @NewCurrencyID>0          
BEGIN          
 SELECT @ExchRateNewCurr=ExRate FROM tblExRateCurrencies          
 WHERE CurrencyID=@NewCurrencyID AND ExRateID=0          
END          
          
 INSERT tblPartPrices          
  (PartId,          
  CurrencyId,          
  Part_Sell,          
  Part_Cost,          
  Full_Credit_Sell,          
  Full_Credit_Cost,          
  Partial_Credit_Sell,          
  Partial_Credit_Cost,          
  Price_Group_ID,          
  LastModByUserId,          
  LastModDate,          
  CreateByUserId,          
  CreateDate)          
 SELECT DISTINCT          
  p.PartId,          
  exr2.CurrencyID,          
  isjp.Part_Unit_Sell/(CASE WHEN @NewCurrencyID>0 THEN @ExchRateNewCurr ELSE exr.ExRate END)*exr2.ExRate*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  isjp.Part_Unit_Cost/(CASE WHEN @NewCurrencyID>0 THEN @ExchRateNewCurr ELSE exr.ExRate END)*exr2.ExRate*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  isjp.Full_Credit_Sell/(CASE WHEN @NewCurrencyID>0 THEN @ExchRateNewCurr ELSE exr.ExRate END)*exr2.ExRate*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  isjp.Full_Credit_Cost/(CASE WHEN @NewCurrencyID>0 THEN @ExchRateNewCurr ELSE exr.ExRate END)*exr2.ExRate*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  isjp.Partial_Credit_Sell/(CASE WHEN @NewCurrencyID>0 THEN @ExchRateNewCurr ELSE exr.ExRate END)*exr2.ExRate*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  isjp.Partial_Credit_Cost/(CASE WHEN @NewCurrencyID>0 THEN @ExchRateNewCurr ELSE exr.ExRate END)*exr2.ExRate*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  pg.Price_Group_ID,          
  0,          
  getdate(),          
  0,          
  getdate()          
 --SELECT distinct *          
 FROM #I_STD_JOB_PARTS isjp          
  LEFT JOIN SOURCE_OF_SUPPLY sos ON sos.Sos_Code=isjp.Part_Source_Of_Supply          
  LEFT JOIN tblParts p ON p.Part=isjp.Part_Number AND p.Source_Of_Supply_ID=sos.Source_Of_Supply_ID          
  LEFT JOIN #I_STD_JOB_OPERATION isjo ON isjp.Std_Job_Operation_ID=isjo.Std_Job_Operation_ID          
  LEFT JOIN #I_STD_JOB_HEADER isjh ON isjo.Std_Job_Header_ID=isjh.Std_Job_Header_ID          
          
  LEFT JOIN tblCurrencies cur ON isjh.Currency=cur.Currency          
          
  LEFT JOIN tblExRateCurrencies exr ON exr.CurrencyID=cur.CurrencyID AND exr.ExRateID=0          
          
  LEFT JOIN tblExRateCurrencies exr2 ON exr2.ExRateID=0          
  LEFT JOIN PRICE_GROUP pg ON pg.Price_Group_ID<>0          
  LEFT JOIN tblPartPrices ppr ON ppr.PartId=p.PartId AND ppr.Price_Group_ID=pg.Price_Group_ID AND ppr.CurrencyID=exr2.CurrencyID          
 WHERE ppr.PartId IS NULL          
  AND (          
   CAST(p.PartId as varchar(50))+':'+          
   CAST(isjp.Part_Unit_Sell as varchar(50))+':'+          
   CAST(isjp.Part_Unit_Cost as varchar(50))+':'+          
   CAST(isjp.Full_Credit_Sell as varchar(50))+':'+          
   CAST(isjp.Full_Credit_Cost as varchar(50))+':'+          
   CAST(isjp.Partial_Credit_Sell as varchar(50))+':'+          
   CAST(isjp.Partial_Credit_Cost as varchar(50))+':'+          
   CAST(exr.ExRate as varchar(50))          
  )=(           
   SELECT TOP 1           
   (          
    CAST(p2.PartId as varchar(50))+':'+          
    CAST(isjp2.Part_Unit_Sell as varchar(50))+':'+          
    CAST(isjp2.Part_Unit_Cost as varchar(50))+':'+          
    CAST(isjp2.Full_Credit_Sell as varchar(50))+':'+          
    CAST(isjp2.Full_Credit_Cost as varchar(50))+':'+          
    CAST(isjp2.Partial_Credit_Sell as varchar(50))+':'+          
    CAST(isjp2.Partial_Credit_Cost as varchar(50))+':'+          
    CAST(exr12.ExRate as varchar(50))          
   )          
   FROM #I_STD_JOB_PARTS isjp2           
    LEFT JOIN SOURCE_OF_SUPPLY sos2 ON sos2.Sos_Code=isjp2.Part_Source_Of_Supply          
    LEFT JOIN tblParts p2 ON p2.Part=isjp2.Part_Number AND p2.Source_Of_Supply_ID=sos2.Source_Of_Supply_ID          
    LEFT JOIN #I_STD_JOB_OPERATION isjo2 ON isjp2.Std_Job_Operation_ID=isjo2.Std_Job_Operation_ID          
    LEFT JOIN #I_STD_JOB_HEADER isjh2 ON isjo2.Std_Job_Header_ID=isjh2.Std_Job_Header_ID          
    LEFT JOIN tblCurrencies cur2 ON isjh2.Currency=cur2.Currency          
    LEFT JOIN tblExRateCurrencies exr12 ON exr12.CurrencyID=cur2.CurrencyID AND exr12.ExRateID=0          
    LEFT JOIN tblExRateCurrencies exr22 ON exr22.ExRateID=0          
    LEFT JOIN PRICE_GROUP pg2 ON pg2.Price_Group_ID<>0          
    LEFT JOIN tblPartPrices ppr2 ON ppr2.PartId=p2.PartId AND ppr2.Price_Group_ID=pg2.Price_Group_ID AND ppr2.CurrencyID=exr22.CurrencyID          
   WHERE isjp2.Part_Number=isjp.Part_Number AND isjp2.Part_Source_Of_Supply=isjp.Part_Source_Of_Supply          
  )          
 -- many operations can have the part with the same number, so take any          
          
-----------------          
          
          
 INSERT STD_JOB_OPERATION_LABOUR          
  (Std_Job_Operation_ID,          
  Labour_Activity_ID,          
  Std_Job_Operation_Labour_Desc,          
  Cost_Rate,          
  Sell_Rate,          
  Labour_Hrs,          
  Last_Mod_By_User_ID,          
  Last_Mod_Date,          
  Create_By_User_ID,          
  Create_Date)          
 SELECT          
  sjo.StdJobOperationId,          
  la.LabourActivityId,          
  isjl.Description,          
  isjl.Cost_Rate*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  isjl.Sell_Rate*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  CASE WHEN isjh.Job_Quantity<=2 THEN isjl.Hours ELSE isjl.Hours*isjh.Job_Quantity END,          
  0,          
  getdate(),          
  0,          
  getdate()          
 --SELECT *          
 FROM #I_STD_JOB_LABOUR isjl          
  LEFT JOIN tblLabourActivities la ON isjl.Labour_Activity=la.ActivityCode          
  LEFT JOIN #I_STD_JOB_OPERATION isjo ON isjl.Std_Job_Operation_ID=isjo.Std_Job_Operation_ID          
  LEFT JOIN #I_STD_JOB_HEADER isjh ON isjo.Std_Job_Header_ID=isjh.Std_Job_Header_ID          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /*VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobId=sjh.StdJobId AND sjo.Std_Job_Operation_Ref=isjl.Std_Job_Operation_ID          
          
-----------------          
          
          
 INSERT STD_JOB_OPERATION_MISC          
  (Std_Job_Operation_ID,          
  Std_Job_Operation_Misc_Desc,          
  Cost,          
  Sell,          
  Last_Mod_By_User_ID,          
  Last_Mod_Date,          
  Create_By_User_ID,          
  Create_Date)          
 SELECT          
  sjo.StdJobOperationId,          
  isjm.Description,          
  (CASE WHEN isjh.Job_Quantity<=2 THEN isjm.Cost ELSE isjm.Cost*isjh.Job_Quantity END)*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  (CASE WHEN isjh.Job_Quantity<=2 THEN isjm.Sell ELSE isjm.Sell*isjh.Job_Quantity END)*(CASE WHEN @NewCurrencyID=0 THEN 1 ELSE @NewRate END),          
  0,          
  getdate(),          
  0,          
  getdate()          
 --SELECT *          
 FROM #I_STD_JOB_MISC isjm          
  LEFT JOIN #I_STD_JOB_OPERATION isjo ON isjm.Std_Job_Operation_ID=isjo.Std_Job_Operation_ID          
  LEFT JOIN #I_STD_JOB_HEADER isjh ON isjo.Std_Job_Header_ID=isjh.Std_Job_Header_ID          
  LEFT JOIN #isLive il ON il.Live_Job=@live1 OR il.Live_Job=@live2          
  LEFT JOIN tblStdJobs sjh ON sjh.Std_Job_Ref=isjh.StdJobRef AND il.Live_Job=sjh.Live_Job           
   /*VV CR8267 AND ((sjh.Simulation_Reference=isjh.Simulation_Reference AND @NewSimulationRef='') OR          
        (sjh.Simulation_Reference=@NewSimulationRef AND @NewSimulationRef<>''))*/          
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobId=sjh.StdJobId AND sjo.Std_Job_Operation_Ref=isjm.Std_Job_Operation_ID          
          
          
-- The following SP may be not effective          
EXEC PRICED_JOBS_CREATE_P           
          
/** VV 14-Jun-2006 added LastModDate ****/          
exec PRICED_JOB_PROJ_TASK_AMTS_UPDATE_P @LastModDate=@CurrentDate          
          
          
/*VV 29-Aug-2008*/          
EXEC STD_JOB_LINK_P   
GO


