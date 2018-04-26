<%-- 
    Document   : puntuar
    Created on : 12-jun-2008, 12:32:29
    Author     : dxfp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <script type="text/javascript">
            var amarillo_en_codigo = "#ffff00";
            var verde_en_codigo = "#9acd32";
            //var verde = "#adff2f";
            //var amarillo = "#ffff80";
            var amarillo = "yellow";
            var verde = "yellowgreen";
            
            var PuestoCambio = 0;
            var CambioPuesto = false;
            var ImpedirSalida = true;
            
            function Inicializar()
            {
                var i;
                for (i = 0; i < document.F1.num_dorsales.value; i++)
                    {
                        //document.getElementById("pos"+i).value = 0;
                        eval("document.F1.pos"+i+".value = 0;");
                    }
            window.onbeforeunload = confirmaSalida;  

            }

            function confirmaSalida()   
            {    
                if (ImpedirSalida == true)
                    return "Don't leave this page. No salga de esta página.";
            }
    
            function cambio(p, pos, dorsal)
            {
                var Puesto = 0;
                
                if (CambioPuesto == false)
                {
                    CambioPuesto = true;
                    PuestoCambio = 0;
                    p.style.backgroundColor = amarillo;
                    eval("PuestoCambio = document.F1.pos"+p.id+".value;");    
                }
                else
                {
                    if (dorsal == 9) //Se ha pulsado la C de nuevo
                    {
                        CambioPuesto = false;
                        PuestoCambio = 0;
                        p.style.backgroundColor = verde;
                    }
                    else
                    {
                        var i = 0;
                        var Posicion = 0;
                        var op = 1;
                
                        eval("PuestoCambio = document.F1.pos"+dorsal+".value;");    
                
                        if (PuestoCambio > 0)
                        {
                            if (PuestoCambio < pos) 
                            {
                                op = -1;
                                PuestoCambio++;
                            }
                            else
                            {
                                Posicion = PuestoCambio;
                                PuestoCambio = pos;
                                pos = Posicion;
                                op = 1;
                                pos--;
                            }

                            for (i=0; i< iNumDorsales; i++)
                            {
                                eval("Posicion = document.F1.pos"+i+".value;");
                                if (Posicion >= PuestoCambio && Posicion <= pos)
                                {
                                    eval("document.F1.pos"+i+".value = Math.abs(Posicion) + op;");
                                    eval("document.F2.puesto"+i+".value = document.F1.pos"+i+".value;");
                                    eval("Puesto = document.F1.pos"+i+".value;");
                                }
                            }
                            if (op == 1)
                            {
                                eval("document.F1.pos"+dorsal+".value = "+PuestoCambio+";");
                                eval("document.F2.puesto"+dorsal+".value = "+PuestoCambio+";");
                            }
                            else
                            {
                                eval("document.F1.pos"+dorsal+".value = "+pos+";");
                                eval("document.F2.puesto"+dorsal+".value = "+pos+";");
                            }
                            PuestoCambio = 0;

                            CambioPuesto = false;
                            ColorearCuadro();
                        }
                        else
                        {
                            CambioPuesto = false;
                            eval("document.F2.c"+dorsal+".style.backgroundColor = 'yellowgreen'");
                        }
                    }
                }
            }
    
            function ColorearCuadro()
            {
                var Puesto;
                var i;
                var j;
                var DorsalesConPuesto = 0;
                
                //Coloreamos todos de blanco y comprobamos los dorsales con puesto
                for (i=0; i< iNumDorsales; i++)
                {
                    eval("Puesto = document.F2.puesto"+i+".value;");
                    if (Puesto > 0)
                        DorsalesConPuesto++;
                    for (j=1; j<= iNumDorsales; j++)
                        eval("document.F2.p"+i+"_"+j+".style.backgroundColor = 'white'");
                }

                for (i=0; i< iNumDorsales; i++)
                {
                    eval("Puesto = document.F2.puesto"+i+".value;");
                    //Coloreamos de verde el puesto y de rojo los demás
                    if (Puesto > 0)
                    {
                        for (j=0; j< iNumDorsales; j++)
                        {
                            if (j == i)
                                eval("document.F2.p"+j+"_"+Puesto+".style.backgroundColor = 'green'");
                            else
                                eval("document.F2.p"+j+"_"+Puesto+".style.backgroundColor = 'red'");
                        }
                    }    
                    eval("document.F2.c"+i+".style.backgroundColor = 'yellowgreen'");
                }
            }
    
            function DorsalNoPresente(d)
            {
                var PosDorsal;
                var PuestoDorsal;
                var NoPresente = false;
                var Confirmar;
                var i;
                var salir = false;
                var Dorsal;
                
                PosDorsal = d.id;
                
                eval("NoPresente = document.F2.puesto"+PosDorsal+".value;");
                if (NoPresente == 'N')
                {
                    //Colocar un dorsal no presente como presente
                    if (confirm("Press 'Accept' if the number is present"))
                    {
                        eval("document.F2.puesto"+PosDorsal+".value = ''");
                        eval("document.F1.pos"+PosDorsal+".value = '0'");
                        eval("document.F2.puesto"+PosDorsal+".style.backgroundColor = 'white'");
                        iNumDorsales++;
                    }
                }
                else //Dorsal presente a no presente
                {
                    if (confirm("Press 'Accept' if the number not this present?"))
                    {
                        //Primero comprobamos que ningún dorsal tenga un puesto mayor que el número de dorsales
                        for (i=0; i<iNumDorsales; i++)
                        {
                            eval("PuestoDorsal = document.F1.pos"+i+".value;");
                            eval("Dorsal = document.F1.dorsal"+i+".value;");
                            if (PuestoDorsal == iNumDorsales)
                            {
                                alert("The number "+Dorsal+" have a bigger position");
                                salir = true;
                            }
                        }
                        if (!salir)
                        {
                            eval("PuestoDorsal = document.F1.pos"+PosDorsal+".value;");
                            if (PuestoDorsal > 0 )
                                alert("The number has assigned a position");
                            else
                            {
                                eval("document.F2.puesto"+PosDorsal+".value = 'N'");
                                eval("document.F1.pos"+PosDorsal+".value = '0'");
                                eval("document.F2.puesto"+PosDorsal+".style.backgroundColor = 'red'");
                                iNumDorsales--;
                            }
                        }
                    }
                }
            }
    
            function Recargar()
            {
                var confirmacion;
                
                confirmacion = prompt("Type 'y' if this operation is authorized","no")
                if (confirmacion == "y")
                {
                    document.F1.op.value=2;
                    document.F1.submit();
                }
            }
            function Enviar()
            {
                var i;
                var DorsalSinPuesto = false;
                var Puesto;
                
                //Comprobamos que todos los dorsales tienen puesto
                for (i = 0; i < iNumDorsales; i++)
                    {
                        //Puesto = document.getElementById('pos'+i).value;
                        eval("Puesto = document.F1.pos"+i+".value;");
                        if (Puesto == 0)
                            {
                                eval("Puesto = document.F2.puesto"+i+".value;");
                                if (Puesto != 'N')
                                    DorsalSinPuesto = true;
                            }
                    }
                    if (DorsalSinPuesto)
                        alert("All the numbers have to have position to send the data");
                    else
                    {
                        ImpedirSalida = false;
                        document.F1.op.value=1;
                        document.F1.submit();
                    }
            }

            function EnviarElim()
            {
                    if (iMarcas > 0)
                        alert("You have not selected all the numbers");
                    else
                    {
                        ImpedirSalida = false;
                        document.F1.op.value=1;
                        document.F1.submit();
                    }
            }

            function pasaElim(c,selec)
            {
                var dorsal;
                var pos_dorsal;
                var s;
                
                dorsal = c.value; //Contiene el número del dorsal
                pos_dorsal = c.id; //Contiene la posición del dorsal
                
                if (c.style.backgroundColor == "lightgreen")
                {
                    c.style.backgroundColor = "white";
                    iMarcas = iMarcas + 1;
                    //document.getElementById('pos'+dorsal).value = 0;
                    eval("document.F1.pos"+pos_dorsal+".value = 0;");
                }
                else if (c.style.backgroundColor == "yellow")
                {
                
                    if (iMarcas > 0)
                    {
                        c.style.backgroundColor = "lightgreen";
                        //document.getElementById("pos"+dorsal).value = 1;
                        eval("document.F1.pos"+pos_dorsal+".value = 1;");
                        iMarcas = iMarcas - 1;
                    }
                    else alert ("All the numbers are selected")
                }
                else
                {
                    //c.style.backgroundColor = amarillo_en_codigo;
                    c.style.backgroundColor = "yellow";
                }
                    
                document.F1.Dorsales.value=iMarcas;
            }

    
        function pasa(c){
                var i = 1;
                var pos;
                var dorsal;
                var s;
                var asignado;
                var PuestoActual;
                var PuestoTmp;

                s = c.id;
                pos = s.charAt(2);
                dorsal = s.charAt(0);
                
                //Si está solicitado un cambio
                if (CambioPuesto == true)                
                {
                    if (pos > iNumDorsales)
                    {
                        alert("The position is very big");
                        asignado = true;
                    }
                    else cambio(c, pos, dorsal);
                }
                else
                {
                    //PuestoActual = document.getElementById("puesto"+dorsal).innerHTML; //Puesto actual
                    eval("PuestoActual = document.F2.puesto"+dorsal+".value;");
                    //Si ya tenía este puesto se lo quitamos
                    if (pos == PuestoActual)
                        {
                            ColorearPuesto(c,dorsal,pos,0);
                            asignado = true;
                        }
                    else 
                        {
                            //Comprobamos si el puesto es mayor que el número de dorsales
                            if (pos > iNumDorsales)
                            {
                                alert("The position is very big");
                                asignado = true;
                            }
                            else
                            {
                                //Comprobamos si el puesto seleccionado lo tiene otro dorsal
                                for (i=0; i<iNumDorsales; i++)
                                {
                                    //PuestoTmp = document.getElementById("puesto"+i).innerHTML;
                                    eval("PuestoTmp = document.F2.puesto"+i+".value;");
                                    if (pos == PuestoTmp)
                                    {
                                        asignado = true;
                                        if (confirm("The position is already assigned.Do you want to change the position?"))
                                        {
                                            ColorearPuesto(c,i,pos,0);
                                            asignado = false;
                                        }
                                    }
                                }
                            }        
                        }
                    if (!asignado)
                        ColorearPuesto(c,dorsal,pos,pos);
                }
            }
            
            function ColorearPuesto(p, dorsal, pos, puesto)
            {
                var s;
                var PuestoActual;
                if (puesto > 0)
                    {
                    //Si este dorsal tenía otro puesto se lo quitamos
                    eval("PuestoActual = document.F2.puesto"+dorsal+".value;");
                    //PuestoActual = document.getElementById("puesto"+dorsal).innerHTML;
                    if (PuestoActual != '')
                        {
                        ColorearPuesto(p,dorsal,PuestoActual,0);
                        }
                    
                    //document.getElementById("puesto"+dorsal).style.backgroundColor = "yellow";
                    eval("document.F2.puesto"+dorsal+".style.backgroundColor = 'yellow';");
                    //document.getElementById("puesto"+dorsal).innerHTML=puesto;
                    eval("document.F2.puesto"+dorsal+".value=puesto;");
                    for (i=0; i<iNumDorsales; i++)
                        {
                        s = i+"_"+pos;
                        //document.getElementById(s).style.backgroundColor = "RED";
                        eval("document.F2.p"+s+".style.backgroundColor = 'RED';");
                        }
                    p.style.backgroundColor = "green";
                    //document.getElementById("pos"+dorsal).value = puesto;
                    eval("document.F1.pos"+dorsal+".value = puesto;");
                    }
                 else //Eliminamos el puesto
                    {
                    //document.getElementById("puesto"+dorsal).value = 0;
                    eval("document.F2.puesto"+dorsal+".value = 0;");
                    //document.getElementById("puesto"+dorsal).style.backgroundColor = "white";
                    eval("document.F2.puesto"+dorsal+".style.backgroundColor = 'white';");
                    //document.getElementById("puesto"+dorsal).innerHTML="";
                    eval("document.F2.puesto"+dorsal+".value='';");
                    //document.getElementById("pos"+dorsal).value = 0;
                    eval("document.F1.pos"+dorsal+".value = 0;");
                    for (i=0; i<iNumDorsales; i++)
                        {
                        s = "p"+i+"_"+pos;
                        //document.getElementById(s).style.backgroundColor = "white";
                        eval("document.F2."+s+".style.backgroundColor = 'white';");
                        }
                    }
            }
        </script>
    </head>
    <!------------------------------------------------------------------------------------------------------------------------------------------------------------->
    <!------------------------------------------------------------------------------------------------------------------------------------------------------------->
    <!------------------------------------------------------------------------------------------------------------------------------------------------------------->
    <!------------------------------------------------------------------------------------------------------------------------------------------------------------->
    <body onLoad='Inicializar();'>
        <%
            try {
                Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
            } catch (Exception e) {
                System.out.println("No se ha podido cargar el Driver JDBC-ODBC");
            }
            try {

                // Obtenemos un contexto inicial
                InitialContext ctx = new InitialContext();

                // Obtenemos el contexto de nuestro entorno. La cadena
                // "java:comp/env" es siempre la misma
                Context envCtx = (Context) ctx.lookup("java:comp/env");

                // Obtenemos una fuente de datos identificada con la cadena que
                // le hemos asignado en los ficheros de configuración
                DataSource ds = (DataSource) envCtx.lookup("jdbc/escrutinio");

                // Ya podemos obtener una conexión y operar con ella normalmente
                Connection con = ds.getConnection();

                //Connection con = DriverManager.getConnection("jdbc:odbc:escrutinio", "", "");
                ResultSetMetaData rsmd;
                Statement st;
                ResultSet rs;
                ResultSet rs1;
                String sJuez = "A";
                String sCategoria = "Empty";
                long lComp = 0;
                long lCateg = 0;
                int  iBaile = 0; 
                int  iFase = 0;
                int  iRep = 0;
                int  iOp = 0;
                int iNumDorsales = 0;
                int iMarcas = 0;
                int iID_PDA = 0;
                String sBaileAbrev = "";
                String sSQL;
                
                    if (request.getParameter("juez") != null)
                        sJuez = request.getParameter("juez");
                    else
                    {
                        out.println("<h2>The judge is not selected</h2>");
                    }
                    if (request.getParameter("op") != null)
                       iOp = (Long.valueOf(request.getParameter("op"))).intValue();
                    else
                       iOp = 0;
                    if (request.getParameter("num_dorsales") != null)
                       iNumDorsales = (Long.valueOf(request.getParameter("num_dorsales"))).intValue();
                    else
                       iNumDorsales = 0;
                    if (request.getParameter("id_pda") != null)
                       iID_PDA = (Long.valueOf(request.getParameter("id_pda"))).intValue();
                    else
                       iID_PDA = 0;

               if (request.getParameter("comp") != null)
                {
                    lComp = (Long.valueOf(request.getParameter("comp"))).longValue();
                    if (request.getParameter("categ") != null)
                        lCateg = (Long.valueOf(request.getParameter("categ"))).longValue();
                    else
                        lCateg = 0;
                    
                    if (request.getParameter("baile") != null)
                        iBaile = (Long.valueOf(request.getParameter("baile"))).intValue();
                    else
                        iBaile = 0;

                    if (request.getParameter("fase") != null)
                        iFase = (Long.valueOf(request.getParameter("fase"))).intValue();
                    else
                        iFase = 0;

                    if (request.getParameter("rep") != null)
                        iRep = (Long.valueOf(request.getParameter("rep"))).intValue();
                    else
                        iRep = 0;
                }
                else
                {
                    //Si no tenemos la categoría, cargamos la actual
                    st = con.createStatement();
                    rs = st.executeQuery("SELECT * FROM cfg_html WHERE fase = 'ACTUAL'");
                    if (rs.next())
                    {
                        lComp = rs.getLong("cod_comp");
                        lCateg = rs.getLong("cod_categoria");
                        iFase = rs.getInt("cod_fase");
                        iBaile = rs.getInt("cod_baile");
                        iRep = rs.getInt("cod_rep");
                    }
                    rs.close();
                    st.close();
                }

                //Grabamos la información del juez
                try
                {
                    st = con.createStatement();
                    if (iID_PDA > 0)
                        st.executeUpdate("DELETE FROM jueces_html WHERE id_pda ="+iID_PDA);
                    sSQL = "INSERT INTO jueces_html VALUES ('"+sJuez+"', " +lCateg+",'"+iID_PDA+"')";
                    st.executeUpdate(sSQL);
                    st.close();
                }
                catch(Exception e)
                {        
                    //Si hay un error por estar ya introducido no hacemos nada
                }
                
                if (iOp == 2) //Cargamos la información de la categoría actual
                {
                    st = con.createStatement();
                    rs = st.executeQuery("SELECT * FROM cfg_html WHERE fase = 'ACTUAL'");
                    if (rs.next())
                    {
                        lComp = rs.getLong("cod_comp");
                        lCateg = rs.getLong("cod_categoria");
                        iFase = rs.getInt("cod_fase");
                        iBaile = rs.getInt("cod_baile");
                        iRep = rs.getInt("cod_rep");
                    }
                    rs.close();
                    st.close();
                }
                if (iOp == 1) //Grabamos los datos y cargamos los siguientes datos
                {
                    int i;
                    int iDorsal = 0, iPuesto = 0;

                    st = con.createStatement();
                    sSQL = "DELETE FROM puntuaciones WHERE cod_juez = '"+sJuez+"' AND cod_categoria ="+lCateg+" AND fase="+iFase+" AND cod_baile="+iBaile+" AND repesca = "+iRep;
                    st.executeUpdate(sSQL);
                    st.close();
                    //Grabamos las puntuaciones de todos los dorsales
                    for (i=0; i<iNumDorsales; i++)
                    {
                        if (request.getParameter("dorsal"+i) != null)
                            iDorsal = (Long.valueOf(request.getParameter("dorsal"+i))).intValue();

                        if (request.getParameter("pos"+i) != null)
                            iPuesto = (Long.valueOf(request.getParameter("pos"+i))).intValue();
                            
                        //Insertamos los datos en la base de datos
                        st = con.createStatement();
                        sSQL = "INSERT INTO puntuaciones VALUES("+iDorsal+","+lCateg+","+iBaile+",'"+sJuez+"',"+iPuesto+","+iFase+","+iRep+")";
                        st.executeUpdate(sSQL);
                        st.close();
                    }
                   //Primero comprobamos si aún queda algún baile en esta fase
                    sSQL = "SELECT TOP 1 cod_baile FROM Bailes_Categ WHERE posicion > (SELECT bc.posicion FROM bailes_categ bc WHERE bc.cod_baile = "+iBaile+" AND bc.cod_categoria = "+lCateg+" AND ((bc.fase ="+iFase+") OR ("+iFase+">2 AND bc.fase = 2))) AND cod_categoria ="+lCateg+" AND ((fase ="+iFase+") OR ("+iFase+">2 AND fase = 2)) ORDER BY posicion";
                    st = con.createStatement();
                    rs = st.executeQuery(sSQL);
                    if (rs.next())
                    {
                        iBaile = rs.getInt("cod_baile");
                    }
                    else
                    {
                        rs.close();
                        //Es el último baile => cargamos la siguiente categoría según el horario
                        /*sSQL = "SELECT TOP 1 * FROM horario WHERE numfase <> 99 AND cod_competicion = " + lComp +
                               " AND orden > (SELECT TOP 1 orden FROM horario WHERE cod_categoria = " + lCateg + " and numfase = " + iFase +
                               " AND repesca = " + iRep + " AND cod_competicion = " + lComp + ") ORDER BY orden";*/
                        sSQL = "SELECT * FROM cfg_html WHERE fase = 'SIGUIENTE' AND cod_comp > 0";
                        rs = st.executeQuery(sSQL);
                        if (rs.next())
                        {
                            lCateg = rs.getLong("cod_categoria");
                            iFase = rs.getInt("cod_fase");
                            iRep = rs.getInt("cod_rep");
                            iBaile = rs.getInt("cod_baile");
                        }
                        else
                            out.println("<h2>This is the last category</h2>");
                           
                    }
                    
                }
    
                //Si el horario no establece baile de comienzo
                if (iBaile == 0)
                {
                    //Recuperamos el primer baile
                    sSQL = "SELECT TOP 1 cod_baile FROM Bailes_Categ WHERE cod_categoria ="+lCateg+" AND (fase ="+iFase+" OR ("+iFase+">2 AND fase = 2)) ORDER BY posicion";
                    st = con.createStatement();
                    rs = st.executeQuery(sSQL);
                    if (rs.next())
                        iBaile = rs.getInt("cod_baile");
                    else
                        out.println("<h2>The category doesn't have dances</h2>");

                    rs.close();
                    st.close();
                }

                st = con.createStatement();
                //Comprobamos si el juez juzga esta categoría
                rs = st.executeQuery("SELECT COUNT(*) AS cont FROM juez_categ WHERE cod_categoria = " + lCateg + " AND id_juez = '"+sJuez+"'");
                rs.next();
                if (rs.getInt("cont") == 0)
                {
                    out.println("<h3>The selected judge doesn't judge this category.<h3>");
                    out.println("<a href = 'jueces.jsp'><h3>You should select another judge.<h3></a>");
                    rs.close();
                }
                else
                {
                    rs.close();

                    //Abreviatura del nombre del baile
                    rs = st.executeQuery("SELECT * FROM bailes WHERE codigo = " + iBaile);
                    if (rs.next())
                        {
                        sBaileAbrev = rs.getString("abrev");
                    }
                    rs.close();

                    st = con.createStatement();
                    rs = st.executeQuery("SELECT COUNT(*) FROM dorsales WHERE cod_categoria = " + lCateg + " and fase = " + iFase + " and repesca = " + iRep);
                    rs.next();
                    iNumDorsales = rs.getInt(1);

                    if (iNumDorsales == 0)
                        out.print("<h2>The category doesn't have participants</h2>");
    %>
        <script type="text/javascript">
            var iNumDorsales = <%=iNumDorsales%>
        </script>
    <%
                    rs.close();
                    rs = st.executeQuery("SELECT descripcion FROM categorias WHERE codigo = " + lCateg );
                    if (rs.next())
                        sCategoria = rs.getString("descripcion");
                    else
                        sCategoria = "Empty";


                    //Comprobamos si tenemos ya todas las posiciones    
                    rs = st.executeQuery("SELECT num_dorsal, '' AS puesto FROM dorsales WHERE cod_categoria = " + lCateg + " and fase = " + iFase + " and repesca = " + iRep + " ORDER BY num_dorsal");
                    rsmd = rs.getMetaData();
                    String fila = null;
                    int cols = rsmd.getColumnCount();
                    int iPosDorsal = 0;
                    String sPosPuesto;
                    int i = 1;
                    if (iFase == 1) // Fase final ********************************************************************************************************************************
                    {
%>
        <form name = "F2" method = "POST" action="puntuar.jsp">
<%
                        while(rs.next()){
        %>
                                <table align="center" bgcolor="#d4d4d4" border="1" cellpadding="0" cellspacing="0">
                                    <tr>

        <%
                            //Introducimos el dorsal
                            out.println("<td color= white bgcolor = powderblue align=center width=40 style='font-size: 100px; width:180px; height:110px;'><b>"+String.valueOf(rs.getString("num_dorsal")+"</b></td>"));
        %>
                                    <td id="puesto_tabla<%=iPosDorsal%>" color= white bgcolor = white align=center  width="20">
                                    <input type="button" name="puesto<%=iPosDorsal%>" id="<%=iPosDorsal%>" onclick='DorsalNoPresente(this);' value='<%=rs.getString("puesto")%>' style='BORDER: rgb(128,128,128) 0px solid; BACKGROUND-COLOR: rgb(255,255,255); font-size: 100px;  width:100px; height:110px;'">
                                    </td>
                                        <td>
                                            <font size = 2>
                                            <table align="center" bgcolor="#d4d4d4" border="0" cellpadding="0" cellspacing="0" height= 20 width="200">
                                                <tr>
        <%
                            for (i=1; i<=9; i++)
                            {
                                if (i == 6)
                                    out.print("</tr><tr>");

                               if (i <= iNumDorsales)
                                    out.println("<td><input type = 'button' name ='p"+iPosDorsal+"_"+i+"' id ='"+iPosDorsal+"_"+i+"' value = '"+i+"' ondblclick='pasa(this);' onclick='pasa(this);' align=center width=40 style='BORDER: rgb(128,128,128) 1px solid; BACKGROUND-COLOR: rgb(255,255,255); height:70px; width:90px; font-size: 60px;'></td>");
                               else if (i == iNumDorsales+1)
                                    out.println("<td><input type = 'button' name ='c"+iPosDorsal+"' id ='"+iPosDorsal+"' value = 'C' onclick='cambio(this,"+i+",9);' align=center width=40 style='BORDER: rgb(128,128,128) 1px solid; BACKGROUND-COLOR: yellowgreen; height:70px; width:90px; font-size: 60px;'></td>");

                            }
                            iPosDorsal++;
                            out.println("</tr>");
        %>
                                            </tr>
                                        </table>
                                    </font>
                                </td>
                            </tr>
        <%
                      } //WHILE
%>
        </form>
<%
                }
                else // Fases eliminatorias **********************************************************************************************
                {
                        iMarcas = iFase*3;
        %>
                                <table align="center" bgcolor="#d4d4d4" border="0" cellpadding="0" cellspacing="0">
                                    <tr>

        <%
                        String sNumDorsal  = "";
                        while(rs.next()){
                            sNumDorsal = String.valueOf(rs.getString("num_dorsal"));
                            //Introducimos el dorsal
                            out.println("<td id ='celda"+sNumDorsal+"' align=center border=0>");
                            out.println("<input type = 'button' name ='"+sNumDorsal+"' id ='"+iPosDorsal+"' value = '"+sNumDorsal+"' onclick='pasaElim(this,1);' align=center width=45 style='BORDER: rgb(128,128,128) 1px solid; BACKGROUND-COLOR: white; font-size: 100px; height:200px;'>");
                            out.println("</td>");
                            iPosDorsal++;
                            if (iPosDorsal % 6 == 0)
                                out.println("</tr><tr>");
                      } //WHILE
                }
    %>
                        <tr><td colspan=6>
        <form name = "F1" method = "POST" action="puntuar.jsp">
    <%

                rs.close();
                rs = st.executeQuery("SELECT * FROM dorsales WHERE cod_categoria = " + lCateg + " and fase = " + iFase + " and repesca = " + iRep + " ORDER BY num_dorsal");
                i = 0;
                while(rs.next())
                {
                    String sNumDorsal = rs.getString("num_dorsal");
                    out.println("<input type='HIDDEN' name='dorsal"+i+"'  id='dorsal"+i+"' value="+sNumDorsal+">");
                    if (iFase == 1)
                        out.println("<input type='HIDDEN' name='pos"+i+"' id='pos"+i+"' value=0>");
                    else
                        out.println("<input type='HIDDEN' name='pos"+i+"' id='pos"+sNumDorsal+"' value=0>");
                    i++;
                }
                out.println("<input type='HIDDEN' id='num_dorsales' name='num_dorsales' value="+iNumDorsales+">");
    %>
        <script type="text/javascript">
            var iMarcas = <%=iMarcas%>;
        </script>
    <input type="HIDDEN" name="juez" value="<%=sJuez%>">    
    <input type="HIDDEN" name="comp" value="<%=lComp%>">    
    <input type="HIDDEN" name="categ" value="<%=lCateg%>">    
    <input type="HIDDEN" name="fase" value="<%=iFase%>">    
    <input type="HIDDEN" name="baile" value="<%=iBaile%>">    
    <input type="HIDDEN" name="rep" value="<%=iRep%>">    
    <input type="HIDDEN" name="id_pda" value="<%=iID_PDA%>">
    <input type="HIDDEN" name="op" value="<%=iOp%>">
    <%
        if (iFase == 1)
            out.println("<input type='button' name='Send' value='Ok' onclick='Enviar();' style='font-size: 100px; width:200px;'>");
        else
            out.println("<input type='button' name='Send' value='Ok' onclick='EnviarElim();' style='font-size: 100px; width:200px;'>");
    %>

    <%
        if (iFase > 1)
            out.println("<input type='button' name='Dorsales' value='"+iMarcas+"'  style='font-size: 100px;'>");
    %>
    <font style='font-size: 60px;'><%=sJuez%>.<%=sBaileAbrev%> - <%=sCategoria.substring(0, 10) %></font>
   <input type="button" name="R" value="R" onclick='Recargar();' style='font-size: 100px;'> 
   <b></b></form>
    </td></tr>
    </table>
<%
            con.close();
                } //else de categoria juzgada por el juez
            } catch (SQLException ex) {
                out.println(ex.toString());
            }   
        %>
    </body>
</html>
