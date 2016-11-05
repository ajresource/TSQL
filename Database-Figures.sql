use isipl_amt_BHJ_86
select 'Site Name' AS Item ,'BHJ' AS Details UNION ALL
select 'Total Number of Equipment',CONVERT(VARCHAR,COUNT(*)) from EQUIPMENT_HIERARCHY_V where EqpPlan is not null UNION ALL
select 'Number of Real Equipment',CONVERT(VARCHAR,COUNT(*)) from EQUIPMENT_HIERARCHY_V where EqpPlan is not null and Projection_Type_ID=1 UNION ALL
select 'Number of WorkOrder Settlements',CONVERT(VARCHAR,COUNT(*)) from tblWorkOrders UNION ALL
select 'Total Number of Projected Tasks',CONVERT(VARCHAR,COUNT(*)) from tblProjTasks UNION ALL
select 'Number of Projected Tasks (Current)',CONVERT(VARCHAR,COUNT(*)) from tblProjTasks PT
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjID=PT.EqpprojID
where EQ.Projection_Type_ID=1 UNION ALL
select 'Number of Active Users',CONVERT(VARCHAR,COUNT(*)) from AMT_USER where Terminated=0 UNION ALL
select Equipment_Name,CONVERT(VARCHAR,COUNT(*)) from BUDGET_EQUIPMENT 
group by Equipment_Name 
 
use isipl_amt_KAL_86
select 'Site Name' AS Item ,'KAL' AS Details UNION ALL
select 'Total Number of Equipment',CONVERT(VARCHAR,COUNT(*)) from EQUIPMENT_HIERARCHY_V where EqpPlan is not null UNION ALL
select 'Number of Real Equipment',CONVERT(VARCHAR,COUNT(*)) from EQUIPMENT_HIERARCHY_V where EqpPlan is not null and Projection_Type_ID=1 UNION ALL
select 'Number of WorkOrder Settlements',CONVERT(VARCHAR,COUNT(*)) from tblWorkOrders UNION ALL
select 'Total Number of Projected Tasks',CONVERT(VARCHAR,COUNT(*)) from tblProjTasks UNION ALL
select 'Number of Projected Tasks (Current)',CONVERT(VARCHAR,COUNT(*)) from tblProjTasks PT
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjID=PT.EqpprojID
where EQ.Projection_Type_ID=1 UNION ALL
select 'Number of Active Users',CONVERT(VARCHAR,COUNT(*)) from AMT_USER where Terminated=0 UNION ALL
select Equipment_Name,CONVERT(VARCHAR,COUNT(*)) from BUDGET_EQUIPMENT 
group by Equipment_Name 

use isipl_amt_SKO_86
select 'Site Name' AS Item ,'SKO' AS Details UNION ALL
select 'Total Number of Equipment',CONVERT(VARCHAR,COUNT(*)) from EQUIPMENT_HIERARCHY_V where EqpPlan is not null UNION ALL
select 'Number of Real Equipment',CONVERT(VARCHAR,COUNT(*)) from EQUIPMENT_HIERARCHY_V where EqpPlan is not null and Projection_Type_ID=1 UNION ALL
select 'Number of WorkOrder Settlements',CONVERT(VARCHAR,COUNT(*)) from tblWorkOrders UNION ALL
select 'Total Number of Projected Tasks',CONVERT(VARCHAR,COUNT(*)) from tblProjTasks UNION ALL
select 'Number of Projected Tasks (Current)',CONVERT(VARCHAR,COUNT(*)) from tblProjTasks PT
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjID=PT.EqpprojID
where EQ.Projection_Type_ID=1 UNION ALL
select 'Number of Active Users',CONVERT(VARCHAR,COUNT(*)) from AMT_USER where Terminated=0 UNION ALL
select Equipment_Name,CONVERT(VARCHAR,COUNT(*)) from BUDGET_EQUIPMENT 
group by Equipment_Name 

use isipl_amt_TTD_86
select 'Site Name' AS Item ,'TTD' AS Details UNION ALL
select 'Total Number of Equipment',CONVERT(VARCHAR,COUNT(*)) from EQUIPMENT_HIERARCHY_V where EqpPlan is not null UNION ALL
select 'Number of Real Equipment',CONVERT(VARCHAR,COUNT(*)) from EQUIPMENT_HIERARCHY_V where EqpPlan is not null and Projection_Type_ID=1 UNION ALL
select 'Number of WorkOrder Settlements',CONVERT(VARCHAR,COUNT(*)) from tblWorkOrders UNION ALL
select 'Total Number of Projected Tasks',CONVERT(VARCHAR,COUNT(*)) from tblProjTasks UNION ALL
select 'Number of Projected Tasks (Current)',CONVERT(VARCHAR,COUNT(*)) from tblProjTasks PT
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjID=PT.EqpprojID
where EQ.Projection_Type_ID=1 UNION ALL
select 'Number of Active Users',CONVERT(VARCHAR,COUNT(*)) from AMT_USER where Terminated=0 UNION ALL
select Equipment_Name,CONVERT(VARCHAR,COUNT(*)) from BUDGET_EQUIPMENT 
group by Equipment_Name 