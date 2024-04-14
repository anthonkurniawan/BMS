/****** AUTHOR: anthon.awan@gmail.com  Script Date: 04/11/2016 04:23:21 ******/
USE BMS3
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--SET ANSI_PADDING ON
--GO

DECLARE
@id varchar(10),
@submit_date_int varchar(50),
@note_int varchar(MAX),
@sign_int varchar(50),
@submit_date_spv_int varchar(50),
@note_spv_int varchar(MAX),
@sign_spv_int varchar(50),
@submit_date_spv_eng varchar(50),
@note_spv_eng varchar(MAX),
@sign_spv_eng varchar(50),
@submit_date_spv_qa varchar(50),
@note_spv_qa varchar(MAX),
@sign_spv_qa varchar(50)

DECLARE @uid varchar(10),@query varchar(MAX)

DECLARE aCursor CURSOR FOR SELECT id,submit_date_int,note_int,sign_int,submit_date_spv_int,note_spv_int,sign_spv_int,submit_date_spv_eng,note_spv_eng,sign_spv_eng,submit_date_spv_qa,note_spv_qa,sign_spv_qa FROM BMS.dbo.report
OPEN aCursor						
	FETCH NEXT FROM aCursor INTO @id,@submit_date_int,@note_int,@sign_int,@submit_date_spv_int,@note_spv_int,@sign_spv_int,@submit_date_spv_eng,@note_spv_eng,@sign_spv_eng,@submit_date_spv_qa,@note_spv_qa,@sign_spv_qa
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		-- INT
		IF @submit_date_int is not null
			BEGIN
				SET @query=''
				SET @uid = (select id from userlist where username=@sign_int)
				--IF @isReject is null SET @isReject=''
				--PRINT 'report_id:'+@id+','+@submit_date_int+','+@note_int+','+'null'+','+'int'+','+@sign_int +'=>'+ @uid
				SET @query='insert into comment(report_id,submit_date,comment,isReject,position,uid)values('''+@id+''','''+@submit_date_int+''','''+@note_int+''',null,''int'','''+@uid+''')'
				PRINT '=>'+@query
				EXEC(@query)
			END
		--SPV_INT
		IF @submit_date_spv_int is not null
			BEGIN
				SET @query=''
				SET @uid=null
				SET @uid = (select id from userlist where username=@sign_spv_int)
				SET @query='insert into comment(report_id,submit_date,comment,isReject,position,uid)values('''+@id+''','''+@submit_date_spv_int+''','''+@note_spv_int+''',0,''spv_int'','''+@uid+''')'
				PRINT '=>'+@query
				EXEC(@query)
			END
		--SPV_ENG
		IF @submit_date_spv_eng is not null
			BEGIN
				SET @query=''
				SET @uid=null
				SET @uid = (select id from userlist where username=@sign_spv_eng)
				SET @query='insert into comment(report_id,submit_date,comment,isReject,position,uid)values('''+@id+''','''+@submit_date_spv_eng+''','''+@note_spv_eng+''',0,''spv_eng'','''+@uid+''')'
				PRINT '=>'+@query
				EXEC(@query)
			END	
		IF @submit_date_spv_qa is not null
			BEGIN
				SET @query=''
				SET @uid=null
				SET @uid = (select id from userlist where username=@sign_spv_qa)
				SET @query='insert into comment(report_id,submit_date,comment,isReject,position,uid)values('''+@id+''','''+@submit_date_spv_qa+''','''+@note_spv_qa+''',0,''spv_qa'','''+@uid+''')'
				PRINT '=>'+@query
				EXEC(@query)
			END	
	FETCH NEXT FROM aCursor INTO @id,@submit_date_int,@note_int,@sign_int,@submit_date_spv_int,@note_spv_int,@sign_spv_int,@submit_date_spv_eng,@note_spv_eng,@sign_spv_eng,@submit_date_spv_qa,@note_spv_qa,@sign_spv_qa
	END    
CLOSE aCursor
DEALLOCATE aCursor  -- unset