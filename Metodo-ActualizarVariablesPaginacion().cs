private void ActualizarVariablesPaginacion()
        {
            var codDepto = "";
            var codProv = "";
            var codMun = "";
            var tipoArea = "";
            var distrito = "";
            var zonaCensal = "";

            if (Convert.ToInt32(ddlDepartamento.SelectedIndex) > 0)
            {
                codDepto = ddlDepartamento.SelectedValue;
                if (Convert.ToInt32(ddlProvincia.SelectedIndex) > 0)
                {
                    codProv = ddlProvincia.SelectedValue;

                    if (Convert.ToInt32(ddlMunicipio.SelectedIndex) > 0)
                    {
                        codMun = ddlMunicipio.SelectedValue;
                        if (Convert.ToInt32(ddlTipoArea.SelectedIndex) > 0)
                        {
                            tipoArea = ddlTipoArea.SelectedValue;
                            if (Convert.ToInt32(ddlDistrito.SelectedIndex) > 0)
                            {
                                distrito = ddlDistrito.SelectedValue;
                                zonaCensal = ddlZona.SelectedValue;
                            }
                        }
                        else
                            GlobalsIne.msgAlert(this, "Seleccione un tipo de área");
                    }
                }
                else
                {
                    GlobalsIne.msgAlert(this, "Seleccione una provincia");
                }
            }

            if (tipoArea == "1")
                CantidadDatos =
                    GlobalsIne.GetSql(
                           "SELECT COUNT(*) FROM   t_ConsistenciaRecepcionCajas tcrc WHERE"
                           + " tcrc.CodigoDepartamento = '" + codDepto + "'"
                           + "AND tcrc.CodigoProvincia = '" + codProv + "'"
                           + "AND tcrc.CodigoMunicipio = '" + codMun + "'"
                           + "AND tcrc.TipoArea = '" + tipoArea + "'"
                           + "AND tcrc.CodigoDistrito = '" + distrito + "'"
                           + "AND tcrc.CodigoZonaCensal = '" + zonaCensal + "'", 0);
            else
                CantidadDatos =
                    GlobalsIne.GetSql(
                           "SELECT COUNT(*) FROM   t_ConsistenciaRecepcionCajas tcrc WHERE"
                           + " tcrc.CodigoDepartamento = '" + codDepto + "'"
                           + "AND tcrc.CodigoProvincia = '" + codProv + "'"
                           + "AND tcrc.CodigoMunicipio = '" + codMun + "'"
                           + "AND tcrc.TipoArea = '" + tipoArea + "'", 0);

            PageNumberFinal = (CantidadDatos / PageSize);
            if ((CantidadDatos % PageSize) == 0)//si la cantidad de datos es divisible entre el tamaño de paginas se debe restar uno a la pagina final 
                PageNumberFinal--;              //porque la paginacion empieza desde 0 

            if (PageNumber > PageNumberFinal) //si la pagina actual es mayor a la pagina final, (porq se elimino el unico registro de la ultima pagina)
                PageNumber = PageNumberFinal; //el numero de pagina actual sera la ultima pagina
        }
        
