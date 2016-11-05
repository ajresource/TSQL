/******************************************************************************
	File: 	amt_1_AMT_Function_Equipment_Type.sql

	Description:	Assigns AMT Function to Eqp Type

	Change History - Most Recent at Top
	
**************************************************************************************************************	
	
Date		Au	Act	Stored Procedure and IssueID
----		--	---	----------------------------
30 Apr 12   JW  Add 535 (563)	
23 Apr 12	VV	Add 534 (562)
MOST RECENT NOW AT TOP	
*****END OF HISTORY*********************************************************************************************************/
SET IDENTITY_INSERT AMT_FUNCTION_EQP_TYPE ON 
GO

 IF EXISTS(SELECT Amt_Function_Eqp_Type_Id FROM AMT_FUNCTION_EQP_TYPE  WHERE Amt_Function_Eqp_Type_Id = 534   )  UPDATE AMT_FUNCTION_EQP_TYPE SET Function_ID=562, Equipment_Type_ID=1 WHERE Amt_Function_Eqp_Type_Id=534 ELSE INSERT INTO AMT_FUNCTION_EQP_TYPE (Amt_Function_Eqp_Type_Id, Function_ID, Equipment_Type_ID) VALUES (534,562,1) 
 IF EXISTS(SELECT Amt_Function_Eqp_Type_Id FROM AMT_FUNCTION_EQP_TYPE  WHERE Amt_Function_Eqp_Type_Id = 535   )  UPDATE AMT_FUNCTION_EQP_TYPE SET Function_ID=563, Equipment_Type_ID=1 WHERE Amt_Function_Eqp_Type_Id=535 ELSE INSERT INTO AMT_FUNCTION_EQP_TYPE (Amt_Function_Eqp_Type_Id, Function_ID, Equipment_Type_ID) VALUES (535,563,1) 
GO

SET IDENTITY_INSERT AMT_FUNCTION_EQP_TYPE OFF
GO