/*
1. IMPORT THE EXCEL FILE TO THE DATABASE AND CREATE A TABLE zz_Security_Metrix (mport Data from SSMS)- Refer to the sample excel template 
2. EXTRACT the INSERT STATEMENTS AND RUN IN A SEPERATE WINDOW
3. DROP THE TEMP TABLE (zz_Security_Metrix)

*/


/******************************************************************************
	File: Security_Metrix.sql

	Desc: 

	Auth: Anjana Rupasoinghege
	Date: 22 May 2013
*******************************************************************************
		Change History
*******************************************************************************
	Date:		Author:		Description:
	--------	--------	----------------------------------------
	
*******************************************************************************/
	/* Param List */
select * 
INTO zz_ROLE_PERMISSION
from ROLE_PERMISSION
GO 

TRUNCATE Table ROLE_PERMISSION
GO

select  distinct 'INSERT INTO ROLE_PERMISSION
select UR.User_Role_ID,AF.Function_ID,0,getdate(),0,getdate(),ZZ.['+c.name+'] AS Access_Type_ID
 from sys.columns C
inner join sys.objects O ON C.object_id=O.object_id
inner join sys.tables T ON T.object_id=O.object_id
inner join USER_ROLE UR ON UR.User_Role_Name=C.name
CROSS JOIN zz_Security_Metrix ZZ
inner join AMT_FUNCTION AF ON ZZ.Function_Name=AF.Function_Name 
where T.name=''zz_Security_Metrix'' AND C.name='''+c.name+''''
 from sys.columns C
inner join sys.objects O ON C.object_id=O.object_id
inner join sys.tables T ON T.object_id=O.object_id
inner join USER_ROLE UR ON UR.User_Role_Name=C.name
CROSS JOIN zz_Security_Metrix ZZ
inner join AMT_FUNCTION AF ON ZZ.Function_Name=AF.Function_Name 
where T.name='zz_Security_Metrix' 

--drop table zz_Security_Metrix