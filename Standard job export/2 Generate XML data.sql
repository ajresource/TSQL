declare @p15 int
set @p15=500
exec KIRD_EXPORT_P @mode=0,@isCodeMap=0,@Branch='DITCHFIELD CONTRACTING',@Price_Group='DEFAULT',
@Model='',@ComponentCode='',
@JobCode='',@Currency='',
@SimulationRef='',@isLive=1,
@System_Source='',@isDummy=2,
@JobIDs='
--Enter Std Job References
',
@NewSimulationRef='',@NRecords=@p15 output
select @p15