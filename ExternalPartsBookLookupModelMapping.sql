DECLARE @PARTSBOOKURL VARCHAR(MAX)
DECLARE @LOOPBACKURL VARCHAR(MAX)

SET @PARTSBOOKURL='https://catsisweb.cat.com/psb2b/ReceiveDocumentServlet/OCIRoundTrip/T080?BUYER_MPID=AMTINTERFACE&USERNAME=*username*&PASSWORD=*password*&~OkCode=ADDI&~TARGET=_blank&~CALLER=CTLG'
SET @LOOPBACKURL='http://10.123.77.153/AmtService/PartsbookCallBack.aspx?~caller=sisweb'



/*----------------------------------------*/


DECLARE @URL VARCHAR(MAX)
DECLARE @STRING VARCHAR(MAX)
DECLARE @SUBSTRING VARCHAR(MAX)
DECLARE @TOXML VARCHAR(MAX)
Declare @XML XML
DECLARE @HEADER_STRING VARCHAR(MAX)
DECLARE @FOOTER_STRING  VARCHAR(MAX)


SET @URL='<![CDATA['+@PARTSBOOKURL+'&HOOK_URL='+@LOOPBACKURL+']]>'

SET @HEADER_STRING='<?xml version="1.0" standalone="yes"?>
<ModelMaps>
'

print @HEADER_STRING
--SET @STRING=@HEADER_STRING
/*CURSOR */

DECLARE @model VARCHAR(200)
DECLARE TheModel CURSOR FOR	

select Replace(model,'&','&amp;') from tblModels --where Model like '%&%'

OPEN TheModel
FETCH NEXT FROM TheModel INTO @model 
WHILE @@fetch_status = 0
BEGIN 

SET @SUBSTRING='<ModelMap>
<Model>'+@model+'</Model>
<Publisher>komatsu</Publisher>
<Book>d355a-3</Book>
<Url>'+@URL+' </Url>
</ModelMap>' 			
--SET @STRING+=@SUBSTRING

print @SUBSTRING

FETCH NEXT FROM TheModel INTO @model 
END
CLOSE TheModel
DEALLOCATE TheModel			
					
SET @FOOTER_STRING='
</ModelMaps>'

--SET @TOXML=@STRING+@FOOTER_STRING

--SET @XML=CAST(@TOXML AS XML);

print  @FOOTER_STRING