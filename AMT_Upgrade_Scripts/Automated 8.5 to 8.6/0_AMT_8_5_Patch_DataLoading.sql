

/***************************************************************************************************************

	0_AMT_85_Patch_DataLoading

	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
 21 Sep 11	V Vasylyeva	Added CreatePlanningCompleteWOOnly
*END OF HISTORY*************************************************************************************************************/


IF NOT EXISTS (SELECT * FROM AMT_TYPED_VARIABLE WHERE Value_Name='CreatePlanningCompleteWOOnly')
INSERT INTO AMT_TYPED_VARIABLE(Value_Name,Varchar_Value)
VALUES('CreatePlanningCompleteWOOnly','0')

GO


