/****** AUTHOR: anthon.awan@gmail.com  Script Date: 04/11/2016 04:23:21 ******/
CREATE PROCEDURE
cleantemptbl
AS 
DECLARE tblCursor CURSOR FOR SELECT table_name FROM INFORMATION_SCHEMA.TABLES 
		WHERE TABLE_NAME IN ( SELECT REPLACE(REPLACE( REPLACE (tagname,'.','_'),'-','_'),';','_') FROM tagname)

--PRINT '#1. CEK JIKA TABLE TEMPORARY TABLE TAGNAME ADA'
OPEN tblCursor						
	DECLARE @tblname nvarchar(100),@dropQuery nvarchar(100)
	
	FETCH NEXT FROM tblCursor INTO @tblname 
		WHILE @@FETCH_STATUS = 0				
			BEGIN 
				SET @dropQuery='DROP TABLE '+ @tblname
				EXEC(@dropQuery)	--PRINT '  EXEC-->' + @dropQuery 
				FETCH NEXT FROM tblCursor INTO @tblname
			END     
CLOSE tblCursor
DEALLOCATE tblCursor	
GO
