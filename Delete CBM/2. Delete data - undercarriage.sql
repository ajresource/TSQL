
-- Create Backup tables

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AA_CM_TRANSLATION_BACKUP]') AND type in (N'U'))
DROP TABLE [dbo].[AA_CM_TRANSLATION_BACKUP]
GO


select T.CMTranslationId,T.EqpClassId,T.FleetId,
T.ManufacturerId,T.ModelFamilyId,T.ModelId,T.PartId,T.PartRatingId,
T.SiteId,T.SystemSourceId,C.* 
into AA_CM_TRANSLATION_BACKUP
from CM_CODE C
inner join CM_TRANSLATION T ON C.CMCodeId=T.CMCodeId 
where C.CMCompartment='Undercarriage'

--Delete data

declare @CMTranslationId INT

DECLARE theCursor3 CURSOR FOR	

select T.CMTranslationId
from CM_CODE C
inner join CM_TRANSLATION T ON C.CMCodeId=T.CMCodeId 
where C.CMCompartment='Undercarriage'

OPEN theCursor3
FETCH NEXT FROM theCursor3 INTO @CMTranslationId 
WHILE @@fetch_status = 0
BEGIN 
--select @CMTranslationId
exec CM_TRANSLATION_DELETE_P   @CMTranslationId=@CMTranslationId

FETCH NEXT FROM theCursor3 INTO @CMTranslationId 
END
CLOSE theCursor3
DEALLOCATE theCursor3
