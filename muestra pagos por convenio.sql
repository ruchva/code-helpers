--de un plan de pago saca los depositos realizados
--un pago de n cuotas lo muestra como 1 pago de 1 cuota n veces

IF OBJECT_ID('tempdb..#tt') IS NOT NULL
	DROP TABLE #tt

SELECT *
      ,(
           SELECT MontoBsHaber
           FROM   Convenio.PlanRecuperacionProyectado
           WHERE  IdDeuda         = 352
                  AND IdCuota     = CASE 
                                     WHEN (
                                              SELECT TOP 1 COUNT(Periodo)
                                              FROM   Convenio.PlanRecuperacionProyectado
                                              GROUP BY
                                                     Periodo
                                          ) = 1 THEN 1
                                     ELSE 2
                                END
       )'couta'
       INTO #tt
FROM   Convenio.Depositos --where IdDeuda = 352
                          --select *,MontoDeposito/829.00 into #tt  from Convenio.Depositos where IdDeuda = 352
                          --select * from Convenio.PlanRecuperacionProyectado  where IdDeuda = 352
IF OBJECT_ID('tempdb..#ttt') IS NOT NULL
	DROP TABLE #ttt

SELECT *
      ,CASE 
            WHEN MontoDeposito = couta THEN 'C'
            ELSE CASE 
                      WHEN MontoDeposito = (
                               SELECT MontoBsHaber
                               FROM   Convenio.PlanRecuperacionProyectado
                               WHERE  IdDeuda = 352
                                      AND IdCuota = CASE 
                                                         WHEN (
                                                                  SELECT TOP 1 
                                                                         COUNT(Periodo)
                                                                  FROM   
                                                                         Convenio.PlanRecuperacionProyectado
                                                                  GROUP BY
                                                                         Periodo
                                                              ) = 2 THEN 1
                                                         ELSE 2
                                                    END
                           ) THEN 'H'
                      ELSE 'C'
                 END
       END AS 'Tipo' INTO #ttt
FROM   #tt

IF OBJECT_ID('tempdb..#tttt') IS NOT NULL
	DROP TABLE #tttt

SELECT *
      ,CASE 
            WHEN Tipo = 'H' THEN 1
            ELSE ROUND(
                     MontoDeposito /(
                         SELECT MontoBsHaber
                         FROM   Convenio.PlanRecuperacionProyectado
                         WHERE  --IdDeuda = 352 and 
                                IdCuota = CASE 
                                               WHEN (
                                                        SELECT TOP 1 COUNT(Periodo)
                                                        FROM   Convenio.PlanRecuperacionProyectado
                                                        GROUP BY
                                                               Periodo
                                                    ) = 1 THEN 1
                                               ELSE 2
                                          END
                     )
                    ,0
                 )
       END
       Cantidad
       INTO #tttt
FROM   #ttt
--select top 1 * from Convenio.Depositos

IF OBJECT_ID('tempdb..#prueba2') IS NOT NULL
	DROP TABLE #prueba2

CREATE TABLE #prueba2
(
	Iddeposito                    BIGINT
   ,IdDeuda                       BIGINT
   ,NUPAsegurado                  BIGINT
   ,NumeroDeposito                BIGINT
   ,IdMonedaDeposito              BIGINT
   ,MontoDeposito                 DECIMAL(38 ,2)
   ,FechaDeposito                 date
   ,IdCuenta                      INT
   ,IdUsuarioRegistroDeposito     INT
   ,FechaRegistroDeposito         date
   ,RegistroActico                BIT
   ,Cantidad                      INT
)
   
DECLARE @IdDeposito INT
       ,@c INT
       ,@i INT;
WHILE EXISTS(
          SELECT *
          FROM   #tttt
      )
BEGIN
    SELECT TOP 1 @IdDeposito = IdDeposito
          ,@c = Cantidad
    FROM   #tttt
    
    SET @i = 0
    WHILE @i < @c
    BEGIN
        INSERT INTO #prueba2
        SELECT IdDeposito
              ,IdDeuda
              ,NUPAsegurado
              ,NumeroDepositoBanco
              ,IdMonedaDeposito
              ,MontoDeposito
              ,FechaDeposito
              ,IdCuenta
              ,IdUsuarioRegistroDeposito
              ,FechaRegistroDeposito
              ,RegistroActivo
              ,Cantidad
        FROM   #tttt
        WHERE  IdDeposito = @IdDeposito
        
        SET @i = @i + 1;
    END
    DELETE 
    FROM   #tttt
    WHERE  IdDeposito = @IdDeposito
END

--select * from  #prueba2

SELECT *
FROM   (
           SELECT *
           FROM   Convenio.PlanRecuperacionProyectado
           WHERE  Periodo >= 201411
       ) a
       LEFT JOIN (
                SELECT ROW_NUMBER() OVER(
                           PARTITION BY IdDeuda
                          ,NUPAsegurado ORDER BY FechaDeposito ASC
                       )'Columna'
                      ,*
                FROM   #prueba2 b
                WHERE  CONVERT(CHAR(6) ,b.FechaDeposito ,112) >= 201411
                       AND b.RegistroActico = 1
            )b
            ON  a.IdDeuda = b.IdDeuda
            AND a.NUPAsegurado = b.NUPAsegurado
            AND b.Columna = a.IdCuota