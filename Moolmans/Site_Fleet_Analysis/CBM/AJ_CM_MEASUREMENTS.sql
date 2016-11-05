
/****** Object:  StoredProcedure [dbo].[AJ_CM_MEASUREMENT_GET_P]    Script Date: 02/10/2013 17:53:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AJ_CM_MEASUREMENT_GET_P]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AJ_CM_MEASUREMENT_GET_P]
GO

/****** Object:  StoredProcedure [dbo].[AJ_CM_MEASUREMENT_GET_P]    Script Date: 02/10/2013 17:53:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[AJ_CM_MEASUREMENT_GET_P]    
/******************************************************************************    
 File:     
 Name: CM_MEASUREMENT_GET_P    
    
 Called By:     
    
 Desc:     
    
 Auth:  Sergey Ivanov    
 Date:  09 Oct 2007    
*******************************************************************************    
  Change History    
*******************************************************************************    
Date:  Author:  Description:    
-------- -------- ----------------------------------------    
12/03/08 AL   Added @CMMeasurementId    
02/07/09 AL   CR9298: Added @IsTranslationOnly and revamped SP    
03/07/09 AL   CR9298: moved filtering level of @IsTranslationOnly    
11-10-10 V Vasylyeva E311: inclusive filtering  
*******************************************************************************/    
 /* Param List */    
    
@Branch varchar(MAX) = '',    
@Site varchar(MAX) = '',    
@Fleet varchar(MAX) = '',    
@Model varchar(MAX) = '',    
@Equipment varchar(MAX) = '',    
@Compartment varchar(MAX) = '',    
@MeasurementType varchar(MAX) = '',    
@ElementType varchar(MAX) = '',    
@Source varchar(MAX) = '',    
@EndDate DATETIME = '2200-01-01',    
@IsIncludeIgnored BIT = 1,    
@IsIncludeNoReading BIT = 1,    
@isGetAnyway int = 1,    
@CMMeasurementId int = NULL,    
@IsTranslationOnly BIT = 1    
     
AS    
    
SET @Branch = REPLACE(ISNULL(@Branch,''),'''','')    
SET @Site = REPLACE(ISNULL(@Site,''),'''','')    
SET @Fleet = REPLACE(ISNULL(@Fleet,''),'''','')    
SET @Model = REPLACE(ISNULL(@Model,''),'''','')    
SET @Equipment = REPLACE(ISNULL(@Equipment,''),'''','')    
SET @Compartment =','+REPLACE(ISNULL(@Compartment,''),'''','')+','    
SET @MeasurementType =','+REPLACE(ISNULL(@MeasurementType,''),'''','')+','    
SET @ElementType =','+REPLACE(ISNULL(@ElementType,''),'''','')+','    
SET @Source = REPLACE(ISNULL(@Source,''),'''','')    
  
/*E311*/   
DECLARE @EqpPlan xml  
  
CREATE TABLE #z_EqpPlan(EqpPlanId int PRIMARY KEY(EqpPlanId))  
INSERT INTO #z_EqpPlan(EqpPlanId)  
SELECT EqpPlanId FROM EQUIPMENT_HIERARCHY_V EH  
WHERE   
EH.Projection_type_ID=1    
AND (EH.BranchID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Branch)) OR ISNULL(@Branch,'')='')    
AND (EH.SiteID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Site)) OR ISNULL(@Site,'')='')    
AND (EH.FleetID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Fleet)) OR ISNULL(@Fleet,'')='')    
AND (EH.ModelID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Model)) OR ISNULL(@Model,'')='')    
AND (EH.EqpPlanID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Equipment)) OR ISNULL(@Equipment,'')='')  
  
SET @EqpPlan=(SELECT EqpPlanId AS List_Item FROM #z_EqpPlan FOR XML RAW('Row'),ROOT('Rows'),ELEMENTS)  
  
  
/*VV E311  
SELECT A.EqpPlanId,A.EqpPlan,A.SerialNumber,A.Model,A.ModelID,A.CMCodeId,A.CMCompartment,A.MeasurementTypeDesc,A.Element,A.EqpProjId    
INTO #ELEMENTS    
FROM    
 (SELECT EH.EqpPlanId,EH.EqpPlan,    
   EH.SerialNumber,EH.EqpProjID,    
   EH.Model,EH.ModelID,    
   CC.CMCodeId,    
   CC.CMCompartment,    
   CC.MeasurementTypeDesc,    
   CC.CMElementDesc + ' (' + CC.CMElementUOM + ')' AS Element    
 FROM             
   EQUIPMENT_HIERARCHY_V EH CROSS JOIN    
   CM_CODE CC     
 WHERE    
   EH.Projection_type_ID=1    
   AND (EH.BranchID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Branch)) OR ISNULL(@Branch,'')='')    
   AND (EH.SiteID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Site)) OR ISNULL(@Site,'')='')    
   AND (EH.FleetID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Fleet)) OR ISNULL(@Fleet,'')='')    
   AND (EH.ModelID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Model)) OR ISNULL(@Model,'')='')    
   AND (EH.EqpPlanID IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Equipment)) OR ISNULL(@Equipment,'')='')    
    
   AND (@Compartment=',,' OR CHARINDEX(','+CC.CMCompartment+',', @Compartment) > 0)    
   AND (@MeasurementType=',,' OR CHARINDEX(','+CC.MeasurementTypeCode+',', @MeasurementType) > 0)    
   AND (@ElementType=',,' OR CHARINDEX(','+CC.CMElementCode+',', @ElementType) > 0)    
 )A LEFT OUTER JOIN    
 CM_TRANSLATION CT ON     
  A.CMCodeId=CT.CMCodeId    
  AND A.ModelId=CT.ModelId    
WHERE    
 (CT.SystemSourceId IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Source)) OR ISNULL(@Source,'')='')    
GROUP BY    
 A.EqpPlanId,A.EqpPlan,A.SerialNumber,A.Model,A.ModelID,A.CMCodeId,A.CMCompartment,A.MeasurementTypeDesc,A.Element,A.EqpProjId    
HAVING    
 (COUNT(CT.CMTranslationId)>0 OR @IsTranslationOnly=0)  */  
   
CREATE TABLE #z_CM_CODE(CMCodeId int PRIMARY KEY(CMCodeId))  
  
INSERT INTO #z_CM_CODE(CMCodeId)  
SELECT CMCodeId FROM CM_CODE WHERE    
(@Compartment=',,' OR CMCompartment IN (SELECT list_item FROM dbo.LIST_TO_TABLE_2_F(@Compartment)))   
AND (@MeasurementType=',,' OR MeasurementTypeCode IN (SELECT list_item FROM dbo.LIST_TO_TABLE_2_F(@MeasurementType)))  
AND (@ElementType=',,' OR CMElementCode IN (SELECT list_item FROM dbo.LIST_TO_TABLE_2_F(@ElementType)))  
  
  
SELECT EH.EqpPlanId,EH.EqpPlan,EH.SerialNumber,EH.Model,EH.ModelID,CC.CMCodeId,  
CC.CMCompartment,CC.MeasurementTypeDesc,CC.CMElementDesc + ' (' + CC.CMElementUOM + ')' AS Element,  
EH.EqpProjId    
INTO #ELEMENTS    
 FROM   
(SELECT E.EqpPlanId,C.CMCodeId FROM #z_EqpPlan E CROSS JOIN  #z_CM_CODE C) A  
 INNER JOIN  
EQUIPMENT_HIERARCHY_V EH  
 ON A.EqpPlanId=EH.EqpPlanId AND EH.Projection_Type_ID=1  
 INNER JOIN  
CM_CODE CC     
 ON A.CMCodeId=CC.CMCodeId  
 LEFT JOIN  
(SELECT E.EqpPlanId, CC.CMCodeId FROM  
#z_CM_CODE CC  
 INNER JOIN  
CM_TRANSLATION T   
 ON CC.CMCodeId=T.CMCodeId  
 INNER JOIN  
dbo.EQP_CM_TRANSLATION_CODES_F(@EqpPlan) E  
 ON ISNULL(T.ModelId,E.ModelId)=E.ModelId  
 AND ISNULL(T.ModelFamilyId,E.ModelFamilyId)=E.ModelFamilyId  
 AND ISNULL(T.EqpClassId,E.EqpClassId)=E.EqpClassId  
 AND ISNULL(T.FleetId,E.FleetId)=E.FleetId  
 AND ISNULL(T.SiteId,E.SiteId)=E.SiteId  
 AND ISNULL(ISNULL(T.PartId,E.PartId),0)=ISNULL(E.PartId,0)  
 AND ISNULL(ISNULL(T.PartRatingId,E.PartRatingId),0)=ISNULL(E.PartRatingId,0)  
 AND ISNULL(T.ManufacturerId,E.ManufacturerId)=E.ManufacturerId  
 AND ISNULL(ISNULL(T.ComponentCodeId,E.ComponentCodeId),0)=ISNULL(E.ComponentCodeId,0)  
WHERE   
(ISNULL(@Source,'')='' OR T.SystemSourceId IS NULL OR T.SystemSourceId IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Source)))  
GROUP BY E.EqpPlanId, CC.CMCodeId) B  
 ON A.EqpPlanId=B.EqpPlanId  
 AND A.CMCodeId=B.CMCodeId  
WHERE @IsTranslationOnly=0 OR B.CMCodeId>0  
  
DROP TABLE #z_CM_CODE,#z_EqpPlan  
    
    
DECLARE @MaxRecords int,@MaxRecordsWarning int,@Count int    
SELECT TOP 1 @MaxRecords=Max_Records,@MaxRecordsWarning=Max_Records_Warning FROM AMT_VARIABLE    
SET @MaxRecords=ISNULL(@MaxRecords,20000)    
SET @MaxRecordsWarning=ISNULL(@MaxRecordsWarning,2000)    
    
IF ISNULL(@isGetAnyway,0)=0 AND (@MaxRecords>0 OR @MaxRecordsWarning>0)    
BEGIN    
 SELECT  @Count=COUNT(*)    
 FROM             
 #ELEMENTS E   
  OUTER APPLY     
   (SELECT TOP 10 CMT.*  
    FROM     
 CM_MEASUREMENT CMT   
 /*VV E311  
  INNER JOIN    
 EQUIPMENT_HIERARCHY_V EHT   
  ON CMT.EqpPlanId=EHT.EqpPlanId   
    
  INNER JOIN    
 SYSTEM_SOURCE SS ON   
  CMT.SystemSourceId=SS.System_Source_ID   
  LEFT JOIN    
 CM_TRANSLATION CTT   
 ON CMT.CMCodeId=CTT.CMCodeId    
 AND EHT.ModelId=CTT.ModelId    
 AND CMT.SystemSourceId=CTT.SystemSourceId   
  LEFT JOIN    
 TASK T   
  ON CMT.TaskID=T.Task_ID   
  LEFT JOIN    
 tblWorkorders W   
  ON T.Work_Order_ID=W.WorkorderID */  
   WHERE    
     CMT.MeasurementTime <= @EndDate    
     /*VV E311 AND EHT.EqpProjId = E.EqpProjId */   
     AND CMT.EqpPlanId=E.EqpPlanId  
     AND CMT.CMCodeId = E.CMCodeId    
     AND (CMT.SystemSourceId IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Source)) OR ISNULL(@Source,'')='')    
     AND (CMT.IsIgnore = 0 OR @IsIncludeIgnored = 1)    
   ORDER BY CMT.MeasurementTime DESC    
   ) CM    
 WHERE    
   (CM.CMMeasurementId IS NOT NULL OR @IsIncludeNoReading=1)    
   AND (@CMMeasurementId IS NULL OR CM.CMMeasurementId=@CMMeasurementId) --AL: 12/03/08    
    
 IF ISNULL(@Count,0)>@MaxRecords AND @MaxRecords>0    
 BEGIN    
  SELECT @MaxRecords AS MaxRecords    
  DROP TABLE #ELEMENTS    
  RETURN    
 END    
 ELSE IF ISNULL(@Count,0)>@MaxRecordsWarning AND @MaxRecordsWarning>0    
 BEGIN    
  SELECT ISNULL(@Count,0) AS Warning    
  DROP TABLE #ELEMENTS    
  RETURN    
 END    
END   
  
/*VV E311*/   
SELECT  CM.CMMeasurementId,    
  E.EqpPlanId,    
  E.EqpPlan,    
  E.SerialNumber,    
  E.Model,    
  E.CMCodeId,    
  E.CMCompartment,    
  E.MeasurementTypeDesc,    
  E.Element,    
  CM.MeasurementTime,    
  CM.EquipmentUsage,    
  CM.QUOM,    
  CM.HoursOnOil,    
  CM.Reading,    
  CM.Rating,    
  CM.CMRatingId,    
  CM.ExtComments,    
  CM.Recommendations,    
  CM.IsIgnore,    
  CM.Comments,    
  CM.System_Source_Code,    
  CM.LastModDate,    
  CM.WorkorderNumber    
  INTO zzAJ_MEASUREMENTS
FROM             
#ELEMENTS E   
 OUTER APPLY     
(SELECT TOP 10 CMT.*,SS.System_Source_Code,W.WorkorderNumber    
FROM     
CM_MEASUREMENT CMT   
 LEFT JOIN    
SYSTEM_SOURCE SS   
 ON CMT.SystemSourceId=SS.System_Source_ID   
 LEFT JOIN    
TASK T   
 ON CMT.TaskID=T.Task_ID   
 LEFT JOIN    
tblWorkorders W   
 ON T.Work_Order_ID=W.WorkorderID    
WHERE    
CMT.MeasurementTime <= @EndDate    
AND CMT.EqpPlanId = E.EqpPlanId    
AND CMT.CMCodeId = E.CMCodeId    
AND (CMT.SystemSourceId IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@Source)) OR ISNULL(@Source,'')='')    
AND (CMT.IsIgnore = 0 OR @IsIncludeIgnored = 1)    
ORDER BY CMT.MeasurementTime DESC    
) CM    
WHERE    
(CM.CMMeasurementId IS NOT NULL OR @IsIncludeNoReading=1)    
AND (@CMMeasurementId IS NULL OR CM.CMMeasurementId=@CMMeasurementId) --AL: 12/03/08    
ORDER BY E.EqpPlan, E.EqpPlanId, E.CMCompartment, E.MeasurementTypeDesc,    
E.Element, E.CMCodeId, CM.MeasurementTime DESC    
    
DROP TABLE #ELEMENTS    
  
GO


