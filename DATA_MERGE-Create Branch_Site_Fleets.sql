
--- BACCAN -SOURCE ; Wes - DESTINATION
/*
-- Find this code an change are required

SELECT 
DISTINCT Branch,Site,Fleet 
INTO zz_BranchSiteFleet
FROM dbo.EQUIPMENT_HIERARCHY_V WHERE Cost_Responsibility_ID=@Cost_Responsibility_ID
GO


*/

/*
---ADD PRICE GROUP 
FIND BELOW CODE AND CHANGE AS REQUIRED TO GET THE PRICE GROUP

SELECT @Price_Group_ID=Price_Group_ID FROM dbo.PRICE_GROUP WHERE Price_Group='CANDEFAULT'

*/
USE BUCAUS
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zz_BranchSiteFleet]') AND type in (N'U'))
DROP TABLE [dbo].[zz_BranchSiteFleet]
GO

--DECLARE @Cost_Responsibility_ID INT
--SET @Cost_Responsibility_ID=9

SELECT 
DISTINCT Branch,Site,Fleet 
INTO zz_BranchSiteFleet
FROM dbo.EQUIPMENT_HIERARCHY_V WHERE Cost_Responsibility_ID=8 or FleetId=399 or [SiteId] = '59' or [SiteId] = '190'
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zz_Sites]') AND type in (N'U'))
DROP TABLE [dbo].[zz_Sites]
GO

SELECT DISTINCT S.Site,S.Shifts_Start_Time 
INTO zz_Sites
FROM dbo.tblSites S INNER JOIN 
zz_BranchSiteFleet BSF ON S.Site=BSF.SITE

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zz_Fleets]') AND type in (N'U'))
DROP TABLE [dbo].[zz_Fleets]
GO

declare @Price_Group_ID INT
SET @Price_Group_ID=0

select DISTINCT F.Fleet, F.Service_Interval, F.Service_Tolerance,@Price_Group_ID AS Price_Group_ID,F.SalesToolFleet,F.Availability_Type_ID
INTO zz_Fleets
FROM dbo.tblFleets F  INNER JOIN 
zz_BranchSiteFleet BSF ON F.Fleet=BSF.Fleet
GO

USE Wes
---------- ADD Branches -----------------------

DECLARE @Branch VARCHAR(MAX)

DECLARE theCursorBranch CURSOR FOR	

SELECT DISTINCT Branch FROM BUCAUS..zz_BranchSiteFleet
 
OPEN theCursorBranch
FETCH NEXT FROM theCursorBranch INTO @Branch
WHILE @@fetch_status = 0
BEGIN 
 exec BRANCH_ADD_P @Branch=@Branch
	 
FETCH NEXT FROM theCursorBranch INTO @Branch 
END
CLOSE theCursorBranch
DEALLOCATE theCursorBranch
GO
----- ADD Sites ----


DECLARE @Branch_ID VARCHAR(MAX)
DECLARE @Site VARCHAR(MAX)
DECLARE @Shift_Start_Time VARCHAR(MAX)

DECLARE theCursorSite CURSOR FOR	

SELECT DISTINCT Site FROM BUCAUS..zz_Sites

OPEN theCursorSite
FETCH NEXT FROM theCursorSite INTO @Site
WHILE @@fetch_status = 0
BEGIN 

SELECT @Branch_ID=B.BranchId FROM tblBranches B INNER JOIN
BUCAUS..zz_BranchSiteFleet BSF ON B.Branch=BSF.Branch INNER JOIN 
BUCAUS..zz_sites S ON S.Site=BSF.SITE
where S.SITE=@site 

SELECT @Shift_Start_Time=Shifts_Start_Time FROM BUCAUS..zz_Sites WHERE Site=@site 
SELECT @Shift_Start_Time = CONVERT(datetime,@Shift_Start_Time)
exec SITE_ADD_P @BranchId=@Branch_ID,@Site=@Site,@Shifts_Start_Time=@Shift_Start_Time
	 
FETCH NEXT FROM theCursorSite INTO @Site 
END
CLOSE theCursorSite
DEALLOCATE theCursorSite
GO
-- Add Fleets

DECLARE @Site_ID VARCHAR(MAX)
DECLARE @Fleet VARCHAR(MAX)
declare @ServiceInterval int
Declare @ServiceTolerance int
declare @SalesToolFleet int
declare @AvailabilityTypeID INT
declare @Price_Group_ID INT


DECLARE theCursorFleet CURSOR FOR	

SELECT DISTINCT Fleet FROM BUCAUS..zz_Fleets

OPEN theCursorFleet
FETCH NEXT FROM theCursorFleet INTO @Fleet
WHILE @@fetch_status = 0
BEGIN 

SELECT @Site_ID=S.SiteId FROM tblSites S INNER JOIN
BUCAUS..zz_BranchSiteFleet BSF ON S.Site=BSF.Site INNER JOIN 
BUCAUS..zz_Fleets zF ON zF.Fleet=BSF.Fleet
where zF.Fleet=@Fleet 

SELECT @Price_Group_ID=Price_Group_ID FROM dbo.PRICE_GROUP WHERE Price_Group='AUSDEFAULT'
SELECT @ServiceInterval=Service_Interval, @ServiceTolerance=Service_Tolerance,@SalesToolFleet=SalesToolFleet,@AvailabilityTypeID=Availability_Type_ID FROM BUCAUS..zz_fleets WHERE Fleet=@fleet
--SELECT @Fleet,@Site_ID,@ServiceInterval,@ServiceTolerance,@Price_Group_ID,@SalesToolFleet,@AvailabilityTypeID
exec FLEET_ADD_P @Fleet=@Fleet,@SiteId=@Site_ID,@ServiceInterval=@ServiceInterval,@ServiceTolerance=@ServiceTolerance,@PricingGroupId=@Price_Group_ID,@SalesToolFleet=@SalesToolFleet,@AvailabilityTypeId=@AvailabilityTypeID

FETCH NEXT FROM theCursorFleet INTO @Fleet 
END
CLOSE theCursorFleet
DEALLOCATE theCursorFleet

------Testing ----
SELECT Branch FROM BUCAUS..zz_BranchSiteFleet WHERE Branch NOT IN
(SELECT Branch FROM dbo.tblBranches)
GO
DECLARE @aa VARCHAR(MAX)
SELECT @aa=Branch +'@'+ Site FROM BUCAUS..zz_BranchSiteFleet
SELECT Branch, Site FROM BUCAUS..zz_BranchSiteFleet  WHERE @aa
NOT IN (SELECT B.Branch +'@'+ S.Site FROM tblSites S INNER JOIN
dbo.tblBranches B ON S.BranchId=B.BranchId)
GO
DECLARE @aa VARCHAR(MAX)
SELECT @aa=Site +'@'+ Fleet FROM BUCAUS..zz_BranchSiteFleet
SELECT Site, Fleet FROM BUCAUS..zz_BranchSiteFleet  WHERE @aa
NOT IN (SELECT S.Site +'@'+ F.Fleet FROM dbo.tblFleets F  INNER JOIN
dbo.tblSites S ON F.SiteId = S.SiteId)

USE BUCAUS
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zz_BranchSiteFleet]') AND type in (N'U'))
DROP TABLE [dbo].[zz_BranchSiteFleet]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zz_Sites]') AND type in (N'U'))
DROP TABLE [dbo].[zz_Sites]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zz_Fleets]') AND type in (N'U'))
DROP TABLE [dbo].[zz_Fleets]
GO
