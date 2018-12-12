-- Хранимка для записи событий в BDM7_Archive_Manual
-- BeginTime 20180420
-- !!! 14/05/2018 Самый окончательный вариант работать будет из БД Procont


use [Procont]
IF OBJECT_ID ( 'Procont.dbo.sp_BDM7_Archive_manual', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_BDM7_Archive_manual;  
GO  
CREATE PROCEDURE dbo.sp_BDM7_Archive_manual   

AS  
BEGIN 

CREATE TABLE #BDM7_Archive_Manual(
	[ID] [uniqueidentifier] NOT NULL DEFAULT newid(),
	[Asodu_ID] [nvarchar](50) NULL,
	[DateTime] [datetime] NULL,
	[Description] [nvarchar](200) NULL,
	[Value] [real] NULL,
	[Unit] [nvarchar](50) NULL,
	[StoredInOracle] [int] NOT NULL DEFAULT (0),
--	[Number] [real] NULL
) 



-- максимальное время из таблицы [dbo].[BDM7_Archive_BackUp]
Declare @TimeEndMax as DateTime

-- Строковая переменная для передачи максимального времени в OpenQuery
Declare @EndTimeMax NVARCHAR(50)

Set @TimeEndMax=DATEADD(millisecond,4,(select MAX([DateTime]) from [Procont].[dbo].[BDM7_Archive_Manual])) -- добовляю 4 милисекунды

if @TimeEndMax IS NULL 
 begin
	Set @TimeEndMax=DATEADD(millisecond,4,(select MAX([DateTime]) from [Procont].[dbo].[BDM7_Archive_Manual_BackUP])) -- добовляю 4 милисекунды
 end

Set @EndTimeMax=CONVERT(NVARCHAR,ISNULL(@TimeEndMax,DATEADD(hour,-24,getdate())), 121)


Declare @sql_str1 nvarchar(max) -- строка запроса к шабону Тамбур_БДМ 1    
Declare @sql_str_final1 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_БДМ 1 

Set @sql_str1=N'SELECT 
				efa.Name [Asodu_ID]
				,ef.EndTime [DateTime]
				,efa.Description [Description]
				,efs.ValueDbl [Value]
				,uom.Abbreviation [Unit] 
		FROM [AF].[EventFrame].[EventFrameTemplate]  eft
			INNER JOIN [AF].[EventFrame].[EventFrame] ef ON ef.EventFrameTemplateID = eft.ID
			INNER JOIN [AF].[EventFrame].[EventFrameAttribute] efa ON efa.EventFrameID = ef.ID
			INNER JOIN [AF].[Data].[EventFrameSnapshot] efs ON efs.EventFrameAttributeID = efa.ID
			LEFT JOIN [System].[UnitOfMeasure].[UOM] uom ON efa.DefaultUOMID=uom.ID
		WHERE eft.Name = N''BDM7_Archive_Manual''
		AND  ef.EndTime IS NOT NULL and ef.EndTime >'''+ @EndTimeMax +'''
		--AND efa.Name = ''BatchID''
		OPTION (FORCE ORDER)'

Set @sql_str_final1 = N'
INSERT INTO #BDM7_Archive_Manual
		(
			[Asodu_ID],
			[DateTime] ,
			[Description],
			[Value],
			[Unit]
	)
SELECT 
			[Asodu_ID]
			,[DateTime]
			,[Description]
			,[Value]
			,[Unit] 

	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str1, '''', '''''') + ''')'

EXEC (@sql_str_final1)


CREATE TABLE #BDM7_Archive_Manual_Pasta(
	[ID] [uniqueidentifier] NOT NULL DEFAULT newid(),
	[Asodu_ID] [nvarchar](50) NULL,
	[DateTime] [datetime] NULL,
	[Description] [nvarchar](200) NULL,
	[Value] [real] NULL,
	[Unit] [nvarchar](50) NULL,
	[StoredInOracle] [int] NOT NULL DEFAULT (0),
	[Number] [real] NULL
) 

Declare @sql_str2 nvarchar(max) -- строка запроса к шабону Тамбур_БДМ 1    
Declare @sql_str_final2 nvarchar(max) -- окончательная строка запроса к шаблону Тамбур_БДМ 1 

Set @sql_str2=N'SELECT 
				ef.Name [EF Name]
				,ef.StartTime
				,ef.EndTime [DateTime]
				,efa.Name [Asodu_ID]
				,efa.Description [Description]
				,efs.ValueDbl [Value]
				,uom.Abbreviation [Unit] 
		FROM [AF].[EventFrame].[EventFrameTemplate]  eft
			INNER JOIN [AF].[EventFrame].[EventFrame] ef ON ef.EventFrameTemplateID = eft.ID
			INNER JOIN [AF].[EventFrame].[EventFrameAttribute] efa ON efa.EventFrameID = ef.ID
			INNER JOIN [AF].[Data].[EventFrameSnapshot] efs ON efs.EventFrameAttributeID = efa.ID
			LEFT JOIN [System].[UnitOfMeasure].[UOM] uom ON efa.DefaultUOMID=uom.ID
		WHERE eft.Name = N''Паста''
		AND  ef.EndTime IS NOT NULL and ef.EndTime >'''+ @EndTimeMax +'''
		AND efs.ValueDbl IS NOT NULL
		OPTION (FORCE ORDER)'

Set @sql_str_final2 = N'
INSERT INTO  #BDM7_Archive_Manual_Pasta
		(
			[Asodu_ID],
			[DateTime] ,
			[Description],
			[Value],
			[Unit]
	)
SELECT 
			[Asodu_ID]
			,[DateTime]
			,[Description]
			,[Value]
			,[Unit] 

	FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str2, '''', '''''') + ''')'

EXEC (@sql_str_final2)

--===================================================================
-- Запись в основную БД Procont
Insert Into [Procont].[dbo].[BDM7_Archive_Manual]
		(
			[ID] ,
			[Asodu_ID] ,
			[DateTime] ,
			[Description] ,
			[Value] ,
			[Unit] ,
			[StoredInOracle],
			[Number]
		)
select 
			a.[ID] ,
			a.[Asodu_ID] ,
			a.[DateTime] ,
			a.[Description] ,
		  	Round(ISNULL(a.[Value],0),3) [Value],
			a.[Unit] ,
			a.[StoredInOracle],
            n.value as [Number] 
from  #bdm7_archive_manual a
left join #bdm7_archive_manual n on a.datetime=n.datetime and n.asodu_id='number'
where a.[asodu_id]<>'number'


-- Запись отдельного тега 2003WIQ_817_4783R.PV из шаблона 'Паста' в [BDM7_Archive_Manual]
Insert Into [Procont].[dbo].[BDM7_Archive_Manual]
		(
			[ID] ,
			[Asodu_ID] ,
			[DateTime] ,
			[Description] ,
			[Value] ,
			[Unit] ,
			[StoredInOracle],
			[Number]
		)
select 
			[ID] ,
			[Asodu_ID] ,
			[DateTime] ,
			[Description] ,
			Round([Value],3) [Value],
			[Unit] ,
			[StoredInOracle],
			[Number]
from  #BDM7_Archive_Manual_Pasta
where [Asodu_ID]=N'2003WIQ_817_4783R.PV'

drop table #BDM7_Archive_Manual
drop table #BDM7_Archive_Manual_Pasta

--=================================================================
-- Перенос в основной БД Procont из табл [dbo].[BDM7_Archive_Manual] в табл [dbo].[BDM7_Archive_Manual_BackUP]

CREATE TABLE #BDM7_Archive_Manual_temp
(
	[ID] [uniqueidentifier] NULL,
	[Asodu_ID] [nvarchar](50) NULL,
	[DateTime] [datetime] NULL,
	[Description] [nvarchar](200) NULL,
	[Value] [real] NULL,
	[Unit] [nvarchar](50) NULL,
	[StoredInOracle] [int] NOT NULL,
	[Number] [real] NULL
) 

begin transaction 
insert into #BDM7_Archive_Manual_temp([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle],[Number])
select [ID], [Asodu_ID],[DateTime] ,[Description] ,[Value] ,[Unit] ,[StoredInOracle],[Number]
from [Procont].[dbo].[BDM7_Archive_Manual]
where [StoredInOracle]=1 AND [Description] IS NOT NULL

Merge Into [Procont].[dbo].[BDM7_Archive_Manual_BackUP] as TGT
	using #BDM7_Archive_Manual_temp as SRC
	 on TGT.[Asodu_ID] collate Latin1_General_CI_AS=SRC.[Asodu_ID] AND TGT.[DateTime]=SRC.[DateTime]
	 When Matched AND
	  (
	   TGT.[ID]<>SRC.[ID] OR
	   TGT.[Description] collate Latin1_General_CI_AS<>SRC.[Description] OR
	   TGT.[Value]<>SRC.[Value] OR
	   TGT.[Unit] collate Latin1_General_CI_AS<>SRC.[Unit] OR
	   TGT.[StoredInOracle]<>SRC.[StoredInOracle] OR
	   TGT.[Number]<>SRC.[Number]
	  ) THEN
	  Update SET
	   TGT.[ID]=SRC.[ID],
	   TGT.[Description]=SRC.[Description],
	   TGT.[Value]=SRC.[Value],
	   TGT.[Unit]=SRC.[Unit],
	   TGT.[StoredInOracle]=SRC.[StoredInOracle],
	   TGT.[Number]=SRC.[Number]
	When NOT Matched THEN
		insert ([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle],[Number])
		values (SRC.[ID],SRC.[Asodu_ID],SRC.[DateTime],SRC.[Description],SRC.[Value],SRC.[Unit],SRC.[StoredInOracle],SRC.[Number]);

delete From [Procont].[dbo].[BDM7_Archive_Manual] 
Where [StoredInOracle]=1

Drop table #BDM7_Archive_Manual_temp
commit transaction
--=======================================================

End