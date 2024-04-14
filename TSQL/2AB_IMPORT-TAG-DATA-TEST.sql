/****** AUTHOR: anthon.awan@gmail.com  Script Date: 04/11/2016 04:23:21 ******/
/* -- DROP TEMP TABLE -- */
EXECUTE cleantemptbl
-----------------------------------------------------------------------------------------
DECLARE @start_time VARCHAR(30), @end_time VARCHAR(30),@tagsdata_tmp_tbl VARCHAR(20),@tagsdata_tbl VARCHAR(20)
SET @start_time = '2012-10-12 00:00:00' -- START COPY TAGS-DATA
SET @end_time = '2016-01-01 00:00:00'
SET @tagsdata_tmp_tbl ='TAGS_DATA_TMP'
SET @tagsdata_tbl ='TAGS_DATA'

-- STAR CREATE DATA TEMP "PER/TAGS"--
DECLARE aCursor CURSOR FOR SELECT id,tagname  FROM tagname --WHERE area='test'  ----------BUAT TEST
OPEN aCursor						
	DECLARE @id VARCHAR(3),@tagname varchar(200),@tagname_alias varchar(200),@firstTag VARCHAR(200)
	DECLARE @tagQuery VARCHAR(500), @tagQueryFinal VARCHAR(500)
	DECLARE @qjoin VARCHAR(MAX), @qjoinAdd VARCHAR(MAX)
	SET @qjoinAdd =''
	
	FETCH NEXT FROM aCursor INTO @id,@tagname 
			
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (SELECT tagname FROM OPENQUERY(HISTORIAN,'select tagname from ihtags')WHERE tagname=@tagname) IS NOT NULL
				BEGIN
					EXEC getTagAlias @tagname, @out=@tagname_alias output
					-- FETCH TAG-DATA
					SET @tagQuery =  'SET starttime=' + '''' + '''' + @start_time + '''' + ''',
						endtime=' + '''' + '''' + @end_time + '''' + ''',
						intervalmilliseconds=30m,
						SELECT tagname, timestamp, value FROM ihRawData WHERE tagname ='+@tagname

					SET @tagQueryFinal = 'SELECT CAST(timestamp as smalldatetime) as timestamp,tagname,value as '+@tagname_alias+'
						INTO '+@tagname_alias+ '
						FROM OPENQUERY(HISTORIAN,' + '''' + @tagQuery + '''' + ')'

					--PRINT'  EXEC-->'+ @tagQueryFinal
					EXEC(@tagQueryFinal)
					
					-- JOIN TAG-DATA
					IF @id=1
						BEGIN
							SET @firstTag=@tagname_alias
							SET @qjoin = 'SELECT t'+@id+'.timestamp as tanggal,' +@tagname_alias; 
						END
					ELSE
						BEGIN 
							SET @qjoin =@qjoin+ ',' +@tagname_alias
							SET @qjoinAdd=@qjoinAdd+' LEFT JOIN '+@tagname_alias+' as t'+@id+' ON t1.timestamp=t'+@id+'.timestamp';
						END
					--PRINT '==>'+@id+' '+@tagname_alias+' '+@qjoin
				END
			FETCH NEXT FROM aCursor INTO @id,@tagname
		END
		
CLOSE aCursor
DEALLOCATE aCursor  --UNSET cursor

IF (NOT EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE table_name=''+@tagsdata_tbl+'')) 
	BEGIN
		SET @qjoin =@qjoin+' INTO '+@tagsdata_tbl+' FROM '+@firstTag+' AS t1'+@qjoinAdd
		EXEC(@qjoin)
	END
ELSE
	BEGIN
		-- START COPY TO TAGS-DATA-TEMP
		IF (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE table_name=''+@tagsdata_tmp_tbl+'')) 
			BEGIN 
				EXEC('DROP table '+@tagsdata_tmp_tbl) 
			END
		SET @qjoin =@qjoin+' INTO '+@tagsdata_tmp_tbl+' FROM '+@firstTag+' AS t1'+@qjoinAdd
		EXEC(@qjoin)
		EXEC('INSERT INTO '+@tagsdata_tbl+' SELECT * FROM '+@tagsdata_tmp_tbl)
	END
	
PRINT'  EXEC-->'+@qjoin	

EXEC split_data_year
----------------------------------------------------------------------------------------------------
--#CREATE TEMP TAGS TABLE
--SELECT t1.timestamp as tanggal,XP_SP3_Simulation00001,SAMPLE_IFIX1_BATCH_BULKFLOW_B_CUALM
--INTO tags_data_tmp 
--FROM XP_SP3_Simulation00001 as t1		/*AHU1 */
--LEFT JOIN SAMPLE_IFIX1_BATCH_BULKFLOW_B_CUALM as t2 ON t1.timestamp=t2.timestamp

--INSERT INTO tags_data SELECT * FROM tags_data_tmp 

-- NEXT BAGI TAG-DATA TBL JADI PER-TAHUN
-- 1. TAGS_DATA < 1Y(for current data/this year )
-- 2.. TAGS_DATA_<Y> (for years table)
