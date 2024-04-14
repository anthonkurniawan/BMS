USE [BMS3]
GO
/****** Object:  StoredProcedure [dbo].[getTagAlias]    Script Date: 03/06/2023 23:56:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE
[dbo].[getTagAlias] @tagname VARCHAR(150)=null, @out VARCHAR(150) OUTPUT
AS 
	SELECT @out= REPLACE(REPLACE( REPLACE (@tagname,'.','_'),'-','_'),';','_')
RETURN
