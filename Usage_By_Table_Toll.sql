use isipl_amt_Toll_87
GO
SELECT OBJECT_NAME(OBJECT_ID) TableName, st.row_count
INTO #TemptblCmp1
FROM sys.dm_db_partition_stats st
WHERE index_id < 2 
ORDER BY TableName 

use TMS_AMT_Toll
GO
SELECT OBJECT_NAME(OBJECT_ID) TableName, st.row_count
INTO #TemptblCmp2
FROM sys.dm_db_partition_stats st
WHERE index_id < 2 
ORDER BY TableName 

select Toll.TableName,Toll.row_count AS NewDB_RowCount ,TMS.row_count AS RepDB_RowCount from #TemptblCmp1 AS Toll 
INNER JOIN #TemptblCmp2 TMS ON Toll.TableName COLLATE DATABASE_DEFAULT =TMS.TableName COLLATE DATABASE_DEFAULT
where Toll.row_count>=TMS.row_count 
order by NewDB_RowCount DESC