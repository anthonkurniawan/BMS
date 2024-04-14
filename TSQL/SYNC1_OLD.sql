--SET NOCOUNT ON
/* -- DROP TABLE -- */
DECLARE tblCursor CURSOR FOR SELECT table_name FROM INFORMATION_SCHEMA.TABLES 
		WHERE TABLE_NAME IN ( SELECT REPLACE( REPLACE (tagname,'.','_'),'-','_') FROM tagname)

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
-----------------------------------------------------------------------------------------------------------------------------------------------------

/* -- SNY TIME TO HISTORIAN DB -- */
DECLARE @max_data_time smalldatetime, @max_his_time smalldatetime

SET @max_data_time=(SELECT MAX(tanggal) FROM tags_data)
SET @max_his_time=
	(SELECT CAST(max_time as smalldatetime)as max_his_time
	FROM OPENQUERY (HISTORIAN,'SET intervalmilliseconds=1h,
         	SELECT MAX(timestamp) as max_time FROM ihRawdata"'))
 
----------------------------------------------------------------------------------------------------------------------
-- check jika tags_data empty
IF @max_data_time is null
	BEGIN 
		--PRINT char(10)+'#2.CEK DATA JIKA KOSONG'+char(10)+'  historian_data kosong.(cari dari data archieve)'+char(10)
		SET @max_data_time=(SELECT MAX(tanggal) FROM TAGS_DATA_DISTRIBUTION)
	END
----------------------------------------------------------------------------------------------------------------------
--PRINT '#3.COMPARE TIME--> max_data_time :'+cast(@max_data_time as varchar(20))+'max_his_time :'+cast(@max_his_time as varchar(20))+char(10)
-- COMPARE TIME 
IF @max_data_time < @max_his_time
	BEGIN
		--PRINT'max_data_time < @max_his_time (copy data).STEP SNYCRONIZE...'+char(10)+'  CEK EXIST "tags_data_tmp"?'
		IF (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE table_name='tags_data_tmp')) 
		BEGIN 
			--PRINT'  ada'+char(10)+'  drop table tags_data_tmp ..'
			DROP table tags_data_tmp 
		END

		DECLARE @start_time VARCHAR(30), @end_time VARCHAR(30)
	  SET @start_time = cast(@max_data_time as varchar(20))
    SET @end_time = cast(@max_his_time as varchar(20))

        -- STAR CREATE DATA TEMP "PER/TAGS"--
		DECLARE @sqlQuery VARCHAR(500), @finalQuery VARCHAR(500)
		
		DECLARE aCursor CURSOR FOR SELECT tagname  FROM TAGNAME --WHERE area='test'  ----------BUAT TEST
		OPEN aCursor						
			DECLARE @tagname nvarchar(150)
			FETCH NEXT FROM aCursor INTO @tagname 
			
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @sqlQuery =  'SET starttime=' + '''' + '''' + @start_time + '''' + ''',
						 endtime=' + '''' + '''' + @end_time + '''' + ''',
						 intervalmilliseconds=1h,
						 SELECT tagname, timestamp, value FROM ihRawData WHERE tagname ='+@tagname
				-------------------------------------------------------------------
				SET @finalQuery = 'SELECT CAST(timestamp as smalldatetime) as timestamp,
						   tagname,
						   value as '+(SELECT REPLACE( REPLACE (@tagname,'.','_'),'-','_'))+ '
						   INTO '+(SELECT REPLACE( REPLACE (@tagname,'.','_'),'-','_'))+ '
						   FROM OPENQUERY(HISTORIAN,' + '''' + @sqlQuery + '''' + ')'

				--PRINT'  EXEC-->' + @finalQuery
				EXEC(@finalQuery) 
				FETCH NEXT FROM aCursor INTO @tagname
			END    
		CLOSE aCursor
		DEALLOCATE aCursor  -- DI UNSET cursor
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--PRINT char(10)+'#4. CREATE "tags_data_tmp" (select join smua tagname)' 
		 /* #CREATE TEMP TAGS TABLE ----*/
		SELECT t1.timestamp as tanggal,
			XP_SP3_Simulation00001,		
			SAMPLE_IFIX1_BATCH_BULKFLOW_B_CUALM
		INTO tags_data_tmp 
		FROM XP_SP3_Simulation00001 as t1		/*AHU1 */
		LEFT JOIN SAMPLE_IFIX1_BATCH_BULKFLOW_B_CUALM as t2 ON t1.timestamp=t2.timestamp
		--ORDER BY tanggal DESC --XXXXXXXXXXXXXXXXXX	ADD FILTER ORDER
		
		/* #INSERT/UPDATE "tags_data" TABLE --------------------------------------------------------*/
		--PRINT char(10)+'#5.INSERT/COPY TO "tags_data"(insert into tags_data select * tags_data_tmp'
		INSERT INTO tags_data 
		SELECT * FROM tags_data_tmp --ORDER BY tanggal DESC --XXXXXXXXXXXXXXXXXX	ADD FILTER ORDER
	END