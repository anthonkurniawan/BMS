/* -- COPY ALL IHRAWDATA FROM  HISTORIAN DB -- AUTHOR: anthon.awan@gmail.com*/
DECLARE @max_data_time smalldatetime, @max_his_time smalldatetime, @tagsdata_tbl VARCHAR(20)
DECLARE @start_time VARCHAR(30), @end_time VARCHAR(30),@intv VARCHAR(3)
SET @intv ='30m'
SET @tagsdata_tbl='TAGS_DATA'
SET @max_his_time=
	(SELECT CAST(max_time as smalldatetime)as max_his_time FROM OPENQUERY (HISTORIAN,'SELECT MAX(timestamp) as max_time FROM ihRawdata"'))
  
IF (NOT EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE table_name=@tagsdata_tbl))
  BEGIN 
    SET @max_data_time ='2014-01-01 00:00'
    SET @start_time =@max_data_time
    SET @end_time ='2014-03-01 00:00'
  END
ELSE
  BEGIN 
    SET @max_data_time=(SELECT MAX(tanggal) FROM TAGS_DATA) 
    SET @start_time = cast(@max_data_time as varchar(20))
    SET @end_time=(select DATEADD(month, 3, @max_data_time))
    IF @end_time > @max_his_time
      BEGIN SET @end_time = @max_his_time END
  END

IF @max_data_time < @max_his_time
	BEGIN
    EXECUTE cleantemptbl
    DECLARE aCursor CURSOR FOR SELECT id,tagname  FROM tagname
    OPEN aCursor						
      DECLARE @id VARCHAR(3),@tagname varchar(200),@tagname_alias varchar(200), @id_1 VARCHAR(5), @tag_1 VARCHAR(200), @tag_join VARCHAR(MAX), @tagQuery VARCHAR(500), @tagQueryFinal VARCHAR(500), @qjoin VARCHAR(MAX), @qjoinAdd VARCHAR(MAX)
      SET @qjoinAdd =''

      FETCH NEXT FROM aCursor INTO @id,@tagname 
          
      WHILE @@FETCH_STATUS = 0
        BEGIN
          IF (SELECT tagname FROM OPENQUERY(HISTORIAN,'select tagname from ihtags') WHERE tagname=@tagname) IS NOT NULL
            BEGIN
              EXEC getTagAlias @tagname, @out=@tagname_alias output
              -- FETCH TAG-DATA
              SET @tagQuery =  'SET starttime=' + '''' + '''' + @start_time + '''' + ''',
                endtime=' + '''' + '''' + @end_time + '''' + ''',
                intervalmilliseconds='+@intv+',
                SELECT tagname, timestamp, value FROM ihRawData WHERE tagname ='+@tagname

              SET @tagQueryFinal = 'SELECT CAST(timestamp as smalldatetime) as timestamp,tagname,value as '+@tagname_alias+'
                INTO '+@tagname_alias+ '
                FROM OPENQUERY(HISTORIAN,' + '''' + @tagQuery + '''' + ')'

              EXEC(@tagQueryFinal)
              
              -- JOIN TAG-DATA
              IF @id=1
                BEGIN
									SET @id_1=@id
                  SET @tag_1=@tagname_alias
                  SET @tag_join=@tagname_alias
                END
							ELSE
                BEGIN 
                  SET @tag_join= @tag_join +',' +@tagname_alias
                  SET @qjoinAdd=@qjoinAdd +' LEFT JOIN '+@tagname_alias+' as t'+@id+' ON t1.timestamp=t'+@id+'.timestamp';
                END
            END
          FETCH NEXT FROM aCursor INTO @id,@tagname
        END
        
    CLOSE aCursor
    DEALLOCATE aCursor

    IF (NOT EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.TABLES WHERE table_name=''+@tagsdata_tbl+'')) 
      BEGIN
        EXEC sp_createTbl @name=@tagsdata_tbl
      END
			
		SET @qjoin = 'INSERT INTO '+@tagsdata_tbl+' (tanggal,'+@tag_join+') SELECT t'+@id_1+'.timestamp as tanggal,' +@tag_join +' FROM '+@tag_1+' AS t1'+@qjoinAdd
		EXEC(@qjoin)
    --PRINT'  EXEC-->'+@qjoin
    EXEC split_data_year
	END
