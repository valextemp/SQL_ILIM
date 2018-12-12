

 select Machina, Num, Time_End, COUNT(num)
 from [ProcontExchange].[dbo].[Tambur_Info]
 group by Machina, Num, Time_End

  select Machina, Num, Time_End, COUNT(num)
 from [Procont].[dbo].[Tambur_Info]
 group by Machina, Num, Time_End

 Select *
 FROM [Procont].[dbo].[Tambur_Info]
 Where [InProcont]=0
order by [Time_End] desc

 Select *
 FROM [Procont].[dbo].[Tambur_Info]
 --Where [InProcont]=0
order by [Time_End] desc

--======================================
Select  DATEDIFF(minute, '2018-05-14 00:00:00', '2018-05-21 17:20:00');

exec ProcontExchange.dbo.sp_Tambur_Info_Merge @Minute=60

exec Procont.dbo.sp_Tambur_Info_Merge @Minute=11120
--=====================================
select PTI.[Machina] ,PTI.[Num] ,PTI.[Sort] ,PTI.[Time_product] ,PTI.[Mass_product] ,PTI.[Area_capacity]
           ,PTI.[Mass_capacity] ,PTI.[Length] ,PTI.[Width] ,PTI.[Time_break] ,PTI.[Speed] ,PTI.[CountBreak]
           ,PTI.[InProcont] ,PTI.[BW_2_Sigma] ,PTI.[DW_2_Sigma] ,PTI.[MO_2_Sigma] ,PTI.[depth] ,PTI.[moisture]
           ,PTI.[density] ,PTI.[Time_Start] ,PTI.[Time_End],
		   PExTI.[Machina] ,PExTI.[Num] ,PExTI.[Sort] ,PExTI.[Time_product] ,PExTI.[Mass_product] ,PExTI.[Area_capacity]
           ,PExTI.[Mass_capacity] ,PExTI.[Length] ,PExTI.[Width] ,PExTI.[Time_break] ,PExTI.[Speed] ,PExTI.[CountBreak]
           ,PExTI.[InProcont] ,PExTI.[BW_2_Sigma] ,PExTI.[DW_2_Sigma] ,PExTI.[MO_2_Sigma] ,PExTI.[depth] ,PExTI.[moisture]
           ,PExTI.[density] ,PExTI.[Time_Start] ,PExTI.[Time_End]
from [Procont].[dbo].[Tambur_Info] PTI
left join [ProcontExchange].[dbo].[Tambur_Info] PExTI on PTI.Machina=PExTI.Machina And PTI.Num=PExTI.Num And PTI.Time_End=PExTI.Time_End
Where  PTI.Time_End between '2018-05-21 12:38:00' and '2018-05-21 14:48:01'
order by PTI.Time_End


select PTI.[Machina] ,PTI.[Num] ,PTI.[Sort] ,PTI.[Time_product] ,PTI.[Mass_product] ,PTI.[Area_capacity]
           ,PTI.[Mass_capacity] ,PTI.[Length] ,PTI.[Width] ,PTI.[Time_break] ,PTI.[Speed] ,PTI.[CountBreak]
           ,PTI.[InProcont] ,PTI.[BW_2_Sigma] ,PTI.[DW_2_Sigma] ,PTI.[MO_2_Sigma] ,PTI.[depth] ,PTI.[moisture]
           ,PTI.[density] ,PTI.[Time_Start] ,PTI.[Time_End],
		   PExTI.[Machina] ,PExTI.[Num] ,PExTI.[Sort] ,PExTI.[Time_product] ,PExTI.[Mass_product] ,PExTI.[Area_capacity]
           ,PExTI.[Mass_capacity] ,PExTI.[Length] ,PExTI.[Width] ,PExTI.[Time_break] ,PExTI.[Speed] ,PExTI.[CountBreak]
           ,PExTI.[InProcont] ,PExTI.[BW_2_Sigma] ,PExTI.[DW_2_Sigma] ,PExTI.[MO_2_Sigma] ,PExTI.[depth] ,PExTI.[moisture]
           ,PExTI.[density] ,PExTI.[Time_Start] ,PExTI.[Time_End]
from [ProcontExchange].[dbo].[Tambur_Info] PExTI
left join [Procont].[dbo].[Tambur_Info] PTI on PTI.Machina=PExTI.Machina And PTI.Num=PExTI.Num And PTI.Time_End=PExTI.Time_End
Where  PTI.Time_End between '2018-05-21 12:38:00' and '2018-05-21 14:48:01'
order by PTI.Time_End
--=======================================
