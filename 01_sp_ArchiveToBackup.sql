-- 08/05/2018 переброска данных(и удаление из архивных табл) из архивных таблиц в ArchiveBackup, тех записей у которых устаноленн [StoredInOracle]=1
-- !!! 14/05/2018 —амый окончательный вариант работать будет из Ѕƒ Procont


use [Procont]
IF OBJECT_ID ( 'Procont.dbo.sp_ArchiveToBackup', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_ArchiveToBackup;  
GO 
Create PROCEDURE sp_ArchiveToBackup

AS
BEGIN

CREATE TABLE #temp_tbl_Archive(
	[ID] [uniqueidentifier] NOT NULL ,
	[Asodu_ID] [nvarchar](50) NOT NULL,
	[DateTime] [datetime] NULL,
	[Description] [nvarchar](200) NULL,
	[Value] [real] NULL,
	[Unit] [nvarchar](50) NULL,
	[StoredInOracle] [int] NOT NULL 
)
--============================================================================
-- BDM7
begin transaction 
insert into #temp_tbl_Archive([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
select [ID], [Asodu_ID],[DateTime] ,[Description] ,[Value] ,[Unit] ,[StoredInOracle]
from [Procont].[dbo].[BDM7_Archive]
where [StoredInOracle]=1

Merge Into [Procont].[dbo].[BDM7_Archive_BackUp] as TGT
	using #temp_tbl_Archive as SRC
	 on TGT.[Asodu_ID] collate Latin1_General_CI_AS=SRC.[Asodu_ID] AND TGT.[DateTime]=SRC.[DateTime]
	 When Matched AND
	  (
	   TGT.[ID]<>SRC.[ID] OR
	   TGT.[Description] collate Latin1_General_CI_AS<>SRC.[Description] OR
	   TGT.[Value]<>SRC.[Value] OR
	   TGT.[Unit] collate Latin1_General_CI_AS<>SRC.[Unit] OR
	   TGT.[StoredInOracle]<>SRC.[StoredInOracle]
	  ) THEN
	  Update SET
	   TGT.[ID]=SRC.[ID],
	   TGT.[Description]=SRC.[Description],
	   TGT.[Value]=SRC.[Value],
	   TGT.[Unit]=SRC.[Unit],
	   TGT.[StoredInOracle]=SRC.[StoredInOracle]
	When NOT Matched THEN
		insert ([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
		values (SRC.[ID],SRC.[Asodu_ID],SRC.[DateTime],SRC.[Description],SRC.[Value],SRC.[Unit],SRC.[StoredInOracle]);

delete From O
	From [Procont].[dbo].[BDM7_Archive] as O
	 Join #temp_tbl_Archive as C
	  ON O.ID=C.ID

truncate table #temp_tbl_Archive
commit transaction
--===================================================================================
--============================================================================
-- EnTec
begin transaction
insert into #temp_tbl_Archive([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
select [ID], [Asodu_ID],[DateTime] ,[Description] ,[Value] ,[Unit] ,[StoredInOracle]
from [Procont].[dbo].[EnTec_Archive]
where [StoredInOracle]=1

Merge Into [Procont].[dbo].[EnTec_Archive_BackUp] as TGT
	using #temp_tbl_Archive as SRC
	 on TGT.[Asodu_ID] collate Latin1_General_CI_AS=SRC.[Asodu_ID] AND TGT.[DateTime]=SRC.[DateTime]
	 When Matched AND
	  (
	   TGT.[ID]<>SRC.[ID] OR
	   TGT.[Description] collate Latin1_General_CI_AS<>SRC.[Description] OR
	   TGT.[Value]<>SRC.[Value] OR
	   TGT.[Unit] collate Latin1_General_CI_AS<>SRC.[Unit] OR
	   TGT.[StoredInOracle]<>SRC.[StoredInOracle]
	  ) THEN
	  Update SET
	   TGT.[ID]=SRC.[ID],
	   TGT.[Description]=SRC.[Description],
	   TGT.[Value]=SRC.[Value],
	   TGT.[Unit]=SRC.[Unit],
	   TGT.[StoredInOracle]=SRC.[StoredInOracle]
	When NOT Matched THEN
		insert ([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
		values (SRC.[ID],SRC.[Asodu_ID],SRC.[DateTime],SRC.[Description],SRC.[Value],SRC.[Unit],SRC.[StoredInOracle]);

delete From O
	From [Procont].[dbo].[EnTec_Archive] as O
	 Join #temp_tbl_Archive as C
	  ON O.ID=C.ID

truncate table #temp_tbl_Archive
commit transaction
--===================================================================================
--============================================================================
-- KBP
begin transaction
insert into #temp_tbl_Archive([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
select [ID], [Asodu_ID],[DateTime] ,[Description] ,[Value] ,[Unit] ,[StoredInOracle]
from [Procont].[dbo].[KBP_Archive]
where [StoredInOracle]=1

Merge Into [Procont].[dbo].[KBP_Archive_BackUp] as TGT
	using #temp_tbl_Archive as SRC
	 on TGT.[Asodu_ID] collate Latin1_General_CI_AS=SRC.[Asodu_ID] AND TGT.[DateTime]=SRC.[DateTime]
	 When Matched AND
	  (
	   TGT.[ID]<>SRC.[ID] OR
	   TGT.[Description] collate Latin1_General_CI_AS<>SRC.[Description] OR
	   TGT.[Value]<>SRC.[Value] OR
	   TGT.[Unit] collate Latin1_General_CI_AS<>SRC.[Unit] OR
	   TGT.[StoredInOracle]<>SRC.[StoredInOracle]
	  ) THEN
	  Update SET
	   TGT.[ID]=SRC.[ID],
	   TGT.[Description]=SRC.[Description],
	   TGT.[Value]=SRC.[Value],
	   TGT.[Unit]=SRC.[Unit],
	   TGT.[StoredInOracle]=SRC.[StoredInOracle]
	When NOT Matched THEN
		insert ([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
		values (SRC.[ID],SRC.[Asodu_ID],SRC.[DateTime],SRC.[Description],SRC.[Value],SRC.[Unit],SRC.[StoredInOracle]);

delete From O
	From [Procont].[dbo].[KBP_Archive] as O
	 Join #temp_tbl_Archive as C
	  ON O.ID=C.ID

truncate table #temp_tbl_Archive
commit transaction
--===================================================================================
--============================================================================
-- KRI
begin transaction
insert into #temp_tbl_Archive([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
select [ID], [Asodu_ID],[DateTime] ,[Description] ,[Value] ,[Unit] ,[StoredInOracle]
from [Procont].[dbo].[KRI_Archive]
where [StoredInOracle]=1

Merge Into [Procont].[dbo].[KRI_Archive_BackUp] as TGT
	using #temp_tbl_Archive as SRC
	 on TGT.[Asodu_ID] collate Latin1_General_CI_AS=SRC.[Asodu_ID] AND TGT.[DateTime]=SRC.[DateTime]
	 When Matched AND
	  (
	   TGT.[ID]<>SRC.[ID] OR
	   TGT.[Description] collate Latin1_General_CI_AS<>SRC.[Description] OR
	   TGT.[Value]<>SRC.[Value] OR
	   TGT.[Unit] collate Latin1_General_CI_AS<>SRC.[Unit] OR
	   TGT.[StoredInOracle]<>SRC.[StoredInOracle]
	  ) THEN
	  Update SET
	   TGT.[ID]=SRC.[ID],
	   TGT.[Description]=SRC.[Description],
	   TGT.[Value]=SRC.[Value],
	   TGT.[Unit]=SRC.[Unit],
	   TGT.[StoredInOracle]=SRC.[StoredInOracle]
	When NOT Matched THEN
		insert ([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
		values (SRC.[ID],SRC.[Asodu_ID],SRC.[DateTime],SRC.[Description],SRC.[Value],SRC.[Unit],SRC.[StoredInOracle]);

delete From O
	From [Procont].[dbo].[KRI_Archive] as O
	 Join #temp_tbl_Archive as C
	  ON O.ID=C.ID

truncate table #temp_tbl_Archive
commit transaction
--===================================================================================
--============================================================================
-- PPB
begin transaction
insert into #temp_tbl_Archive([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
select [ID], [Asodu_ID],[DateTime] ,[Description] ,[Value] ,[Unit] ,[StoredInOracle]
from [Procont].[dbo].[PPB_Archive]
where [StoredInOracle]=1

Merge Into [Procont].[dbo].[PPB_Archive_BackUp] as TGT
	using #temp_tbl_Archive as SRC
	 on TGT.[Asodu_ID] collate Latin1_General_CI_AS=SRC.[Asodu_ID] AND TGT.[DateTime]=SRC.[DateTime]
	 When Matched AND
	  (
	   TGT.[ID]<>SRC.[ID] OR
	   TGT.[Description] collate Latin1_General_CI_AS<>SRC.[Description] OR
	   TGT.[Value]<>SRC.[Value] OR
	   TGT.[Unit] collate Latin1_General_CI_AS<>SRC.[Unit] OR
	   TGT.[StoredInOracle]<>SRC.[StoredInOracle]
	  ) THEN
	  Update SET
	   TGT.[ID]=SRC.[ID],
	   TGT.[Description]=SRC.[Description],
	   TGT.[Value]=SRC.[Value],
	   TGT.[Unit]=SRC.[Unit],
	   TGT.[StoredInOracle]=SRC.[StoredInOracle]
	When NOT Matched THEN
		insert ([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
		values (SRC.[ID],SRC.[Asodu_ID],SRC.[DateTime],SRC.[Description],SRC.[Value],SRC.[Unit],SRC.[StoredInOracle]);

delete From O
	From [Procont].[dbo].[PPB_Archive] as O
	 Join #temp_tbl_Archive as C
	  ON O.ID=C.ID

truncate table #temp_tbl_Archive
commit transaction
--===================================================================================
--============================================================================
-- PSBC
begin transaction
insert into #temp_tbl_Archive([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
select [ID], [Asodu_ID],[DateTime] ,[Description] ,[Value] ,[Unit] ,[StoredInOracle]
from [Procont].[dbo].[PSBC_Archive]
where [StoredInOracle]=1

Merge Into [Procont].[dbo].[PSBC_Archive_BackUp] as TGT
	using #temp_tbl_Archive as SRC
	 on TGT.[Asodu_ID] collate Latin1_General_CI_AS=SRC.[Asodu_ID] AND TGT.[DateTime]=SRC.[DateTime]
	 When Matched AND
	  (
	   TGT.[ID]<>SRC.[ID] OR
	   TGT.[Description] collate Latin1_General_CI_AS<>SRC.[Description] OR
	   TGT.[Value]<>SRC.[Value] OR
	   TGT.[Unit] collate Latin1_General_CI_AS<>SRC.[Unit] OR
	   TGT.[StoredInOracle]<>SRC.[StoredInOracle]
	  ) THEN
	  Update SET
	   TGT.[ID]=SRC.[ID],
	   TGT.[Description]=SRC.[Description],
	   TGT.[Value]=SRC.[Value],
	   TGT.[Unit]=SRC.[Unit],
	   TGT.[StoredInOracle]=SRC.[StoredInOracle]
	When NOT Matched THEN
		insert ([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
		values (SRC.[ID],SRC.[Asodu_ID],SRC.[DateTime],SRC.[Description],SRC.[Value],SRC.[Unit],SRC.[StoredInOracle]);

delete From O
	From [Procont].[dbo].[PSBC_Archive] as O
	 Join #temp_tbl_Archive as C
	  ON O.ID=C.ID

truncate table #temp_tbl_Archive
commit transaction
--===================================================================================
--============================================================================
-- UPO
begin transaction
insert into #temp_tbl_Archive([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
select [ID], [Asodu_ID],[DateTime] ,[Description] ,[Value] ,[Unit] ,[StoredInOracle]
from [Procont].[dbo].[Upo_Archive]
where [StoredInOracle]=1

Merge Into [Procont].[dbo].[UPO_Archive_BackUp] as TGT
	using #temp_tbl_Archive as SRC
	 on TGT.[Asodu_ID] collate Latin1_General_CI_AS=SRC.[Asodu_ID] AND TGT.[DateTime]=SRC.[DateTime]
	 When Matched AND
	  (
	   TGT.[ID]<>SRC.[ID] OR
	   TGT.[Description] collate Latin1_General_CI_AS<>SRC.[Description] OR
	   TGT.[Value]<>SRC.[Value] OR
	   TGT.[Unit] collate Latin1_General_CI_AS<>SRC.[Unit] OR
	   TGT.[StoredInOracle]<>SRC.[StoredInOracle]
	  ) THEN
	  Update SET
	   TGT.[ID]=SRC.[ID],
	   TGT.[Description]=SRC.[Description],
	   TGT.[Value]=SRC.[Value],
	   TGT.[Unit]=SRC.[Unit],
	   TGT.[StoredInOracle]=SRC.[StoredInOracle]
	When NOT Matched THEN
		insert ([ID],[Asodu_ID],[DateTime],[Description],[Value],[Unit],[StoredInOracle])
		values (SRC.[ID],SRC.[Asodu_ID],SRC.[DateTime],SRC.[Description],SRC.[Value],SRC.[Unit],SRC.[StoredInOracle]);

delete From O
	From [Procont].[dbo].[Upo_Archive] as O
	 Join #temp_tbl_Archive as C
	  ON O.ID=C.ID

truncate table #temp_tbl_Archive
commit transaction
--===================================================================================

Drop table  #temp_tbl_Archive

END;