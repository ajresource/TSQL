/******************************************************************************
	File: 	AMT85C_HOTFIX_20120524.sql

	
            
-------------------------------------------------------------------------------
DATE		BY	CCL		NOTES
-------------------------------------------------------------------------------
25 May 12	GD	#4180 Error en reporte MARC PCV Chart
-------------------------------------------------------------------------------
******************************************************************************/




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[JOB_CODE_ADD_CODE_P]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[JOB_CODE_ADD_CODE_P]
GO


create Procedure [dbo].[JOB_CODE_ADD_CODE_P]
/******************************************************************************
	Name: JOB_CODE_ADD_CODE_P

	Called By: -

	Desc: 
             
	Auth: Gareth Facer
	Date: 07-Jan-2003
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	24 May 12   GD          issue 4180
	--OLD COMMENTS
	
	16-Feb-2010	AL			CR8786: cannot have no default record
	12-Mar-2009	V Vasylyeva	Added @ConsumableDescription varchar(10)=NULL,
									@ConsumableUOM varchar(50) =NULL,
									@Lube bit=0,
									@RemoveInstall bit=0,
									@Message varchar(max)='' OUTPUT
	27/09/05	SI		Set new parameters to have default values
	06/05/05	P Joy		Fixed to add create date and global_job_code_id,@Message
	31 Jan 2011 T Patel     E713 : Job Code System table changes
*******************************************************************************/
	/* Param List */
	@Code  varchar(10),
	@Description varchar(50)='',
	@Default_Record bit=0,
	@Budget_Code bit=1,
	@Global_Job_Code_Id int=0,
	@Create_By_User_Id int=0,
	@id int OUTPUT,
	@ConsumableDescription varchar(10)=NULL,
	@ConsumableUOM varchar(50) =NULL,
	@Lube bit=0,
	@RemoveInstall bit=0,
	@DefaultTaskTypeId int = NULL,
	@IncludeRIJob bit=1,
	@ShopLabour bit=0,	
	@Message varchar(max)='' OUTPUT
AS


--GD 24 May 2012 Issue 4180
IF(@DefaultTaskTypeId IS NULL)
SELECT @DefaultTaskTypeId = TaskTypeID FROM tblTaskTypes WHERE Default_Record = 1 

--AL: 16/02/10
IF ISNULL(@Default_Record,0)=0 AND NOT EXISTS(SELECT * FROM tblJOBCodes)
BEGIN
	SET @Message='There is no default record'
	RETURN
END

IF @Description='' SET @Description=@Code

IF @Global_Job_Code_Id<1
	SELECT TOP 1 @Global_Job_Code_Id=Global_Job_Id FROM GLOBAL_JOB_CODES WHERE Default_Record<>0

INSERT 
INTO dbo.tblJOBCodes
	(Code, [Description], Default_Record, BudgetCode, 
	 CreateByUserId, CreateDate, LastModByUserId, LastModDate, Global_Job_Code_Id,ConsumableDescription,ConsumableUOM,
Lube,RemoveInstall, DefaultTaskTypeId, IncludeRIJob, ShopLabour)
VALUES
	(@code, @Description, @Default_Record, @Budget_Code, @Create_By_User_Id, GetDate(), @Create_By_User_Id, GetDate(), 
@Global_Job_Code_Id,@ConsumableDescription,@ConsumableUOM,@Lube,@RemoveInstall, @DefaultTaskTypeId, @IncludeRIJob, @ShopLabour)


SET @id = SCOPE_IDENTITY()

IF @@ERROR = 0 IF @Default_Record = 1 UPDATE tblJobCodes SET Default_Record = 0 WHERE JobCodeId <> @id

GO



IF NOT EXISTS (SELECT * FROM information_schema.tables	WHERE table_type = 'base table' AND table_catalog=DB_NAME() and table_schema='dbo' and Table_Name='AMT_HOTFIX')
	CREATE TABLE AMT_HOTFIX(FixName nvarchar(MAX),Description nvarchar(MAX), DatabasePatchVersion varchar(15), DateApplied DateTime)
GO

DECLARE @FixName nVarchar(MAX),@dbasePatchVer varchar(15)
SET @FixName=N'AMT85C_HOTFIX_20120524.sql'

SELECT TOP 1 @dbasePatchVer=Database_Patch_Ver FROM AMT_VARIABLE


IF EXISTS(SELECT * FROM AMT_HOTFIX WHERE FixName=@FixName)
	UPDATE AMT_HOTFIX SET DateApplied=GetDate()
ELSE
	INSERT INTO AMT_HOTFIX VALUES(@FixName,N'',@dbasePatchVer,GetDate())
GO
