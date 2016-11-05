/*****************************************
	V Vasylyeva 19-Mar-2012
	
	This script updates task counter of the duplicate
	strategy tasks
	
	For the first duplicate update the task counter to 11, 
	for the second duplicate update the task counter to 12 and so on.
	

******************************************/


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[z_DuplicateTasks]') AND type in (N'U'))
DROP TABLE [dbo].[z_DuplicateTasks]
GO



CREATE TABLE z_DuplicateTasks(EqpProjId int, ProjTaskId int,
ComponentCodeId int,ModifierId int,TaskTypeId int,ApplicationCodeId int,
NumberOfDuplicateTasks int,RowCounter int,NewApplicationCodeId int,NeedToChange bit
PRIMARY KEY(ProjTaskId))

INSERT INTO z_DuplicateTasks(EqpProjId , ProjTaskId ,
ComponentCodeId,ModifierId,TaskTypeId,ApplicationCodeId ,
NumberOfDuplicateTasks ,RowCounter,NewApplicationCodeId,NeedToChange)
SELECT T.EqpProjId, T.ProjTaskId,
T.ComponentCodeId,T.ModifierId,T.TaskTypeId,T.ApplicationCodeId,NumberOfDuplicateTasks,
ROW_NUMBER() OVER(PARTITION BY T.EqpProjId, T.ComponentCodeId,T.ModifierId,T.TaskTypeId,T.ApplicationCodeId 
ORDER BY T.ProjTaskId ASC) AS RowCounter,
T.ApplicationCodeId AS NewApplicationCodeId,1 AS NeedToChange
FROM
tblProjTasks T
	INNER JOIN
(select PT.EqpProjId,PT.ComponentCodeId,PT.ModifierId,PT.TaskTypeId,PT.ApplicationCodeId,
COUNT(PT.ProjTaskId) AS NumberOfDuplicateTasks,MIN(PT.ProjTaskId) AS ProjTaskId
from
tblProjTasks PT
	inner join
tblEqpProjs EPR
	ON PT.EqpProjId=EPR.EqpProjId
WHERE EPR.Projection_Type_ID<>4
GROUP BY PT.EqpProjId,PT.ComponentCodeId,PT.ModifierId,PT.TaskTypeId,PT.ApplicationCodeId
HAVING COUNT(PT.ProjTaskId)>1) A
	ON T.EqpProjId=A.EqpProjId
	and T.ComponentCodeId=A.ComponentCodeId
	and T.ModifierId=a.ModifierId
	and T.TaskTypeId=a.TaskTypeId
	and T.ApplicationCodeId=a.ApplicationCodeId
ORDER BY T.EqpProjId,T.Task_Header_Id, T.ProjTaskId,T.ApplicationCodeId
	
/*First task does not need to change*/	
UPDATE D SET NeedToChange=0
FROM z_DuplicateTasks D WHERE D.RowCounter=1

/*Reset Rownumber in case there are duplicate combination of 
EqpProjId, ComponentCodeId,ModifierId,TaskTypeId in the tasks to change
*/
UPDATE Z SET RowCounter=A.RowCounter+1
FROM
z_DuplicateTasks Z
	INNER JOIN
(SELECT D.EqpProjId, D.ComponentCodeId,D.ModifierId,D.TaskTypeId,D.ProjTaskId,
ROW_NUMBER() OVER(PARTITION BY D.EqpProjId, D.ComponentCodeId,D.ModifierId,D.TaskTypeId
ORDER BY D.ProjTaskId ASC) AS RowCounter
FROM
z_DuplicateTasks D
WHERE D.NeedToChange=1
) A
	ON Z.ProjTaskId=A.ProjTaskId
	
/*Change application code per rule: 
For the first duplicate update the task counter to 11, 
for the second duplicate update the task counter to 12 and so on.
*/	
UPDATE D SET D.NewApplicationCodeID=B.ApplicationCodeID
FROM 
z_DuplicateTasks D
	INNER JOIN
tblApplicationCodes A
	ON D.ApplicationCodeID=A.ApplicationCodeID
	LEFT JOIN
tblApplicationCodes B
	ON CAST(9+D.RowCounter as varchar(50))= B.Code
WHERE ISNUMERIC(A.Code)=1 AND D.NeedToChange=1

IF NOT EXISTS(
SELECT T.EqpProjId,T.ComponentCodeId,T.ModifierId,T.TaskTypeId,T.ApplicationCodeId,
T.ProjTaskId,D.ProjTaskId AS D_ProjTaskId,A.Code
FROM
tblProjTasks T
	INNER JOIN
z_DuplicateTasks D
	ON T.EqpProjId=D.EqpProjId
	and T.ComponentCodeId=D.ComponentCodeId
	and T.ModifierId=D.ModifierId
	and T.TaskTypeId=D.TaskTypeId
	and T.ApplicationCodeId=D.NewApplicationCodeId
	INNER JOIN
tblApplicationCodes A
	ON T.ApplicationCodeId=A.ApplicationCodeID
WHERE D.NeedToChange=1)
BEGIN

	BEGIN TRANSACTION
	
	UPDATE T SET T.ApplicationCodeId=D.NewApplicationCodeId
	FROM
	tblProjTasks T
		INNER JOIN
	z_DuplicateTasks D
		ON T.ProjTaskId=D.ProjtaskId
	WHERE D.NeedToChange=1
	
	/**Can be reused*/
	EXEC TASK_HEADERS_UPDATE_ALL_P
		
	DECLARE @ProjTaskId varchar(max)
	SET @ProjTaskId=''

	SELECT @ProjTaskId = (SELECT CAST(ProjTaskId AS varchar)+',' FROM
	z_DuplicateTasks WHERE NeedToChange=1
		 FOR XML PATH('') )

	SET @ProjTaskId=ISNULL(@ProjTaskId,'')
	
	EXEC UPDATE_STRATEGY_TASK_HISTORY_P @projTaskId=@ProjTaskId
	EXEC STRATEGY_TASK_LINK_TO_EQS_TASK_P @ProjTaskIdMany=@ProjTaskId
	/**End of reusable code*/
	COMMIT TRANSACTION
	
END
ELSE
BEGIN
	SELECT 'There are duplicate strategy tasks to create. Modify the queries.'
END

/*Check for duplicates Can be reused*/
select PT.EqpProjId,PT.ComponentCodeId,PT.ModifierId,PT.TaskTypeId,PT.ApplicationCodeId,
COUNT(PT.ProjTaskId) AS NumberOfDuplicateTasks,MIN(PT.ProjTaskId) AS ProjTaskId
from
tblProjTasks PT
	inner join
tblEqpProjs EPR
	ON PT.EqpProjId=EPR.EqpProjId
WHERE EPR.Projection_Type_ID<>4
GROUP BY PT.EqpProjId,PT.ComponentCodeId,PT.ModifierId,PT.TaskTypeId,PT.ApplicationCodeId
HAVING COUNT(PT.ProjTaskId)>1