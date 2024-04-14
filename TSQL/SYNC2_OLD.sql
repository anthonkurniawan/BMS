--USE BMS
--SET IMPLICIT_TRANSACTIONS ON

DECLARE @max_newest_data_time datetime,  @min_oldest_data_time datetime
DECLARE @max_his_time datetime  -- max datetime on historian
DECLARE @last_3bulan datetime  --interval
DECLARE @jarak_bulan int
DECLARE @jarak_tahun int
DECLARE @last_1tahun datetime

SET @max_newest_data_time=(SELECT MAX(tanggal) FROM tags_data)
SET @min_oldest_data_time=(SELECT MIN(tanggal) FROM tags_data)
SET @last_3bulan= DATEADD(MONTH, -3, @max_newest_data_time)
SET @last_1tahun = DATEADD(YEAR, 1, @min_oldest_data_time)

PRINT 'min_oldest_data_time(TAGS_DATA) :' + cast(@min_oldest_data_time as varchar(20))
PRINT 'max_newest_data_time(TAGS_DATA) :' + cast(@max_newest_data_time as varchar(20))
PRINT 'last_3bulan :' + cast(@last_3bulan as varchar(20)) 
PRINT 'previous_1tahun :' + CAST(@last_1tahun as varchar(20)) + char(10)


--DECLARE @data_terbaru_3bulan datetime  -- CARI NEXT 3BULAN DARI DATA YG PALING BARU  @max_newest_data_time
--SET @data_terbaru_3bulan= DATEADD(MONTH, 3, @max_newest_data_time) 
--PRINT 'next_3bulan : TO ' + CAST(@data_terbaru_3bulan as varchar(20))


/* CHECK FILTER FOR DATA FRESH TO OLD DATA */
--SET @jarak_bulan= DATEDIFF(MONTH ,@data_terbaru_3bulan, CAST(GETDATE() AS smalldatetime)) -- JARAK DR "NOW" GETDATE()
--SET @jarak_bulan= DATEDIFF(MONTH , @max_newest_data_time, @data_terbaru_3bulan) -- 
SET @jarak_bulan= DATEDIFF(MONTH , @min_oldest_data_time, @max_newest_data_time)
PRINT 'JARAK BULAN :' + CAST(@jarak_bulan AS VARCHAR) + 'BULAN'
--SELECT DATEDIFF(DAY, GETDATE()  , @min_oldest_data_time) 
 
PRINT '#1. FILTER DATA TERBARU 3 BULAN ----------------------------------------------------------------------' 
--IF @max_newest_data_time > @last_3bulan		-- IF @jarak_bulan > 0
IF @jarak_bulan > 2
BEGIN
	PRINT 'data lebih dari 3 BULAN ('+cast(@max_newest_data_time as varchar(20))+' TO '+cast(@min_oldest_data_time as varchar(20)) +')'
	
	DECLARE @query AS VARCHAR(200)
	IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TAGS_DATA_DISTRIBUTION')) --check table "tags_data"
	BEGIN
		SET @query= 'SELECT * INTO TAGS_DATA_DISTRIBUTION FROM tags_data WHERE tanggal <='''+ CAST(@last_3bulan as varchar)+''' ORDER BY tanggal DESC'
		EXEC (@query)	--moving data
		DELETE FROM TAGS_DATA WHERE tanggal <= @last_3bulan  --ORDER BY tanggal DESC --delete data
	END
	ELSE
	BEGIN
		SET @query= 'INSERT INTO TAGS_DATA_DISTRIBUTION SELECT * FROM tags_data WHERE tanggal <='''+ CAST(@last_3bulan as varchar)+''' ORDER BY tanggal DESC'
		EXEC (@query)	--moving data
		DELETE FROM TAGS_DATA WHERE tanggal <= @last_3bulan  --ORDER BY tanggal DESC --delete data
	END
	PRINT '->'+ @query
	PRINT '-> DELETE FROM TAGS_DATA WHERE tanggal <='''+ CAST(@last_3bulan as varchar)+''
	
END
ELSE 
	PRINT '1. data kurang dari 3 bulan' + char(10)

/* CHECK FILTER FOR DATA TAHUNan */
SET @jarak_tahun=(SELECT DATEDIFF(YEAR,(SELECT MIN(tanggal) FROM  TAGS_DATA_DISTRIBUTION ), (SELECT MAX(tanggal) FROM TAGS_DATA_DISTRIBUTION)) )
--SET @jarak_tahun=(SELECT DATEDIFF(YEAR,(SELECT MIN(tanggal) FROM  TAGS_DATA_DISTRIBUTION ), GETDATE()) ) --XXXXXXX
PRINT 'JARAK TAHUN UTK DI FILTER:' + CAST(@jarak_tahun AS VARCHAR) +'TAHUN'

PRINT '#2. CHECK JIKA DATA SUDAH GENAP 1YEAR ----------------------------------------------------------------------' 
--IF @max_newest_data_time > @last_1tahun
--IF @jarak_tahun > 0
WHILE @jarak_tahun > 0
BEGIN
	--DECLARE @tbl_old_tahun as VARCHAR(20) = 'TAGS_DATA'+ CAST(DATEPART(YEAR, GETDATE()) AS varchar)
	DECLARE @old_tahun AS VARCHAR(4), @next_old_tahun AS VARCHAR(4), @tbl_old_tahun as VARCHAR(20), @query_tahun AS VARCHAR(200)
	DECLARE @min_oldest_data smalldatetime, @max_newest_data smalldatetime, @data_terbaru_1year smalldatetime
	
	SET @min_oldest_data = (SELECT MIN(tanggal) from TAGS_DATA_DISTRIBUTION)
	SET @max_newest_data = (SELECT MAX(tanggal) from TAGS_DATA_DISTRIBUTION) -->ga dipake
	
	SET @old_tahun = CAST(DATEPART(YEAR, @min_oldest_data) AS VARCHAR)
	SET @next_old_tahun = CAST(DATEPART (YEAR, (DATEADD(YEAR, 1, @old_tahun))) AS VARCHAR)
	SET @tbl_old_tahun = 'TAGS_DATA'+ @old_tahun
	
	--SET @data_terbaru_1year= DATEADD(YEAR, -1, @max_newest_data)  --data terbarukan( FROM REAL DATA)
	
	PRINT 'min_oldest_data(TAGS_DATA_DISTRIBUTION) ->' + CAST(@min_oldest_data AS VARCHAR)
	PRINT 'max_newest_data(TAGS_DATA_DISTRIBUTION) ->' + CAST(@max_newest_data AS VARCHAR) ---> ga di pake
	PRINT 'old_tahun ->' + @old_tahun
	PRINT 'tbl_old_tahun ->' + CAST(@tbl_old_tahun AS VARCHAR)
	PRINT 'next_old_tahun ->' + CAST(@next_old_tahun AS VARCHAR)
	--PRINT 'data_terbaru_1year ->' + CAST(@data_terbaru_1year AS VARCHAR)

	--SET @query= 'SELECT * INTO '+@tbl_old_tahun+' FROM TAGS_DATA_DISTRIBUTION WHERE tanggal >='''+ CAST(@data_terbaru_1year AS VARCHAR)+''' ORDER BY tanggal ASC'
	SET @query= 'SELECT * INTO '+@tbl_old_tahun+' FROM TAGS_DATA_DISTRIBUTION WHERE tanggal >='''+ CAST(@old_tahun AS VARCHAR)+''' AND tanggal < '''+ @next_old_tahun+''''
	
	PRINT '-> ' + @query
	EXEC (@query)	--moving data
	
	PRINT '-> DELETE FROM TAGS_DATA_DISTRIBUTION WHERE tanggal >= @data_terbaru_1year'
	DELETE FROM TAGS_DATA_DISTRIBUTION WHERE tanggal >= @old_tahun AND tanggal < @next_old_tahun 

	PRINT '-------------------------------------------------------' 
	SET @jarak_tahun= DATEDIFF(YEAR, (SELECT MIN(tanggal) FROM TAGS_DATA_DISTRIBUTION), GETDATE()) 
	PRINT 'JARAK TAHUN :' + CAST(@jarak_tahun AS VARCHAR) +'TAHUN'
END
--ELSE 
--	PRINT 'data kurang dari 1 tahun'+ char(10)
	
