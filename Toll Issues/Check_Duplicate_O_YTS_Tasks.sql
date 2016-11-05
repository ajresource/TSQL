select EQ.EQpplan,TH.Description,B.Strategy_Date,B.description,B.Task_Count,B.* from isipl_AMT_Toll_87_20130918..EQUIPMENT_HIERARCHY_V EQ 
INNER JOIN
(select Eqp_Plan_ID,Task_Header_ID,Strategy_Date,description,count(*) as Task_Count from TASK
where Strategy_date IS NOT NULL AND Task_Status_ID IN (1,6)--- AND S_Task_ID IS NULL*/
group by Eqp_Plan_ID,Task_Header_ID,Strategy_Date,description,Strategy_Usage
having count(*)>1) B 
ON B.Eqp_Plan_ID=EQ.EqpPlanID AND EQ.Projection_Type_ID=1
INNER JOIN TASK_HEADER TH ON TH.Task_Header_ID=B.Task_Header_ID
order by B.Task_Count
