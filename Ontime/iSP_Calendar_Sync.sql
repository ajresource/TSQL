USE [Ontime]
GO

/****** Object:  StoredProcedure [dbo].[iSP_Calendar_Sync]    Script Date: 07/02/2013 18:05:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[iSP_Calendar_Sync]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[iSP_Calendar_Sync]
GO

USE [Ontime]
GO

/****** Object:  StoredProcedure [dbo].[iSP_Calendar_Sync]    Script Date: 07/02/2013 18:05:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[iSP_Calendar_Sync]

@TaskID INT ,
@Email VARCHAR(200) =NULL,
@RequiredbyDate datetime,
@BudgetHours REAL=NULL

AS

DECLARE @AssignedTo varchar(200)
DECLARE @ReportedBy varchar(200)
DECLARE @EmailDetailsXML VARCHAR(MAX)
DECLARE @NewAssignedtoID INT=0

IF @Email IS NOT NULL
BEGIN
select @NewAssignedtoID=UserID from Users where Email=@Email 
Update Tasks 
SET AssignedtoID=ISNULL(@NewAssignedtoID,0) 
where TaskID=@TaskID
END


IF @BudgetHours IS NOT NULL
BEGIN
update Tasks
SET EstimatedDuration=@BudgetHours, DurationUnitTypeID=2
where TaskID=@TaskID
END

--REMOVE A SECOND FROM THE DATE(CALANDER FORMATTING)
SET @RequiredbyDate=DATEADD(SECOND,-1,@RequiredbyDate)
-- UPDATE TASK DETAILS
update TaskCustomFields
set Custom_210=@RequiredbyDate
where TaskId=@TaskID

-- SEND AN EMAIL

select @AssignedTo=U.Email from Tasks T
inner join Users U ON T.AssignedToID=U.UserID
where T.TaskID=@TaskID


select @ReportedBy=U.Email from Tasks T
inner join Users U ON T.ReportedByID=U.UserID
where T.TaskID=@TaskID

IF @ReportedBy IS NULL
BEGIN 
set @ReportedBy=@AssignedTo
END
select @ReportedBy
set @EmailDetailsXML=N'<?xml version="1.0" encoding="utf-16"?>
<MailMessage xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <EmailFrom>OnTimeNotifications@Axosoft.com</EmailFrom>
  <EmailSubject>OnTime Notification: Task ID [#'+CONVERT(VARCHAR,@TaskID)+'] has changed</EmailSubject>
  <EmailTo>
    <string>'+@ReportedBy+'</string>
  </EmailTo>
  <EmailCC />
  <EmailBCC />
  <EmailMessage>
  
 You have received an OnTime Notification.&amp;nbsp;Here are the notification details:&lt;br /&gt;
		Change Details:&lt;br /&gt;
			
			&lt;ul&gt;
			&lt;li&gt;Required By date has changed To : '+CONVERT(VARCHAR,@RequiredbyDate)+'&lt;/li&gt;
			&lt;/ul&gt;
		&lt;br /&gt;
'
+
CASE WHEN @Email<>NULL
THEN
'

	&lt;ul&gt;
			&lt;li&gt;Email has changed To : '+@Email+'&lt;/li&gt;
			&lt;/ul&gt;
		&lt;br /&gt;'
ELSE 

'--'
END	
+
'


		</EmailMessage>
  <MessageType>HTML</MessageType>
  <MessageEncoding>UTF8</MessageEncoding>
  <Attachments />
</MailMessage>'

select @EmailDetailsXML
--exec spI_EmailQueue @EmailDetailsXML=@EmailDetailsXML
GO


