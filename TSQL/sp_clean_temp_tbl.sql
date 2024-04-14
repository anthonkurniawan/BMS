USE [BMS3]
GO
/****** Object:  StoredProcedure [dbo].[cleantemptbl]    Script Date: 03/06/2023 23:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE
[dbo].[cleantemptbl]
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
