<%-- 
    Document   : jueces
    Created on : 14-jun-2008, 10:30:46
    Author     : dxfp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Control of baterie</title>
    </head>
    <body>
<%
    int iBateria = 0;
    int iID_PDA = 0;
    java.util.Date dFecha = new java.util.Date();    
    
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
    Statement st = con.createStatement();
    ResultSet rs;
    ResultSetMetaData rsmd;

   if (request.getParameter("bateria") != null)
        iBateria = (Long.valueOf(request.getParameter("bateria"))).intValue();
    else
        iBateria = 0;

    if (request.getParameter("id_pda") != null)
        iID_PDA = (Long.valueOf(request.getParameter("id_pda"))).intValue();
    else
        iID_PDA = 0;

    java.text.SimpleDateFormat Formato = new SimpleDateFormat("hh:mm:ss");
    
    rs = st.executeQuery("SELECT COUNT(*) AS cont FROM bateria_html WHERE id_pda="+iID_PDA+";");
    rs.next();
    String sSQL;
    
    if (rs.getInt("cont") > 0 )
    {
        rs.close();
        sSQL = "UPDATE bateria_html SET  hora_op = '"+Formato.format(dFecha)+"',bateria =  "+iBateria+" WHERE id_pda="+iID_PDA+";";
        out.println(sSQL);
        st.executeUpdate(sSQL);
    }
    else
    {
        rs.close();
        st.executeUpdate("INSERT INTO bateria_html VALUES("+iID_PDA+","+iBateria+",'"+Formato.format(dFecha)+"');");
    }
    st.close();
    out.println("OK");
    %>
</body>
</html>
