
/****** Object:  StoredProcedure [dbo].[AJ_KIRD_EXPORT_P]    Script Date: 01/31/2013 22:28:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AJ_KIRD_EXPORT_P]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AJ_KIRD_EXPORT_P]
GO



/****** Object:  StoredProcedure [dbo].[AJ_KIRD_EXPORT_P]    Script Date: 01/31/2013 22:28:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AJ_KIRD_EXPORT_P]    



     
--FOR XML AUTO, ELEMENTS
/******************************************************************************    
     
 Name: AJ_KIRD_EXPORT_P    
    
 Called By:     
    
 Desc: Modified script from current Export routine for database consolidation purposes.    
    
 Auth:  AJ    
 Date:  21 Jan 2013   
*******************************************************************************    
  Change History    
*******************************************************************************    
Date:  Author:  Description:    
-
*******************************************************************************/    
 /* Param List */    
@mode int=0, -- 0-export, 1-generate tables for UI, 2-export from Projections    
@isCodeMap bit=0,    
--FILTERS !!!    
@Branch varchar(50)='',    
@Price_Group varchar(50)='',    
@Model varchar(20)='',    
@ComponentCode varchar(10)='',    
@JobCode varchar(10)='',    
@Currency varchar(3)='',    
@SimulationRef varchar(175)='', -- CAN BE EMPTY    
@isLive int=0, -- 0-fixed, 1-Live, CONNOT BE Both(2)!!!    
@System_Source varchar(10)='',    
@isDummy int=2, -- 0-NoDummy, 1-Dummy, 2-All    
-- #4699    
--@JobIDs varchar(Max)='', -- IDs of jobs to import ('01','03','12')    
-- New Values    
@NewSimulationRef varchar(175)='',    
@NRecords int = 0 OUTPUT    
    
AS    
/*    
DECLARE @ComponentCode varchar(10)    
SET @ComponentCode='';    
IF @ComponentCodeId>=0    
 SELECT @ComponentCode=Code FROM tblComponentCodes WHERE ComponentCodeID=@ComponentCodeId    
*/    

IF EXISTS (select * from sys.tables where name='I_STD_JOB_HEADER')
BEGIN DROP TABLE I_STD_JOB_HEADER
END

IF EXISTS (select * from sys.tables where name='I_STD_JOB_OPERATION')
BEGIN DROP TABLE I_STD_JOB_OPERATION
END

IF EXISTS (select * from sys.tables where name='I_STD_JOB_PARTS')
BEGIN DROP TABLE I_STD_JOB_PARTS
END

IF EXISTS (select * from sys.tables where name='I_STD_JOB_LABOUR')
BEGIN DROP TABLE I_STD_JOB_LABOUR
END

IF EXISTS (select * from sys.tables where name='I_STD_JOB_MISC')
BEGIN DROP TABLE I_STD_JOB_MISC
END
 
  
DECLARE @UseStdJobPartsMargin int  
  
SELECT @UseStdJobPartsMargin=UseStdJobPartsMargin FROM AMT_VARIABLE   
  
CREATE TABLE #I_STD_JOB_HEADER (    
 StdJobId int NOT NULL,    
 Std_Job_Header_ID varchar (500) COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Std_Job_Header_ID)) <> ''), --PRIMARY KEY CLUSTERED,    
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
 --GD 25-Mar-2011 Changed application code to 100 char    
 --Application_Code varchar (50) COLLATE database_default NULL ,    
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
 Labour_Activity varchar (50) COLLATE database_default NULL    
)    
CREATE TABLE #I_STD_JOB_OPERATION (    
 --StdJobOperationId int NOT NULL,    
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
 Part_Source_Of_Supply varchar (50)/*VV #4604 (10)*/ COLLATE database_default NOT NULL CHECK (LTRIM(RTRIM(Part_Source_Of_Supply)) <> ''),    
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
    
---------------------------------------------------------------    
-- getting default values    
DECLARE @gccDefcc varchar(10)    
SELECT TOP 1 @gccDefcc=Global_Component_Code FROM GLOBAL_COMPONENT_CODES WHERE Default_Record<>0    
    
DECLARE @DefJobCode varchar(10)    
DECLARE @DefGlobalJobCode varchar(10)    
SELECT     TOP 1 @DefGlobalJobCode = GLOBAL_JOB_CODES.Global_Job_Code, @DefJobCode =  tblJobCodes.Code    
FROM         tblJobCodes INNER JOIN    
                      GLOBAL_JOB_CODES ON tblJobCodes.Global_Job_Code_Id = GLOBAL_JOB_CODES.Global_Job_Id    
WHERE     (tblJobCodes.Default_Record = 1)    
    
----------------------------------------------------------------    
    
 INSERT #I_STD_JOB_HEADER    
 SELECT     
  sjh.StdJobId,    
  sjh.Std_Job_Ref as Std_Job_Header_ID,    
  sjh.StdJob as Std_Job_Description,    
  mod.Model,    
  sjh.Serial_No_Prefix,    
  sjh.Serial_No_Start,    
  sjh.Serial_No_End,    
  sjh.Live_Job,    
  sjh.Dummy_Job,    
  ss.System_Source_Code as System_Source,    
  CASE WHEN @isCodeMap=0 THEN cc.Code ELSE (CASE WHEN gcc.Global_Component_Code IS NULL THEN @gccDefcc ELSE gcc.Global_Component_Code END) END as Component_Code,    
  mc.Code as Modifier_Code,    
  CASE WHEN @isCodeMap=0 THEN ISNULL(jc.Code,@DefJobCode) ELSE ISNULL(gjc.Global_Job_Code,@DefGlobalJobCode) END as Job_Code,    
  tt.Code as Task_Type,    
  ot.OccurrenceType as Occurrence_Type,    
  sjh.Option_Pobability,    
  sjh.Job_Default_Option,    
  ac.Code as Application_Code,    
  wa.Work_Application_Code as Work_Application,    
  jcon.Job_Condition_Code as Job_Condition,    
  ct.Cab_Type_Code as Cab_Type,    
  jl.Job_Location_Code as Job_Location,    
  br.Branch as Pricing_Branch,    
  pg.Price_Group,    
  cur.Currency,    
  sjh.Overwrite_Costs,    
  sjh.Job_Quantity,    
  sjh.Parts_Usage_Factor,    
  /*E1030*/  
  CASE WHEN @UseStdJobPartsMargin=2 THEN sjh.Parts_Cost ELSE pj.PartsCost END as Parts_Cost,    
  CASE WHEN @UseStdJobPartsMargin=2 THEN sjh.labour_Cost ELSE pj.LabourCost  END Labour_Cost,    
  CASE WHEN @UseStdJobPartsMargin=2 THEN sjh.Misc_Cost ELSE pj.MiscCost  END Misc_Cost,    
  pj.LabourHours as Labour_Hrs,    
  sjh.Simulation_Reference,    
  sjh.Simulation_Description,    
  sjh.Group_No,    
  sjh.Use_Rotable,    
  man.Manufacturer, --sjh.Supplier,    
  CASE WHEN sjh.Use_Rotable=1 THEN rp.Part_Number ELSE p.Part END as Rotable_Part_Number,    
  sjh.Default_First,    
  sjh.Default_Interval,    
  CASE WHEN sjh.QUOM_ID IS NULL THEN 'Days' ELSE quom.Short_Desc END as Unit_Of_Measure,    
  dl.Dealer as Company,    
  br.Branch,    
  sjh.Site,    
  sjh.Fleet,    
  sjh.Equipment,    
  sjh.Serial_Number,    
  CASE WHEN prtp.Projection_Type_Name IS NULL THEN '' ELSE prtp.Projection_Type_Name END,    
  sjh.Planning_Task,    
  sjh.Lead_Days,    
  sjh.Not_After,    
  sjh.Last_Change_Date,    
  sjh.Last_Change_Usage,    
  sjh.Use_Std_Job,    
  sjh.Pricing_Date,    
  CASE WHEN @isCodeMap=0 THEN pt.PartType ELSE gpt.Global_Part_Type END as Part_Type,    
  la.ActivityCode as Labour_Activity    
 FROM tblStdJobs sjh
  INNER JOIN AJ_STD_JOB_LIST AJ ON AJ.Std_Job_Ref= sjh.Std_Job_Ref    
  LEFT JOIN tblModels mod ON sjh.ModelId=mod.ModelId    
  LEFT JOIN tblCurrencies cur ON sjh.Currency_ID=cur.CurrencyID    
  LEFT JOIN tblQUOMs quom ON sjh.QUOM_ID=quom.QUOMId    
  LEFT JOIN SYSTEM_SOURCE ss ON sjh.System_Source_ID=ss.System_Source_ID    
  LEFT JOIN tblComponentCodes cc ON sjh.ComponentCodeId=cc.ComponentCodeID    
  LEFT JOIN GLOBAL_COMPONENT_CODE_LINK gccl ON gccl.AMT_Component_Code_Id=cc.ComponentCodeID    
  LEFT JOIN GLOBAL_COMPONENT_CODES gcc ON gccl.Global_Component_Code_Id=gcc.Global_ID    
  LEFT JOIN tblModifierCodes mc ON sjh.ModifierCodeId=mc.ModifierID    
  LEFT JOIN tblJobCodes jc ON sjh.JobCodeId=jc.JobCodeID    
  LEFT JOIN GLOBAL_JOB_CODES gjc ON jc.Global_Job_Code_Id=gjc.Global_Job_Id    
  LEFT JOIN tblTaskTypes tt ON sjh.TaskTypeId=tt.TaskTypeID    
  LEFT JOIN tblApplicationCodes ac ON sjh.ApplicationCodeID=ac.ApplicationCodeID    
  LEFT JOIN tblOccurrenceTypes ot ON sjh.Occurrence_Type_Id=ot.OccurrenceTypeId    
  LEFT JOIN JOB_LOCATION jl ON sjh.Job_Location_ID=jl.Job_Location_ID    
  LEFT JOIN WORK_APPLICATION wa ON sjh.Work_Application_ID=wa.Work_Application_ID    
  LEFT JOIN JOB_CONDITION jcon ON sjh.Job_Condition_ID=jcon.Job_Condition_ID    
  LEFT JOIN CAB_TYPE ct ON sjh.Cab_Type_ID=ct.Cab_Type_ID    
  LEFT JOIN PROJECTION_TYPE prtp ON prtp.Projection_Type_ID=sjh.Projection_Type    
  LEFT JOIN tblPartTypes pt ON sjh.Part_Type_ID=pt.PartTypeId    
  LEFT JOIN GLOBAL_PART_TYPES gpt ON pt.Global_Part_Type_Id=gpt.Global_Part_Type_Id    
  LEFT JOIN tblLabourActivities la ON sjh.Labour_Activity_ID=la.LabourActivityId    
  LEFT JOIN tblManufacturers man ON sjh.Manufacturer_Id=man.ManufacturerId    
  LEFT JOIN ROTABLE_PART rp ON sjh.Rotable_Part_Id=rp.Rotable_Part_Id    
  LEFT JOIN tblParts p ON sjh.Rotable_Part_Id=p.PartId    
  LEFT JOIN tblPricedJobs pj ON pj.StdJobId=sjh.StdJobId    
  LEFT JOIN PRICE_GROUP pg ON pg.Price_Group_ID=pj.Price_Group_ID    
  LEFT JOIN tblBranches br ON br.BranchId=pj.BranchId    
  LEFT JOIN tblDealers dl ON dl.DealerId=br.DealerId    
    
DELETE #I_STD_JOB_HEADER    
 WHERE    
  -- Filters    
      (Branch<>@Branch AND ISNULL(@Branch,'')<>'')    
  OR (Price_Group<>@Price_Group AND ISNULL(@Price_Group,'')<>'')    
  OR (Model<>@Model AND ISNULL(@Model,'')<>'')    
  OR (Component_Code<>@ComponentCode AND ISNULL(@ComponentCode,'')<>'')    
  OR (Job_Code<>@JobCode AND ISNULL(@JobCode,'')<>'')    
  OR (Currency<>@Currency AND ISNULL(@Currency,'')<>'')    
  OR (Simulation_Reference<>@SimulationRef AND ISNULL(@SimulationRef,'')<>'')    
  OR (Live_Job<>@isLive)    
  OR (System_Source<>@System_Source AND ISNULL(@System_Source,'')<>'')    
  OR (NOT (Dummy_Job=0 AND @isDummy=0) AND NOT (Dummy_Job=1 AND @isDummy=1) AND NOT @isDummy=2)    
    
--SELECT * FROM #I_STD_JOB_HEADER    
--return    
    
-- generate tables for UI    
IF @mode=1    
BEGIN    
 SELECT Std_Job_Header_ID, Branch, Price_Group, Std_Job_Description, Model, Component_Code,     
  Modifier_Code, Job_Code, Labour_Hrs, Parts_Cost+Labour_Cost+Misc_Cost as Total_Cost, Currency, System_Source    
 FROM #I_STD_JOB_HEADER isjh    
 ORDER BY 2,3,5,6,7,8    
    
 RETURN    
END    
--#3738    
--IF (@mode<>1) AND (@JobIDs IS NOT NULL) AND (@JobIDs NOT LIKE '')    
 --EXEC ('DELETE #I_STD_JOB_HEADER WHERE Std_Job_Header_ID NOT IN ('+@JobIDs+')')    
 --DELETE H FROM #I_STD_JOB_HEADER H LEFT JOIN [LIST_TO_TABLE_3_F](SUBSTRING(@JobIDs, 2, DATALENGTH(@JobIDs)-2), ''',''') L     
 --ON H.Std_Job_Header_ID = L.list_item    
 --WHERE L.List_item is Null    
     
    
SELECT @NRecords=count(*) FROM #I_STD_JOB_HEADER    
    
IF (ISNULL(@Branch,'')='')    
BEGIN    
 RAISERROR ('You must specify a filter for Branch', 16, 1)      
 RETURN    
END    
IF (ISNULL(@Price_Group,'')='')    
BEGIN    
 RAISERROR ('You must specify a filter for Price Group', 16, 1)      
 RETURN    
END    
--IF (ISNULL(@SimulationRef,'')='')    
--BEGIN    
-- RAISERROR ('You must specify a filter for Simulation Reference', 16, 1)      
-- RETURN    
--END    
IF (@isLive<0 OR @isLive>1)    
BEGIN    
 RAISERROR ('You can choose only Fixed or Live status (not both)', 16, 1)    
 RETURN    
END    
    
IF ISNULL(@NewSimulationRef,'')<>''    
 UPDATE #I_STD_JOB_HEADER    
 SET Simulation_Reference=@NewSimulationRef    
    
INSERT #I_STD_JOB_OPERATION    
SELECT    
 --sjo.Std_Job_Operation_Ref as Std_Job_Operation_ID,    
 sjo.StdJobOperationId as Std_Job_Operation_ID,    
 isjh.Std_Job_Header_ID as Std_Job_Header_ID,    
 sjo.StdJobOperation as Name,    
 CASE WHEN @isCodeMap=0 THEN cc.Code ELSE gcc.Global_Component_Code END as Component_Code,    
 CASE WHEN @isCodeMap=0 THEN jc.Code ELSE gjc.Global_Job_Code END as Job_Code,    
 sjo.DurationHours,    
 sjo.Group_No    
FROM tblStdJobOperations sjo    
  LEFT JOIN #I_STD_JOB_HEADER isjh ON isjh.StdJobId=sjo.StdJobId    
  LEFT JOIN tblComponentCodes cc ON sjo.ComponentCodeId=cc.ComponentCodeID    
  LEFT JOIN GLOBAL_COMPONENT_CODE_LINK gccl ON gccl.AMT_Component_Code_Id=cc.ComponentCodeID    
  LEFT JOIN GLOBAL_COMPONENT_CODES gcc ON gccl.Global_Component_Code_Id=gcc.Global_ID    
  LEFT JOIN tblModifierCodes mc ON sjo.ModifierCodeId=mc.ModifierID    
  LEFT JOIN tblJobCodes jc ON sjo.JobCodeId=jc.JobCodeID    
  LEFT JOIN GLOBAL_JOB_CODES gjc ON jc.Global_Job_Code_Id=gjc.Global_Job_Id    
  LEFT JOIN tblApplicationCodes ac ON sjo.ApplicationCodeID=ac.ApplicationCodeID    
WHERE isjh.Std_Job_Header_ID IS NOT NULL    
    
INSERT #I_STD_JOB_PARTS    
SELECT     
 --sjo.Std_Job_Operation_Ref as Std_Job_Operation_ID,    
 sjo.StdJobOperationId as Std_Job_Operation_ID,    
 p.Part as Part_Number,    
 sos.Sos_Code as Part_Source_Of_Supply,    
 p.PartDescription as Part_Description,    
 pt.PartType as Part_Type,    
 pp.Part_Cost as Part_Unit_Cost,    
 pp.Part_Sell as Part_Unit_Sell,    
 sjop.Quantity as Part_Quantity,    
 sjop.Probability as Part_Probability,    
 CASE WHEN Use_Credit_Price=0 THEN 'NONE' WHEN Use_Credit_Price=1 AND Full_Credit=0 THEN 'PARTIAL' ELSE 'FULL' END as Core_Credit,    
 pp.Full_Credit_Cost,    
 pp.Full_Credit_Sell,    
 pp.Partial_Credit_Cost,    
 pp.Partial_Credit_Sell    
FROM tblStdJobOperationParts sjop    
  LEFT JOIN tblParts p ON p.PartId=sjop.PartId    
  LEFT JOIN tblPartTypes pt ON pt.PartTypeId=p.Part_Type_ID    
  LEFT JOIN SOURCE_OF_SUPPLY sos ON sos.Source_Of_Supply_ID=p.Source_Of_Supply_ID    
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobOperationId=sjop.StdJobOperationId    
  LEFT JOIN #I_STD_JOB_HEADER isjh ON isjh.StdJobId=sjo.StdJobId    
  LEFT JOIN PRICE_GROUP pg ON pg.Price_Group=isjh.Price_Group    
  LEFT JOIN tblCurrencies cur ON cur.Currency=isjh.Currency    
  LEFT JOIN tblPartPrices pp ON pp.PartId=p.PartId AND pp.CurrencyId=cur.CurrencyID AND pp.Price_Group_ID=pg.Price_Group_ID    
WHERE isjh.Std_Job_Header_ID IS NOT NULL    
    
INSERT #I_STD_JOB_LABOUR    
SELECT     
 --sjo.Std_Job_Operation_Ref as Std_Job_Operation_ID,    
 sjo.StdJobOperationId as Std_Job_Operation_ID,    
 la.ActivityCode as Labour_Activity,    
 sjol.Std_Job_Operation_Labour_Desc as Description,    
 sjol.Cost_Rate,    
 sjol.Sell_Rate,    
 sjol.Labour_Hrs as Hours    
FROM STD_JOB_OPERATION_LABOUR sjol    
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobOperationId=sjol.Std_Job_Operation_ID    
  LEFT JOIN #I_STD_JOB_HEADER isjh ON isjh.StdJobId=sjo.StdJobId    
  LEFT JOIN tblLabourActivities la ON sjol.Labour_Activity_ID=la.LabourActivityId    
WHERE isjh.Std_Job_Header_ID IS NOT NULL    
    
INSERT #I_STD_JOB_MISC    
SELECT     
 --sjo.Std_Job_Operation_Ref as Std_Job_Operation_ID,    
 sjo.StdJobOperationId as Std_Job_Operation_ID,    
 sjom.Std_Job_Operation_Misc_Desc as Description,    
 sjom.Cost,    
 sjom.Sell    
FROM STD_JOB_OPERATION_MISC sjom    
  LEFT JOIN tblStdJobOperations sjo ON sjo.StdJobOperationId=sjom.Std_Job_Operation_ID    
  LEFT JOIN #I_STD_JOB_HEADER isjh ON isjh.StdJobId=sjo.StdJobId    
WHERE isjh.Std_Job_Header_ID IS NOT NULL    
    
-- Parse to XML 

SELECT  Std_Job_Header_ID, Std_Job_Description, Model, Serial_No_Prefix, Serial_No_Start, Serial_No_End, Live_Job,    
  Dummy_Job, System_Source, Component_Code, Modifier_Code, Job_Code, Task_Type, Occurrence_Type,    
  Option_Pobability, Job_Default_Option, Application_Code, Work_Application, Job_Condition, Cab_Type,    
  Job_Location, Pricing_Branch, Price_Group, Currency, Overwrite_Costs, Job_Quantity, Parts_Usage_Factor,    
  Parts_Cost, Labour_Cost, Misc_Cost, Labour_Hrs, Simulation_Reference, Simulation_Description,    
  Group_No, Use_Rotable, Supplier, Rotable_Part_Number, Default_First, Default_Interval, Unit_Of_Measure,    
  Company, Branch, Site, Fleet, Equipment, Serial_Number, Projection_Type, Planning_Task, Lead_Time_Days,    
  Not_After, Last_Change_Date, Last_Change_Usage, Use_Std_Job, Pricing_Date, Part_Type, Labour_Activity 
  INTO   I_STD_JOB_HEADER
FROM #I_STD_JOB_HEADER     
--FOR XML AUTO, ELEMENTS   
SELECT * 
INTO I_STD_JOB_OPERATION
FROM #I_STD_JOB_OPERATION     
--FOR XML AUTO, ELEMENTS   
SELECT * 
INTO I_STD_JOB_PARTS
FROM #I_STD_JOB_PARTS  
--FOR XML AUTO, ELEMENTS
SELECT * 
INTO I_STD_JOB_LABOUR
FROM #I_STD_JOB_LABOUR     
--FOR XML AUTO, ELEMENTS
SELECT * 
INTO I_STD_JOB_MISC
FROM #I_STD_JOB_MISC     
--FOR XML AUTO, ELEMENTS

GO


