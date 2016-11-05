
--Drop table zz_ProjBilling

--CREATE TABLE zz_ProjBilling(
--ID INT IDENTITY(1,1),
--Eqpplan VARCHAR(200),
--Start_Usage INT,
--End_Usage INT,
--Currency VARCHAR(200),
--Billing_Rate Float,
--Projection Varchar(200))


 UPDATE EQ
 SET MARC_EQP=1
 from zz_ProjBilling ZZ
 INNER JOIN EQUIPMENT_HIERARCHY_V EQ ON ZZ.Eqpplan=EQ.EqpPlan 
 
INSERT INTO tblProjBillings 
 select distinct EQ.EqpProjID,NULL,'Current',EQ.QuomID,NULL,getdate(),0,getdate(),NULL,0,0,NULL,0,NULL,0,NULL,0,C.CurrencyID,getdate(),2,1,EQ.ProjHeaderID from zz_ProjBilling ZZ
 inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.Eqpplan=ZZ.Eqpplan AND EQ.ProjName=ZZ.Projection
 INNER JOIN tblCurrencies C ON C.Currency=ZZ.Currency
 
INSERT INTO tblProjBillingAmounts
select PB.ProjBillingID,Billing_Rate,Start_Usage,End_Usage from zz_ProjBilling ZZ
inner join EQUIPMENT_HIERARCHY_V EQ ON EQ.Eqpplan=ZZ.Eqpplan AND EQ.ProjName=ZZ.Projection
INNER JOIN tblProjBillings PB ON EQ.EqpprojID=PB.EqpProjID AND EQ.ProjHeaderID=PB.ProjectionHeaderID