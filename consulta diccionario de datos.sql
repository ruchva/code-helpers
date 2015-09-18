sp_columns REPROCESO_CC
--sp_help REPROCESO_CC

SELECT st.name'Tabla'
      ,sc.name'Columna'
      ,sep.value'Descripcion'
FROM   sys.tables st
       INNER JOIN sys.columns sc ON  st.object_id = sc.object_id
       LEFT JOIN sys.extended_properties sep ON  st.object_id = sep.major_id
            AND sc.column_id = sep.minor_id
            AND sep.name = 'MS_Description'
WHERE  st.name = 'ReprocesoCC'
       --AND sc.name = 'NRO_FORM'