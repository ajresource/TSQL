Update AMT_VARIABLE SET Database_Patch_Ver = '8.5.119.3'
GO

DELETE FROM AMT_TYPED_VARIABLE WHERE Value_Name = 'Front_Page_HTML'

GO
DECLARE @TodaysDate DATETIME
SET @TodaysDate = GETDATE()

DECLARE @CustomerName VARCHAR(100)
 
 
SELECT @CustomerName = SystemName FROM AMT_VARIABLE

SET @CustomerName = ISNULL(@CustomerName,'XYZ')




insert AMT_TYPED_VARIABLE ( Value_Name,Varchar_Value )
select 'Front_Page_HTML','<html>  
<head>  <style>  <!-- p.MsoNormal   {margin:0cm;   margin-bottom:.0001pt;   font-size:10.0pt;   font-family:"Arial";}-->  </style>  
</head>  
<body lang=EN-US>  
<p class=MsoNormal>
<span style=font-size:76.0pt>&nbsp;</span></p>  
<p class=MsoNormal align=center style=text-align:center><b><span style=font-size:18.0pt;color:red>Proactive asset management</span></b></p>  
<p class=MsoNormal><b><span style=font-size:36.0pt>&nbsp;</span></b></p>  
<p class=MsoNormal align=center style=text-align:center><b><span style=font-size:12.0pt>AMT 8.5C (Update 3) </span></b></p>  
<p class=MsoNormal><span>&nbsp;</span></p>  
<p class=MsoNormal align=center style=text-align:center><span>Last Software Update <b>'+CAST(DAY(@TodaysDate)AS VARCHAR)+'-'+ DATENAME(month, @TodaysDate)+'-'+ CAST(YEAR(@TodaysDate)AS VARCHAR)+'</b></span></p> 
<p class=MsoNormal align=center style=text-align:center><span>&nbsp;</span></p>  
<p class=MsoNormal align=center style=text-align:center><span>Licensed to <b>' + @CustomerName + '</b></span></p>  
<p class=MsoNormal><b><span style=font-size:32.0pt>&nbsp;</span></b></p>  
<p class=MsoNormal align=center style=text-align:center><span style=font-size:9.0pt;color:#999999>Support Email <a href="mailto:support@isipl.com">support@isipl.com</a></span></p>
<p class=MsoNormal><span style=font-size:32.0pt>&nbsp;</span></p>  
<p class=MsoNormal><span style=color:#999999>AMT is distributed and supported by:</span></p>  
<p class=MsoNormal><b><span style=font-size:8.0pt;color:#999999>iSolutions International Pty Ltd</span></b></p>  
<p class=MsoNormal><span style=font-size:8.0pt;color:#999999>Level 2, 6-12 Atchison Street</span></p>  
<p class=MsoNormal><span style=font-size:8.0pt;color:#999999>St Leonards, NSW 2065, Australia</span></p>  
<p class=MsoNormal><span style=font-size:8.0pt;color:#999999>T: 61 2 9966 9096</span></p>  
<p class=MsoNormal><span style=font-size:8.0pt;color:#999999><a href="http://www.isipl.com"><b>www.isipl.com</b></a></span></p>  <p class=MsoNormal><span style=font-size:8.0pt>&nbsp;</span></p>  
<p class=MsoNormal><span style=font-size:8.0pt;color:#999999>AMT is protected by copyright and international treaties. Unauthorised reproduction or distribution of this program, or any portion of it, may result in civil and criminal penalties.</span></p>  
</body>  
</html>'

GO