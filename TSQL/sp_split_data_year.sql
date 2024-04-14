USE [BMS3]
GO
/****** Object:  StoredProcedure [dbo].[split_data_year]    Script Date: 03/06/2023 23:59:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** AUTHOR: anthon.gmail@yahoo.com  Script Date: 04/11/2016 04:23:21 ******/
ALTER PROCEDURE
[dbo].[split_data_year]
AS 
DECLARE @max_data_time datetime, @min_data_time datetime, @jarak int
SET @max_data_time=(SELECT MAX(tanggal) FROM TAGS_DATA)
SET @min_data_time=(SELECT MIN(tanggal) FROM TAGS_DATA)
SET @jarak=DATEDIFF(YEAR , @min_data_time, @max_data_time)

IF @jarak > 0
BEGIN
	DECLARE @data_year VARCHAR(4), @next_data_year VARCHAR(4), @tblYear VARCHAR(14)
  
  SET @data_year=CAST(DATEPART(YEAR, @min_data_time) AS VARCHAR)
	SET @next_data_year=CAST(DATEPART (YEAR, (DATEADD(YEAR, 1, @data_year))) AS VARCHAR)
	SET @tblYear='TAGS_DATA'+ @data_year
	
  IF (NOT EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE table_name=''+@tblYear+'')) 
    BEGIN
      EXEC sp_createTbl @name=@tblYear
    END
    
  EXEC ('INSERT INTO '+@tblYear+' SELECT * FROM TAGS_DATA WHERE tanggal >='''+@data_year+''' AND tanggal < '''+ @next_data_year+'''')	--moving data
	DELETE TAGS_DATA WHERE tanggal >= @data_year AND tanggal < @next_data_year 
END
