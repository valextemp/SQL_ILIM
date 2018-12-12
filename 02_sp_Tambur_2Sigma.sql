
-- !!! 14/05/2018 Самый окончательный вариант работать будет из БД Procont

--============================================================================
use [Procont]
IF OBJECT_ID ( 'Procont.dbo.sp_Tambur_2Sigma', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_Tambur_2Sigma;  
GO  
CREATE PROCEDURE dbo.sp_Tambur_2Sigma   

AS  
BEGIN 
Declare @DateToWrite DateTime = GETDATE() -- Параметр для моей табл время записи в табл
Declare @DateToWriteStr NVARCHAR(50) = CONVERT(NVARCHAR,@DateToWrite, 121) 
Declare @TimeEndMax as DateTime
Declare @EndTimeMax NVARCHAR(50)
DECLARE @sql_str nvarchar(max)
Declare @sql_str1 nvarchar(max)
Declare @sql_str_final nvarchar(max)

Set @TimeEndMax=DATEADD(millisecond,4,(select MAX(Time_End) from [Procont].[dbo].[Tambur_2Sigma])) -- добовляю 4 милисекунды
Set @EndTimeMax=CONVERT(NVARCHAR,ISNULL(@TimeEndMax,DATEADD(hour,-24,getdate())), 121)

CREATE TABLE #Tambur_2Sigma(
	[Machina] [int] NULL,
	[Num] [int] NULL,
	[Time_Start] [datetime] NULL,
	[Time_End] [datetime] NULL,
	[S1] [real] NULL,	[S2] [real] NULL,	[S3] [real] NULL,	[S4] [real] NULL,	[S5] [real] NULL,	[S6] [real] NULL,
	[S7] [real] NULL,	[S8] [real] NULL,	[S9] [real] NULL,	[S10] [real] NULL,	[S11] [real] NULL,	[S12] [real] NULL,
	[S13] [real] NULL,	[S14] [real] NULL,	[S15] [real] NULL,	[S16] [real] NULL,	[S17] [real] NULL,	[S18] [real] NULL,
	[S19] [real] NULL,	[S20] [real] NULL,	[S21] [real] NULL,	[S22] [real] NULL,	[S23] [real] NULL,	[S24] [real] NULL,
	[S25] [real] NULL,	[S26] [real] NULL,	[S27] [real] NULL,	[S28] [real] NULL,	[S29] [real] NULL,	[S30] [real] NULL,
	[S31] [real] NULL,	[S32] [real] NULL,	[S33] [real] NULL,	[S34] [real] NULL,	[S35] [real] NULL,	[S36] [real] NULL,
	[S37] [real] NULL,	[S38] [real] NULL,	[S39] [real] NULL,	[S40] [real] NULL
)

Set @sql_str= 	
	N'SELECT 
		 ts.S1 [S1],	ts.S10 [S10],	ts.S11 [S11],	ts.S12 [S12],	ts.S13 [S13],	ts.S14 [S14]
		,ts.S15 [S15],	ts.S16 [S16],	ts.S17 [S17],	ts.S18 [S18],	ts.S19 [S19],	ts.S2 [S2],	ts.S20 [S20]
		,ts.S21 [S21],	ts.S22 [S22],	ts.S23 [S23],	ts.S24 [S24],	ts.S25 [S25],	ts.S26 [S26], ts.S27 [S27]
		,ts.S28 [S28],	ts.S29 [S29],	ts.S3 [S3],	ts.S30 [S30],	ts.S31 [S31],	ts.S32 [S32],	ts.S33 [S33]
		,ts.S34 [S34],	ts.S35 [S35],	ts.S36 [S36],	ts.S37 [S37],	ts.S38 [S38],	ts.S39 [S39],	ts.S4 [S4]
		,ts.S40 [S40],	ts.S5 [S5],	ts.S6 [S6],	ts.S7 [S7],	ts.S8 [S8],	ts.S9 [S9],	ts.Num [Num], ts.Machina [Machina]
		,ef.StartTime [StartTime], ef.EndTime [EndTime]
		
	FROM
	(
		SELECT *
		FROM [AF].[EventFrame].[EventFrame]
		WHERE EventFrameTemplateID IN 
		(
			SELECT ID
			FROM [AF].[EventFrame].[EventFrameTemplate]
			WHERE Name = N''Тамбур_БДМ 7_Сигма'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
		)
	) ef
	INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
		ON efh.ID = ef.ID
	INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_БДМ 7_Сигма] ts
		ON ts.EventFrameID = ef.ID
	OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'


Set @sql_str_final = N'
	INSERT INTO #Tambur_2Sigma (
		 	[S1], 	[S10], 	[S11], 	[S12], 	[S13], 	[S14], 	[S15], 	[S16], 	[S17], 	[S18], 	[S19], 	[S2] 
		,[S20], 	[S21], 	[S22], 	[S23], 	[S24], 	[S25], 	[S26], 	[S27], 	[S28], 	[S29], 	[S3] 	
		,[S30], 	[S31], 	[S32], 	[S33], 	[S34], 	[S35], 	[S36], 	[S37], 	[S38], 	[S39], 	[S4] 	
		,[S40], 	[S5], 	[S6], 	[S7], 	[S8], 	[S9], 	[Num], [Machina]
		,[Time_Start], [Time_End]
		)
	SELECT 
	    	[S1], 	[S10], 	[S11], 	[S12], 	[S13], 	[S14]
		,[S15], 	[S16], 	[S17], 	[S18], 	[S19], 	[S2], 	[S20]
		,[S21], 	[S22], 	[S23], 	[S24], 	[S25], 	[S26], 	[S27]
		,[S28], 	[S29], 	[S3], 	[S30], 	[S31], 	[S32], 	[S33]
		,[S34], 	[S35], 	[S36], 	[S37], 	[S38], 	[S39], 	[S4]
		,[S40], 	[S5], 	[S6], 	[S7], 	[S8], 	[S9], 	[Num], [Machina]
		,[StartTime],[EndTime]
		
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str, '''', '''''') + ''')'

EXEC (@sql_str_final)

-- Запись в основную таблицу Procont Tambur_2Sigma
INSERT INTO [Procont].[dbo].[Tambur_2Sigma] (
	 	[S1], 	[S10], 	[S11], 	[S12], 	[S13], 	[S14], 	[S15], 	[S16], 	[S17], 	[S18], 	[S19], 	[S2] 
	,[S20], 	[S21], 	[S22], 	[S23], 	[S24], 	[S25], 	[S26], 	[S27], 	[S28], 	[S29], 	[S3] 	
	,[S30], 	[S31], 	[S32], 	[S33], 	[S34], 	[S35], 	[S36], 	[S37], 	[S38], 	[S39], 	[S4] 	
	,[S40], 	[S5], 	[S6], 	[S7], 	[S8], 	[S9], 	[Num], [Machina]
	,[Time_Start], [Time_End]
	)
SELECT 		[S1], 	[S10], 	[S11], 	[S12], 	[S13], 	[S14], 	[S15], 	[S16], 	[S17], 	[S18], 	[S19], 	[S2] 
	,[S20], 	[S21], 	[S22], 	[S23], 	[S24], 	[S25], 	[S26], 	[S27], 	[S28], 	[S29], 	[S3] 	
	,[S30], 	[S31], 	[S32], 	[S33], 	[S34], 	[S35], 	[S36], 	[S37], 	[S38], 	[S39], 	[S4] 	
	,[S40], 	[S5], 	[S6], 	[S7], 	[S8], 	[S9], 	[Num], [Machina]
	,[Time_Start], [Time_End]
FROM #Tambur_2Sigma

DROP Table #Tambur_2Sigma
END
GO  