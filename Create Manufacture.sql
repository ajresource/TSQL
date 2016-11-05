declare @Manufacturer varchar(10)
declare @ManufacturerDesc varchar(50)

select 'exec SYSTEM_TABLE_EDIT_P @TableName=''tblManufacturers'',@ID=''-1'',@Cmd1=''Manufacturer,ManufacturerDesc,Manufacturer_Code'',@Cmd2='''''''+A.Manufacturer+''''','''''+A.ManufacturerDesc+''''','''''+A.Manufacturer+''''''''
from 
(select Distinct Manufacturer,ManufacturerDesc from isipl_amt_rsa..EQUIPMENT_HIERARCHY_V where Manufacturer not in
(
select Manufacturer from isipl_amt_barlow..tblManufacturers)) A
CROSS JOIN 
(select Distinct Manufacturer,ManufacturerDesc from isipl_amt_eqstra..EQUIPMENT_HIERARCHY_V where Manufacturer not in
(
select Manufacturer from isipl_amt_barlow..tblManufacturers)) B
group by  A.Manufacturer,A.ManufacturerDesc

