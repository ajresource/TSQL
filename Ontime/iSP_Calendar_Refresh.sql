USE [Ontime]
GO

/****** Object:  StoredProcedure [dbo].[iSP_Calander_Refresh]    Script Date: 07/08/2013 20:19:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[iSP_Calander_Refresh]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[iSP_Calander_Refresh]
GO

USE [Ontime]
GO

/****** Object:  StoredProcedure [dbo].[iSP_Calander_Refresh]    Script Date: 07/08/2013 20:19:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[iSP_Calander_Refresh]
AS 
DECLARE @TaskId INT

DECLARE SyncTasks CURSOR FOR	

select TaskID from iTasks
 
OPEN SyncTasks 
FETCH NEXT FROM SyncTasks INTO @TaskId 
WHILE @@fetch_status = 0
BEGIN 


DECLARE  @TaskNumber nvarchar(20)
DECLARE  @Name nvarchar(200)
DECLARE  @Description VARCHAR(MAX)
DECLARE  @Notes VARCHAR(MAX)
DECLARE  @CategoryTypeId int
DECLARE  @ProjectId int
DECLARE  @StartDate datetime
DECLARE  @DueDate datetime
DECLARE  @CompletionDate datetime
DECLARE  @IsCompleted bit
DECLARE  @IsPublic bit
DECLARE  @AssignedToId int
DECLARE  @CreatedById int
DECLARE  @CreatedDateTime datetime
DECLARE  @LastUpdatedById int
DECLARE  @LastUpdatedDateTime datetime
DECLARE  @Archived bit
DECLARE  @EstimatedDuration real
DECLARE  @DurationUnitTypeId int
DECLARE  @ActualDuration real
DECLARE  @ActualUnitTypeId int
DECLARE  @WorkflowStepId int
DECLARE  @PriorityTypeId int
DECLARE  @RemainingDuration [real]
DECLARE  @RemainingUnitTypeId [int]
DECLARE  @ReleaseId [int]
DECLARE  @StatusTypeId [int]
DECLARE  @PubliclyViewable [int]
DECLARE  @ReportedByCustomerContactId [int]
DECLARE  @ReportedById [int]
DECLARE  @PercentComplete [tinyint]
DECLARE  @ParentId [int]
DECLARE  @Custom_209 nvarchar(50) = null
DECLARE  @Custom_213 datetime  = null 
DECLARE  @Custom_212 float  = null 
DECLARE  @Custom_202 nvarchar(50)  = null 
DECLARE  @Custom_206 nvarchar(50)  = null 
DECLARE  @Custom_229 nvarchar(50)  = null 
DECLARE  @Custom_207 nvarchar(50)  = null 
DECLARE  @Custom_208 nvarchar(5)  = null 
DECLARE  @Custom_249 nvarchar(50)  = null 
DECLARE  @Custom_230 float  = null 
DECLARE  @Custom_204 nvarchar(50)  = null 
DECLARE  @Custom_210 datetime  = null 
DECLARE  @Custom_203 nvarchar(50)  = null 
DECLARE  @Custom_211 nvarchar(50)  = null 
			
DECLARE @AssignedTo VARCHAR(200)
DECLARE @ReportedBy VARCHAR(200)
DECLARE @OriginalEmail VARCHAR(200)
DECLARE @EmailDetailsXML VARCHAR(MAX)

select @OriginalEmail=U.Email from Tasks T
inner join Users U ON T.AssignedToID=U.UserID
where T.TaskID=@TaskID


SELECT
@TaskID=[TaskId],
@TaskNumber=[TaskNumber],
@Name=[Name],
@Description=[Description],
@Notes=[Notes],
@CategoryTypeId=[CategoryTypeId],
@ProjectId=[ProjectId],
@StartDate=[StartDate],
@DueDate=[DueDate],
@CompletionDate=[CompletionDate],
@IsCompleted=[IsCompleted],
@IsPublic=[IsPublic],
@AssignedToId=[AssignedToId],
@CreatedById=[CreatedById],
@CreatedDateTime=[CreatedDateTime],
@LastUpdatedById=[LastUpdatedById],
@LastUpdatedDateTime=[LastUpdatedDateTime],
@ReportedById=[ReportedById],
@Archived=[Archived],
@EstimatedDuration=[EstimatedDuration],
@DurationUnitTypeId=[DurationUnitTypeId],
@ActualDuration=[ActualDuration],
@ActualUnitTypeId=[ActualUnitTypeId],
@WorkflowStepId=[WorkflowStepId],
@PriorityTypeId=[PriorityTypeId],
@RemainingDuration=[RemainingDuration],
@RemainingUnitTypeId=[RemainingUnitTypeId],
@ReleaseId=[ReleaseId],
@StatusTypeId=[StatusTypeId],
@PubliclyViewable=[PubliclyViewable],
@ReportedByCustomerContactId=[ReportedByCustomerContactId],
@PercentComplete=[PercentComplete],
@ParentId=[ParentId]
  FROM [Ontime].[dbo].[iTasks] where TaskID=@TaskId
  
SELECT 
@Custom_202=Custom_202,
@Custom_203=Custom_203,
@Custom_204=Custom_204,
@Custom_206=Custom_206,
@Custom_207=Custom_207,
@Custom_208=Custom_208,
@Custom_209=Custom_209,
@Custom_210=Custom_210,
@Custom_211=Custom_211,
@Custom_212=Custom_212,
@Custom_213=Custom_213,
@Custom_229=Custom_229,
@Custom_230=Custom_230,
@Custom_249=Custom_249
 FROM [Ontime].[dbo].[iTaskCustomFields] where TaskID=@TaskId
  
  
 EXEC  [spU_Tasks]
 @TaskId =@TaskId ,
 @TaskNumber = @TaskNumber ,
 @Name= @Name,
 @Description= @Description,
 @Notes= @Notes,
 @CategoryTypeId= @CategoryTypeId,
 @ProjectId= @ProjectId,
 @StartDate= @StartDate,
 @DueDate= @DueDate,
 @CompletionDate= @CompletionDate,
 @IsCompleted= @IsCompleted,
 @IsPublic= @IsPublic,
 @AssignedToId= @AssignedToId,
 @CreatedById= @CreatedById,
 @CreatedDateTime= @CreatedDateTime,
 @LastUpdatedById= @LastUpdatedById,
 @LastUpdatedDateTime= @LastUpdatedDateTime,
 @Archived= @Archived,
 @EstimatedDuration= @EstimatedDuration,
 @DurationUnitTypeId= @DurationUnitTypeId,
 @ActualDuration= @ActualDuration,
 @ActualUnitTypeId= @ActualUnitTypeId,
 @WorkflowStepId= @WorkflowStepId,
 @PriorityTypeId= @PriorityTypeId,
 @RemainingDuration= @RemainingDuration,
 @RemainingUnitTypeId= @RemainingUnitTypeId,
 @ReleaseId= @ReleaseId,
 @StatusTypeId= @StatusTypeId,
 @PubliclyViewable= @PubliclyViewable,
 @ReportedByCustomerContactId= @ReportedByCustomerContactId,
 @ReportedById= @ReportedById,
 @PercentComplete= @PercentComplete,
 @ParentId= @ParentId


EXEC [spU_TaskCustomFields] 
@TaskID=@TaskID,
@Custom_202=@Custom_202,
@Custom_203=@Custom_203,
@Custom_204=@Custom_204,
@Custom_206=@Custom_206,
@Custom_207=@Custom_207,
@Custom_208=@Custom_208,
@Custom_209=@Custom_209,
@Custom_210=@Custom_210,
@Custom_211=@Custom_211,
@Custom_212=@Custom_212,
@Custom_213=@Custom_213,
@Custom_229=@Custom_229,
@Custom_230=@Custom_230,
@Custom_249=@Custom_249

--- SEND EMAIL 


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
			
			&lt;ul&gt;
			&lt;li&gt;Workflow Step has changed&lt;/li&gt;&lt;li&gt;Category has changed&lt;/li&gt;&lt;li&gt;IT Type has changed&lt;/li&gt;&lt;li&gt;Planned has changed&lt;/li&gt;&lt;li&gt;Required By has changed&lt;/li&gt;&lt;li&gt;Actual Duration has changed&lt;/li&gt;&lt;li&gt;Status has changed&lt;/li&gt;&lt;li&gt;Description has changed&lt;/li&gt;
			&lt;/ul&gt;
		&lt;br /&gt;
			WEB: &lt;a href=''http://support.isipl.com/OnTime2012Web/ViewItem.aspx?type=tasks&amp;id='+@TaskID+'''&gt;http://support.isipl.com/OnTime2012Web/ViewItem.aspx?type=tasks&amp;id='+@TaskID+'&lt;/a&gt;&lt;br /&gt;
		</EmailMessage>
  <MessageType>HTML</MessageType>
  <MessageEncoding>UTF8</MessageEncoding>
  <Attachments />
</MailMessage>'

exec spI_EmailQueue @EmailDetailsXML=@EmailDetailsXML

--select @EmailDetailsXML

--EOF



FETCH NEXT FROM SyncTasks INTO @TaskId 
END
CLOSE SyncTasks 
DEALLOCATE SyncTasks 

truncate table [iTasks]
truncate table [iTaskCustomFields]

GO


