USE [BMS3]
GO
/****** Object:  StoredProcedure [dbo].[getTagname]    Script Date: 03/06/2023 23:57:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE
[dbo].[getTagname] @tagname VARCHAR(150)=null
AS 
BEGIN
	IF @tagname IS NOT NULL
		SELECT * FROM tagname WHERE tagname=@tagname
	ELSE
		SELECT * FROM tagname
END
