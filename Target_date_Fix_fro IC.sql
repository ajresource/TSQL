
	DECLARE @MinDate DateTime
		DECLARE @MaxDate DateTime
		SELECT @MinDate = MIN(Date)  ,@MaxDate= MAX(Date)   FROM REPORT_DATE
 
IF EXISTS(SELECT Performed_By_Date FROM TASK WHERE Performed_By_Date > @MaxDate)
BEGIN
	UPDATE TASK SET Performed_By_Date = @MaxDate    WHERE Performed_By_Date > @MaxDate
END

IF EXISTS(SELECT Performed_By_Date FROM TASK WHERE Performed_By_Date < @MinDate)
BEGIN
	UPDATE TASK SET Performed_By_Date = @MinDate    WHERE Performed_By_Date < @MinDate 
END

IF EXISTS(SELECT Date_Notified FROM TASK WHERE Date_Notified > @MaxDate)
BEGIN
	UPDATE TASK SET Date_Notified = @MaxDate    WHERE Date_Notified > @MaxDate
END

IF EXISTS(SELECT Date_Notified FROM TASK WHERE Date_Notified < @MinDate)
BEGIN
	UPDATE TASK SET Date_Notified = @MinDate    WHERE Date_Notified < @MinDate 
END
 
  