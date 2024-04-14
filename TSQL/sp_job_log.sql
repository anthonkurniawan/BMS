USE [BMS3]
GO
/****** Object:  StoredProcedure [dbo].[jobLog]    Script Date: 03/06/2023 23:57:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** AUTHOR: anthon.awan@gmail.com  Script Date: 04/11/2016 04:23:21 ******/
ALTER PROCEDURE
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
