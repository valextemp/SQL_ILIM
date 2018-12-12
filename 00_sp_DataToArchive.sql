--!!! ������������� ������� �� 05/04/2018 ��������� �������� �� PI �� 3 ������ ������ ��������� ���� � ���������� ����� ������� �� ������ ���� 
-- ���� �� �������� � 16:00, ��������� �� 16:00:00(��� ������ � �����), ����� �������� 3 ������, ��������� �������� �� PI �� 15:57:00
-- � ���������� �� � ������� � ������ ������� 15:00:00
-- 07/05/2018 ��������� ������ ��������������� � �� Procont
-- !!! 14/05/2018 ����� ������������� ������� �������� ����� �� �� Procont


-- ������ � �������� �� �����   ������� ����� 3 ������ ��� PV � ����� � ��� ��� TimeRangeMethod=Average

use [Procont]
IF OBJECT_ID ( 'Procont.dbo.sp_DataToArchive', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_DataToArchive;  
GO 
Create PROCEDURE sp_DataToArchive

@NameArchive nvarchar(5)

AS
BEGIN

Declare @FlagWork int=1 -- ���� ��� �������� ��� ��������� ������� ����� ��������� 1 ���������, 0 �������

declare @dt datetime
declare @dt_round datetime -- ����� ����������� �� ����� (��� ������ � ��� �����)
declare @dt_roundstr nvarchar(20) -- ����� ����������� �� �����
declare @dtminus3min datetime
declare @dtminus3minstr nvarchar(20)
declare @dtminus1hour datetime -- ��� ������ � ����� ������� � ������� ����� 1 ���
declare @dtminus1hourstr nvarchar(20)

Set @dt=GETDATE()
Set @dt_round=dateadd(hour, datediff(hour, 0, @dt), 0) -- ������ �� ����� �� ��������
Set @dtminus3min=dateadd(MINUTE,-3, @dt_round)  -- �������� 3 ������
Set @dtminus1hour=dateadd(hour, datediff(hour, 0, @dtminus3min), 0)


-- dateadd(hour, datediff(hour, 0, dateadd(MINUTE,-3, dateadd(hour, datediff(hour, 0, GETDATE()), 0))), 0)

Set @dtminus3minstr=CONVERT(NVARCHAR,@dtminus3min, 121)
Set @dtminus1hourstr=CONVERT(NVARCHAR,@dtminus1hour, 121)
Set @dt_roundstr=CONVERT(NVARCHAR,@dt_round, 121)


Declare @sql_str nvarchar(max)
Declare @sql_str_final nvarchar(max)


 --=================================================================
 -- ���������� ��� ������� � ��� �������� � PI AF
Declare @TableName nvarchar(30)-- ��� ������� � ������� �����
Declare @PIelement nvarchar(5)-- ��� ������� � PI AF


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
-- �������� �� ������������ ������� ���������� ��������� �������

IF @FlagWork=0
    BEGIN  
        PRINT N'Error 1. ������������ ������� ������'
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
		WHERE eh.Path = N''\���������� ������\�������� ������ � �������\'' AND eh.Name='''+@PIelement+'''
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
		WHERE eh.Path = N''\���������� ������\�������� ������ � �������\'' AND eh.Name='''+@PIelement+'''
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