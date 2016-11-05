
declare @none_ID varchar(10)
declare @GR_ID varchar(10)

select @none_ID=TaskTypeID from tblTaskTypes where Code='0'
select @GR_ID=TaskTypeID from tblTaskTypes where Code='GR'

select '------ Converting Task type ID from '+@none_ID+' to '+@GR_ID+' -------'

update TASK set Task_Type_ID=@GR_ID where Task_Type_ID=@none_ID

Exec TASK_HEADERS_UPDATE_ALL_P
Exec TASK_WORKORDER_FIX_P
Exec STRATEGY_TASK_LINK_TO_EQS_TASK_P
GO