

/****** Object:  Trigger [iTASK_STATUS_TRIGGER]    Script Date: 06/21/2013 15:32:44 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[iTASK_STATUS_TRIGGER]'))
DROP TRIGGER [dbo].[iTASK_STATUS_TRIGGER]
GO


/****** Object:  Trigger [dbo].[iTASK_STATUS_TRIGGER]    Script Date: 06/21/2013 15:32:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[iTASK_STATUS_TRIGGER] ON [dbo].[Tasks]
FOR INSERT,UPDATE
AS 
BEGIN
DECLARE @ActualUnitTypeId INT
DECLARE @TaskId INT
DECLARE @ActualDuration REAL=0
DECLARE @TotalActualDuration REAL=0
SELECT @TaskId=TaskId, @ActualDuration=ActualDuration,@ActualUnitTypeId=ActualUnitTypeId FROM inserted
SELECT @TotalActualDuration=SUM(ActualDuration) FROM iTASK_STATUS 
WHERE TaskId=@TaskId
GROUP BY TaskId
INSERT INTO iTASK_STATUS
SELECT @TaskId,@ActualDuration-@TotalActualDuration,@ActualUnitTypeId,GETDATE()
END

GO


