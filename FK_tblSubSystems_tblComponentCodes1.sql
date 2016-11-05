USE [isipl_amt_Congo_Equipment]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblSubSystems_tblComponentCodes1]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblSubSystems]'))
ALTER TABLE [dbo].[tblSubSystems] DROP CONSTRAINT [FK_tblSubSystems_tblComponentCodes1]
GO

USE [isipl_amt_Congo_Equipment]
GO

ALTER TABLE [dbo].[tblSubSystems]  WITH CHECK ADD  CONSTRAINT [FK_tblSubSystems_tblComponentCodes1] FOREIGN KEY([UnsCompCodeID])
REFERENCES [dbo].[tblComponentCodes] ([ComponentCodeID])
GO

ALTER TABLE [dbo].[tblSubSystems] CHECK CONSTRAINT [FK_tblSubSystems_tblComponentCodes1]
GO


