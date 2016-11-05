	 

DECLARE @EqpProjId INT 


DECLARE theCursor3 CURSOR FOR	


select EqpProjId from EQUIPMENT_HIERARCHY_V
where Branch='NAM - U.S.A.' AND ProjName='Budget'

 
OPEN theCursor3
FETCH NEXT FROM theCursor3 INTO @EqpProjId 
WHILE @@fetch_status = 0
BEGIN 
 
declare @p2 varchar(8000)
set @p2=''
exec DELETE_PROJECTION_P @EqpProjId=@EqpProjId,@Message=@p2 output
select @p2

FETCH NEXT FROM theCursor3 INTO @EqpProjId 
END
CLOSE theCursor3
DEALLOCATE theCursor3
