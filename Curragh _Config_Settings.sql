--WOS import = every 2 minutes
--External Downtime = 1
--AutoCreateExtEvent = 1
--MaxPlanningWOtoCreate = 5 
--AutoLookupPartsReadyStatus = 1
--AuthorisationMode = 0
---------------------------------------------------------------------------------------------

-- Update System Task
update AMT_SYSTEM_TASK
Set Frequency=2,Frequency_UOM_Id=2
Where Task_Name='Live - eAM WorkorderSettlement Import'

-- Update AMT Feature

--update AMT_FEATURE
--set Feature_Enabled=1
--where Feature_Id = 18

update AMT_FEATURE
set Feature_Enabled=1
where Feature_Name = 'External Downtime'

-- Update AMT Varilable
update AMT_VARIABLE set AutoCreateExtEvent=1

update AMT_VARIABLE set AuthorisationMode=0

--Update AMT_Typed Variable

update AMT_TYPED_VARIABLE
set Varchar_Value=5
where Value_Name='MaxPlanningWOtoCreate'

update AMT_TYPED_VARIABLE
set Varchar_Value=1
where Value_Name = 'AutoLookupPartsReadyStatus'