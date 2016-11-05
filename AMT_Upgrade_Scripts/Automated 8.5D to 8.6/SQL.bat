@ECHO OFF
SET /P Server=Server name :
SET /P DB=Database name :
SET /P User= Username :
SET /P Pass= Password :
ECHO ON

sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i AmtDatabase_8_5_281_to_8_5_310.sql

sqlcmd -S %Server% -U %User% -P %Pass%  -d %DB% -i AmtDatabase_8_5E_to_8_6_46.sql

pause



