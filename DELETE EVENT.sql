select * from EVENT where description like 'TEST%'


delete from TASK_OPERATION_LABOUR where Task_Operation_Id
IN 
(select Task_Operation_Id from TASK_OPERATION where Task_ID IN (
select Task_ID from TASK where Event_ID=388964))

delete from TASK_OPERATION where Task_ID IN (
select Task_ID from TASK where Event_ID=388964)

delete from task where Event_ID=388964

delete from DOWN_TIME_ALLOCATION where Event_ID=388964

delete from EVENT where Event_ID=388964