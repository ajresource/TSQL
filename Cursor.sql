	 
DECLARE @ProjTaskId INT

DECLARE theCursor3 CURSOR FOR	

---------------


 
OPEN theCursor3
FETCH NEXT FROM theCursor3 INTO @ProjTaskId 
WHILE @@fetch_status = 0
BEGIN 
 
 -----
 
FETCH NEXT FROM theCursor3 INTO @ProjTaskId 
END
CLOSE theCursor3
DEALLOCATE theCursor3
