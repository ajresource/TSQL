--select * from AMT_SYSTEM_TASK
update AMT_SYSTEM_TASK 
set is_Auto_Run=1
where Task_Name='CBM Action Process'
select * from AMT_SYSTEM_TASK where Task_Name='CBM Action Process'


update AMT_TYPED_VARIABLE 
SET Varchar_Value='AMTSupport@downeredimining.com'
where Value_Name='FromEmailAddress'
select * from AMT_TYPED_VARIABLE  where Value_Name='FromEmailAddress'


update AMT_TYPED_VARIABLE 
SET Varchar_Value='FALSE'
where Value_Name='SMTPEnableSsl'
select * from AMT_TYPED_VARIABLE  where Value_Name='SMTPEnableSsl'


update AMT_TYPED_VARIABLE 
SET Varchar_Value='192.168.200.12'
where Value_Name='SMTPHost'
select * from AMT_TYPED_VARIABLE  where Value_Name='SMTPHost'


update AMT_TYPED_VARIABLE 
SET Varchar_Value='25'
where Value_Name='SMTPPort'
select * from AMT_TYPED_VARIABLE  where Value_Name='SMTPPort'