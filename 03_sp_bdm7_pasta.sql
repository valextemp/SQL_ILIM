
-- !!! 14/05/2018 —амый окончательный вариант работать будет из Ѕƒ Procont

use [Procont]
IF OBJECT_ID ( 'Procont.dbo.sp_bdm7_pasta', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_bdm7_pasta;  
GO  
CREATE PROCEDURE dbo.sp_bdm7_pasta  

AS  
BEGIN 
CREATE TABLE #BDM7_Pasta
		(
			[ID] [uniqueidentifier] NOT NULL DEFAULT newid(),
			[DateTime] [datetime] NULL,
			[2003G_001R_1] [real] NULL,
			[2003G_001R_2] [real] NULL,
			[2003G_001R_3] [real] NULL,
			[2003G_001R_4] [real] NULL,
			[2003G_001R_5] [real] NULL,
			[2003G_001R_6] [real] NULL,
			[2003G_002R_1] [real] NULL,
			[2003G_002R_2] [real] NULL,
			[2003G_002R_3] [real] NULL,
			[2003G_002R_4] [real] NULL,
			[2003G_003R_1] [real] NULL,
			[2003G_003R_2] [real] NULL,
			[2003G_003R_3] [real] NULL,
			[2003G_003R_4] [real] NULL,
			[2003G_003R_5] [real] NULL,
			[2003G_003R_6] [real] NULL,
			[2003G_003R_7] [real] NULL,
			[2003G_003R_8] [real] NULL,
			[2003G_003R_9] [real] NULL,
			[2003G_003R_10] [real] NULL,
			[2003G_003R_11] [real] NULL,
			[2003G_003R_12] [real] NULL,
			[2003G_003R_13] [real] NULL,
			[2003G_003R_14] [real] NULL,
			[2003G_004R] [real] NULL,
			[2003G_005R] [real] NULL,
			[2003G_006R] [real] NULL,
			[2003G_007R] [real] NULL,
			[2003G_008R] [real] NULL,
			[Process] [int] NOT NULL,
			[Gl_Mat] [int] NOT NULL,
			[StoredInOracle] [int] NOT NULL  DEFAULT (0)
		)

Declare @DateToWrite DateTime = GETDATE() -- ѕараметр дл¤ моей табл врем¤ записи в табл
Declare @DateToWriteStr NVARCHAR(50) = CONVERT(NVARCHAR,@DateToWrite, 121) 
Declare @TimeStartMax as DateTime -- —обыти¤ записываем по старту событи¤
Declare @StartTimeMax NVARCHAR(50)
DECLARE @sql_str nvarchar(max)
Declare @sql_str1 nvarchar(max)
Declare @sql_str_final nvarchar(max)

-- Set @TimeEndMax=Null -- ќтладочный вариант
Set @TimeStartMax=(select MAX([DateTime]) from [Procont].[dbo].[BDM7_Pasta]) -- добовл¤ю 4 милисекунды
Set @StartTimeMax=CONVERT(NVARCHAR,ISNULL(@TimeStartMax,DATEADD(hour,-24,getdate())), 121)

Set @sql_str=N'SELECT 
			ef.starttime [starttime]
			,ts.[2003G_001R_1] [2003G_001R_1]
			,ts.[2003G_001R_2] [2003G_001R_2]
			,ts.[2003G_001R_3] [2003G_001R_3]
			,ts.[2003G_001R_4] [2003G_001R_4]
			,ts.[2003G_001R_5] [2003G_001R_5]
			,ts.[2003G_001R_6] [2003G_001R_6]
			,ts.[2003G_002R_1] [2003G_002R_1]
			,ts.[2003G_002R_2] [2003G_002R_2]
			,ts.[2003G_002R_3] [2003G_002R_3]
			,ts.[2003G_002R_4] [2003G_002R_4]
			,ts.[2003G_003R_1] [2003G_003R_1]
			,ts.[2003G_003R_2] [2003G_003R_2]
			,ts.[2003G_003R_3] [2003G_003R_3]
			,ts.[2003G_003R_4] [2003G_003R_4]
			,ts.[2003G_003R_5] [2003G_003R_5]
			,ts.[2003G_003R_6] [2003G_003R_6]
			,ts.[2003G_003R_7] [2003G_003R_7]
			,ts.[2003G_003R_8] [2003G_003R_8]
			,ts.[2003G_003R_9] [2003G_003R_9]
			,ts.[2003G_003R_10] [2003G_003R_10]
			,ts.[2003G_003R_11] [2003G_003R_11]
			,ts.[2003G_003R_12] [2003G_003R_12]
			,ts.[2003G_003R_13] [2003G_003R_13]
			,ts.[2003G_003R_14] [2003G_003R_14]
			,ts.[2003G_004R] [2003G_004R]
			,ts.[2003G_005R] [2003G_005R]
			,ts.[2003G_006R] [2003G_006R]
			,ts.[2003G_007R] [2003G_007R]
			,ts.[2003G_008R] [2003G_008R]
			,ts.[Gl_Mat] [Gl_Mat]
			,ts.[Process] [Process]             FROM [AF].[EventFrame].[EventFrame] ef
             INNER JOIN [AF].[EventFrame].[EventFrameTemplate] eft ON ef.EventFrameTemplateID = eft.ID
             INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_ѕаста] ts ON ts.EventFrameID = ef.ID
             WHERE eft.Name = N''ѕаста'' and starttime >'''+ @StartTimeMax +'''
             OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

--==================================================================================

Set @sql_str_final = N'
INSERT INTO #BDM7_Pasta
		(
			[DateTime]
			,[2003G_001R_1]
			,[2003G_001R_2]
			,[2003G_001R_3]
			,[2003G_001R_4]
			,[2003G_001R_5]
			,[2003G_001R_6]
			,[2003G_002R_1]
			,[2003G_002R_2]
			,[2003G_002R_3]
			,[2003G_002R_4]
			,[2003G_003R_1]
			,[2003G_003R_2]
			,[2003G_003R_3]
			,[2003G_003R_4]
			,[2003G_003R_5]
			,[2003G_003R_6]
			,[2003G_003R_7]
			,[2003G_003R_8]
			,[2003G_003R_9]
			,[2003G_003R_10]
			,[2003G_003R_11]
			,[2003G_003R_12]
			,[2003G_003R_13]
			,[2003G_003R_14]
			,[2003G_004R]
			,[2003G_005R]
			,[2003G_006R]
			,[2003G_007R]
			,[2003G_008R]
			,[Gl_Mat]
			,[Process]
	)
SELECT 
			[starttime]
			,[2003G_001R_1]
			,[2003G_001R_2]
			,[2003G_001R_3]
			,[2003G_001R_4]
			,[2003G_001R_5]
			,[2003G_001R_6]
			,[2003G_002R_1]
			,[2003G_002R_2]
			,[2003G_002R_3]
			,[2003G_002R_4]
			,[2003G_003R_1]
			,[2003G_003R_2]
			,[2003G_003R_3]
			,[2003G_003R_4]
			,[2003G_003R_5]
			,[2003G_003R_6]
			,[2003G_003R_7]
			,[2003G_003R_8]
			,[2003G_003R_9]
			,[2003G_003R_10]
			,[2003G_003R_11]
			,[2003G_003R_12]
			,[2003G_003R_13]
			,[2003G_003R_14]
			,[2003G_004R]
			,[2003G_005R]
			,[2003G_006R]
			,[2003G_007R]
			,[2003G_008R]
			,[Gl_Mat]
			,[Process]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str, '''', '''''') + ''')'

EXEC (@sql_str_final)

-- ƒобавление в основную таблицу Procont
INSERT INTO [Procont].[dbo].[BDM7_Pasta]
           (
		    [ID]
			,[DateTime]
			,[2003G_001R_1]
			,[2003G_001R_2]
			,[2003G_001R_3]
			,[2003G_001R_4]
			,[2003G_001R_5]
			,[2003G_001R_6]
			,[2003G_002R_1]
			,[2003G_002R_2]
			,[2003G_002R_3]
			,[2003G_002R_4]
			,[2003G_003R_1]
			,[2003G_003R_2]
			,[2003G_003R_3]
			,[2003G_003R_4]
			,[2003G_003R_5]
			,[2003G_003R_6]
			,[2003G_003R_7]
			,[2003G_003R_8]
			,[2003G_003R_9]
			,[2003G_003R_10]
			,[2003G_003R_11]
			,[2003G_003R_12]
			,[2003G_003R_13]
			,[2003G_003R_14]
			,[2003G_004R]
			,[2003G_005R]
			,[2003G_006R]
			,[2003G_007R]
			,[2003G_008R]
			,[Process]
			,[Gl_Mat]
			,[StoredInOracle]
		   	)
    SELECT 
			[ID]
			, Cast(CONVERT(NVARCHAR,DATEADD(hour,0, DATEADD(second, 1, [DateTime])), 120) as datetime) [DateTime] -- доб 1 сек и отсекаю милисек
			,[2003G_001R_1]
			,[2003G_001R_2]
			,[2003G_001R_3]
			,[2003G_001R_4]
			,[2003G_001R_5]
			,[2003G_001R_6]
			,[2003G_002R_1]
			,[2003G_002R_2]
			,[2003G_002R_3]
			,[2003G_002R_4]
			,[2003G_003R_1]
			,[2003G_003R_2]
			,[2003G_003R_3]
			,[2003G_003R_4]
			,[2003G_003R_5]
			,[2003G_003R_6]
			,[2003G_003R_7]
			,[2003G_003R_8]
			,[2003G_003R_9]
			,[2003G_003R_10]
			,[2003G_003R_11]
			,[2003G_003R_12]
			,[2003G_003R_13]
			,[2003G_003R_14]
			,[2003G_004R]
			,[2003G_005R]
			,[2003G_006R]
			,[2003G_007R]
			,[2003G_008R]
			,[Process]
			,[Gl_Mat]
			,[StoredInOracle]
    FROM #BDM7_Pasta

Drop table #BDM7_Pasta

End;