
SELECT User_Role_ID,User_Role_Name,User_Role_Description FROM USER_ROLE
--SELECT * FROM ACCESS_TYPE
 
DECLARE @Columns VARCHAR(MAX)
SELECT @Columns = COALESCE(@Columns + ',[' + cast(User_Role_Name as varchar) + ']','[' + cast(User_Role_Name as varchar)+ ']') FROM USER_ROLE
ORDER BY User_Role_ID
 
 
--SELECT @Columns

DECLARE @SQL VARCHAR(MAX)

SET @SQL = 
		'SELECT Function_Id,Function_Name,Is_Report, ' + @Columns + '
		FROM 
		( 
			SELECT A.Function_Id,   A.Function_Name,A.Is_Report,A.User_Role_Name,MAX(ISNULL(RP.Access_Type_ID,0)) AS AccessType
			FROM
			(
			SELECT AF.Function_ID, AF.Function_Name, AF.Is_Report,UR.User_Role_ID,UR.User_Role_Name FROM USER_ROLE UR
			CROSS JOIN AMT_FUNCTION AF 
			) A LEFT JOIN  ROLE_PERMISSION RP ON RP.User_Role_ID = A.User_Role_ID AND RP.Function_ID = A.Function_ID		 
			GROUP BY  A.Function_Id,A.Function_Name,A.Is_Report,A.User_Role_Name 
		
		) ps
		PIVOT
		(
		SUM (PS.AccessType)
		FOR User_Role_Name IN (' + @Columns + ')
		) AS pvt
		ORDER BY 	 Function_Id
	'
	
ExEC (@SQL)

--SELECT A.Function_ID,A.Function_Name,A.Is_Report,A.User_Role_ID,A.User_Role_Name,ISNULL(RP.Access_Type_ID,0)
--FROM
--(
--SELECT AF.Function_ID, AF.Function_Name, AF.Is_Report,UR.User_Role_ID,UR.User_Role_Name FROM USER_ROLE UR
--CROSS JOIN AMT_FUNCTION AF
--) A LEFT JOIN  ROLE_PERMISSION RP ON RP.User_Role_ID = A.User_Role_ID AND RP.Function_ID = A.Function_ID