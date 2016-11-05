/******************************************************************************
	File: 	4_AMT_8_5_Patch_Function.sql

	Description:	Creates the Functions in the database

**************************************************************************************************************
	Change History
**************************************************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
25 Jul 10	VV			Add: EQP_SIBLINGS_F
**END OF HISTORY************************************************************************************************************/
SET QUOTED_IDENTIFIER ON	--should be always ON
GO
SET ANSI_NULLS ON			--should be always ON
GO
--=============================================================================

if exists (select * from dbo.sysobjects where id = object_id(N'EQP_SIBLINGS_F') and xtype in (N'FN', N'IF', N'TF'))
drop function EQP_SIBLINGS_F
GO

create  FUNCTION [dbo].[EQP_SIBLINGS_F]
(@ParentEqpPlanID	varchar(MAX)) 
/******************************************************************************
	
	Name: EQP_SIBLINGS_F

	Desc:	If there are parent equipments set, you need to filter the equipments to only include 
			those parents and their children

	      Returns table
              
	Auth: Alex Lassauniere	
	Date: 03 April 2008
*******************************************************************************
		Change History
*******************************************************************************
Date:		Author:		Description:
--------	--------	----------------------------------------
25-Jul-11	V Vasylyeva	#2153: Error when multiple equipment is selected
*******************************************************************************/
RETURNS @EQPPLAN_SIBLINGS		table
		(EqpPlanID int  ,
		EqpPlan varchar (100),			
		ParentEqpPlanID int
		PRIMARY KEY(EqpPlanID))
AS  
BEGIN

IF (LEN(@ParentEqpPlanID) > 0)
BEGIN
	--If there are parent equipments set, you need to filter the equipments to only include 
	--those parents and their children
	WITH tblEqpplansCTE(EqpPlanId,EqpPlan,ParentEqpPlanId)
	AS
	(
		SELECT	EqpPlanId,EqpPlan,ParentEqpPlanId 
		FROM	tblEqpplans  
		WHERE	EqpPlanId IN (SELECT list_item FROM dbo.LIST_TO_TABLE_F(@ParentEqpPlanID))
		UNION ALL
		SELECT	E.EqpPlanId,E.EqpPlan,E.ParentEqpPlanId 
		FROM 
				tblEqpplans AS E INNER JOIN 
				tblEqpplansCTE AS M ON E.ParentEqpPlanId = M.EqpPlanId
	)

	INSERT INTO @EQPPLAN_SIBLINGS(EqpPlanID,EqpPlan,ParentEqpPlanID)
	SELECT /*VV #2153*/	DISTINCT EqpPlanID,EqpPlan,ParentEqpPlanID
	FROM tblEqpplansCTE
	OPTION (MAXRECURSION 0);
END

RETURN 

END

GO