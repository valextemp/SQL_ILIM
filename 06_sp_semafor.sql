-- Хранимая проц на основе кода Романа
-- !!! 14/05/2018 Самый окончательный вариант работать будет из БД Procont


use [Procont]
IF OBJECT_ID ( 'Procont.dbo.sp_semafor', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_semafor;  
GO  
CREATE PROCEDURE dbo.sp_semafor  

AS  
BEGIN 


DECLARE @MaxTime datetime 
DECLARE @MaxTimeStr nvarchar(max)

Select @MaxTime = max(DT_Change) FROM [Procont].[dbo].[Semafor]
Set @MaxTimeStr=CONVERT(NVARCHAR,ISNULL(@MaxTime,DATEADD(hour,-24,getdate())), 121)

DECLARE @Event TABLE
(
StartTime datetime
,EndTime datetime
,ASODU_ID nvarchar(max)
,PV int
,Description nvarchar(max)
)

DECLARE @sql_str nvarchar(max)

Set @sql_str=
'		SELECT ef.starttime, ef.endtime, ts.*
		FROM [AF].[EventFrame].[EventFrame] ef
		INNER JOIN [AF].[EventFrame].[EventFrameTemplate] eft ON ef.EventFrameTemplateID = eft.ID
		INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_Semafor] ts ON ts.EventFrameID = ef.ID
		WHERE eft.Name = N''Semafor''
		and ef.starttime > '''+ @MaxTimeStr +''' or ef.endtime > '''+ @MaxTimeStr +'''
		OPTION (FORCE ORDER, IGNORE ERRORS, EMBED ERRORS)'


Set @sql_str=
'SELECT StartTime, EndTime, ASODU_ID, PV, Description
FROM OPENQUERY(KRSPIAF,'''+REPLACE(@sql_str, '''', '''''') + ''')'


INSERT INTO @Event
EXEC (@sql_str)
--order by EndTime desc

DECLARE @Current TABLE
(
ASODU_ID nvarchar(max)
,Description nvarchar(max)
,PV int
,Datetime datetime
,Duration int
,DT_Change datetime
)

INSERT INTO @Current
SELECT ASODU_ID, Description, PV, [DataTime], Duration, DT_Change 
FROM [Procont].[dbo].[Semafor]
where Duration is null

--SELECT * FROM @Current


UPDATE [Procont].[dbo].[Semafor]
SET  [Duration] = datediff(s,e.starttime,e.endtime)
	,[DT_Change] = e.EndTime
FROM @Event e
where e.ASODU_ID collate SQL_Latin1_General_CP1_CI_AS =[Procont].[dbo].[Semafor].[ASODU_ID] 
	  and e.Description collate SQL_Latin1_General_CP1_CI_AS = [Procont].[dbo].[Semafor].[Description] 
	  and e.PV=[Procont].[dbo].[Semafor].[PV] 
	  and e.StartTime=[DataTime]
	  and e.endtime is not null

INSERT INTO [Procont].[dbo].[Semafor]
	(
		[ASODU_ID]
		,[Description]
		,[PV]
		,[DataTime]
		,[Duration]
		,[DT_Change]
		,[TypeInsert]
		,[StoredInOracle]
	)
SELECT 
		e.ASODU_ID
		,e.Description
		,e.PV
		,e.StartTime as [DataTime]
		,datediff(s,e.starttime,e.endtime) as [Duration]
		,e.EndTime as DT_Change
		,'Automatic' [TypeInsert]
		,0 [StoredInOracle]
FROM @Event e
LEFT JOIN @Current c ON e.ASODU_ID=c.ASODU_ID and e.Description=c.Description and e.PV=c.PV and e.StartTime=c.Datetime
where endtime is not null and c.PV is null
union
SELECT 
		e.ASODU_ID
		,e.Description
		,e.PV
		,e.StartTime as Datetime
		,NULL as Duration
		,e.StartTime as DT_Change
		,'Automatic' [TypeInsert]
		,0 [StoredInOracle]
FROM @Event e
LEFT JOIN @Current c ON e.ASODU_ID=c.ASODU_ID and e.Description=c.Description and e.PV=c.PV and e.StartTime=c.Datetime
where endtime is null and c.PV is null
order by DT_Change desc

END;