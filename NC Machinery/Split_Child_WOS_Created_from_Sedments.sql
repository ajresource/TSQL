-- STOP SERVICES
update tblWorkorders
set Ext_Segment_ID='01',PureWONumber=WorkOrderNumber,AMTParentWorkOrderID=WorkorderID, ForcedChild=0

GO

truncate table tblUnlinkedWO 

GO 

insert into  tblUnlinkedWO
select WorkorderID from tblWorkorders 

GO

EXEC REPLAN_START_P
select getdate()
GO
EXEC RECALC_START_P @DirtyOnly=0
select getdate()
