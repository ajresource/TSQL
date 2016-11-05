
declare @p15 int
set @p15=NULL
exec KIRD_IMPORT_P @doc='
<?xml version="1.0" encoding="UTF-8"?><I_STD_JOBs>
</I_STD_JOBs>
'
,@mode=0,@isCodeMap=0,@Model='',@ComponentCode='',@JobCode='',@Currency='',@SimulationRef='',@isExisting=2,@JobIDs='',@NewSimulationRef='',@isLive=2,@NewCurrency='',@NewRate=1,@NRecords=@p15 output
select @p15

GO
