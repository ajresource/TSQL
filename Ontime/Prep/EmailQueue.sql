exec spI_EmailQueue @EmailDetailsXML=N'<?xml version="1.0" encoding="utf-16"?>
<MailMessage xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <EmailFrom>OnTimeNotifications@Axosoft.com</EmailFrom>
  <EmailSubject>OnTime Notification: Task ID [#443] has changed</EmailSubject>
  <EmailTo>
    <string>maroun.maroun@isipl.com</string>
  </EmailTo>
  <EmailCC />
  <EmailBCC />
  <EmailMessage>
			I want to go home before the traffic,
			
			I will do the rest from home tonight ;)
		</EmailMessage>
  <MessageType>HTML</MessageType>
  <MessageEncoding>UTF8</MessageEncoding>
  <Attachments />
</MailMessage>'