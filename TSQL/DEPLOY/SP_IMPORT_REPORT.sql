/****** AUTHOR: anthon.awan@gmail.com  Script Date: 04/11/2016 04:23:21 ******/
--CREATE PROCEDURE
--importReport
--AS 

DECLARE
@id varchar(10),
@unit varchar(20),
@dept varchar(20),
@date varchar(20),
@status varchar(2),
@progress varchar(2),
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

DECLARE @uid varchar(10),@update_date varchar(20), @qreport varchar(MAX), @qComment varchar(MAX)

DECLARE aCursor CURSOR FOR SELECT id,unit,dept,date,status,progress,submit_date_int,note_int,sign_int,submit_date_spv_int,note_spv_int,sign_spv_int,submit_date_spv_eng,note_spv_eng,sign_spv_eng,submit_date_spv_qa,note_spv_qa,sign_spv_qa FROM BMS.dbo.report
OPEN aCursor						
	FETCH NEXT FROM aCursor INTO @id,@unit,@dept,@date,@status,@progress,@submit_date_int,@note_int,@sign_int,@submit_date_spv_int,@note_spv_int,@sign_spv_int,@submit_date_spv_eng,@note_spv_eng,@sign_spv_eng,@submit_date_spv_qa,@note_spv_qa,@sign_spv_qa
	WHILE @@FETCH_STATUS = 0 
	BEGIN 													PRINT 'DATE:'+@date+' status:'+@status+' progress:'+@progress
		IF (@id is not null AND @id!='') AND (@date is not null AND @date!='Jan  1 1900 12:00AM') AND (@unit is not null AND @unit!='') AND (@status !=0)AND (@submit_date_int is not null AND @submit_date_int!='Jan  1 1900 12:00AM' AND @sign_int!='' AND @note_int!='')
		BEGIN
			/* IMPORT TO REPORT */
			SET @qReport=''
			IF @status is null SET @status=1
			IF @status=3 SET @status=2
			IF @progress is null OR @progress='' SET @progress=0
			IF @progress=9 SET @progress=4
			IF @unit='warehouse' SET @unit='wh'
			IF @unit='qa' SET @unit='retain'
			IF @unit='laboratory' SET @unit='lab'
			IF @dept='pro' SET @dept='prod'
			IF @dept='qa' AND @unit !='retain' SET @dept='qo'
			IF @dept is null OR @dept ='' SET @dept = (SELECT t1.code from depts as t1 join units as t2 ON t1.id=t2.deptId where t2.code=@unit)
			
			SET @update_date = @submit_date_int PRINT @update_date
			IF (@submit_date_spv_int is not null AND @submit_date_spv_int !='Jan  1 1900 12:00AM' AND @submit_date_spv_int !='') SET @update_date=@submit_date_spv_int 
			IF (@submit_date_spv_eng is not null AND @submit_date_spv_eng !='Jan  1 1900 12:00AM' AND @submit_date_spv_eng !='') SET @update_date=@submit_date_spv_eng 
			IF (@submit_date_spv_qa is not null AND @submit_date_spv_qa !='Jan  1 1900 12:00AM' AND @submit_date_spv_qa !='') SET @update_date=@submit_date_spv_qa 
			PRINT @update_date
			
			SET @qReport='INSERT INTO report(id,unit,dept,date,status,update_date,progress) values('''+@id+''','''+@unit+''','''+@dept+''','''+@date+''','''+@status+''','''+@update_date+''','''+@progress+''')'
			PRINT 'QUERY REPORT :'+ @qReport
			SET IDENTITY_INSERT report ON
			EXEC(@qReport)
			SET IDENTITY_INSERT report OFF
			
			/*IMPORT TO COMMENT */
			SET @qComment=''
			SET @uid = (select id from userlist where username=@sign_int)
			IF @uid is null set @uid = (select top 1 id from userlist where dept=@dept and position='int' and status=2)
			SET @qComment='insert into comment(report_id,submit_date,comment,isReject,position,uid)values('''+@id+''','''+@submit_date_int+''','''+@note_int+''',null,''int'','''+@uid+''')'
			PRINT '=>'+@qComment
			EXEC(@qComment)

			--SPV_INT
			IF (@submit_date_spv_int is not null AND @submit_date_spv_int!='Jan  1 1900 12:00AM') AND (@sign_spv_int is not null AND @sign_spv_int !='')
				BEGIN
					SET @qComment=''
					SET @uid=null
					SET @uid = (select id from userlist where username=@sign_spv_int)
					IF @uid is null set @uid = (select top 1 id from userlist where dept=@dept and position='spv' and status=2)
					SET @qComment='insert into comment(report_id,submit_date,comment,isReject,position,uid)values('''+@id+''','''+@submit_date_spv_int+''','''+@note_spv_int+''',0,''spv_int'','''+@uid+''')'
					PRINT '=>'+@qComment
					EXEC(@qComment)
				END
			--SPV_ENG
			IF (@submit_date_spv_eng is not null AND @submit_date_spv_eng !='Jan  1 1900 12:00AM') AND (@sign_spv_eng is not null AND @sign_spv_eng !='')
				BEGIN
					SET @qComment=''
					SET @uid=null
					SET @uid = (select id from userlist where username=@sign_spv_eng)
					IF @uid is null set @uid = (select top 1 id from userlist where dept='eng' and position='spv' and status=2)
					SET @qComment='insert into comment(report_id,submit_date,comment,isReject,position,uid)values('''+@id+''','''+@submit_date_spv_eng+''','''+@note_spv_eng+''',0,''spv_eng'','''+@uid+''')'
					PRINT '=>'+@qComment
					EXEC(@qComment)
					
					-- SPV QA
					IF (@submit_date_spv_qa is not null AND @submit_date_spv_qa !='Jan  1 1900 12:00AM') AND (@sign_spv_qa is not null AND @sign_spv_qa !='')
					BEGIN
						SET @qComment=''
						SET @uid=null
						SET @uid = (select id from userlist where username=@sign_spv_qa)
						IF @uid is null set @uid = (select top 1 id from userlist where dept='qa' and position='spv' and status=2)
						SET @qComment='insert into comment(report_id,submit_date,comment,isReject,position,uid)values('''+@id+''','''+@submit_date_spv_qa+''','''+@note_spv_qa+''',0,''spv_qa'','''+@uid+''')'
						PRINT '=>'+@qComment
						EXEC(@qComment)
					END	
				END	
		END
		FETCH NEXT FROM aCursor INTO @id,@unit,@dept,@date,@status,@progress,@submit_date_int,@note_int,@sign_int,@submit_date_spv_int,@note_spv_int,@sign_spv_int,@submit_date_spv_eng,@note_spv_eng,@sign_spv_eng,@submit_date_spv_qa,@note_spv_qa,@sign_spv_qa
	END    
CLOSE aCursor
DEALLOCATE aCursor  -- unset cursor
GO
