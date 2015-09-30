select tblPivot.columna
      ,tblPivot.valor
from
(select convert(varchar, isnull(p.Matricula,''))[Matricula]
       ,convert(varchar, isnull(p.Tramite,''))[Tramite]	
	   ,convert(varchar, cast(p.no_certif as char(20)))[no_certif]
 from dbo.Piv_CERTIF_PMM_PU p 
 where p.Matricula = '565218CAM' and p.Tramite = 141060
)Certif
unpivot (valor for columna in ([Matricula]
                              ,[Tramite]
							  ,[no_certif]
							  )
		) AS tblPivot


--sp_columns Piv_CERTIF_PMM_PU