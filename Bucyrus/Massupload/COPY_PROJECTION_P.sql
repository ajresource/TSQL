
ALTER PROCEDURE COPY_PROJECTION_P  
/******************************************************************************  
 Name: COPY_PROJECTION_P  
  
 Desc: Copy the projection from one equipment to another  
  
  
 Auth: AJ 
 Date: 16-Jan-2013  
*******************************************************************************  
  Change History  
*******************************************************************************  
Date:  Author:  Description:  

-------- -------- ----------------------------------------  

*******************************************************************************/  
 /* Param List */  
 
@SourceEqp VARCHAR(200), 
@DestEqp VARCHAR(200),  
@CopyFrequency BIT = 0,  
@CopyParts BIT = 0,
@ProjectionName VARCHAR(200)='Centreline'
AS 

SET XACT_ABORT ON  

/*CHECK DATA*/

IF NOT EXISTS(SELECT * FROM tblEqpPlans WHERE Eqpplan=@SourceEqp)
BEGIN
select 'ERROR: Source Equipment ('+@SourceEqp+') is not valid, Please check the Equipment and try again'
RETURN
END


IF NOT EXISTS(SELECT * FROM tblEqpPlans WHERE Eqpplan=@DestEqp)
BEGIN
select 'ERROR: Destination Equipment ('+@DestEqp+') is not valid, Please check the Equipment and try again'
RETURN
END
  
IF NOT EXISTS(SELECT * FROM EQUIPMENT_HIERARCHY_V EQ
inner join PROJECTION_HEADER PH ON PH.Projection_Header_ID=EQ.ProjHeaderID
 where EQ.EqpPlan=@SourceEqp AND Projection_Name=@ProjectionName)
BEGIN
select 'ERROR: There is no '+@ProjectionName+' Projection for Equipment '+@SourceEqp+''
RETURN
END
  
IF @SourceEqp=@DestEqp
BEGIN
select 'ERROR: Source and the destination Equipment name cannot be the same'
RETURN
END

select 'Copying data from Equipment= '+@SourceEqp+' Projection= '+@ProjectionName+'To Equipment= '+@DestEqp+' Projection = Current'

--- BACKUP OLD PROJECTION FROM DESTINATION EQUIPMENT

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZZ_OLD_PROJECTION]') AND type in (N'U'))
DROP TABLE [dbo].[ZZ_OLD_PROJECTION]


SELECT EQ.EqpplanID,EQ.EqPplan,EQ.Projection_Type_ID,EQ.Projection_Type_Name,PJ.ProjTaskId,
PJ.ComponentCodeId,PJ.ModifierId,PJ.TaskTypeId,PJ.ApplicationCodeId,PJ.First,PJ.Frequency,PJ.Final,PJ.Last_Change_Usage,
PJ.Last_Change_Date,PJ.Part_Id,PJ.Group_Number
INTO ZZ_OLD_PROJECTION
FROM tblProjtasks PJ 
	INNER JOIN EQUIPMENT_HIERARCHY_V EQ ON PJ.EqpprojID=EQ.EqpProjID
where EQ.Eqpplan= @DestEqp and EQ.Projection_Type_ID=1

/*DELETE DATA FROM DESTINATION EQUIPEMTN*/

DECLARE @Task_ID INT
DECLARE @projTaskID INT
DECLARE DELPROJ CURSOR FAST_FORWARD FOR
SELECT projTaskID FROM ZZ_OLD_PROJECTION
OPEN DELPROJ
FETCH NEXT FROM DELPROJ INTO @projTaskID
WHILE @@FETCH_STATUS = 0
BEGIN

-- DELETE STRATEGY_WORKORDERS
	
select @Task_ID=Task_ID from TASK T
inner join tblprojtaskOpts PTO ON PTO.ProjtaskOptID=T.Strategy_Proj_Task_Opt_ID
inner join tblProjtasks PT ON PT.ProjtaskID=PTO.ProjtaskID
where PT.ProjtaskID=@ProjtaskID

IF @Task_ID IS NOT NULL
EXEC [TASK_DELETE_BY_ID_P] @Task_ID=@Task_ID,@Error_Message=NULL  

--DELETE PROJECTED TASKS
	exec [usp_Delete_Proj_Task] @projTaskID=@projTaskID,@forceDelete=1



select @Task_ID=NULL

	FETCH NEXT FROM DELPROJ INTO @projTaskID
END
CLOSE DELPROJ
DEALLOCATE DELPROJ


-- COPY PROJECTION 
DECLARE @fromEqpPlanId INT
DECLARE @toEqpPlanId INT
DECLARE @toFleetId INT
DECLARE @fromEqpProjHeaderId INT
DECLARE @fromProjTaskHeaderId INT
DECLARE @Message varchar(8000)

UPDATE AMT_VARIABLE SET Filter_Std_Job_Model=0

DECLARE Cur CURSOR FAST_FORWARD FOR
SELECT EQ.EqpplanID,EQ.ProjHeaderID,PJ.Task_Header_ID FROM EQUIPMENT_HIERARCHY_V EQ
inner join tblProjtasks PJ ON PJ.EqpProjID=EQ.EqpprojID
inner join PROJECTION_HEADER PH ON PH.Projection_Header_ID=EQ.ProjHeaderID
where EQ.EqpPlan=@SourceEqp AND PH.Projection_Name=@ProjectionName
	 
OPEN Cur
FETCH NEXT FROM Cur INTO @fromEqpPlanId,@fromEqpProjHeaderId,@fromProjTaskHeaderId
WHILE @@FETCH_STATUS = 0
BEGIN

SELECT @toEqpPlanId=EqpplanID, @toFleetId=FleetID FROM EQUIPMENT_HIERARCHY_V where EqpPlan=@DestEqp AND Projection_Type_ID=1

declare @p13 int
set @p13=0
declare @p14 varchar(8000)
set @p14=''
exec PROJECTION_TASK_COPY_MULTIEQP_P 
@fromEqpPlanId=@fromEqpPlanId,@fromEqpProjHeaderId=@fromEqpProjHeaderId,
@fromProjTaskHeaderId=@fromProjTaskHeaderId,
@toFleetId=@toFleetId,
@toEqpPlanId=@toEqpPlanId,
@toEqpProjHeaderId=1,
@Esc_Desc_Prices=0,
@KeepLinkToStdJob=1,
@overwrite=0,
@firstOccOption=2,
@rotPartOption=1,
@supDepOption=1,
@EqpUpdated=@p13 
output,@errorMsg=@p14 output,
@CopyPerfStrat=1
--select @p13, @p14


	FETCH NEXT FROM Cur INTO @fromEqpPlanId,@fromEqpProjHeaderId,@fromProjTaskHeaderId
END
CLOSE Cur
DEALLOCATE Cur

-- CREATE PROJ TASK LINK 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZZ_PROJ_TASK_LINK]') AND type in (N'U'))
DROP TABLE [dbo].[ZZ_PROJ_TASK_LINK]

select SOR.ProjTaskID AS SourceProjTaskID,SOR.Part_ID,SOR.Frequency,DES.ProjTaskID AS DestinationProjTaskID 
INTO ZZ_PROJ_TASK_LINK 
FROM
(select PJ.ProjTaskID,PJ.Task_Header_ID,EQ.Projection_Type_ID,PJ.Part_ID,PJ.Frequency from tblProjTasks PJ
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjID=PJ.EqpProjID
where EQ.Eqpplan=@SourceEqp) SOR
INNER JOIN
(select PJ.ProjTaskID,PJ.Task_Header_ID,EQ.Projection_Type_ID from tblProjTasks PJ
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.EqpProjID=PJ.EqpProjID
where EQ.Eqpplan=@DestEqp) DES
ON SOR.Projection_Type_ID=DES.Projection_Type_ID
AND SOR.Task_Header_ID=DES.Task_Header_ID



-- COPY PARTS
update PJ
Set PJ.Part_ID=NULL
from tblProjtasks PJ
INNER JOIN ZZ_PROJ_TASK_LINK  ZZ ON PJ.ProjTaskID=ZZ.DestinationProjTaskID


IF @CopyParts=1
BEGIN
update PJ
Set PJ.Part_ID=ZZ.Part_ID
from tblProjtasks PJ
INNER JOIN ZZ_PROJ_TASK_LINK ZZ ON PJ.ProjTaskID=ZZ.DestinationProjTaskID
END

-- COPY FREQUENCY

IF @CopyFrequency=1
BEGIN
update PJ
Set PJ.frequency=ZZ.frequency
from tblProjtasks PJ
INNER JOIN ZZ_PROJ_TASK_LINK ZZ ON PJ.ProjTaskID=ZZ.DestinationProjTaskID

update PJ
Set PJ.frequency=ZZ.frequency
from tblProjtaskOpts PJ
INNER JOIN ZZ_PROJ_TASK_LINK ZZ ON PJ.ProjTaskID=ZZ.DestinationProjTaskID

END


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZZ_OLD_PROJECTION]') AND type in (N'U'))
DROP TABLE [dbo].[ZZ_OLD_PROJECTION]

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZZ_PROJ_TASK_LINK]') AND type in (N'U'))
DROP TABLE [dbo].[ZZ_PROJ_TASK_LINK]

SET XACT_ABORT OFF  

