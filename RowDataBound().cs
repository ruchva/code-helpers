protected void gvAsignacionTecnico_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if(e.Row.RowType == DataControlRowType.DataRow)
            {
                var imgAsignar = (ImageButton)e.Row.FindControl("imgAsignar");
                var imgDevolver = (ImageButton)e.Row.FindControl("imgDevolver");
                var imgRevertir = (ImageButton) e.Row.FindControl("imgRevertir");
                switch (e.Row.Cells[7].Text)
                {
                    case "&nbsp;":
                        imgAsignar.Enabled = true;
                        imgAsignar.Visible = true;
                        imgDevolver.Enabled = false;
                        imgDevolver.Visible = false;
                        imgRevertir.Enabled = false;
                        imgRevertir.Visible = false;
                        e.Row.Cells[7].Text = "No";
                        e.Row.Cells[7].BackColor = Color.FromName("#ffeb9c");
                        break;
                    default:
                        if (e.Row.Cells[7].Text != "&nbsp;")
                        {
                            switch (Convert.ToInt32(e.Row.Cells[7].Text))
                            {
                                case 0:
                                    imgAsignar.Enabled = false;
                                    imgAsignar.Visible = false;
                                    imgDevolver.Enabled = true;
                                    imgDevolver.Visible = true;
                                    imgRevertir.Enabled = true;
                                    imgRevertir.Visible = true;
                                    e.Row.Cells[7].Text = "Si";
                                    e.Row.Cells[7].BackColor = Color.FromName("#c6efce");
                                    break;
                                case 1:
                                    imgAsignar.Enabled = false;
                                    imgAsignar.Visible = false;
                                    imgDevolver.Enabled = false;
                                    imgDevolver.Visible = false;
                                    imgRevertir.Enabled = false;
                                    imgRevertir.Visible = false;
                                    e.Row.Cells[7].Text = "Devuelto";
                                    e.Row.Cells[7].BackColor = Color.FromName("#ffc7ce");
                                    break;
                            }
                        }
                        break;
                }
            }
        }
