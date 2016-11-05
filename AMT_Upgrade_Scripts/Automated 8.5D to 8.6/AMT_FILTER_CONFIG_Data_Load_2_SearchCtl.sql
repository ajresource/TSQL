/******************************************************************************
	File: 	AMT_8_5_FILTER_CONFIG_Data_Load_1_Report.sql

	Description:	Creates search control configuration in the database

**************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
18 Aug 11   TP          Add: ImportErrorType
30-Aug-11	TP			Mod: BudgetComparisonHighLevelAnalyseBy - #2257
30-Aug-11	TP			Add: BudgetCostPerUOM - #2257
**END OF HISTORY************************************************************************************************************/

DECLARE @FilterConfigName VARCHAR(100),@FilterConfigXML xml,@FilterTypeID int

SET @FilterTypeID=2	--SearchCtl

-- ImportErrorType
SET @FilterConfigName = 'ImportErrorType'
SET @FilterConfigXML='	<ImportErrorType>
		<StoredProcedure>GENERIC_FILTERED_GET_P</StoredProcedure>
 		<SearchParam>SearchText</SearchParam>
		<Properties>
			<Caption>Error Type</Caption>
			<MultiSelector>true</MultiSelector>
		</Properties>
		<Params>
			<IdColumn>ImportErrorTypeId</IdColumn>
			<DescColumn>ImportErrorType</DescColumn>
			<SearchColumn>ImportErrorType</SearchColumn>
			<OrderByColumn>ImportErrorType</OrderByColumn>
			<TableName>IMPORT_ERROR_TYPE</TableName>
		</Params>			 
	</ImportErrorType>
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

--BudgetComparisonHighLevelAnalyseBy
SET @FilterConfigName = 'BudgetComparisonHighLevelAnalyseBy'
SET @FilterConfigXML='	<BudgetComparisonHighLevelAnalyseBy>
		<Items>
			<Item>BRAN,Branch</Item>
			<Item>SITE,Site</Item>
			<Item>FLEE,Fleet</Item>
			<Item>CCTR,Cost Centre</Item>
			<Item>CCAC,CC Activity</Item>
			<Item>CCLO,CC Location</Item>
			<Item>CCRP,CC Responsibility</Item>
			<Item>CCAT,Cost Category</Item>
			<Item>CEXP,Cost Expense</Item>
		</Items>
		<Properties>
			<Caption>Analyse By</Caption>
		</Properties>
	</BudgetComparisonHighLevelAnalyseBy>
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

--BudgetCostPerUOM
SET @FilterConfigName = 'BudgetCostPerUOM'
SET @FilterConfigXML='	<BudgetCostPerUOM>
		<Items>
			<Item>BRAN,Branch</Item>
			<Item>SITE,Site</Item>
			<Item>FLEE,Fleet</Item>
			<Item>CCTR,Cost Centre</Item>
			<Item>CCAC,CC Activity</Item>
			<Item>CCLO,CC Location</Item>
			<Item>CCRP,CC Responsibility</Item>
			<Item>CCAT,Cost Category</Item>
		</Items>
		<Properties>
			<Caption>Analyse By</Caption>
		</Properties>
	</BudgetCostPerUOM>
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
