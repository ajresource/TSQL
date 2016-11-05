

update PROJECTION_HEADER
set Projection_Name='Budget1'
where Projection_Name='Budget'

GO

SET IDENTITY_INSERT PROJECTION_HEADER ON
			GO

			INSERT INTO PROJECTION_HEADER
			(Projection_Header_ID,Projection_NAme)
			VALUES
			(2,'Budget')

			GO

			SET IDENTITY_INSERT PROJECTION_HEADER  OFF
			GO


select * from PROJECTION_HEADER where Projection_Name='Budget'

exec [AA_REPLACE_CODES_P] 'PROJECTION_HEADER','Projection_Name','Budget1','Budget',1

