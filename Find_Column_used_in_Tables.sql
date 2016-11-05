SELECT T.name AS [Table],C.name AS [Column] FROM sys.columns C
INNER JOIN sys.objects O ON C.object_id=O.object_id
INNER JOIN sys.tables T ON O.object_id=T.object_id
WHERE C.name='OrganisationId'