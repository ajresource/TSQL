--create table zz_Branch (
--Code Varchar(10),
--Name Varchar(50))

--create table zz_Site (
--Code Varchar(10),
--Name Varchar(50),
--Branch_Name varchar(10),
--Time_D int,
--Shift_Start varchar(10)
--)

--create table zz_Fleet (
--Name varchar(50),
--Site varchar(50),
--Price_Group varchar(50),
--S_Interval int,
--S_Tolerence int,
--Availability_Type varchar(50)
--)

--GO

--DECLARE @Name VARCHAR(MAX)
--DECLARE @Code VARCHAR(MAX)

--DECLARE theCursorBranch CURSOR FOR	

--SELECT  Name FROM zz_Branch

--OPEN theCursorBranch
--FETCH NEXT FROM theCursorBranch INTO @Name
--WHILE @@fetch_status = 0
--BEGIN 
--select @Code=Code from zz_Branch where Name=@Name  
--exec BRANCH_ADD_P @Branch=@Name, @BranchCode=@Code

--FETCH NEXT FROM theCursorBranch INTO @Name 
--END
--CLOSE theCursorBranch
--DEALLOCATE theCursorBranch
--GO


--DECLARE @Branch_ID VARCHAR(MAX)
--DECLARE @Site VARCHAR(MAX)
--DECLARE @Shift_Start_Time VARCHAR(MAX)
--DECLARE @SiteCode VARCHAR(MAX)
--DECLARE @TimeOffset VARCHAR(MAX)

--DECLARE theCursorSite CURSOR FOR	

--SELECT Name FROM zz_Site

--OPEN theCursorSite
--FETCH NEXT FROM theCursorSite INTO @Site
--WHILE @@fetch_status = 0
--BEGIN 
--select @Branch_ID=BranchID from tblBranches where Branch_Code IN (select Branch_Name from zz_Site where Name=@Site)
--select @SiteCode=Code, @TimeOffset=Time_D from zz_Site where Name=@Site
--exec SITE_ADD_P @BranchId=@Branch_ID,@Site=@Site,@SiteCode=@SiteCode,@TimeOffset=@TimeOffset--,@Shifts_Start_Time=
----select 	 @Branch_ID,@Site,@SiteCode,@TimeOffset
--FETCH NEXT FROM theCursorSite INTO @Site 
--END
--CLOSE theCursorSite
--DEALLOCATE theCursorSite
--GO


DECLARE @Site_ID VARCHAR(MAX)
DECLARE @Fleet VARCHAR(MAX)
declare @ServiceInterval int
Declare @ServiceTolerance int
declare @SalesToolFleet int
declare @AvailabilityTypeID INT
declare @Price_Group_ID INT


DECLARE theCursorFleet CURSOR FOR	

SELECT Name FROM zz_Fleet

OPEN theCursorFleet
FETCH NEXT FROM theCursorFleet INTO @Fleet
WHILE @@fetch_status = 0
BEGIN 

select @Site_ID=SiteID from tblSites where Site IN (Select Site from zz_Fleet where Name=@Fleet)
SELECT @ServiceInterval=S_Interval, @ServiceTolerance=S_Tolerence, @AvailabilityTypeID=1, @Price_Group_ID=1 FROM zz_Fleet WHERE Name=@fleet

--SELECT @Fleet,@Site_ID,@ServiceInterval,@ServiceTolerance,@Price_Group_ID,@SalesToolFleet,@AvailabilityTypeID
exec FLEET_ADD_P @Fleet=@Fleet,@SiteId=@Site_ID,@ServiceInterval=@ServiceInterval,@ServiceTolerance=@ServiceTolerance,@PricingGroupId=@Price_Group_ID/*,@SalesToolFleet=@SalesToolFleet*/,@AvailabilityTypeId=@AvailabilityTypeID

FETCH NEXT FROM theCursorFleet INTO @Fleet 
END
CLOSE theCursorFleet
DEALLOCATE theCursorFleet
