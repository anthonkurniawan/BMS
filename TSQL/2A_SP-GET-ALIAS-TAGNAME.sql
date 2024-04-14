/****** AUTHOR: anthon.awan@gmail.com Object:  StoredProcedure [dbo].[getTagname]    Script Date: 04/11/2016 04:23:21 ******/
CREATE PROCEDURE
[dbo].[getTagAlias] @tagname VARCHAR(150)=null, @out VARCHAR(150) OUTPUT
AS 
	SELECT @out= REPLACE(REPLACE( REPLACE (@tagname,'.','_'),'-','_'),';','_')
RETURN
GO