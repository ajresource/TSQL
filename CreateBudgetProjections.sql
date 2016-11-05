  

CREATE TABLE zz_BudgetProjectionsCreate
(EqpPlanId INT, 
CurentProjectionId INT,
ErrorMessage VARCHAR(8000),
Logged DATETIME,
StartDate DATETIME

)
GO

TRUNCATE TABLE zz_BudgetProjectionsCreate
GO


INSERT INTO zz_BudgetProjectionsCreate (EqpPlanId,CurentProjectionId,Logged,StartDate)
SELECT EP.EqpPlanId, EPROJ.EqpProjId,GETDATE(),EP.StartDate
FROM aa_EqpToBeImported E  
INNER JOIN tblEqpPlans EP ON EP.EqpPlanId = E.WESEqpPlanid
INNER JOIN tblEqpProjs EPROJ ON EPROJ.EqpPlanId = EP.EqpPlanId
LEFT JOIN tblEqpProjs BUD_PJ ON BUD_PJ.EqpPlanId = EP.EqpPlanId AND BUD_PJ.Projection_Type_ID = 2
WHERE  EPROJ.Projection_Type_ID = 1 AND  BUD_PJ.EqpProjId IS NULL

DECLARE @EqppRojIdFrom INT
DECLARE @EqpPlanIdTo INT
DECLARE @PricingDate DATETIME
declare @p9 varchar(8000)

DECLARE Cur CURSOR FOR 
	SELECT  CurentProjectionId,EqpPlanId,StartDate FROM zz_BudgetProjectionsCreate
OPEN Cur
FETCH NEXT FROM Cur INTO @EqppRojIdFrom,@EqpPlanIdTo,@PricingDate
WHILE @@FETCH_STATUS = 0
BEGIN
		Update tblEqpPlans SET Multi_Projection = 1 where EqpPlanId = @EqpPlanIdTo
		
		set @p9=''
		exec COPY_ADD_PROJECTION_P 
		@EqpProjIdFrom=@EqppRojIdFrom,
		@EqpPlanTo=@EqpPlanIdTo,
		@ProjectionTypeId=2,
		@EqpProjName='Budget',
		@Esc_Desc_Prices=1,
		@LeavePricingDate=0,
		@KeepLinkToStdJob=1,
		@NewPricingDate=@PricingDate,
		@Message=@p9 output,
		@EqpRolloverId=0,
		@RolloverOpt=0
		
		Update zz_BudgetProjectionsCreate SET ErrorMessage =@p9 where EqpPlanId = @EqpPlanIdTo AND CurentProjectionId = @EqppRojIdFrom
	 
	FETCH NEXT FROM Cur INTO @EqppRojIdFrom,@EqpPlanIdTo,@PricingDate
END
CLOSE Cur
DEALLOCATE Cur


GO


SELECT * FROM zz_BudgetProjectionsCreate 