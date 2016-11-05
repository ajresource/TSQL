/******************************************************************************
File: 	amt_0_AMT_Function.sql

Description:	Creates / updates the AMT Functions

Instructions: Insert your comment below this line in the format  DATE AUTHOR(INITIALS) ACTION (Add/Mod/Del) and ID
Change History - Most Recent at Top

**************************************************************************************************************	

Date		Au	Act	IssueID, FunctionID
03 May 12   GD  Mod 4102, 556
30 Apr 12   JW  E793		 563
23 Apr 12	VV	E779 
13 Apr 12   GD  Add E777     561

***END OF COMMENTS***********************************************************************************************************/
--Deletion


IF EXISTS(SELECT Function_Id FROM AMT_FUNCTION  WHERE Function_Id = 561   )  BEGIN UPDATE AMT_FUNCTION SET Function_Name = 'Part Classification',Function_Description='Parts classification is a system table that allows users to define the relevant approach for rebuilding rotable components. 


It is particularly important for the component capacity management functionality as you can define which rotable component cores are retained in the system vs those that leave the system. 

It also allows you to produce forecasts by supplier or specific rebuild centre.',Function_Tips='This enables users to distinguish between reman and exchange and also between different rebuild workshops and suppliers.',Report_Section_Name='',Report_Init_Param='' ,Feature_ID =NULL  WHERE Function_Id = 561   END  ELSE  BEGIN INSERT INTO AMT_FUNCTION(Function_ID,Function_Name,Feature_ID,Is_Report,Function_Description,Function_Tips,Report_Section_Name,Report_Init_Param) VALUES (561,'Part Classification',NULL,0,'Parts classification is a system table that allows users to define the relevant approach for rebuilding rotable components. 


It is particularly important for the component capacity management functionality as you can define which rotable component cores are retained in the system vs those that leave the system. 

It also allows you to produce forecasts by supplier or specific rebuild centre.','This enables users to distinguish between reman and exchange and also between different rebuild workshops and suppliers.','','') END

IF EXISTS(SELECT Function_Id FROM AMT_FUNCTION  WHERE Function_Id = 562   )  BEGIN UPDATE AMT_FUNCTION SET Function_Name = 'Forecast Rotables Stock',Function_Description='This report displays per month the quantity of rotable components available for use. 

A positive number indicates excess stock on hand, a negative number indicates shortage and zero indicates supply equalled demand in the month. 

The report also contains four KPIs: Total Period Demand, Maximum Stock Level, Minimum Stock Level and Annualised Stock Turn. 

Data for this report is sourced from the Inventory Parts Table, Parts Table and Strategy Tasks (Next Due and Projected).',Function_Tips='Use this report to validate whether there are sufficient rotables to meet future demand. 

If shortages exist, then look “move” stock excesses to the month of shortage through adjusting Next Due dates/usage of Strategy Tasks, 
optimising turn time (update Total Budget Turn Time in Parts Manager) 
and/or purchasing new rotable parts into stock (increasing parts on order in the Inventory Parts table)',Report_Section_Name='Rpt_562_Forecast_Rotables_Stock',Report_Init_Param='|ControlType|,|IDlist|,|TextList|,|UserID|' ,Feature_ID =NULL  WHERE Function_Id = 562   END  ELSE  BEGIN INSERT INTO AMT_FUNCTION(Function_ID,Function_Name,Feature_ID,Is_Report,Function_Description,Function_Tips,Report_Section_Name,Report_Init_Param) VALUES (562,'Forecast Rotables Stock',NULL,1,'This report displays per month the quantity of rotable components available for use.  

A positive number indicates excess stock on hand, a negative number indicates shortage and zero indicates supply equalled demand in the month.  

The report also contains four KPIs: Total Period Demand, Maximum Stock Level, Minimum Stock Level and Annualised Stock Turn. 

Data for this report is sourced from the Inventory Parts Table, Parts Table and Strategy Tasks (Next Due and Projected).','Use this report to validate whether there are sufficient rotables to meet future demand.  

If shortages exist, then look “move” stock excesses to the month of shortage through adjusting Next Due dates/usage of Strategy Tasks, 
optimising turn time (update Total Budget Turn Time in Parts Manager) 
and/or purchasing new rotable parts into stock (increasing parts on order in the Inventory Parts table)','Rpt_562_Forecast_Rotables_Stock','|ControlType|,|IDlist|,|TextList|,|UserID|') END

IF EXISTS(SELECT Function_Id FROM AMT_FUNCTION  WHERE Function_Id = 563   )  BEGIN UPDATE AMT_FUNCTION SET Function_Name = 'Rebuild Centre Forecast Workload',Function_Description='This report is useful for rebuild centres to forecast their future workload. The report also takes into consideration rebuild work currently in progress. If the workload is too high in certain periods, contact those responsible for the component forecast to assess whether a rebuild can be pushed out/brought forward or transferring the rebuild to a different location.',Function_Tips='Use Review and Sales status filters to understand actual vs. potential workload.',Report_Section_Name='Rpt_563_Rebuild_Centre_Forecast_Workload',Report_Init_Param='|ControlType|,|IDlist|,|TextList|,|LogoLocation|,|UserID|' ,Feature_ID =NULL  WHERE Function_Id = 563   END  ELSE  BEGIN INSERT INTO AMT_FUNCTION(Function_ID,Function_Name,Feature_ID,Is_Report,Function_Description,Function_Tips,Report_Section_Name,Report_Init_Param) VALUES (563,'Rebuild Centre Forecast Workload',NULL,1,'This report is useful for rebuild centres to forecast their future workload.  The report also takes into consideration rebuild work currently in progress.    If the workload is too high in certain periods, contact those responsible for the component forecast to assess whether a rebuild can be pushed out/brought forward or transferring the rebuild to a different location.','Use Review and Sales status filters to understand actual vs. potential workload.','Rpt_563_Rebuild_Centre_Forecast_Workload','|ControlType|,|IDlist|,|TextList|,|LogoLocation|,|UserID|') END 

IF EXISTS(SELECT Function_Id FROM AMT_FUNCTION  WHERE Function_Id = 556   )  BEGIN UPDATE AMT_FUNCTION SET Function_Name = 'Projection Summary and Cost per Interval - Modelling',Function_Description='This report provides a summary of Equipment Lifecycle costs along with an analysis of costs per interval.',Function_Tips='The interval is provided by the user when the report is run.',Report_Section_Name='Rpt_556_Projection_Summary_and_Cost_per_Interval',Report_Init_Param='|ControlType|,|IDlist|,|TextList|,|Enable_Cost_At_Cost|,|CostBearer|,|ProjectionTypes|,|UserID|' ,Feature_ID =NULL  WHERE Function_Id = 556   END  ELSE  BEGIN INSERT INTO AMT_FUNCTION(Function_ID,Function_Name,Feature_ID,Is_Report,Function_Description,Function_Tips,Report_Section_Name,Report_Init_Param) VALUES (556,'Projection Summary and Cost per Interval - Modelling',NULL,1,'This report provides a summary of Equipment Lifecycle costs along with an analysis of costs per interval.','The interval is provided by the user when the report is run.','Rpt_556_Projection_Summary_and_Cost_per_Interval','|ControlType|,|IDlist|,|TextList|,|Enable_Cost_At_Cost|,|CostBearer|,|ProjectionTypes|,|UserID|') END 