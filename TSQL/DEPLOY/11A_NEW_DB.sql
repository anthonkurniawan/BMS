/****** AUTHOR: anthon.awan@gmail.com  Script Date: 04/11/2016 04:23:21 ******/

USE [BMS3]
GO
/****** Object:  Table [dbo].[userlog]    Script Date: 05/06/2016 15:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userlog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[date] [smalldatetime] NOT NULL,
	[userid] [smallint] NOT NULL,
	[event] [varchar](1000) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[userlist]    Script Date: 05/06/2016 15:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userlist](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[fullname] [varchar](100) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[dept] [varchar](15) NOT NULL,
	[position] [varchar](5) NOT NULL,
	[sign] [varchar](50) NULL,
	[spv] [varchar](100) NULL,
	[priviledges] [varchar](150) NOT NULL,
	[status] [tinyint] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[units]    Script Date: 05/06/2016 15:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[units](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[deptId] [smallint] NOT NULL,
	[code] [varchar](10) NOT NULL,
	[label] [varchar](150) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[units] ON
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (1, 1, N'ahu1', N'AHU1')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (2, 1, N'ahu2', N'AHU2')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (3, 1, N'wfi', N'WFI & PSG')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (4, 1, N'wpu', N'WPU')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (5, 1, N'demin', N'Demineralization')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (6, 3, N'wh', N'Warehouse')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (7, 2, N'drycore', N'Dry Core')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (8, 2, N'sterile', N'Sterile')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (9, 2, N'goods', N'Finished Goods')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (10, 4, N'retain', N'Retained Sample')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (13, 4, N'lab_chemic', N'Chemical Lab.')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (14, 4, N'lab_micro', N'Micro Lab.')
INSERT [dbo].[units] ([id], [deptId], [code], [label]) VALUES (15, 5, N'', N'')
SET IDENTITY_INSERT [dbo].[units] OFF

/****** Object:  Table [dbo].[tagtime]    Script Date: 05/06/2016 15:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tagtime](
	[time] [smallint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tagname]    Script Date: 05/06/2016 15:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tagname](
	[id] [smallint] IDENTITY(1,1) NOT NULL,
	[tagname] [varchar](255) NOT NULL,
	[unit] [smallint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[getTagAlias]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE
[dbo].[getTagAlias] @tagname VARCHAR(150)=null, @out VARCHAR(150) OUTPUT
AS 
	SELECT @out= REPLACE(REPLACE( REPLACE (@tagname,'.','_'),'-','_'),';','_')
RETURN
GO
/****** Object:  Table [dbo].[emailcfg]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[emailcfg](
	[id] [int] NOT NULL,
	[Host] [varchar](100) NOT NULL,
	[Port] [smallint] NOT NULL,
	[From] [varchar](150) NOT NULL,
	[FromName] [varchar](150) NOT NULL,
	[Priority] [tinyint] NOT NULL,
	[ContentType] [varchar](10) NOT NULL,
	[Timeout] [smallint] NULL,
	[SMTPAuth] [tinyint] NULL,
	[SMTPSecure] [varchar](5) NULL,
	[Username] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[SMTPDebug] [tinyint] NULL,
	[Debugoutput] [varchar](5) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[depts]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[depts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](10) NOT NULL,
	[label] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[depts] ON
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (1, N'eng', N'Engineering')
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (2, N'prod', N'Production')
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (3, N'wh', N'Warehouse')
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (4, N'qo', N'Quality Operations')
INSERT [dbo].[depts] ([id], [code], [label]) VALUES (5, N'qa', N'Quality Assurance')
SET IDENTITY_INSERT [dbo].[depts] OFF
/****** Object:  Table [dbo].[report]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[report](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[unit] [varchar](20) NOT NULL,
	[dept] [varchar](10) NOT NULL,
	[date] [date] NOT NULL,
	[status] [tinyint] NOT NULL,
	[update_date] [smalldatetime] NULL,
	[progress] [tinyint] NOT NULL,
 CONSTRAINT [PK_report] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_report] ON [dbo].[report] 
(
	[date] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_createTbl]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** AUTHOR: anthon.awan@yahoo.com Object:  StoredProcedure [dbo].[getTagname]    Script Date: 04/11/2016 04:23:21 ******/
CREATE PROCEDURE [dbo].[sp_createTbl] @name VARCHAR(20)=null
AS 
	DECLARE aCursor CURSOR FOR SELECT tagname  FROM tagname
	OPEN aCursor						
	DECLARE @tagname varchar(200),@tagname_alias varchar(200), @query varchar(MAX)

	SET @query = 'CREATE TABLE ['+@name+']([tanggal] [smalldatetime] NOT NULL'
	
	FETCH NEXT FROM aCursor INTO @tagname 
  WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC getTagAlias @tagname, @out=@tagname_alias output
			IF (SELECT tagname FROM OPENQUERY(HISTORIAN,'select tagname from ihtags') WHERE tagname=@tagname) IS NOT NULL
				BEGIN
					SET @query = @query + ',' + @tagname_alias +' real NULL'
				END
			FETCH NEXT FROM aCursor INTO @tagname
		END
        
	CLOSE aCursor
	DEALLOCATE aCursor

	SET @query = @query+' ) ON [PRIMARY]'
	EXEC(@query)

EXECUTE('CREATE UNIQUE CLUSTERED INDEX '+@name+'_IDX ON '+@name+'(tanggal)')
GO
/****** Object:  StoredProcedure [dbo].[backupLog]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** AUTHOR: anthon.awan@yahoo.com  Script Date: 04/11/2016 04:23:21 ******/
CREATE PROCEDURE
[dbo].[backupLog]
AS 
SELECT TOP ( 5 )
s.database_name,
s.server_name,
s.user_name,
CASE s.[type]
WHEN 'D' THEN 'Full'
WHEN 'I' THEN 'Differential'
WHEN 'L' THEN 'Transaction Log'
END as BackupType,
m.physical_device_name,
cast(CAST(s.backup_size / 1000000 AS INT) as varchar(14)) + ' ' + 'MB' as bkSize,
s.backup_start_date,
s.backup_finish_date,
CAST(DATEDIFF(second, s.backup_start_date, s.backup_finish_date) AS VARCHAR(4)) + ' '+ 'Seconds' TimeTaken,
s.recovery_model
FROM msdb.dbo.backupset s
inner join msdb.dbo.backupmediafamily m ON s.media_set_id=m.media_set_id
WHERE s.database_name='BMS3'
ORDER BY backup_start_date desc,
backup_finish_date
GO
/****** Object:  StoredProcedure [dbo].[jobLog]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** AUTHOR: anthon.awan@yahoo.com  Script Date: 04/11/2016 04:23:21 ******/
CREATE PROCEDURE
[dbo].[jobLog]
AS 
SELECT TOP 10 JOB.name,
HIST.step_name,
CASE WHEN HIST.run_status=0 THEN 'Failed'
WHEN HIST.run_status=1 THEN 'Succeeded'
WHEN HIST.run_status=2 THEN 'Retry'
WHEN HIST.run_status=3 THEN 'Canceled'
END,
HIST.message,
msdb.dbo.agent_datetime(run_date, run_time) as 'RunDateTime',
((run_duration/10000*3600 +(run_duration/100)%100*60 + run_duration%100 + 31) / 60) as 'RunDurationMinutes'
FROM  msdb.dbo.sysjobs JOB
INNER JOIN  msdb.dbo.sysjobhistory HIST ON HIST.job_id=JOB.job_id
WHERE JOB.name='HISTORIAN_SNYC'
ORDER BY RunDateTime DESC
GO
/****** Object:  StoredProcedure [dbo].[getTagname]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE
[dbo].[getTagname] @tagname VARCHAR(150)=null
AS 
BEGIN
	IF @tagname IS NOT NULL
		SELECT * FROM tagname WHERE tagname=@tagname
	ELSE
		SELECT * FROM tagname
END
GO
/****** Object:  Table [dbo].[comment]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[comment](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[report_id] [int] NOT NULL,
	[submit_date] [smalldatetime] NOT NULL,
	[comment] [varchar](max) NOT NULL,
	[isReject] [tinyint] NULL,
	[position] [varchar](10) NOT NULL,
	[uid] [smallint] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE CLUSTERED INDEX [IX_comment] ON [dbo].[comment] 
(
	[report_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_comment_userId] ON [dbo].[comment] 
(
	[uid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[cleantemptbl]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE
[dbo].[cleantemptbl]
AS 
DECLARE tblCursor CURSOR FOR SELECT table_name FROM INFORMATION_SCHEMA.TABLES 
		WHERE TABLE_NAME IN ( SELECT REPLACE(REPLACE( REPLACE (tagname,'.','_'),'-','_'),';','_') FROM tagname)

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
GO
/****** Object:  StoredProcedure [dbo].[split_data_year]    Script Date: 05/06/2016 15:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** AUTHOR: anthon.awan@yahoo.com  Script Date: 04/11/2016 04:23:21 ******/
CREATE PROCEDURE
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
GO
/****** Object:  ForeignKey [FK_comment_report]    Script Date: 05/06/2016 15:13:04 ******/
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_report] FOREIGN KEY([report_id])
REFERENCES [dbo].[report] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_report]
GO
