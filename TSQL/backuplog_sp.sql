USE [BMS3]
GO
/****** Object:  StoredProcedure [dbo].[backupLog]    Script Date: 03/06/2023 23:48:40 ******/
/****** AUTHOR: anthon.awan@gmail.com  Script Date: 04/11/2016 04:23:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE
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
