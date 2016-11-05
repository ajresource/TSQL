
IF EXISTS (select * from sys.tables where name='zzAJ_MEASUREMENTS')
BEGIN DROP TABLE zzAJ_MEASUREMENTS
END


exec AJ_CM_MEASUREMENT_GET_P @Branch='',@Site='',@Fleet='',@Model='',@Equipment='',@Compartment='',@MeasurementType='',@ElementType='',@Source='',
@EndDate='2013-02-13 06:05:00',@IsIncludeIgnored=0,@IsIncludeNoReading=0,@IsTranslationOnly=1,@isGetAnyway=0

select 
ZZ.Model,ZZ.SerialNumber,zz.MeasurementTime,ZZ.EquipmentUsage,ZZ.QUOM AS EquipmentUsageUOM,ZZ.HoursOnOil,ZZ.System_Source_Code AS SystemSource,CM.MeasurementTypeCode,
CM.CMElementCode,ZZ.Reading,Rating,ZZ.ExtComments AS Comments,NULL AS Recommendations,ZZ.CMCompartment AS Compartment
 from zzAJ_MEASUREMENTS ZZ
INNER JOIN CM_CODE CM ON ZZ.CMCodeID=CM.CMCodeId

