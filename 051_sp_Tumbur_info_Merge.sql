

-- Хранимая процедура после последних модификций 13/03/2018 шаблонов событий
-- Тамбур_БДМ 1, Тамбур_БДМ 2 .....
-- 07/05/2018 переделано на запись в основную БД Procont
-- !!! 14/05/2018 Самый окончательный вариант работать будет из БД Procont (раньше называлась dbo.Tambur_InfoStorProc1)
-- Должна запускаться в отдельном Jobe каждые 30 секунд



use [Procont]
IF OBJECT_ID ( 'Procont.dbo.sp_Tambur_Info_Merge', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_Tambur_Info_Merge;  
GO  
CREATE PROCEDURE dbo.sp_Tambur_Info_Merge   

@Minute int -- Количество минут назад от текущего getdate положительное число

AS  
BEGIN 
CREATE TABLE #Tambur_Info_EF_Machine(
			[Machina]	[int] NULL,	--Номер машины 1
			[Num]	[int] NULL,	--Номер тамбура АСУТП  2
			[Sort]	[nvarchar](50) NULL,	--Сорт  3
			[Time_product]	[real] NULL,	--Время намотки  4
			[Mass_product]	[real] NULL,	--Выработка (т)  5
			[Area_capacity]	[real] NULL,	--Произведено (Га) 6 
			[Mass_capacity]	[real] NULL,	--Производительность (т/ч)  7
			[Length]	[real] NULL,	--Длина полотна 8
			[Width]	[real] NULL,	--Ширина полотна (см) 9 
			[Time_break]	[real] NULL,	--Время обрывов 10
			[Speed]	[real] NULL,	--Скорость машины  11
			[CountBreak]	[int] NULL,	--кол-во обрывов 12
			[InProcont]	[int] NULL DEFAULT (0),	--"для признака что в Проконт передано" 13
			[BW_2_Sigma]	[real] NULL,	--сигма основному весу 14
			[DW_2_Sigma]	[real] NULL,	--сигма по абс. Сух весу 15
			[MO_2_Sigma]	[real] NULL,	--сигма по влажности 16
			[depth]	[real] NULL,	--Толщина полотна 17
			[moisture]	[real] NULL,	--Влажность полотна 18
			[density]	[real] NULL, -- Плотность полотна 19

			[Time_Start]	[datetime] NULL,	--время начала 20
			[Time_End]	[datetime] NULL,	--время окончания 21

			)
Declare @Tambur_Info_EF_Machine table(
			[Machina]	[int] NULL,	--Номер машины 1
			[Num]	[int] NULL,	--Номер тамбура АСУТП  2
			[Sort]	[nvarchar](50) NULL,	--Сорт  3
			[Time_product]	[real] NULL,	--Время намотки  4
			[Mass_product]	[real] NULL,	--Выработка (т)  5
			[Area_capacity]	[real] NULL,	--Произведено (Га) 6 
			[Mass_capacity]	[real] NULL,	--Производительность (т/ч)  7
			[Length]	[real] NULL,	--Длина полотна 8
			[Width]	[real] NULL,	--Ширина полотна (см) 9 
			[Time_break]	[real] NULL,	--Время обрывов 10
			[Speed]	[real] NULL,	--Скорость машины  11
			[CountBreak]	[int] NULL,	--кол-во обрывов 12
			[InProcont]	[int] NULL DEFAULT (0),	--"для признака что в Проконт передано" 13
			[BW_2_Sigma]	[real] NULL,	--сигма основному весу 14
			[DW_2_Sigma]	[real] NULL,	--сигма по абс. Сух весу 15
			[MO_2_Sigma]	[real] NULL,	--сигма по влажности 16
			[depth]	[real] NULL,	--Толщина полотна 17
			[moisture]	[real] NULL,	--Влажность полотна 18
			[density]	[real] NULL, -- Плотность полотна 19

			[Time_Start]	[datetime] NULL,	--время начала 20
			[Time_End]	[datetime] NULL	--время окончания 21

			)


CREATE TABLE #Tambur_Info_EF_PRC
(
			[Machina]	[int] NULL,	--Номер машины 1
			[Num]	[int] NULL,	--Номер тамбура АСУТП  2
			[Sort]	[nvarchar](50) NULL,	--Сорт  3
			[Time_product]	[real] NULL,	--Время намотки  4
			[Mass_product]	[real] NULL,	--Выработка (т)  5
			[Area_capacity]	[real] NULL,	--Произведено (Га) 6 
			[Mass_capacity]	[real] NULL,	--Производительность (т/ч)  7
			[Length]	[real] NULL,	--Длина полотна 8
			[Width]	[real] NULL,	--Ширина полотна (см) 9 
			[Time_break]	[real] NULL,	--Время обрывов 10
			[Speed]	[real] NULL,	--Скорость машины  11
			[CountBreak]	[int] NULL,	--кол-во обрывов 12
			[InProcont]	[int] NULL DEFAULT (0),	--"для признака что в Проконт передано" 13
			[BW_2_Sigma]	[real] NULL,	--сигма основному весу 14
			[DW_2_Sigma]	[real] NULL,	--сигма по абс. Сух весу 15
			[MO_2_Sigma]	[real] NULL,	--сигма по влажности 16
			[depth]	[real] NULL,	--Толщина полотна 17
			[moisture]	[real] NULL,	--Влажность полотна 18
			[density]	[real] NULL, -- Плотность полотна 19

			[Time_Start]	[datetime] NULL,	--время начала 20
			[Time_End]	[datetime] NULL,	--время окончания 21

)
Declare @Tambur_Info_EF_PRC table
(
			[Machina]	[int] NULL,	--Номер машины 1
			[Num]	[int] NULL,	--Номер тамбура АСУТП  2
			[Sort]	[nvarchar](50) NULL,	--Сорт  3
			[Time_product]	[real] NULL,	--Время намотки  4
			[Mass_product]	[real] NULL,	--Выработка (т)  5
			[Area_capacity]	[real] NULL,	--Произведено (Га) 6 
			[Mass_capacity]	[real] NULL,	--Производительность (т/ч)  7
			[Length]	[real] NULL,	--Длина полотна 8
			[Width]	[real] NULL,	--Ширина полотна (см) 9 
			[Time_break]	[real] NULL,	--Время обрывов 10
			[Speed]	[real] NULL,	--Скорость машины  11
			[CountBreak]	[int] NULL,	--кол-во обрывов 12
			[InProcont]	[int] NULL DEFAULT (0),	--"для признака что в Проконт передано" 13
			[BW_2_Sigma]	[real] NULL,	--сигма основному весу 14
			[DW_2_Sigma]	[real] NULL,	--сигма по абс. Сух весу 15
			[MO_2_Sigma]	[real] NULL,	--сигма по влажности 16
			[depth]	[real] NULL,	--Толщина полотна 17
			[moisture]	[real] NULL,	--Влажность полотна 18
			[density]	[real] NULL, -- Плотность полотна 19

			[Time_Start]	[datetime] NULL,	--время начала 20
			[Time_End]	[datetime] NULL	--время окончания 21

)

CREATE TABLE #Tambur_Info_EF_PRC_Machine
(
			[Machina]	[int] NULL,	--Номер машины 1
			[Num]	[int] NULL,	--Номер тамбура АСУТП  2
			[Sort]	[nvarchar](50) NULL,	--Сорт  3
			[Time_product]	[real] NULL,	--Время намотки  4
			[Mass_product]	[real] NULL,	--Выработка (т)  5
			[Area_capacity]	[real] NULL,	--Произведено (Га) 6 
			[Mass_capacity]	[real] NULL,	--Производительность (т/ч)  7
			[Length]	[real] NULL,	--Длина полотна 8
			[Width]	[real] NULL,	--Ширина полотна (см) 9 
			[Time_break]	[real] NULL,	--Время обрывов 10
			[Speed]	[real] NULL,	--Скорость машины  11
			[CountBreak]	[int] NULL,	--кол-во обрывов 12
			[InProcont]	[int] NULL DEFAULT (0),	--"для признака что в Проконт передано" 13
			[BW_2_Sigma]	[real] NULL,	--сигма основному весу 14
			[DW_2_Sigma]	[real] NULL,	--сигма по абс. Сух весу 15
			[MO_2_Sigma]	[real] NULL,	--сигма по влажности 16
			[depth]	[real] NULL,	--Толщина полотна 17
			[moisture]	[real] NULL,	--Влажность полотна 18
			[density]	[real] NULL, -- Плотность полотна 19

			[Time_Start]	[datetime] NULL,	--время начала 20
			[Time_End]	[datetime] NULL,	--время окончания 21

)
Declare @Tambur_Info_EF_PRC_Machine table
(
			[Machina]	[int] NULL,	--Номер машины 1
			[Num]	[int] NULL,	--Номер тамбура АСУТП  2
			[Sort]	[nvarchar](50) NULL,	--Сорт  3
			[Time_product]	[real] NULL,	--Время намотки  4
			[Mass_product]	[real] NULL,	--Выработка (т)  5
			[Area_capacity]	[real] NULL,	--Произведено (Га) 6 
			[Mass_capacity]	[real] NULL,	--Производительность (т/ч)  7
			[Length]	[real] NULL,	--Длина полотна 8
			[Width]	[real] NULL,	--Ширина полотна (см) 9 
			[Time_break]	[real] NULL,	--Время обрывов 10
			[Speed]	[real] NULL,	--Скорость машины  11
			[CountBreak]	[int] NULL,	--кол-во обрывов 12
			[InProcont]	[int] NULL DEFAULT (0),	--"для признака что в Проконт передано" 13
			[BW_2_Sigma]	[real] NULL,	--сигма основному весу 14
			[DW_2_Sigma]	[real] NULL,	--сигма по абс. Сух весу 15
			[MO_2_Sigma]	[real] NULL,	--сигма по влажности 16
			[depth]	[real] NULL,	--Толщина полотна 17
			[moisture]	[real] NULL,	--Влажность полотна 18
			[density]	[real] NULL, -- Плотность полотна 19

			[Time_Start]	[datetime] NULL,	--время начала 20
			[Time_End]	[datetime] NULL	--время окончания 21

)

--=======================================================
-- Временная для записи всех EF со всех шаблонов
CREATE TABLE #Tambur_Info_EF_All
(
			[Machina]	[int] NULL,	--Номер машины 1
			[Num]	[int] NULL,	--Номер тамбура АСУТП  2
			[Sort]	[nvarchar](50) NULL,	--Сорт  3
			[Time_product]	[real] NULL,	--Время намотки  4
			[Mass_product]	[real] NULL,	--Выработка (т)  5
			[Area_capacity]	[real] NULL,	--Произведено (Га) 6 
			[Mass_capacity]	[real] NULL,	--Производительность (т/ч)  7
			[Length]	[real] NULL,	--Длина полотна 8
			[Width]	[real] NULL,	--Ширина полотна (см) 9 
			[Time_break]	[real] NULL,	--Время обрывов 10
			[Speed]	[real] NULL,	--Скорость машины  11
			[CountBreak]	[int] NULL,	--кол-во обрывов 12
			[InProcont]	[int] NULL ,	--"для признака что в Проконт передано" 13
			[BW_2_Sigma]	[real] NULL,	--сигма основному весу 14
			[DW_2_Sigma]	[real] NULL,	--сигма по абс. Сух весу 15
			[MO_2_Sigma]	[real] NULL,	--сигма по влажности 16
			[depth]	[real] NULL,	--Толщина полотна 17
			[moisture]	[real] NULL,	--Влажность полотна 18
			[density]	[real] NULL, -- Плотность полотна 19

			[Time_Start]	[datetime] NULL,	--время начала 20
			[Time_End]	[datetime] NULL,	--время окончания 21

)

Declare @DateToWrite DateTime = GETDATE() -- Параметр для моей табл время записи в табл
Declare @DateToWriteStr NVARCHAR(50) = CONVERT(NVARCHAR,@DateToWrite, 121) 
Declare @TimeEndMax as DateTime
Declare @EndTimeMax NVARCHAR(50)
DECLARE @sql_str nvarchar(max)
Declare @sql_str_final nvarchar(max) 

Declare @sql_str1 nvarchar(max) -- строка запроса к шабону Тамбур_БДМ 1    
Declare @sql_str_final1 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_БДМ 1 
Declare @sql_str2 nvarchar(max) -- строка запроса к шабону Тамбур_БДМ 2    
Declare @sql_str_final2 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_БДМ 2 
Declare @sql_str3 nvarchar(max) -- строка запроса к шабону Тамбур_КДМ 3    
Declare @sql_str_final3 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_КДМ 3 
Declare @sql_str4 nvarchar(max) -- строка запроса к шабону Тамбур_КДМ 4  
Declare @sql_str_final4 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_КДМ 4
Declare @sql_str5 nvarchar(max) -- строка запроса к шабону Тамбур_БДМ 5
Declare @sql_str_final5 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_БДМ 5
Declare @sql_str6 nvarchar(max) -- строка запроса к шабону Тамбур_БДМ 6    
Declare @sql_str_final6 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_БДМ 6 
Declare @sql_str7 nvarchar(max) -- строка запроса к шабону Тамбур_БДМ 7    
Declare @sql_str_final7 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_АМУ
Declare @sql_str8 nvarchar(max) -- строка запроса к шабону Тамбур_БДМ 7    
Declare @sql_str_final8 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_АМУ
Declare @sql_strPRC nvarchar(max) -- Строка запроса к шаблону ПРС
Declare @sql_str_finalPRC nvarchar(max) -- Окончательная Строка запроса к шаблону ПРС
Declare @sql_strPRC_machine nvarchar(max) -- Строка запроса к шаблону ПРС машин
Declare @sql_str_finalPRC_machine nvarchar(max) -- Окончательная Строка запроса к шаблону ПРС

Set @TimeEndMax=Null

--  Устанавливаю EndTime на час назад
Set @EndTimeMax=CONVERT(NVARCHAR,ISNULL(@TimeEndMax,DATEADD(MINUTE,(@Minute)*(-1),getdate())), 121)

-- print @EndTimeMax

--Set @TimeEndMax=(CONVERT(dateTime, '2018-02-19 00:00:00'))
--Set @EndTimeMax=CONVERT(NVARCHAR,ISNULL(@TimeEndMax,DATEADD(hour,0,getdate())), 121)
--===============================================================================
--- Шаблон события "Тамбур_БДМ 1"
Set @sql_str1=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_БДМ 1'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_БДМ 1] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_final1 = N'
INSERT INTO #Tambur_Info_EF_Machine
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str1, '''', '''''') + ''')'

EXEC (@sql_str_final1)

Set @sql_str2=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_БДМ 2'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_БДМ 2] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_final2 = N'
INSERT INTO #Tambur_Info_EF_Machine
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str2, '''', '''''') + ''')'

EXEC (@sql_str_final2)
--==================================================================================
-- Машина КДМ 3
Set @sql_str3=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_КДМ 3'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_КДМ 3] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_final3 = N'
INSERT INTO #Tambur_Info_EF_Machine
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str3, '''', '''''') + ''')'

EXEC (@sql_str_final3)

--==================================================================================
-- Машина КДМ 4
Set @sql_str4=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_КДМ 4'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_КДМ 4] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_final4 = N'
INSERT INTO #Tambur_Info_EF_Machine
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str4, '''', '''''') + ''')'

EXEC (@sql_str_final4)
--==================================================================================
-- Машина БДМ 5
Set @sql_str5=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_БДМ 5'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_БДМ 5] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_final5 = N'
INSERT INTO #Tambur_Info_EF_Machine
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str5, '''', '''''') + ''')'

EXEC (@sql_str_final5)

--==================================================================================
-- Машина БДМ 6
Set @sql_str6=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_БДМ 6'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_БДМ 6] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_final6 = N'
INSERT INTO #Tambur_Info_EF_Machine
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str6, '''', '''''') + ''')'

EXEC (@sql_str_final6)
--==================================================================================
-- Машина БДМ 7
Set @sql_str7=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_БДМ 7'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_БДМ 7] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_final7 = N'
INSERT INTO #Tambur_Info_EF_Machine
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str7, '''', '''''') + ''')'

EXEC (@sql_str_final7)
--==================================================================================
-- Машина АМУ
Set @sql_str8=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_АМУ'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_АМУ] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_final8 = N'
INSERT INTO #Tambur_Info_EF_Machine
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str8, '''', '''''') + ''')'

EXEC (@sql_str_final8)

--=========================================================================================
-- Шаблон Тамбур_ПРС
Set @DateToWrite = GETDATE() -- Параметр для моей табл время записи в табл
Set @DateToWriteStr  = CONVERT(NVARCHAR,@DateToWrite, 121) 

Set @sql_strPRC=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_ПРС'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_ПРС] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_finalPRC = N'
INSERT INTO #Tambur_Info_EF_PRC
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_strPRC, '''', '''''') + ''')'

EXEC (@sql_str_finalPRC)


--=========================================================================
-- Шаблон Тамбур_ПРС_машин
Set @DateToWrite = GETDATE() -- Параметр для моей табл время записи в табл
Set @DateToWriteStr  = CONVERT(NVARCHAR,@DateToWrite, 121) 

Set @sql_strPRC_machine=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  Не используется  тип данных - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  Сигма основному весу  тип данных - Double 2
					, ts.CountBreak [CountBreak]   --  Кол-во обрывов  тип данных - Int32 3
					, ts.density [density]   --  Плотность полотна (г/м2)  тип данных - Double  4
					, ts.depth [depth]   --  Толщина полотна  тип данных - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  Сигма по абс весу  тип данных - Double  6
					, ts.Length [Length]   --  Длина полотна  тип данных - Double  7
					, ts.Machina [Machina]   --    тип данных - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  Производительность (т/ч)  тип данных - Double 9
					, ts.Mass_product [Mass_product]   --  Выработка (т)  тип данных - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  Сигма по влажности  тип данных - Double  11
					, ts.moisture [moisture]   --  Влажность полотна текущая  тип данных - Double 12
					, ts.Num [Num]   --  Номер тамбура  тип данных - Int32 13
					, ts.Sort [Sort]   --  Сорт  тип данных - String 14
					, ts.Speed [Speed]   --  Скорость наката БДМ-7  тип данных - Double  15
					, ts.Time_Break [Time_Break]   --  Время обрывов  тип данных - Double  16
					, ts.Time_Product [Time_Product]   --  Время намотки тамбура  тип данных - Double 17
					, ts.Width [Width]   --  Ширина тамбура  тип данных - Double  -- 18

					, ef.StartTime [Time_Start], ef.EndTime [Time_End]  --19
					, ts.EventFrameID [EventFrameID]  --20
				FROM
				(
					SELECT *
					FROM [AF].[EventFrame].[EventFrame]
					WHERE EventFrameTemplateID IN 
					(
						SELECT ID
						FROM [AF].[EventFrame].[EventFrameTemplate]
						WHERE Name = N''Тамбур_ПРС_машин'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Тамбур_ПРС_машин] ts
					ON ts.EventFrameID = ef.ID
				OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'

Set @sql_str_finalPRC_machine = N'
INSERT INTO  #Tambur_Info_EF_PRC_Machine
		(
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	)
SELECT 
				 [Area_Capacity]
				, [BW_2_Sigma]
				, [CountBreak]
				, [density]
				, [depth]
				, [DW_2_Sigma]
				, [Length]
				, CONVERT(int, [Machina]) [Machina]
				, [Mass_Capacity]
				, [Mass_product]
				, [MO_2_Sigma]
				, [moisture]
				, [Num]
				, [Sort]
				, [Speed]
				, [Time_Break]
				, [Time_Product]
				, [Width]

				, [Time_Start], [Time_End]
	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_strPRC_machine, '''', '''''') + ''')'

EXEC (@sql_str_finalPRC_machine)

--================================================================
-- Запись всех EF в общаю временную таблицу
INSERT INTO #Tambur_Info_EF_All
           (
           [Machina]
           ,[Num]
           ,[Sort]
           ,[Time_product]
           ,[Mass_product]
           ,[Area_capacity]
           ,[Mass_capacity]
           ,[Length]
           ,[Width]
           ,[Time_break]
           ,[Speed]
           ,[CountBreak]
           ,[InProcont]
           ,[BW_2_Sigma]
           ,[DW_2_Sigma]
           ,[MO_2_Sigma]
           ,[depth]
           ,[moisture]
           ,[density]
           ,[Time_Start]
           ,[Time_End]
 		   	)
    SELECT 
			[Machina]
			,[Num]
			,[Sort]
			,ROUND(ISNULL([Time_product],0),3) [Time_product]
			,ROUND([Mass_product],3) [Mass_product]
			,ISNULL([Area_capacity],0) [Area_capacity]
			,ROUND([Mass_capacity],3) [Mass_capacity]
			,ROUND([Length],3) [Length]
			,ROUND([Width],3) [Width]
			,ISNULL([Time_break],0) [Time_break]
			,ROUND([Speed],3) [Speed]
			,ISNULL([CountBreak],0) [CountBreak]
			,[InProcont]
			,CASE [Machina]
					 WHEN 4 THEN ROUND(ISNULL([BW_2_Sigma],0),3)
					 Else  ROUND([BW_2_Sigma],3)
			 END  AS    [BW_2_Sigma]
			,CASE [Machina]
					 WHEN 4 THEN ROUND(ISNULL([DW_2_Sigma],0),3)
					 Else  ROUND([DW_2_Sigma],3)
			 END  AS    [DW_2_Sigma]
			,CASE [Machina]
					 WHEN 4 THEN ROUND(ISNULL([MO_2_Sigma],0),3)
					 Else  ROUND([MO_2_Sigma],3)
			 END  AS    [MO_2_Sigma]
			,ROUND([depth],3) [depth]
			,ROUND([moisture],1) [moisture]
			,ROUND([density],1) [density]
			,[Time_Start]
			,[Time_End]
    FROM #Tambur_Info_EF_Machine
--===============================================================
INSERT INTO #Tambur_Info_EF_All
           (
           [Machina]
           ,[Num]
           ,[Sort]
           ,[Time_product]
           ,[Mass_product]
           ,[Area_capacity]
           ,[Mass_capacity]
           ,[Length]
           ,[Width]
           ,[Time_break]
           ,[Speed]
           ,[CountBreak]
           ,[InProcont]
           ,[BW_2_Sigma]
           ,[DW_2_Sigma]
           ,[MO_2_Sigma]
           ,[depth]
           ,[moisture]
           ,[density]
           ,[Time_Start]
           ,[Time_End]
 		   	)
    SELECT 
	/* Преобразуем как у них в таблице и учитываем замечания в файле
	   Информация по тамбурам БДМ1-7и ПРС АМУ БДМ7 БДМ56 с привязкой к тэгам АСУТП (002).xlsx*/
			[Machina]
			,CONVERT(int, FORMAT( [Time_End], 'HHmmddMM' )) [Num]
			,[Sort]
			,Round ((DATEDIFF(second, [Time_Start], [Time_End]))/60.0,3) [Time_product]
			,ISNULL([Mass_product],0) [Mass_product]
			,ISNULL([Area_capacity],0) [Area_capacity]
			,ISNULL([Mass_capacity],0) [Mass_capacity]
			,Round ([Length], 3) [Length]
			,ISNULL([Width],0) [Width]
			,ISNULL([Time_break],0) [Time_break]
			,ISNULL([Speed],0) [Speed]
			,ISNULL([CountBreak],0) [CountBreak]
			,[InProcont]
			,ISNULL([BW_2_Sigma],0) [BW_2_Sigma]
			,ISNULL([DW_2_Sigma],0) [DW_2_Sigma]
			,ISNULL([MO_2_Sigma],0) [MO_2_Sigma]
			,[depth]
			,[moisture]
			,[density]
			,[Time_Start]
			,[Time_End]
    FROM #Tambur_Info_EF_PRC  
	Where [Length]>1000
--==================================================================
INSERT INTO #Tambur_Info_EF_All
           (
           [Machina]
           ,[Num]
           ,[Sort]
           ,[Time_product]
           ,[Mass_product]
           ,[Area_capacity]
           ,[Mass_capacity]
           ,[Length]
           ,[Width]
           ,[Time_break]
           ,[Speed]
           ,[CountBreak]
           ,[InProcont]
           ,[BW_2_Sigma]
           ,[DW_2_Sigma]
           ,[MO_2_Sigma]
           ,[depth]
           ,[moisture]
           ,[density]
           ,[Time_Start]
           ,[Time_End]
 		   	)
	/* Преобразуем как у них в таблице и учитываем замечания в файле
	   Информация по тамбурам БДМ1-7и ПРС АМУ БДМ7 БДМ56 с привязкой к тэгам АСУТП (002).xlsx*/
   SELECT 
			[Machina]
			,CONVERT(int, FORMAT( [Time_End], 'HHmmddMM' )) [Num]
			,[Sort]
			,ISNULL([Time_product],0) [Time_product]
			,ISNULL([Mass_product],0) [Mass_product]
			,ISNULL([Area_capacity],0) [Area_capacity]
			,ISNULL([Mass_capacity],0) [Mass_capacity]
			,ROUND([Length],3) [Length]
			,ROUND([Width],3) [Width]
			,ISNULL([Time_break],0) [Time_break]
			,ISNULL([Speed],0) [Speed]
			,ISNULL([CountBreak],0) [CountBreak]
			,[InProcont]
			,ISNULL([BW_2_Sigma],0) [BW_2_Sigma]
			,ISNULL([DW_2_Sigma],0) [DW_2_Sigma]
			,ISNULL([MO_2_Sigma],0) [MO_2_Sigma]
			,[depth]
			,[moisture]
			,[density]
			,[Time_Start]
			,[Time_End]
    FROM #Tambur_Info_EF_PRC_Machine 
--=============================================================


----==============================================================	
---- Запись в основну БД Procont
--INSERT INTO [Procont].[dbo].[Tambur_Info] 
--           (
--           [Machina]
--           ,[Num]
--           ,[Sort]
--           ,[Time_product]
--           ,[Mass_product]
--           ,[Area_capacity]
--           ,[Mass_capacity]
--           ,[Length]
--           ,[Width]
--           ,[Time_break]
--           ,[Speed]
--           ,[CountBreak]
--           ,[InProcont]
--           ,[BW_2_Sigma]
--           ,[DW_2_Sigma]
--           ,[MO_2_Sigma]
--           ,[depth]
--           ,[moisture]
--           ,[density]
--           ,[Time_Start]
--           ,[Time_End]
-- 		   	)
--    SELECT 
--			[Machina]
--			,[Num]
--			,[Sort]
--			,ROUND(ISNULL([Time_product],0),3) [Time_product]
--			,ROUND([Mass_product],3) [Mass_product]
--			,ISNULL([Area_capacity],0) [Area_capacity]
--			,ROUND([Mass_capacity],3) [Mass_capacity]
--			,ROUND([Length],3) [Length]
--			,ROUND([Width],3) [Width]
--			,ISNULL([Time_break],0) [Time_break]
--			,ROUND([Speed],3) [Speed]
--			,ISNULL([CountBreak],0) [CountBreak]
--			,[InProcont]
--			,CASE [Machina]
--					 WHEN 4 THEN ROUND(ISNULL([BW_2_Sigma],0),3)
--					 Else  ROUND([BW_2_Sigma],3)
--			 END  AS    [BW_2_Sigma]
--			,CASE [Machina]
--					 WHEN 4 THEN ROUND(ISNULL([DW_2_Sigma],0),3)
--					 Else  ROUND([DW_2_Sigma],3)
--			 END  AS    [DW_2_Sigma]
--			,CASE [Machina]
--					 WHEN 4 THEN ROUND(ISNULL([MO_2_Sigma],0),3)
--					 Else  ROUND([MO_2_Sigma],3)
--			 END  AS    [MO_2_Sigma]
--			,ROUND([depth],3) [depth]
--			,ROUND([moisture],1) [moisture]
--			,ROUND([density],1) [density]
--			,[Time_Start]
--			,[Time_End]
--    FROM #Tambur_Info_EF_Machine
----=========================================================================================
--INSERT INTO [Procont].[dbo].[Tambur_Info] 
--           (
--           [Machina]
--           ,[Num]
--           ,[Sort]
--           ,[Time_product]
--           ,[Mass_product]
--           ,[Area_capacity]
--           ,[Mass_capacity]
--           ,[Length]
--           ,[Width]
--           ,[Time_break]
--           ,[Speed]
--           ,[CountBreak]
--           ,[InProcont]
--           ,[BW_2_Sigma]
--           ,[DW_2_Sigma]
--           ,[MO_2_Sigma]
--           ,[depth]
--           ,[moisture]
--           ,[density]
--           ,[Time_Start]
--           ,[Time_End]
-- 		   )
--    SELECT 
--	/* Преобразуем как у них в таблице и учитываем замечания в файле
--	   Информация по тамбурам БДМ1-7и ПРС АМУ БДМ7 БДМ56 с привязкой к тэгам АСУТП (002).xlsx*/
--			[Machina]
--			,CONVERT(int, FORMAT( [Time_End], 'HHmmddMM' )) [Num]
--			,[Sort]
--			,Round ((DATEDIFF(second, [Time_Start], [Time_End]))/60.0,3) [Time_product]
--			,ISNULL([Mass_product],0) [Mass_product]
--			,ISNULL([Area_capacity],0) [Area_capacity]
--			,ISNULL([Mass_capacity],0) [Mass_capacity]
--			,Round ([Length], 3) [Length]
--			,ISNULL([Width],0) [Width]
--			,ISNULL([Time_break],0) [Time_break]
--			,ISNULL([Speed],0) [Speed]
--			,ISNULL([CountBreak],0) [CountBreak]
--			,[InProcont]
--			,ISNULL([BW_2_Sigma],0) [BW_2_Sigma]
--			,ISNULL([DW_2_Sigma],0) [DW_2_Sigma]
--			,ISNULL([MO_2_Sigma],0) [MO_2_Sigma]
--			,[depth]
--			,[moisture]
--			,[density]
--			,[Time_Start]
--			,[Time_End]
--    FROM #Tambur_Info_EF_PRC  
--	Where [Length]>1000
----===================================================================
--INSERT INTO [Procont].[dbo].[Tambur_Info] 
--           (
--           [Machina]
--           ,[Num]
--           ,[Sort]
--           ,[Time_product]
--           ,[Mass_product]
--           ,[Area_capacity]
--           ,[Mass_capacity]
--           ,[Length]
--           ,[Width]
--           ,[Time_break]
--           ,[Speed]
--           ,[CountBreak]
--           ,[InProcont]
--           ,[BW_2_Sigma]
--           ,[DW_2_Sigma]
--           ,[MO_2_Sigma]
--           ,[depth]
--           ,[moisture]
--           ,[density]
--           ,[Time_Start]
--           ,[Time_End]
--		   )
--    SELECT 
--	/* Преобразуем как у них в таблице и учитываем замечания в файле
--	   Информация по тамбурам БДМ1-7и ПРС АМУ БДМ7 БДМ56 с привязкой к тэгам АСУТП (002).xlsx*/
--			[Machina]
--			,CONVERT(int, FORMAT( [Time_End], 'HHmmddMM' )) [Num]
--			,[Sort]
--			,ISNULL([Time_product],0) [Time_product]
--			,ISNULL([Mass_product],0) [Mass_product]
--			,ISNULL([Area_capacity],0) [Area_capacity]
--			,ISNULL([Mass_capacity],0) [Mass_capacity]
--			,ROUND([Length],3) [Length]
--			,ROUND([Width],3) [Width]
--			,ISNULL([Time_break],0) [Time_break]
--			,ISNULL([Speed],0) [Speed]
--			,ISNULL([CountBreak],0) [CountBreak]
--			,[InProcont]
--			,ISNULL([BW_2_Sigma],0) [BW_2_Sigma]
--			,ISNULL([DW_2_Sigma],0) [DW_2_Sigma]
--			,ISNULL([MO_2_Sigma],0) [MO_2_Sigma]
--			,[depth]
--			,[moisture]
--			,[density]
--			,[Time_Start]
--			,[Time_End]
--    FROM #Tambur_Info_EF_PRC_Machine 

--===========================================
-- Мерджим EventFrame в Tambur_Info
Merge Into [Procont].[dbo].[Tambur_Info]  as TGT
	using #Tambur_Info_EF_All as SRC
	 on TGT.[Machina]=SRC.[Machina] AND (TGT.[Time_End] between DATEADD(second,-5,SRC.[Time_End]) and DATEADD(second,5,SRC.[Time_End]))
--	 on TGT.[Machina]=SRC.[Machina] AND TGT.[Time_End]=SRC.[Time_End]
	 When Matched AND
	  (
			TGT.[Sort] collate Latin1_General_CI_AS<>SRC.[Sort]  OR
			TGT.[Time_product]<>SRC.[Time_product]  OR	
			TGT.[Mass_product]<>SRC.[Mass_product]  OR	
			TGT.[Area_capacity]<>SRC.[Area_capacity]  OR
			TGT.[Mass_capacity]<>SRC.[Mass_capacity]  OR
			TGT.[Length]<>SRC.[Length]  OR
			TGT.[Width]<>SRC.[Width]  OR
			TGT.[Time_break]<>SRC.[Time_break]  OR
			TGT.[Speed]<>SRC.[Speed]  OR
			TGT.[CountBreak]<>SRC.[CountBreak]  OR
			TGT.[BW_2_Sigma]<>SRC.[BW_2_Sigma]  OR
			TGT.[DW_2_Sigma]<>SRC.[DW_2_Sigma]  OR
			TGT.[MO_2_Sigma]<>SRC.[MO_2_Sigma]  OR
			TGT.[depth]<>SRC.[depth]  OR
			TGT.[moisture]<>SRC.[moisture]  OR
			TGT.[density]<>SRC.[density]  OR
			TGT.[Time_Start]<>SRC.[Time_Start]  OR
			TGT.[Time_End]<>SRC.[Time_End] 
	  ) 
	  THEN
	  Update SET
			TGT.[Sort]=SRC.[Sort],  
			TGT.[Time_product]=SRC.[Time_product],  	
			TGT.[Mass_product]=SRC.[Mass_product],  	
			TGT.[Area_capacity]=SRC.[Area_capacity], 
			TGT.[Mass_capacity]=SRC.[Mass_capacity],  
			TGT.[Length]=SRC.[Length],  
			TGT.[Width]=SRC.[Width],  
			TGT.[Time_break]=SRC.[Time_break],  
			TGT.[Speed]=SRC.[Speed], 
			TGT.[CountBreak]=SRC.[CountBreak],  
			TGT.[InProcont]=SRC.[InProcont],  
			TGT.[BW_2_Sigma]=SRC.[BW_2_Sigma],  
			TGT.[DW_2_Sigma]=SRC.[DW_2_Sigma],  
			TGT.[MO_2_Sigma]=SRC.[MO_2_Sigma],  
			TGT.[depth]=SRC.[depth],  
			TGT.[moisture]=SRC.[moisture],  
			TGT.[density]=SRC.[density],  
			TGT.[Time_Start]=SRC.[Time_Start],  
			TGT.[Time_End]=SRC.[Time_End] 
	When NOT Matched THEN
		insert 
		(
			[Machina] ,[Num] ,[Sort] ,[Time_product] ,[Mass_product] ,[Area_capacity]
           ,[Mass_capacity] ,[Length] ,[Width] ,[Time_break] ,[Speed] ,[CountBreak]
           ,[InProcont] ,[BW_2_Sigma] ,[DW_2_Sigma] ,[MO_2_Sigma] ,[depth] ,[moisture]
           ,[density] ,[Time_Start] ,[Time_End]
		)
		values 
		(
			SRC.[Machina] ,SRC.[Num] ,SRC.[Sort] ,SRC.[Time_product] ,SRC.[Mass_product] ,SRC.[Area_capacity]
           ,SRC.[Mass_capacity] ,SRC.[Length] ,SRC.[Width] ,SRC.[Time_break] ,SRC.[Speed] ,SRC.[CountBreak]
           ,SRC.[InProcont] ,SRC.[BW_2_Sigma] ,SRC.[DW_2_Sigma] ,SRC.[MO_2_Sigma] ,SRC.[depth] ,SRC.[moisture]
           ,SRC.[density] ,SRC.[Time_Start] ,SRC.[Time_End]
		);


--===========================================

DROP Table #Tambur_Info_EF_Machine
DROP Table #Tambur_Info_EF_PRC
DROP Table #Tambur_Info_EF_PRC_Machine
DROP Table #Tambur_Info_EF_All

END
GO 

