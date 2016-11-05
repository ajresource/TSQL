USE [Ontime]
GO
/****** Object:  UserDefinedFunction [dbo].[fnUserName]    Script Date: 07/12/2013 14:40:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[iBudgetStartDate] 
(
	@BudgetHours REAL,
	@RequiredDate VARCHAR(200)
	
)  
RETURNS nvarchar(200)
AS  
BEGIN
DECLARE @BudgetStartDate VARCHAR(200)
DECLARE @OrgBudgetStartDate VARCHAR(200)
-- INITIAL BUDGET START DATE
set @OrgBudgetStartDate=DATEADD(HOUR,CASE 
										WHEN @BudgetHours<=8 
											THEN 
												-@BudgetHours /*IF ACTUAL HOOURS LESS THAN 8 DONT DO ANYTHING */
											ELSE 
										-@BudgetHours*3+24 /*IF ACTUAL HOURS GREATER THAN 8 THEN *3 TO SHOW IN THE 24 HOUR CALANDER*/
										END 

										,Convert(Datetime,CASE 
															WHEN @BudgetHours<=8 AND ( DATEPART(hOUR,@RequiredDate)>19 OR  DATEPART(hOUR,@RequiredDate)=0)
																 THEN 
																	DATEADD(HOUR,19,CONVERT(DATETIME,LEFT(@RequiredDate,11),20))
																	/*IF THE TASK COMPLETE TIME BETWEEN 1901 AND 0000 THEN COMPLATE TIME IS 1900 AS THE WORKING HOURS FROM 6AM TO 7PM*/
																ELSE 
																	@RequiredDate
																END 
												,101)
									
								) 
					 
-- IF TASK IS ONE DAY AND THE DATE IS NOT IN A WEEKEND
				IF @BudgetHours<=8 AND DATENAME(dw, @RequiredDate) NOT IN ('Saturday', 'Sunday') 
				BEGIN 
					SET @BudgetStartDate=@OrgBudgetStartDate
				END	 
-- IF TASK IS ONE DAY BUT REQUIRED DATE IS A WEEK END
				IF  @BudgetHours<=8 AND DATENAME(dw, @RequiredDate) IN ('Saturday', 'Sunday') 
				BEGIN 
						IF DATENAME(dw, @OrgBudgetStartDate)='Saturday'
							SET @BudgetStartDate=CONVERT(VARCHAR,DATEADD(DAY,-1,@OrgBudgetStartDate))
						IF DATENAME(dw, @OrgBudgetStartDate)='Sunday'
							   SET @BudgetStartDate=CONVERT(VARCHAR,DATEADD(DAY,-2,@OrgBudgetStartDate))
					END		   
-- IF TASK IS LONGER THAN ONE DAY, CALCULATE THE START DATE BY REMOVING THE WEKENDS 						
				 IF @BudgetHours>8
				BEGIN 
				 SET @BudgetStartDate=(DATEADD(DAY,-DateDiff(ww,@OrgBudgetStartDate, @RequiredDate)/*#OF WEEKENDS*/*2 ,@OrgBudgetStartDate))
				END
	

Return @BudgetStartDate
END