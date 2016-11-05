/******************************************************************************
	File: 	amt_2_AMT_Function_Hierarchy_System_Administrator.sql

	Description:	Default Administrator Role Hierarchy + Permission.

	Change History - Most Recent at Top
	
**************************************************************************************************************	
	
Date		Au	Act	Stored Procedure and IssueID
----		--	---	----------------------------
30 Apr 12   JW  E793    Add 563
23 Apr 12	VV	E779	Add 562
13 Apr 12   GD  E777	Add 561  
***END OF HISTORY***********************************************************************************************************/

DECLARE @SysAdminID INT

select top 1 @SysAdminID=user_role_id from user_role where defaultrole<>0

IF ISNULL(@SysAdminID,0) = 0 
BEGIN
	SELECT 'Unable to find the SYSTEM Administration User Role'
END
ELSE
BEGIN
		DELETE FROM ROLE_PERMISSION WHERE Function_ID = 561 AND User_role_Id = @SysAdminID
			
		INSERT INTO ROLE_PERMISSION (Function_ID,User_Role_ID,Access_Type_ID,Create_Date,Create_By_User_ID,Last_Mod_Date,Last_Mod_By_User_ID)
		SELECT 	561,
			@SysAdminID as User_Role_ID,
			(select Access_Type_Id from access_type where Access_Name='All') as Access_Type_ID,Getdate(),0,Getdate(),0
		
		IF NOT EXISTS(SELECT * FROM ROLE_PERMISSION WHERE Function_ID = 562 AND User_role_Id = @SysAdminID)	
		BEGIN
			
			INSERT INTO ROLE_PERMISSION (Function_ID,User_Role_ID,Access_Type_ID,Create_Date,Create_By_User_ID,Last_Mod_Date,Last_Mod_By_User_ID)
			SELECT 	Function_ID,@SysAdminID as User_Role_ID,
			Case Is_Report 
				WHEN 0 THEN (select Access_Type_Id from access_type where Access_Name='All') 
				ELSE (select Access_Type_Id from access_type where Access_Name='View') 
				END 
			as Access_Type_ID,
			Getdate(),0,Getdate(),0
		FROM AMT_FUNCTION	WHERE Function_ID=562
			
		END
		
		IF NOT EXISTS(SELECT * FROM ROLE_PERMISSION WHERE Function_ID = 563 AND User_role_Id = @SysAdminID)	
		BEGIN
			
			INSERT INTO ROLE_PERMISSION (Function_ID,User_Role_ID,Access_Type_ID,Create_Date,Create_By_User_ID,Last_Mod_Date,Last_Mod_By_User_ID)
			SELECT 	Function_ID,@SysAdminID as User_Role_ID,
			Case Is_Report 
				WHEN 0 THEN (select Access_Type_Id from access_type where Access_Name='All') 
				ELSE (select Access_Type_Id from access_type where Access_Name='View') 
				END 
			as Access_Type_ID,
			Getdate(),0,Getdate(),0
		FROM AMT_FUNCTION	WHERE Function_ID=563
			
		END
END


DELETE FROM FUNCTION_HIERARCHY WHERE User_role_Id IS NOT NULL AND Function_ID IN (54,55,72,73,89,407,536,539,561,563)

	INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,54,'System Administration\System Tables\Parts & Standard Jobs' FROM USER_ROLE
		INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,55,'System Administration\System Tables\Parts & Standard Jobs' FROM USER_ROLE
		INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,72,'System Administration\System Tables\Parts & Standard Jobs' FROM USER_ROLE
		INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,73,'System Administration\System Tables\Parts & Standard Jobs' FROM USER_ROLE
		INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,89,'System Administration\System Tables\Parts & Standard Jobs' FROM USER_ROLE
		INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,561,'System Administration\System Tables\Parts & Standard Jobs' FROM USER_ROLE
		INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,407,'System Administration\System Tables\Parts & Standard Jobs' FROM USER_ROLE
		INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,536,'System Administration\System Tables\Parts & Standard Jobs' FROM USER_ROLE
		INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,539,'System Administration\System Tables\Parts & Standard Jobs' FROM USER_ROLE
		INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,563,'Long-term Planning\Components' FROM USER_ROLE

DELETE FROM AMT_MODE_PERMISSION WHERE FunctionID = 561
INSERT INTO AMT_MODE_PERMISSION (AMTModeID, FunctionID, Enabled) 
SELECT 1,561,1
GO

IF NOT EXISTS(SELECT * FROM FUNCTION_HIERARCHY WHERE Function_ID=562)
BEGIN
	INSERT INTO FUNCTION_HIERARCHY (User_Role_ID, Function_ID, Level_Path) SELECT User_Role_ID,562,'Long-term Planning\Components' FROM USER_ROLE
END



