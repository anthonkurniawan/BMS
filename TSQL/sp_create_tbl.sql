USE [BMS3]
GO
/****** Object:  StoredProcedure [dbo].[sp_createTbl]    Script Date: 03/06/2023 23:59:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** AUTHOR: anthon.awan@gmail.com Object:  StoredProcedure [dbo].[getTagname]    Script Date: 04/11/2016 04:23:21 ******/
ALTER PROCEDURE [dbo].[sp_createTbl] @name VARCHAR(20)=null
AS 
	DECLARE aCursor CURSOR FOR SELECT tagname  FROM tagname
	OPEN aCursor						
	DECLARE @tagname varchar(200),@tagname_alias varchar(200), @query varchar(MAX)

	SET @query = 'CREATE TABLE ['+@name+']([tanggal] [smalldatetime] NOT NULL'
	
	FETCH NEXT FROM aCursor INTO @tagname 
  WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC getTagAlias @tagname, @out=@tagname_alias output
			IF (SELECT tagname FROM OPENQUERY(HISTORIAN,'select tagname from ihtags') WHERE tagname=@tagname) IS NOT NULL
				BEGIN
					SET @query = @query + ',' + @tagname_alias +' real NULL'
				END
			FETCH NEXT FROM aCursor INTO @tagname
		END
        
	CLOSE aCursor
	DEALLOCATE aCursor

	SET @query = @query+' ) ON [PRIMARY]'
	EXEC(@query)

EXECUTE('CREATE UNIQUE CLUSTERED INDEX '+@name+'_IDX ON '+@name+'(tanggal)')
