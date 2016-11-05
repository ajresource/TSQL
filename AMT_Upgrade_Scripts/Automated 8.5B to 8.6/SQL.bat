@ECHO OFF
SET /P Server=Server name :
SET /P DB=Database name :
SET /P User= Username :
SET /P Pass= Password :
ECHO ON


sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 00_AmtDatabase_8_5_47_to_8_5_119.sql

sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 0_AMT_8_5C_Patch_DataLoading.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 1_AMT_8_5C_Patch_Database_Structure.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 4_AMT_8_5C_Patch_Function.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 5_AMT_8_5C_Patch_Views.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 6_AMT_8_5C_Patch_SP.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 7_AMT_8_5C_Patch_Tr.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i "9_AMT 8.5C Update 3 - FrontPage.sql"
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i amt_0_AMT_Function.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i amt_1_AMT_Function_Equipment_Type.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i amt_2_AMT_Function_Hierarchy_System_Administrator.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i amt_3_AMT_MODES.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i AMT_FILTER_CONFIG_Data_Load_1_Report.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i AMT_FILTER_CONFIG_Data_Load_2_SearchCtl.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i AMT_FILTER_CONFIG_Data_Load_4_FilterCtl.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i AMT85C_HOTFIX_20120524.sql
sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i AMT85C_HOTFIX_20120529.sql

sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 01_AmtDatabase_8_5_119(U3)_to_8_5_261.sql

sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 02_AmtDatabase_8_5_261_to_8_5_268.sql

sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i 03_AmtDatabase_8_5_268_to_8_5_281.sql

sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i AmtDatabase_8_5_281_to_8_5_310.sql

sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i AmtDatabase_8_5E_to_8_6_46.sql

pause



