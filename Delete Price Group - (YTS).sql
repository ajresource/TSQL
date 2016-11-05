delete from tblPartPrices where Price_Group_ID IN
(select Price_Group_ID from PRICE_GROUP
where Price_Group_ID=2)

update tblFleets SET Price_Group_ID=1
where Price_Group_ID=2

--delete from dbo.tblPricedJobs
--where Price_Group_ID IN
--(select Price_Group_ID from PRICE_GROUP
--where Price_Group_ID=2)

update tblPricedJobs SET Price_Group_ID=1
where Price_Group_ID=2


delete from PRICE_GROUP
where Price_Group_ID=2
