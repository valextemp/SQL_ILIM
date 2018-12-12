--!!! Окончательный вариант на 05/04/2018 считываем значения из PI на 3 минуты раньше окончания часа и записываем метку времени на начало часа 
-- напр ХП вызываем в 16:00, округляем до 16:00:00(без секунд и минут), затем отнимаем 3 минуты, считываем значения из PI на 15:57:00
-- и записываем их в Проконт с меткой времени 15:00:00
-- 07/05/2018 добавлена запись непосредственно в их Procont
-- !!! 14/05/2018 Самый окончательный вариант работать будет из БД Procont


-- версия с запросом по метке   времени минус 3 минуты для PV и ровно в час для TimeRangeMethod=Average

use [Procont]
IF OBJECT_ID ( 'Procont.dbo.sp_DataToArchive', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_DataToArchive;  
GO 
Create PROCEDURE sp_DataToArchive

@NameArchive nvarchar(5)

AS
BEGIN

Declare @FlagWork int=1 -- Флаг для проверки что процедуру функцию можно запускать 1 запускаем, 0 выходим

declare @dt datetime
declare @dt_round datetime -- время округленное до часов (без секунд и без минут)
declare @dt_roundstr nvarchar(20) -- время округленное до часов
declare @dtminus3min datetime
declare @dtminus3minstr nvarchar(20)
declare @dtminus1hour datetime -- Для записи в метки времени в проконт минус 1 час
declare @dtminus1hourstr nvarchar(20)

Set @dt=GETDATE()
Set @dt_round=dateadd(hour, datediff(hour, 0, @dt), 0) -- Усекаю до часов не округляя
Set @dtminus3min=dateadd(MINUTE,-3, @dt_round)  -- Отнимаем 3 минуты
Set @dtminus1hour=dateadd(hour, datediff(hour, 0, @dtminus3min), 0)


-- dateadd(hour, datediff(hour, 0, dateadd(MINUTE,-3, dateadd(hour, datediff(hour, 0, GETDATE()), 0))), 0)

Set @dtminus3minstr=CONVERT(NVARCHAR,@dtminus3min, 121)
Set @dtminus1hourstr=CONVERT(NVARCHAR,@dtminus1hour, 121)
Set @dt_roundstr=CONVERT(NVARCHAR,@dt_round, 121)


Declare @sql_str nvarchar(max)
Declare @sql_str_final nvarchar(max)


 --=================================================================
 -- Определяем имя таблицы и имя элемента в PI AF
Declare @TableName nvarchar(30)-- имя таблицы в которую пишем
Declare @PIelement nvarchar(5)-- имя элемнта в PI AF


Set @PIelement=''
Set @TableName=''



If UPPER(@NameArchive)='BDM7'
	begin
		Set @PIelement='BDM7'
		Set @TableName='BDM7_Archive'
	end
		else if UPPER(@NameArchive)='ENTEC'   
	begin
		Set @PIelement='EnTec'
		Set @TableName='EnTec_Archive'
	end
		else if UPPER(@NameArchive)='KBP'   
	begin
		Set @PIelement='KBP'
		Set @TableName='KBP_Archive'
	end
		else if UPPER(@NameArchive)='KRI'   
	begin
		Set @PIelement='KRI'
		Set @TableName='KRI_Archive'
	end
		else if UPPER(@NameArchive)='PPB'   
	begin
		Set @PIelement='PPB'
		Set @TableName='PPB_Archive'
	end
		else if UPPER(@NameArchive)='PSBC'   
	begin
		Set @PIelement='PSBC'
		Set @TableName='PSBC_Archive'
	end
		else if UPPER(@NameArchive)='UPO'   
	begin
		Set @PIelement='UPO'
		Set @TableName='Upo_Archive'
	end

if @PIelement=''
	Set @FlagWork=0
--================================================================
-- Проверка на правильность входных параметров процедуры функции

IF @FlagWork=0
    BEGIN  
        PRINT N'Error 1. Неправильные входные данные'
        RETURN  
    END  
--=================================================================




CREATE TABLE #temp_BDM7_Archive(
	[ID] [uniqueidentifier] NOT NULL DEFAULT newid(),
	[Asodu_ID] [nvarchar](50) NOT NULL,
	[DateTime] [datetime] NULL,
	[Description] [nvarchar](200) NULL,
	[Value] [real] NULL,
	[Unit] [nvarchar](50) NULL,
	[StoredInOracle] [int] NOT NULL DEFAULT (0)
)

Set @sql_str=N'SELECT 
		ea.Name [NameAttribute]
		,ea.Description [Description]
		,uom.Abbreviation [UOMAbr] 
		,i.ElementAttributeID [ElementAttributeID] 
		,i.Time [Time] 
		,i.Value [Value] 
		,i.ValueInt [ValueInt] 
		,i.ValueDbl [ValueDbl] 
		,i.ValueStr [ValueStr] 
		,i.ValueGuid [ValueGuid] 
		,i.ValueDateTime [ValueDateTime] 
		,i.Status [Status] 
		,i.Annotated [Annotated] 
		,i.IsGood [IsGood] 
		,i.Questionable [Questionable] 
		,i.Substituted [Substituted] 
		FROM [AF].[Asset].[ElementHierarchy] eh
		INNER JOIN [AF].[Asset].[ElementAttribute] ea ON ea.ElementID = eh.ElementID
		LEFT JOIN [System].[UnitOfMeasure].[UOM] uom ON ea.DefaultUOMID=uom.ID,
		[AF].[Data].[ft_InterpolateDiscrete] i
		WHERE eh.Path = N''\Прикладные задачи\Передача данных в Проконт\'' AND eh.Name='''+@PIelement+'''
			AND i.ElementAttributeID = ea.ID -- first InterpolateDiscrete TVF argument
			AND ea.ConfigString NOT Like''%TimeRangeMethod=Average%''
			AND ea.Name NOT Like ''%input''
			AND i.Time = '''+ @dtminus3minstr +''' -- second InterpolateDiscrete TVF argument
		OPTION (FORCE ORDER, EMBED ERRORS)'

Set @sql_str_final = N' INSERT INTO #temp_BDM7_Archive(
	[Asodu_ID]
	,[DateTime]
	,[Description]
	,[Value]
	,[Unit]
	) 
SELECT 
	[NameAttribute]
	,dateadd(hour, datediff(hour, 0, dateadd(MINUTE,-3, dateadd(hour, datediff(hour, 0, GETDATE()), 0))), 0) [Time]
	,[Description]
	,ISNULL([ValueDbl],0) [ValueDbl],ISNULL( [UOMAbr],'''') [UOMAbr]
FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str, '''', '''''') + ''')'

EXEC (@sql_str_final)

Set @sql_str=N'SELECT 
		ea.Name [NameAttribute]
		,ea.Description [Description]
		,uom.Abbreviation [UOMAbr] 
		,i.ElementAttributeID [ElementAttributeID] 
		,i.Time [Time] 
		,i.Value [Value] 
		,i.ValueInt [ValueInt] 
		,i.ValueDbl [ValueDbl] 
		,i.ValueStr [ValueStr] 
		,i.ValueGuid [ValueGuid] 
		,i.ValueDateTime [ValueDateTime] 
		,i.Status [Status] 
		,i.Annotated [Annotated] 
		,i.IsGood [IsGood] 
		,i.Questionable [Questionable] 
		,i.Substituted [Substituted] 
		FROM [AF].[Asset].[ElementHierarchy] eh
		INNER JOIN [AF].[Asset].[ElementAttribute] ea ON ea.ElementID = eh.ElementID
		LEFT JOIN [System].[UnitOfMeasure].[UOM] uom ON ea.DefaultUOMID=uom.ID,
		[AF].[Data].[ft_InterpolateDiscrete] i
		WHERE eh.Path = N''\Прикладные задачи\Передача данных в Проконт\'' AND eh.Name='''+@PIelement+'''
			AND i.ElementAttributeID = ea.ID -- first InterpolateDiscrete TVF argument
			AND ea.ConfigString Like''%TimeRangeMethod=Average%''
			AND ea.Name NOT Like ''%input''
			AND i.Time = '''+ @dt_roundstr +''' -- second InterpolateDiscrete TVF argument
		OPTION (FORCE ORDER, EMBED ERRORS)'

Set @sql_str_final = N' INSERT INTO #temp_BDM7_Archive
	(
	[Asodu_ID]
	,[DateTime]
	,[Description]
	,[Value]
	,[Unit]
	) 
SELECT 
	[NameAttribute]
	,dateadd(hour, datediff(hour, 0, dateadd(MINUTE,-3, dateadd(hour, datediff(hour, 0, GETDATE()), 0))), 0) [Time]
	,[Description]
	,ISNULL([ValueDbl],0) [ValueDbl]
	,ISNULL( [UOMAbr],'''') [UOMAbr] 
FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str, '''', '''''') + ''')'

EXEC (@sql_str_final)

Declare @sql_table_str nvarchar(max)

Set @sql_table_str=N'INSERT INTO [Procont].[dbo].'+@TableName+'
  (
  [ID]
  ,[Asodu_ID]
  ,[DateTime]
  ,[Description]
  ,[Value]
  ,[Unit]
  ,[StoredInOracle]
  )
SELECT 
	[ID]
	,[Asodu_ID]
	,[DateTime]
	,[Description]
	,[Value]
	,[Unit]
	,[StoredInOracle]
FROM #temp_BDM7_Archive'

EXEC (@sql_table_str)

Drop table #temp_BDM7_Archive

END