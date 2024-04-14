/****** AUTHOR: anthon.awan@gmail.com  Script Date: 04/11/2016 04:23:21 ******/
USE BMS3
SET IDENTITY_INSERT userlist ON

DECLARE @id varchar(2),@username varchar(150),@fullname varchar(150),@email varchar(150),@dept varchar(150),@position varchar(150)
DECLARE @sign varchar(150), @status char, @spv1 varchar(50), @spv2 varchar(50),@admin char(1),@engineering char(1),@warehouse char(1),@retained_sample char(1),@production char(1)
DECLARE @spv varchar(255), @priviledges varchar(255), @query varchar(MAX)

DECLARE aCursor CURSOR FOR SELECT id,username,fullname,email,dept,position,[sign],[status],spv1,spv2,admin,engineering,warehouse,retained_sample,production  FROM BMS.dbo.userlist
OPEN aCursor						
	FETCH NEXT FROM aCursor INTO @id,@username,@fullname,@email,@dept,@position,@sign,@status,@spv1,@spv2,@admin,@engineering,@warehouse,@retained_sample,@production
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		set @priviledges='' set @spv='' --print '===>'+@priviledges
		IF @sign is null SET @sign=''
		IF @status='1' SET @status='2' ELSE SET @status='1' --UBAH STATUS
		IF @spv1 !='' SET @spv=(select id from BMS.dbo.userlist where username=@spv1) --@spv1+',xx' --ELSE SET @spv=null
		IF @spv2 !='' SET @spv=@spv+','+(SELECT CAST(id AS CHAR) from BMS.dbo.userlist where username=@spv2)
		IF @engineering=1 SET @priviledges='"eng"'
		IF @warehouse=1 BEGIN IF @priviledges!='' SET @priviledges+=',"wh"' ELSE SET @priviledges+='"wh"' END
		IF @retained_sample=1 BEGIN IF @priviledges!='' SET @priviledges+=',"qo"' ELSE SET @priviledges+='"qo"' END
		IF @production=1 BEGIN IF @priviledges!='' SET @priviledges+=',"prod"' ELSE SET @priviledges+='"prod"' END
		
		PRINT'id:'+@id+','+@username+', '+@fullname+', '+@email+', '+@dept+', '+@position+', '+@sign+', status: '+@status+', '+@spv1+', '+@spv2+', '+@admin+', '+@engineering+', '+@warehouse+', '+@retained_sample+', '+@production
		SET @query='INSERT INTO userlist (id, username,fullname,email,dept,position,sign,spv,priviledges,status)
		VALUES ('''+@id+''','''+@username+''','''+@fullname+''','''+@email+''','''+@dept+''','''+@position+''','''+@sign+''','''+@spv+''','''+@priviledges+''','''+@status+''')'
		PRINT @query
		EXEC(@query)
	FETCH NEXT FROM aCursor INTO @id,@username,@fullname,@email,@dept,@position,@sign,@status,@spv1,@spv2,@admin,@engineering,@warehouse,@retained_sample,@production
	--print @@FETCH_STATUS
	END    
CLOSE aCursor
DEALLOCATE aCursor  -- unset cursor
SET IDENTITY_INSERT userlist OFF