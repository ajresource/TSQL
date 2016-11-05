
 
/***************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
16 Apr 12   GD          Mod ChangeOutAnalyseBy (E783)
12 Apr 12   GD          Add PartClassification
***END OF HISTORY***********************************************************************************************************/

DECLARE @FilterConfigName VARCHAR(100),@FilterConfigXML xml,@FilterTypeID int

SET @FilterTypeID=2	--SearchCtl


SET @FilterConfigName = 'PartClassification'
SET @FilterConfigXML='  <PartClassification>
    <StoredProcedure>PART_CLASSIFICATION_GET_ALL_P</StoredProcedure>
    <SearchParam>SearchText</SearchParam>
    <Properties>
      <Caption>Part Classification</Caption>
    </Properties>
  </PartClassification>
'

IF @FilterConfigName <> '' AND CAST(@FilterConfigXML AS VARCHAR(MAX)) <> ''
BEGIN
	IF EXISTS (SELECT * FROM AMT_FILTER_CONFIG WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID)
		BEGIN
			UPDATE AMT_FILTER_CONFIG SET FilterConfig = @FilterConfigXML,LastModDate=GetDate() WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID
		END
	ELSE
		BEGIN
			INSERT INTO AMT_FILTER_CONFIG (FilterConfigName, FilterConfig,FilterTypeID) VALUES (@FilterConfigName, @FilterConfigXML,@FilterTypeID)
		END

END


--ChangeOutAnalyseBy
SET @FilterConfigName = 'ChangeOutAnalyseBy'
SET @FilterConfigXML='	<ChangeOutAnalyseBy>
		<Items>
			<Item>BRAN,Branch</Item>
			<Item>SITE,Site</Item>
			<Item>FLEE,Fleet</Item>
			<Item>EQPL,Equipment</Item>
			<Item>MODL,Model</Item>
			<Item>PRTA,Strategy Task</Item>
			<Item>PRDE,Strategy Task Description</Item>
			<Item>EVCC,Component Code</Item>
			<Item>CTTY,Cost Type</Item>
			<Item>SYST,System</Item>
			<Item>SUBS,Sub System</Item>
			<Item>EVTT,Task Type</Item>
			<Item>MDCO,Modifier Code</Item>
			<Item>REGN,Region</Item>
			<Item>LCTN,Equipment Location</Item>
			<Item>DEVI,Division</Item>
			<Item>PRPN,Primary Part No.</Item>
			<Item>CRSP,Cost Responsibility</Item>
			<Item>SRNO,Serial Number</Item>
			<Item>PACL,Part Classification</Item>
			<Item>PARA,Part Rating</Item>			
			<Item>RELO,Rebuild Location</Item>
			<Item>REST,Review Status</Item>
			<Item>SAST,Sales Status</Item>
    </Items>
		<Properties>
			<Caption>Analyse By*(5 max)</Caption>
		</Properties>
	</ChangeOutAnalyseBy>
'

IF @FilterConfigName <> '' AND CAST(@FilterConfigXML AS VARCHAR(MAX)) <> ''
BEGIN
	IF EXISTS (SELECT * FROM AMT_FILTER_CONFIG WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID)
		BEGIN
			UPDATE AMT_FILTER_CONFIG SET FilterConfig = @FilterConfigXML,LastModDate=GetDate() WHERE FilterConfigName = @FilterConfigName AND FilterTypeID=@FilterTypeID
		END
	ELSE
		BEGIN
			INSERT INTO AMT_FILTER_CONFIG (FilterConfigName, FilterConfig,FilterTypeID) VALUES (@FilterConfigName, @FilterConfigXML,@FilterTypeID)
		END

END
