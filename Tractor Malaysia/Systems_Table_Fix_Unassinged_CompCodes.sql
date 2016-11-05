

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblSubSystems_tblComponentCodes1]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblSubSystems]'))
ALTER TABLE [dbo].[tblSubSystems] DROP CONSTRAINT [FK_tblSubSystems_tblComponentCodes1]
GO


delete from GLOBAL_COMPONENT_CODES where AMT_Component_Code_Id IN 
(select ComponentCodeID  from tblComponentCodes where ComponentCodeID BETWEEN 1 AND 512 
and Code like 'Z%')

delete from GLOBAL_COMPONENT_CODE_LINK where AMT_Component_Code_Id IN 
(select ComponentCodeID  from tblComponentCodes where ComponentCodeID BETWEEN 1 AND 512 
and Code like 'Z%')



-- ALL THE Z CODES BETWEEN 1 AND 512 ARE INVALID AND NOT LINKED TO ANY OF THE WORKORDERS OR NOT SPECIFIED AS A UNASSIGNED CODE FOR A SUBSYSTEM
delete  from tblComponentCodes where ComponentCodeID IN(
select ComponentCodeID from tblComponentCodes where ComponentCodeID
BETWEEN 1 AND 512 
and Code like 'Z%'
)

update tblComponentCodes 
set Code='Z'+CONVERT(VARCHAR,SubSystemID)from tblComponentCodes
where Code like 'Z0%' and LEN(Code)=5


update S
set S.UnsCompCodeID=CC.ComponentCodeID
from tblSubsystems  S 
inner join tblComponentCodes CC ON S.SubSystemID=CC.SubSystemID
where CC.Code like 'z%'


ALTER TABLE [dbo].[tblSubSystems]  WITH NOCHECK ADD  CONSTRAINT [FK_tblSubSystems_tblComponentCodes1] FOREIGN KEY([SubSystemID])
REFERENCES [dbo].[tblComponentCodes] ([ComponentCodeID])
GO

ALTER TABLE [dbo].[tblSubSystems] CHECK CONSTRAINT [FK_tblSubSystems_tblComponentCodes1]
GO
