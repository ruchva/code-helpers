--ESTE VICHO ACTUALIZA EN 2 TABLAS EN UNS ESQUEMA QUE CONTROLA LAS MODIFICACIONES 'NOVEDADES' CON TABLAS PARAMETRICAS
--TRANSACCIONES, TABLA_CAMPO, DETALLE ACTUALIZACION
ALTER PROCEDURE [Novedades].[PR_EmpresaMod]
	-- PARAMETROS ESPECIFICOS (un parametro para cada columna)
    -- FILTRO PARAMETROS WHERE
     @RUC              VARCHAR(50)
    ,@IdTramite        INTEGER
    ,@IdGrupoBeneficio INTEGER
    ,@Version          INTEGER
    ,@Componente       INTEGER
    ,@IdEmpresa        VARCHAR(50)
    -- PARAMETROS PARA ACTUALZIAR
    ,@RUCnuevo         VARCHAR(50) = NULL
    ,@PeriodoSalario   DATE    = NULL
    ,@IdMonedaSalario  INTEGER = NULL

    ,@IdEmpresanuevo         VARCHAR(50)  = NULL
    ,@NombreEmpresaDeclarada VARCHAR(100) = NULL
    ,@PeriodoInicio    DATE    = NULL
    ,@PeriodoFin       DATE    = NULL
    ,@Monto            DECIMAL = NULL
    ,@IdMoneda         INTEGER = NULL
    ,@IdTipoDocSalario INTEGER = NULL
    ,@GlosaRespaldo    VARCHAR(255)
    ,@IdTipoTramite    INTEGER
    ,@IdSector         INTEGER = NULL

AS	
BEGIN	
	--------------------------------------------------------------------
	-- IMPLEMENTACION DE LAS OPERACIONES DEL PROCEDIMIENTO ALMACENADO --
	--------------------------------------------------------------------
    SET @IdTipoActualizacion = 31401
	
	IF @IdTipoTramite = 357--automatico, ambas tablas****
	BEGIN
		SET @cantidadRegistrosEmp = (
    		SELECT COUNT(*)
			FROM SENARIT.Tramite.EmpresaPersonaRegistro ep
			WHERE ep.IdEmpresa = @IdEmpresa
			AND ep.IdTramite = @IdTramite
			AND ep.idGrupoBeneficio = @IdGrupoBeneficio        
		)
		--PRINT @cantidadRegistrosSal
		--PRINT @cantidadRegistrosEmp
		SET @cantidadRegistrosSal = (
			SELECT COUNT(*)
			FROM SENARIT.CertificacionCC.SalarioCotizable
			WHERE RUC = @RUC
			AND IdTramite = @IdTramite
			AND IdGrupoBeneficio = @IdGrupoBeneficio
			AND Version = @Version
			AND Componente = @Componente
		)
		IF @cantidadRegistrosSal = 0 AND @cantidadRegistrosEmp = 0
		BEGIN
			SELECT @w_iIdMensajeError = 1100160 -- Procesa el valor retornado por el procedimiento invocado
			SELECT @w_iNivelError = 1 -- Es un error que significa la terminación abrupta del programa
			GOTO ErrorSP
		END      
		IF @cantidadRegistrosSal > 1 AND @cantidadRegistrosEmp > 1
		BEGIN
			SELECT @w_iIdMensajeError = 1100161 -- Procesa el valor retornado por el procedimiento invocado
			SELECT @w_iNivelError = 1 -- Es un error que significa la terminación abrupta del programa
			GOTO ErrorSP
		END
	END
    
    IF @IdTipoTramite = 356--manual, solo Empresa...****
    BEGIN
    	SET @cantidadRegistrosEmp = (
    		SELECT COUNT(*)
			FROM SENARIT.Tramite.EmpresaPersonaRegistro ep
			WHERE ep.IdEmpresa = @IdEmpresa
			AND ep.IdTramite = @IdTramite
			AND ep.idGrupoBeneficio = @IdGrupoBeneficio        
		)
		--PRINT @cantidadRegistrosEmp
		IF @cantidadRegistrosEmp = 0
		BEGIN
			SELECT @w_iIdMensajeError = 1100160 -- Procesa el valor retornado por el procedimiento invocado
			SELECT @w_iNivelError = 1 -- Es un error que significa la terminación abrupta del programa
			GOTO ErrorSP
		END    
		IF @cantidadRegistrosEmp > 1
		BEGIN
			SELECT @w_iIdMensajeError = 1100161 -- Procesa el valor retornado por el procedimiento invocado
			SELECT @w_iNivelError = 1 -- Es un error que significa la terminación abrupta del programa
			GOTO ErrorSP
		END
    END

	SELECT @IdFuncionarioRegistro = IdUsuario FROM Seguridad.FN_ListaDatosConexion(@s_iIdConexion)

	-- se inserta la cabecera, en base a los parámetros de entrada
    INSERT INTO Novedades.Actualizacion
	  (
		IdTipoActualizacion
	   ,IdUsuarioRegistro
	   ,IdUsuarioAprobacion
	   ,FechaRegistro
	   ,FechaAprobacion
	   ,GlosaActualizacion
	   ,EstadoActualizacion
	  )
	VALUES
	  (
	    @IdTipoActualizacion
	   ,@IdFuncionarioRegistro
	   ,@IdFuncionarioRegistro
	   ,GETDATE()
	   ,GETDATE()
	   ,'Modificacion de Datos de la Empresa y Salario Cotizable'
	   ,0
	  )
	--set @IdActualizacion = cast(@@IDENTITY as bigint) --ultimo identity introducido
	--ultimo id introducido de la tabla actualizacion
	SET @IdActualizacion = (
		SELECT MAX(IdActualizacion)
		FROM   Novedades.Actualizacion
		WHERE  IdTipoActualizacion = @IdTipoActualizacion
	)

    --se forma la tabla temporal, para actualizar dato anterior
    SELECT RUC
          ,IdTramite
          ,IdGrupoBeneficio
          ,Version
          ,Componente
          ,PeriodoSalario
          ,IdMonedaSalario
          ,IdTipoDocSalario 
          ,SalarioCotizable            
    INTO #temp_salario
    FROM SENARIT.CertificacionCC.SalarioCotizable
    WHERE RUC = @RUC
      AND IdTramite = @IdTramite
      AND IdGrupoBeneficio = @IdGrupoBeneficio
      AND Version = @Version
      AND Componente = @Componente
    --SELECT * FROM #temp_salario
	
    SELECT IdEmpresa
          ,IdTramite
          ,idGrupoBeneficio AS IdGrupoBeneficio
 		  ,NombreEmpresaDeclarada
		  ,PeriodoInicio
		  ,PeriodoFin
		  ,Monto
		  ,IdMoneda
		  ,IdTipoDocSalario 
		  ,IdSector
          ,CAST('' AS VARCHAR(MAX)) AS Respaldo          
	INTO #temp_empresa
	FROM SENARIT.Tramite.EmpresaPersonaRegistro
	WHERE IdEmpresa = @IdEmpresa
	  AND IdTramite = @IdTramite
	  AND idGrupoBeneficio = @IdGrupoBeneficio
	--SELECT * FROM #temp_empresa

    --se forma la estructura para ingresar al detalle
	SELECT a.IdTablaCampo
	      ,@IdActualizacion          AS IdActualizacion
	      ,a.NombreCampo
	      ,@RUC                      AS RUCDetalle
	      ,@IdTramite                AS IdTramiteDetalle
          ,@IdEmpresa                AS IdEmpresaDetalle
	      ,'A'                       AS TipoAccion
	      ,CAST('' AS VARCHAR(MAX))  AS DatoNuevo
	      ,CAST('' AS VARCHAR(MAX))  AS DatoActual
	      ,'1'                       AS Actualiza
	      ,a.IMB
	      ,a.Llave
          ,0                         AS Tabla
	INTO   #temp_detalle
	FROM   Novedades.TablaCampo a
	WHERE  IdTipoModificacion = @IdTipoActualizacion
	--SELECT * FROM #temp_detalle
		
    UPDATE #temp_detalle SET DatoNuevo = @RUCnuevo, DatoActual = ts.RUC, Tabla = 1
    FROM #temp_detalle td JOIN #temp_salario ts ON (td.RUCDetalle = ts.RUC AND td.IdTramiteDetalle = ts.IdTramite)
    WHERE td.NombreCampo = 'RUC'
  	
    UPDATE #temp_detalle SET DatoNuevo = @IdTramite, DatoActual = ts.IdTramite, Actualiza = 0, Tabla = 1
    FROM #temp_detalle td JOIN #temp_salario ts ON (td.RUCDetalle = ts.RUC AND td.IdTramiteDetalle = ts.IdTramite)
    WHERE td.NombreCampo = 'IdTramite'

    UPDATE #temp_detalle SET DatoNuevo = @IdGrupoBeneficio, DatoActual = ts.IdGrupoBeneficio, Actualiza = 0, Tabla = 1
    FROM #temp_detalle td JOIN #temp_salario ts ON (td.RUCDetalle = ts.RUC AND td.IdTramiteDetalle = ts.IdTramite)
    WHERE td.NombreCampo = 'IdGrupoBeneficio'

    UPDATE #temp_detalle SET DatoNuevo = @Version, DatoActual = ts.Version, Actualiza = 0, Tabla = 1
    FROM #temp_detalle td JOIN #temp_salario ts ON (td.RUCDetalle = ts.RUC AND td.IdTramiteDetalle = ts.IdTramite)
    WHERE td.NombreCampo = 'Version'

    UPDATE #temp_detalle SET DatoNuevo = @Componente, DatoActual = ts.Componente, Actualiza = 0, Tabla = 1
    FROM #temp_detalle td JOIN #temp_salario ts ON (td.RUCDetalle = ts.RUC AND td.IdTramiteDetalle = ts.IdTramite)
    WHERE td.NombreCampo = 'Componente'

    UPDATE #temp_detalle SET DatoNuevo = @PeriodoInicio, DatoActual = ts.PeriodoSalario, Tabla = 1
    FROM #temp_detalle td JOIN #temp_salario ts ON (td.RUCDetalle = ts.RUC AND td.IdTramiteDetalle = ts.IdTramite)
    WHERE td.NombreCampo = 'PeriodoSalario'
	
	UPDATE #temp_detalle SET DatoNuevo = @IdMoneda, DatoActual = ts.IdMonedaSalario, Tabla = 1
    FROM #temp_detalle td JOIN #temp_salario ts ON (td.RUCDetalle = ts.RUC AND td.IdTramiteDetalle = ts.IdTramite)
    WHERE td.NombreCampo = 'IdMonedaSalario'
      
    UPDATE #temp_detalle SET DatoNuevo = @IdTipoDocSalario, DatoActual = ts.IdTipoDocSalario, Tabla = 1
    FROM #temp_detalle td JOIN #temp_salario ts ON (td.RUCDetalle = ts.RUC AND td.IdTramiteDetalle = ts.IdTramite)
    WHERE td.NombreCampo = 'IdTipoDocSalario'  
    
    UPDATE #temp_detalle SET DatoNuevo = @Monto, DatoActual = ts.SalarioCotizable, Tabla = 1
    FROM #temp_detalle td JOIN #temp_salario ts ON (td.RUCDetalle = ts.RUC AND td.IdTramiteDetalle = ts.IdTramite)
    WHERE td.NombreCampo = 'SalarioCotizable'  
    
    --------
    UPDATE #temp_detalle SET DatoNuevo = @IdEmpresanuevo, DatoActual = ts.IdEmpresa, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'IdEmpresa'
	
	UPDATE #temp_detalle SET DatoNuevo = @IdTramite, DatoActual = ts.IdTramite, Actualiza = 0, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'IdTramite'

	UPDATE #temp_detalle SET DatoNuevo = @IdGrupoBeneficio, DatoActual = ts.IdGrupoBeneficio, Actualiza = 0, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'IdGrupoBeneficio'

	UPDATE #temp_detalle SET DatoNuevo = @NombreEmpresaDeclarada, DatoActual = ts.NombreEmpresaDeclarada, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'NombreEmpresaDeclarada'

	UPDATE #temp_detalle SET DatoNuevo = @PeriodoInicio, DatoActual = ts.PeriodoInicio, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'PeriodoInicio'

    UPDATE #temp_detalle SET DatoNuevo = @PeriodoFin, DatoActual = ts.PeriodoFin, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'PeriodoFin'

    UPDATE #temp_detalle SET DatoNuevo = @Monto, DatoActual = ts.Monto, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'Monto'

    UPDATE #temp_detalle SET DatoNuevo = @IdMoneda, DatoActual = ts.IdMoneda, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'IdMoneda'
	
	UPDATE #temp_detalle SET DatoNuevo = @IdTipoDocSalario, DatoActual = ts.IdTipoDocSalario, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'IdTipoDocSalario' AND td.IdTablaCampo = 154
	
	UPDATE #temp_detalle SET DatoNuevo = @IdSector, DatoActual = ts.IdSector, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'IdSector'
    
    UPDATE #temp_detalle SET DatoNuevo = @GlosaRespaldo, DatoActual = ts.Respaldo, Actualiza = 0, Tabla = 2
	FROM #temp_detalle td JOIN #temp_empresa ts ON (td.IdEmpresaDetalle = ts.IdEmpresa)
	WHERE td.NombreCampo = 'Respaldo'

    --SELECT * FROM #temp_detalle   --where upper(isnull(DatoActual,'')) != upper(isnull(DatoNuevo,''))
	
	INSERT INTO Novedades.DetalleActualizacion
	  (
	    IdTablaCampo
	   ,IdActualizacion
	   ,TipoAccion
	   ,DatoNuevo
	   ,DatoActual
	   ,Actualiza
	  )
	SELECT IdTablaCampo
	      ,IdActualizacion
	      ,TipoAccion
	      ,UPPER(DatoNuevo)
	      ,UPPER(DatoActual)
	      ,Actualiza
	FROM   #temp_detalle
	WHERE  (
	           DatoNuevo IS NOT NULL
	           AND UPPER(ISNULL(DatoActual ,'')) != UPPER(ISNULL(DatoNuevo ,''))
	           OR NombreCampo IN ('Respaldo','RUC','IdTramite','NombreEmpresaDeclarada')
	       )    
    
    --APLICA EL UPDATE
    SELECT
       a.IdTipoActualizacion
      ,a.GlosaActualizacion
      ,b.DetalleActualizacion
      ,b.TipoAccion
      ,b.DatoLlave
      ,CAST(b.DatoActual AS VARCHAR(MAX)) AS DatoActual
      ,CAST(b.DatoNuevo AS VARCHAR(MAX)) AS DatoNuevo
      ,c.NombreEsquema
      ,c.NombreTabla
      ,CAST(c.NombreCampo AS VARCHAR(MAX)) AS NombreCampo
      ,CAST(c.IMB AS VARCHAR(MAX))  AS IMB
      ,a.EstadoRegistro
      ,b.Actualiza
    INTO #temp_update
    FROM   Novedades.Actualizacion a
        INNER JOIN Novedades.DetalleActualizacion b ON  b.IdActualizacion = a.IdActualizacion
        INNER JOIN Novedades.TablaCampo c ON  c.IdTablaCampo = b.IdTablaCampo
    WHERE  a.IdActualizacion = @IdActualizacion
       AND c.NombreCampo NOT IN ('RUC','IdTramite')--ambos se modifican al final
	
    IF @IdTipoTramite = 357--automatico, mod. ambos****
    BEGIN
    	DECLARE CurSalario CURSOR
		FOR SELECT 'UPDATE ' + NombreEsquema + '.' + NombreTabla + ' SET ' + a.NombreCampo + '=' + CHAR(39) + CAST(ISNULL(a.DatoNuevo ,'') AS VARCHAR(200)) + CHAR(39)
				   +' WHERE RUC = ' +CHAR(39)+ @RUC +CHAR(39)
				   +' AND IdTramite = ' + CAST(@IdTramite AS VARCHAR (20))
				   +' AND IdGrupoBeneficio = ' + CAST(@IdGrupoBeneficio  AS VARCHAR(20))
				   +' AND Version = ' + CAST(@Version AS VARCHAR(20))
				   +' AND Componente = ' + CAST(@Componente AS VARCHAR(20))
			  FROM #temp_detalle a
				  JOIN #temp_update b ON a.NombreCampo = b.NombreCampo
			  WHERE a.Actualiza = 1
				AND a.Tabla = 1
		OPEN CurSalario
		FETCH NEXT FROM CurSalario INTO @instruccion
		WHILE @@fetch_status = 0
		BEGIN
			--PRINT(@instruccion)
			EXECUTE(@instruccion)
			FETCH NEXT FROM CurSalario INTO @instruccion
		END
		CLOSE CurSalario
		DEALLOCATE CurSalario		
		---------filtro y dato modificado a la vez
		UPDATE SENARIT.CertificacionCC.SalarioCotizable SET RUC = @RUCnuevo 
		WHERE RUC = @RUC AND IdTramite = @IdTramite AND IdGrupoBeneficio = @IdGrupoBeneficio AND Version = @Version AND Componente = @Componente
		
		DECLARE CurEmpresa CURSOR
		FOR SELECT 'UPDATE ' + NombreEsquema + '.' + NombreTabla + ' SET ' + a.NombreCampo + '=' + CHAR(39) + CAST(ISNULL(a.DatoNuevo ,'') AS VARCHAR(200)) + CHAR(39)
					+' WHERE IdEmpresa = ' + CAST(@IdEmpresa AS VARCHAR (20))
					+' AND IdTramite = ' + CAST(@IdTramite AS VARCHAR (20))
					+' AND idGrupoBeneficio = ' + CAST(@IdGrupoBeneficio  AS VARCHAR(20))
			FROM   #temp_detalle a
				JOIN #temp_update b ON a.NombreCampo = b.NombreCampo
			WHERE a.Actualiza = 1
				AND a.Tabla = 2
				
		OPEN CurEmpresa
		FETCH NEXT FROM CurEmpresa INTO @instruccion
		WHILE @@fetch_status = 0
		BEGIN
			--PRINT(@instruccion)
			EXECUTE(@instruccion)
			FETCH NEXT FROM CurEmpresa INTO @instruccion
		END
		CLOSE CurEmpresa
		DEALLOCATE CurEmpresa
		---------filtro y dato modificado a la vez
		UPDATE SENARIT.Tramite.EmpresaPersonaRegistro SET IdEmpresa = @IdEmpresanuevo
		WHERE IdEmpresa = @IdEmpresa AND IdTramite = @IdTramite AND idGrupoBeneficio = @IdGrupoBeneficio      
    END
		
    IF @IdTipoTramite = 357--manual, mod. Empresa...****
    BEGIN
    	DECLARE CurEmpresa2 CURSOR
		FOR SELECT 'UPDATE ' + NombreEsquema + '.' + NombreTabla + ' SET ' + a.NombreCampo + '=' + CHAR(39) + CAST(ISNULL(a.DatoNuevo ,'') AS VARCHAR(200)) + CHAR(39)
					+' WHERE IdEmpresa = ' + CAST(@IdEmpresa AS VARCHAR (20))
					+' AND IdTramite = ' + CAST(@IdTramite AS VARCHAR (20))
					+' AND idGrupoBeneficio = ' + CAST(@IdGrupoBeneficio  AS VARCHAR(20))
			FROM   #temp_detalle a
				JOIN #temp_update b ON a.NombreCampo = b.NombreCampo
			WHERE a.Actualiza = 1
				AND a.Tabla = 2
		OPEN CurEmpresa2
		FETCH NEXT FROM CurEmpresa2 INTO @instruccion
		WHILE @@fetch_status = 0
		BEGIN
			--PRINT(@instruccion)
			EXECUTE(@instruccion)
			FETCH NEXT FROM CurEmpresa2 INTO @instruccion
		END
		CLOSE CurEmpresa2
		DEALLOCATE CurEmpresa2
		---------filtro y dato modificado a la vez
		UPDATE SENARIT.Tramite.EmpresaPersonaRegistro SET IdEmpresa = @IdEmpresanuevo
		WHERE IdEmpresa = @IdEmpresa AND IdTramite = @IdTramite AND idGrupoBeneficio = @IdGrupoBeneficio    
    END
	
	--SELECT * FROM #temp_update
	UPDATE Novedades.Actualizacion
    SET    EstadoActualizacion = 1
    WHERE  IdActualizacion = @IdActualizacion

    UPDATE Novedades.DetalleActualizacion
    SET    EstadoActualizacion = 1
    WHERE  IdActualizacion = @IdActualizacion
           AND Actualiza = 1

    SET @mensaje_proc = 'Se ha actualizado exitosamente Datos Empresa: ' + CAST(CAST(@IdTramite AS VARCHAR(MAX)) AS VARCHAR(MAX))
    SET @retorno_proc = 1
        RETURN 1
    ---------------------------------------------------------------------------
	-- FIN DE IMPLEMENTACION DE LAS OPERACIONES DEL PROCEDIMIENTO ALMACENADO --
	---------------------------------------------------------------------------
END	