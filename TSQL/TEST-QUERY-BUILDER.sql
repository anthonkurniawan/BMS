/****** AUTHOR: anthon.awan@yahoo.com  Script Date: 04/11/2016 04:23:21 ******/
DECLARE aCursor CURSOR FOR SELECT id,tagname  FROM TAGNAME --WHERE id!=1  ----------BUAT TEST
	OPEN aCursor
		DECLARE @firstTag VARCHAR(200),@query VARCHAR(MAX),@qjoin VARCHAR(MAX)='';
		DECLARE @id CHAR(3),@tagname varchar(200),@tagname_alias varchar(200)

		FETCH NEXT FROM aCursor INTO @id,@tagname 
			
		WHILE @@FETCH_STATUS = 0	
      BEGIN
				IF (SELECT tagname FROM OPENQUERY(HISTORIAN,'select tagname from ihtags')WHERE tagname=@tagname) IS NOT NULL
				BEGIN
					exec getTagAlias @tagname, @out=@tagname_alias output
					IF @id=1
						BEGIN
							SET @firstTag=@tagname_alias
							SET @query = 'SELECT t'+@id+'.timestamp as tanggal,' +@tagname_alias; 
						END
					ELSE
						BEGIN 
							SET @query += ',' +@tagname_alias
							SET @qjoin +=' LEFT JOIN '+@tagname_alias+' as t'+@id+' ON t1.timestamp=t'+@id+'.timestamp';
						END
						
					PRINT '==>'+@id+' '+@tagname_alias
					PRINT @query
				END
				FETCH NEXT FROM aCursor INTO @id,@tagname
			END    
		SET @query = @query + ' INTO tags_data_tmp FROM '+@firstTag+' AS t1'+@qjoin
	CLOSE aCursor
DEALLOCATE aCursor  -- DI UNSET cursor

PRINT'  EXEC-->' + @query
/*  RESULT :
  SELECT t1.timestamp as tanggal,
  XP_SP3_Simulation00001,
  ASPJAKWR809PGZ_HRN_Horner_mbnet_horner_141_126_in4,
  ASPJAKWR809PGZ_HRN_Horner_mbnet_horner_r126_in3,
  ASPJAKWR809PGZ_HRN_Horner_mbnet_horner_r141_in2,
  SAMPLE_IFIX1_BATCH_BULKFLOW_B_CUALM 
  INTO tags_data_tmp 
  FROM XP_SP3_Simulation00001 AS t1 
  LEFT JOIN ASPJAKWR809PGZ_HRN_Horner_mbnet_horner_141_126_in4 as t2 ON t1.timestamp=t2.timestamp 
  LEFT JOIN ASPJAKWR809PGZ_HRN_Horner_mbnet_horner_r126_in3 as t3 ON t1.timestamp=t3.timestamp 
  LEFT JOIN ASPJAKWR809PGZ_HRN_Horner_mbnet_horner_r141_in2 as t4 ON t1.timestamp=t4.timestamp 
  LEFT JOIN SAMPLE_IFIX1_BATCH_BULKFLOW_B_CUALM as t5 ON t1.timestamp=t5.timestamp
*/