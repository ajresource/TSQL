select *
INTO zz_ROLE_PERMISSION 
from ROLE_PERMISSION 

GO 
delete from ROLE_PERMISSION where User_Role_ID IN (
 select User_Role_ID from USER_ROLE where User_Role_Name IN ('Planner','Senior Management','System Administration'))

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



select * from ROLE_PERMISSION where User_Role_ID IN (
 select User_Role_ID from USER_ROLE where User_Role_Name IN ('Planner','Senior Management','System Administration'))