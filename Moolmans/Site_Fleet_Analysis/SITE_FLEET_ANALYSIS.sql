DECLARE @Fleet Varchar(20)
DECLARE @Site Varchar(20)
DECLARE @Branch Varchar(20)
DECLARE @Period INT

-- SET VALUES HERE
Set @Fleet = 'Mining'
Set @Site = 'Geita'
set @Branch = 'Geita'
Set @Period = 201212


SELECT     dbo.tblSites.Site, dbo.tblFleets.Fleet, COUNT(dbo.tblEqpPlans.EqpPlanId) AS [#Equip]
FROM         dbo.tblFleets INNER JOIN
                      dbo.tblEqpPlans ON dbo.tblFleets.FleetId = dbo.tblEqpPlans.FleetId INNER JOIN
                      dbo.tblSites ON dbo.tblFleets.SiteId = dbo.tblSites.SiteId
WHERE     (dbo.tblFleets.FleetID IN( select FleetID from tblFleets where SiteID IN
                      (select SiteID from tblSites where BranchID IN 
                      (select BranchID from tblBranches where Branch like '%'+@Branch+'%')))
                      AND dbo.tblFleets.Fleet Like '%' + @Fleet+ '%'
                      AND (dbo.tblEqpPlans.Eqp_Terminated = 0))
GROUP BY dbo.tblSites.Site, dbo.tblFleets.Fleet
HAVING      (dbo.tblSites.Site Like'%' + @Site + '%')





SELECT     YEAR(dbo.EVENT.Actual_Down_Time) * 100 + MONTH(dbo.EVENT.Actual_Down_Time) AS Period, dbo.tblSites.Site,  
                      dbo.tblTaskTypes.Code AS TaskType, dbo.tblTaskTypes.Description, COUNT(DISTINCT dbo.TASK.Task_ID) AS [#Workorders]
FROM         dbo.TASK INNER JOIN
                      dbo.EVENT ON dbo.TASK.Event_ID = dbo.EVENT.Event_ID INNER JOIN
                      dbo.tblEqpPlans ON dbo.EVENT.Eqp_Plan_ID = dbo.tblEqpPlans.EqpPlanId INNER JOIN
                      dbo.tblFleets ON dbo.tblEqpPlans.FleetId = dbo.tblFleets.FleetId INNER JOIN
                      dbo.tblSites ON dbo.tblFleets.SiteId = dbo.tblSites.SiteId INNER JOIN
                      dbo.tblTaskTypes ON dbo.TASK.Task_Type_ID = dbo.tblTaskTypes.TaskTypeID
WHERE     (dbo.tblFleets.FleetID IN( select FleetID from tblFleets where SiteID IN
                      (select SiteID from tblSites where BranchID IN 
                      (select BranchID from tblBranches where Branch like '%'+@Branch+'%')))
                      AND dbo.tblFleets.Fleet Like '%' + @Fleet+ '%')
GROUP BY YEAR(dbo.EVENT.Actual_Down_Time) * 100 + MONTH(dbo.EVENT.Actual_Down_Time), dbo.tblSites.Site, dbo.tblTaskTypes.Code, 
                      dbo.tblTaskTypes.Description
HAVING      (YEAR(dbo.EVENT.Actual_Down_Time) * 100 + MONTH(dbo.EVENT.Actual_Down_Time) = @Period) AND (dbo.tblSites.Site LIKE '%' + @Site + '%')


SELECT     YEAR(dbo.EVENT.Actual_Down_Time) * 100 + MONTH(dbo.EVENT.Actual_Down_Time) AS Period, dbo.tblSites.Site, 
                      dbo.tblTaskTypes.Code AS TaskType, dbo.tblComponentCodes.Code AS CompCode, dbo.tblComponentCodes.Description, 
                      COUNT(DISTINCT dbo.TASK.Task_ID) AS [#Workorders]
FROM         dbo.TASK INNER JOIN
                      dbo.EVENT ON dbo.TASK.Event_ID = dbo.EVENT.Event_ID INNER JOIN
                      dbo.tblEqpPlans ON dbo.EVENT.Eqp_Plan_ID = dbo.tblEqpPlans.EqpPlanId INNER JOIN
                      dbo.tblFleets ON dbo.tblEqpPlans.FleetId = dbo.tblFleets.FleetId INNER JOIN
                      dbo.tblSites ON dbo.tblFleets.SiteId = dbo.tblSites.SiteId INNER JOIN
                      dbo.tblTaskTypes ON dbo.TASK.Task_Type_ID = dbo.tblTaskTypes.TaskTypeID INNER JOIN
                      dbo.tblComponentCodes ON dbo.TASK.Component_Code_ID = dbo.tblComponentCodes.ComponentCodeID
WHERE     (dbo.tblFleets.FleetID IN( select FleetID from tblFleets where SiteID IN
                      (select SiteID from tblSites where BranchID IN 
                      (select BranchID from tblBranches where Branch like '%'+@Branch+'%')))
                      AND dbo.tblFleets.Fleet Like '%' + @Fleet+ '%')
                      
GROUP BY YEAR(dbo.EVENT.Actual_Down_Time) * 100 + MONTH(dbo.EVENT.Actual_Down_Time), dbo.tblSites.Site, dbo.tblTaskTypes.Code, 
                      dbo.tblComponentCodes.Code, dbo.tblComponentCodes.Description
HAVING      (YEAR(dbo.EVENT.Actual_Down_Time) * 100 + MONTH(dbo.EVENT.Actual_Down_Time) = @Period) AND (dbo.tblSites.Site LIKE '%' + @Site + '%') AND 
                      (dbo.tblTaskTypes.Code = 'GI')
                      
