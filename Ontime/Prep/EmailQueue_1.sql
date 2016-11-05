
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


IF @OriginalEmail IS NULL
BEGIN 
set @OriginalEmail=@AssignedTo
END

select @ReportedBy
set @EmailDetailsXML=N'<?xml version="1.0" encoding="utf-16"?>
<MailMessage xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <EmailFrom>OnTimeNotifications@Axosoft.com</EmailFrom>
  <EmailSubject>OnTime Notification: Task ID [#'+CONVERT(VARCHAR,@TaskID)+'] has changed</EmailSubject>
  <EmailTo>
    <string>'+@ReportedBy+'</string>
  </EmailTo>
  <EmailCC>
     <string>'+@AssignedTo+'</string>
  </EmailCC>
  <EmailBCC>
  <string>'+@OriginalEmail+'</string>
  </EmailBCC>
  <EmailMessage>
  
 You have received an OnTime Notification.&amp;nbsp;Here are the notification details:&lt;br /&gt;
		Change Details:&lt;br /&gt;

'+	
CASE WHEN @RequiredbyDate IS NOT NULL
THEN'
			&lt;ul&gt;
			&lt;li&gt;Required By date has changed To : '+CONVERT(VARCHAR,@RequiredbyDate1)+'&lt;/li&gt;
			&lt;/ul&gt;
		&lt;br /&gt;
	'	
ELSE 

''

END	+
'
'
+
CASE WHEN @Email<>NULL
THEN
'

	&lt;ul&gt;
			&lt;li&gt;Assined to user has changed To : '+@Email+'&lt;/li&gt;
			&lt;/ul&gt;
		&lt;br /&gt;'
ELSE 

''
END	
+
'
'+	
CASE WHEN  @WorkFlowStep='Completed IT Task'
THEN'
			&lt;ul&gt;
			&lt;li&gt;Workflow Step has changed : Completed IT Task 
			&lt;/li&gt;
			&lt;/ul&gt;
		&lt;br /&gt;
	'	
ELSE 

''

END	+
'
'+	
CASE WHEN  @WorkFlowStep='On Hold IT Task'
THEN'
			&lt;ul&gt;
			&lt;li&gt;Workflow Step has changed : On Hold IT Task 
			&lt;/li&gt;
			&lt;/ul&gt;
		&lt;br /&gt;	
		
	'	
ELSE 

''

END	+
'
'+	
CASE WHEN  @WorkFlowStep='Waiting On Approval'
THEN'
			&lt;ul&gt;
			&lt;li&gt;Workflow Step has changed : Waiting On Approval 
			&lt;/li&gt;
			&lt;/ul&gt;
		&lt;br /&gt;
	'	
ELSE 

''

END	+
'


		</EmailMessage>
  <MessageType>HTML</MessageType>
  <MessageEncoding>UTF8</MessageEncoding>
  <Attachments />
</MailMessage>'

exec spI_EmailQueue @EmailDetailsXML=@EmailDetailsXML

--select @EmailDetailsXML

--EOF