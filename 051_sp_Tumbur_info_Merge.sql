

-- �������� ��������� ����� ��������� ���������� 13/03/2018 �������� �������
-- ������_��� 1, ������_��� 2 .....
-- 07/05/2018 ���������� �� ������ � �������� �� Procont
-- !!! 14/05/2018 ����� ������������� ������� �������� ����� �� �� Procont (������ ���������� dbo.Tambur_InfoStorProc1)
-- ������ ����������� � ��������� Jobe ������ 30 ������



use [Procont]
IF OBJECT_ID ( 'Procont.dbo.sp_Tambur_Info_Merge', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_Tambur_Info_Merge;  
GO  
CREATE PROCEDURE dbo.sp_Tambur_Info_Merge   

@Minute int -- ���������� ����� ����� �� �������� getdate ������������� �����

AS  
BEGIN 
CREATE TABLE #Tambur_Info_EF_Machine(
			[Machina]	[int] NULL,	--����� ������ 1
			[Num]	[int] NULL,	--����� ������� �����  2
			[Sort]	[nvarchar](50) NULL,	--����  3
			[Time_product]	[real] NULL,	--����� �������  4
			[Mass_product]	[real] NULL,	--��������� (�)  5
			[Area_capacity]	[real] NULL,	--����������� (��) 6 
			[Mass_capacity]	[real] NULL,	--������������������ (�/�)  7
			[Length]	[real] NULL,	--����� ������� 8
			[Width]	[real] NULL,	--������ ������� (��) 9 
			[Time_break]	[real] NULL,	--����� ������� 10
			[Speed]	[real] NULL,	--�������� ������  11
			[CountBreak]	[int] NULL,	--���-�� ������� 12
			[InProcont]	[int] NULL DEFAULT (0),	--"��� �������� ��� � ������� ��������" 13
			[BW_2_Sigma]	[real] NULL,	--����� ��������� ���� 14
			[DW_2_Sigma]	[real] NULL,	--����� �� ���. ��� ���� 15
			[MO_2_Sigma]	[real] NULL,	--����� �� ��������� 16
			[depth]	[real] NULL,	--������� ������� 17
			[moisture]	[real] NULL,	--��������� ������� 18
			[density]	[real] NULL, -- ��������� ������� 19

			[Time_Start]	[datetime] NULL,	--����� ������ 20
			[Time_End]	[datetime] NULL,	--����� ��������� 21

			)
Declare @Tambur_Info_EF_Machine table(
			[Machina]	[int] NULL,	--����� ������ 1
			[Num]	[int] NULL,	--����� ������� �����  2
			[Sort]	[nvarchar](50) NULL,	--����  3
			[Time_product]	[real] NULL,	--����� �������  4
			[Mass_product]	[real] NULL,	--��������� (�)  5
			[Area_capacity]	[real] NULL,	--����������� (��) 6 
			[Mass_capacity]	[real] NULL,	--������������������ (�/�)  7
			[Length]	[real] NULL,	--����� ������� 8
			[Width]	[real] NULL,	--������ ������� (��) 9 
			[Time_break]	[real] NULL,	--����� ������� 10
			[Speed]	[real] NULL,	--�������� ������  11
			[CountBreak]	[int] NULL,	--���-�� ������� 12
			[InProcont]	[int] NULL DEFAULT (0),	--"��� �������� ��� � ������� ��������" 13
			[BW_2_Sigma]	[real] NULL,	--����� ��������� ���� 14
			[DW_2_Sigma]	[real] NULL,	--����� �� ���. ��� ���� 15
			[MO_2_Sigma]	[real] NULL,	--����� �� ��������� 16
			[depth]	[real] NULL,	--������� ������� 17
			[moisture]	[real] NULL,	--��������� ������� 18
			[density]	[real] NULL, -- ��������� ������� 19

			[Time_Start]	[datetime] NULL,	--����� ������ 20
			[Time_End]	[datetime] NULL	--����� ��������� 21

			)


CREATE TABLE #Tambur_Info_EF_PRC
(
			[Machina]	[int] NULL,	--����� ������ 1
			[Num]	[int] NULL,	--����� ������� �����  2
			[Sort]	[nvarchar](50) NULL,	--����  3
			[Time_product]	[real] NULL,	--����� �������  4
			[Mass_product]	[real] NULL,	--��������� (�)  5
			[Area_capacity]	[real] NULL,	--����������� (��) 6 
			[Mass_capacity]	[real] NULL,	--������������������ (�/�)  7
			[Length]	[real] NULL,	--����� ������� 8
			[Width]	[real] NULL,	--������ ������� (��) 9 
			[Time_break]	[real] NULL,	--����� ������� 10
			[Speed]	[real] NULL,	--�������� ������  11
			[CountBreak]	[int] NULL,	--���-�� ������� 12
			[InProcont]	[int] NULL DEFAULT (0),	--"��� �������� ��� � ������� ��������" 13
			[BW_2_Sigma]	[real] NULL,	--����� ��������� ���� 14
			[DW_2_Sigma]	[real] NULL,	--����� �� ���. ��� ���� 15
			[MO_2_Sigma]	[real] NULL,	--����� �� ��������� 16
			[depth]	[real] NULL,	--������� ������� 17
			[moisture]	[real] NULL,	--��������� ������� 18
			[density]	[real] NULL, -- ��������� ������� 19

			[Time_Start]	[datetime] NULL,	--����� ������ 20
			[Time_End]	[datetime] NULL,	--����� ��������� 21

)
Declare @Tambur_Info_EF_PRC table
(
			[Machina]	[int] NULL,	--����� ������ 1
			[Num]	[int] NULL,	--����� ������� �����  2
			[Sort]	[nvarchar](50) NULL,	--����  3
			[Time_product]	[real] NULL,	--����� �������  4
			[Mass_product]	[real] NULL,	--��������� (�)  5
			[Area_capacity]	[real] NULL,	--����������� (��) 6 
			[Mass_capacity]	[real] NULL,	--������������������ (�/�)  7
			[Length]	[real] NULL,	--����� ������� 8
			[Width]	[real] NULL,	--������ ������� (��) 9 
			[Time_break]	[real] NULL,	--����� ������� 10
			[Speed]	[real] NULL,	--�������� ������  11
			[CountBreak]	[int] NULL,	--���-�� ������� 12
			[InProcont]	[int] NULL DEFAULT (0),	--"��� �������� ��� � ������� ��������" 13
			[BW_2_Sigma]	[real] NULL,	--����� ��������� ���� 14
			[DW_2_Sigma]	[real] NULL,	--����� �� ���. ��� ���� 15
			[MO_2_Sigma]	[real] NULL,	--����� �� ��������� 16
			[depth]	[real] NULL,	--������� ������� 17
			[moisture]	[real] NULL,	--��������� ������� 18
			[density]	[real] NULL, -- ��������� ������� 19

			[Time_Start]	[datetime] NULL,	--����� ������ 20
			[Time_End]	[datetime] NULL	--����� ��������� 21

)

CREATE TABLE #Tambur_Info_EF_PRC_Machine
(
			[Machina]	[int] NULL,	--����� ������ 1
			[Num]	[int] NULL,	--����� ������� �����  2
			[Sort]	[nvarchar](50) NULL,	--����  3
			[Time_product]	[real] NULL,	--����� �������  4
			[Mass_product]	[real] NULL,	--��������� (�)  5
			[Area_capacity]	[real] NULL,	--����������� (��) 6 
			[Mass_capacity]	[real] NULL,	--������������������ (�/�)  7
			[Length]	[real] NULL,	--����� ������� 8
			[Width]	[real] NULL,	--������ ������� (��) 9 
			[Time_break]	[real] NULL,	--����� ������� 10
			[Speed]	[real] NULL,	--�������� ������  11
			[CountBreak]	[int] NULL,	--���-�� ������� 12
			[InProcont]	[int] NULL DEFAULT (0),	--"��� �������� ��� � ������� ��������" 13
			[BW_2_Sigma]	[real] NULL,	--����� ��������� ���� 14
			[DW_2_Sigma]	[real] NULL,	--����� �� ���. ��� ���� 15
			[MO_2_Sigma]	[real] NULL,	--����� �� ��������� 16
			[depth]	[real] NULL,	--������� ������� 17
			[moisture]	[real] NULL,	--��������� ������� 18
			[density]	[real] NULL, -- ��������� ������� 19

			[Time_Start]	[datetime] NULL,	--����� ������ 20
			[Time_End]	[datetime] NULL,	--����� ��������� 21

)
Declare @Tambur_Info_EF_PRC_Machine table
(
			[Machina]	[int] NULL,	--����� ������ 1
			[Num]	[int] NULL,	--����� ������� �����  2
			[Sort]	[nvarchar](50) NULL,	--����  3
			[Time_product]	[real] NULL,	--����� �������  4
			[Mass_product]	[real] NULL,	--��������� (�)  5
			[Area_capacity]	[real] NULL,	--����������� (��) 6 
			[Mass_capacity]	[real] NULL,	--������������������ (�/�)  7
			[Length]	[real] NULL,	--����� ������� 8
			[Width]	[real] NULL,	--������ ������� (��) 9 
			[Time_break]	[real] NULL,	--����� ������� 10
			[Speed]	[real] NULL,	--�������� ������  11
			[CountBreak]	[int] NULL,	--���-�� ������� 12
			[InProcont]	[int] NULL DEFAULT (0),	--"��� �������� ��� � ������� ��������" 13
			[BW_2_Sigma]	[real] NULL,	--����� ��������� ���� 14
			[DW_2_Sigma]	[real] NULL,	--����� �� ���. ��� ���� 15
			[MO_2_Sigma]	[real] NULL,	--����� �� ��������� 16
			[depth]	[real] NULL,	--������� ������� 17
			[moisture]	[real] NULL,	--��������� ������� 18
			[density]	[real] NULL, -- ��������� ������� 19

			[Time_Start]	[datetime] NULL,	--����� ������ 20
			[Time_End]	[datetime] NULL	--����� ��������� 21

)

--=======================================================
-- ��������� ��� ������ ���� EF �� ���� ��������
CREATE TABLE #Tambur_Info_EF_All
(
			[Machina]	[int] NULL,	--����� ������ 1
			[Num]	[int] NULL,	--����� ������� �����  2
			[Sort]	[nvarchar](50) NULL,	--����  3
			[Time_product]	[real] NULL,	--����� �������  4
			[Mass_product]	[real] NULL,	--��������� (�)  5
			[Area_capacity]	[real] NULL,	--����������� (��) 6 
			[Mass_capacity]	[real] NULL,	--������������������ (�/�)  7
			[Length]	[real] NULL,	--����� ������� 8
			[Width]	[real] NULL,	--������ ������� (��) 9 
			[Time_break]	[real] NULL,	--����� ������� 10
			[Speed]	[real] NULL,	--�������� ������  11
			[CountBreak]	[int] NULL,	--���-�� ������� 12
			[InProcont]	[int] NULL ,	--"��� �������� ��� � ������� ��������" 13
			[BW_2_Sigma]	[real] NULL,	--����� ��������� ���� 14
			[DW_2_Sigma]	[real] NULL,	--����� �� ���. ��� ���� 15
			[MO_2_Sigma]	[real] NULL,	--����� �� ��������� 16
			[depth]	[real] NULL,	--������� ������� 17
			[moisture]	[real] NULL,	--��������� ������� 18
			[density]	[real] NULL, -- ��������� ������� 19

			[Time_Start]	[datetime] NULL,	--����� ������ 20
			[Time_End]	[datetime] NULL,	--����� ��������� 21

)

Declare @DateToWrite DateTime = GETDATE() -- �������� ��� ���� ���� ����� ������ � ����
Declare @DateToWriteStr NVARCHAR(50) = CONVERT(NVARCHAR,@DateToWrite, 121) 
Declare @TimeEndMax as DateTime
Declare @EndTimeMax NVARCHAR(50)
DECLARE @sql_str nvarchar(max)
Declare @sql_str_final nvarchar(max) 

Declare @sql_str1 nvarchar(max) -- ������ ������� � ������ ������_��� 1    
Declare @sql_str_final1 nvarchar(max) -- ������������� ������ ������� � ������� ������_��� 1 
Declare @sql_str2 nvarchar(max) -- ������ ������� � ������ ������_��� 2    
Declare @sql_str_final2 nvarchar(max) -- ������������� ������ ������� � ������� ������_��� 2 
Declare @sql_str3 nvarchar(max) -- ������ ������� � ������ ������_��� 3    
Declare @sql_str_final3 nvarchar(max) -- ������������� ������ ������� � ������� ������_��� 3 
Declare @sql_str4 nvarchar(max) -- ������ ������� � ������ ������_��� 4  
Declare @sql_str_final4 nvarchar(max) -- ������������� ������ ������� � ������� ������_��� 4
Declare @sql_str5 nvarchar(max) -- ������ ������� � ������ ������_��� 5
Declare @sql_str_final5 nvarchar(max) -- ������������� ������ ������� � ������� ������_��� 5
Declare @sql_str6 nvarchar(max) -- ������ ������� � ������ ������_��� 6    
Declare @sql_str_final6 nvarchar(max) -- ������������� ������ ������� � ������� ������_��� 6 
Declare @sql_str7 nvarchar(max) -- ������ ������� � ������ ������_��� 7    
Declare @sql_str_final7 nvarchar(max) -- ������������� ������ ������� � ������� ������_���
Declare @sql_str8 nvarchar(max) -- ������ ������� � ������ ������_��� 7    
Declare @sql_str_final8 nvarchar(max) -- ������������� ������ ������� � ������� ������_���
Declare @sql_strPRC nvarchar(max) -- ������ ������� � ������� ���
Declare @sql_str_finalPRC nvarchar(max) -- ������������� ������ ������� � ������� ���
Declare @sql_strPRC_machine nvarchar(max) -- ������ ������� � ������� ��� �����
Declare @sql_str_finalPRC_machine nvarchar(max) -- ������������� ������ ������� � ������� ���

Set @TimeEndMax=Null

--  ������������ EndTime �� ��� �����
Set @EndTimeMax=CONVERT(NVARCHAR,ISNULL(@TimeEndMax,DATEADD(MINUTE,(@Minute)*(-1),getdate())), 121)

-- print @EndTimeMax

--Set @TimeEndMax=(CONVERT(dateTime, '2018-02-19 00:00:00'))
--Set @EndTimeMax=CONVERT(NVARCHAR,ISNULL(@TimeEndMax,DATEADD(hour,0,getdate())), 121)
--===============================================================================
--- ������ ������� "������_��� 1"
Set @sql_str1=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_��� 1'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_��� 1] ts
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
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_��� 2'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_��� 2] ts
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
-- ������ ��� 3
Set @sql_str3=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_��� 3'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_��� 3] ts
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
-- ������ ��� 4
Set @sql_str4=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_��� 4'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_��� 4] ts
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
-- ������ ��� 5
Set @sql_str5=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_��� 5'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_��� 5] ts
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
-- ������ ��� 6
Set @sql_str6=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_��� 6'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_��� 6] ts
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
-- ������ ��� 7
Set @sql_str7=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_��� 7'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_��� 7] ts
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
-- ������ ���
Set @sql_str8=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_���'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_���] ts
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
-- ������ ������_���
Set @DateToWrite = GETDATE() -- �������� ��� ���� ���� ����� ������ � ����
Set @DateToWriteStr  = CONVERT(NVARCHAR,@DateToWrite, 121) 

Set @sql_strPRC=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_���'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_���] ts
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
-- ������ ������_���_�����
Set @DateToWrite = GETDATE() -- �������� ��� ���� ���� ����� ������ � ����
Set @DateToWriteStr  = CONVERT(NVARCHAR,@DateToWrite, 121) 

Set @sql_strPRC_machine=
				N'SELECT 
					  ts.Area_Capacity [Area_Capacity]   --  �� ������������  ��� ������ - Double 1
					, ts.BW_2_Sigma [BW_2_Sigma]   --  ����� ��������� ����  ��� ������ - Double 2
					, ts.CountBreak [CountBreak]   --  ���-�� �������  ��� ������ - Int32 3
					, ts.density [density]   --  ��������� ������� (�/�2)  ��� ������ - Double  4
					, ts.depth [depth]   --  ������� �������  ��� ������ - Double  5
					, ts.DW_2_Sigma [DW_2_Sigma]   --  ����� �� ��� ����  ��� ������ - Double  6
					, ts.Length [Length]   --  ����� �������  ��� ������ - Double  7
					, ts.Machina [Machina]   --    ��� ������ - String  8
					, ts.Mass_Capacity [Mass_Capacity]   --  ������������������ (�/�)  ��� ������ - Double 9
					, ts.Mass_product [Mass_product]   --  ��������� (�)  ��� ������ - Double  10
					, ts.MO_2_Sigma [MO_2_Sigma]   --  ����� �� ���������  ��� ������ - Double  11
					, ts.moisture [moisture]   --  ��������� ������� �������  ��� ������ - Double 12
					, ts.Num [Num]   --  ����� �������  ��� ������ - Int32 13
					, ts.Sort [Sort]   --  ����  ��� ������ - String 14
					, ts.Speed [Speed]   --  �������� ������ ���-7  ��� ������ - Double  15
					, ts.Time_Break [Time_Break]   --  ����� �������  ��� ������ - Double  16
					, ts.Time_Product [Time_Product]   --  ����� ������� �������  ��� ������ - Double 17
					, ts.Width [Width]   --  ������ �������  ��� ������ - Double  -- 18

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
						WHERE Name = N''������_���_�����'' and EndTime IS NOT NULL and EndTime >'''+ @EndTimeMax +'''
					)
				) ef
				INNER JOIN [AF].[EventFrame].[EventFrameHierarchy] efh
					ON efh.ID = ef.ID
				INNER JOIN [AF].[DataT].[ft_TransposeEventFrameSnapshot_������_���_�����] ts
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
-- ������ ���� EF � ����� ��������� �������
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
	/* ����������� ��� � ��� � ������� � ��������� ��������� � �����
	   ���������� �� �������� ���1-7� ��� ��� ���7 ���56 � ��������� � ����� ����� (002).xlsx*/
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
	/* ����������� ��� � ��� � ������� � ��������� ��������� � �����
	   ���������� �� �������� ���1-7� ��� ��� ���7 ���56 � ��������� � ����� ����� (002).xlsx*/
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
---- ������ � ������� �� Procont
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
--	/* ����������� ��� � ��� � ������� � ��������� ��������� � �����
--	   ���������� �� �������� ���1-7� ��� ��� ���7 ���56 � ��������� � ����� ����� (002).xlsx*/
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
--	/* ����������� ��� � ��� � ������� � ��������� ��������� � �����
--	   ���������� �� �������� ���1-7� ��� ��� ���7 ���56 � ��������� � ����� ����� (002).xlsx*/
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
-- ������� EventFrame � Tambur_Info
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

