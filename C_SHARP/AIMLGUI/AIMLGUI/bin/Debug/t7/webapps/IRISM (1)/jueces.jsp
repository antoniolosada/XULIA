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

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Select of judges</title>
    </head>
    <body>
<%
    long lComp = 0;
    long lCateg = 0;
    int  iBaile = 0; 
    int  iFase = 0;
    int  iRep = 0;
    int  iOp = 0;
    int  iID_PDA = 0;


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
        rs = st.executeQuery("SELECT * FROM cfg_html");
        if (rs.next()) 
        {
            lComp = rs.getLong("cod_comp");
            lCateg = rs.getLong("cod_categoria");
            iFase = rs.getInt("cod_fase");
            iBaile = rs.getInt("cod_baile");
            iRep = rs.getInt("cod_rep");
            out.print(lComp+"-"+lCateg+"-");
        }
        rs.close();
    }

    if (request.getParameter("id_pda") != null)
        iID_PDA = (Long.valueOf(request.getParameter("id_pda"))).intValue();
    else
        iID_PDA = 0;

    rs = st.executeQuery("SELECT * FROM juez_categ jc, jueces j WHERE jc.cod_juez = j.codigo AND jc.cod_categoria = " + lCateg);
%>
<FORM ID="F1" METHOD="POST" ACTION="puntuar.jsp">
<INPUT TYPE="HIDDEN" NAME="categ" VALUE="<%=lCateg%>">
<input type="HIDDEN" name="comp" value="<%=lComp%>">    
<input type="HIDDEN" name="categ" value="<%=lCateg%>">    
<input type="HIDDEN" name="fase" value="<%=iFase%>">    
<input type="HIDDEN" name="baile" value="<%=iBaile%>">    
<input type="HIDDEN" name="rep" value="<%=iRep%>">    
<input type="HIDDEN" name="id_pda" value="<%=iID_PDA%>">
<input type="HIDDEN" name="op" value="0">
<SELECT name="juez" size=8 style="font-size: 80px;">
<%
    String sJuez;
    while(rs.next())
    {
        sJuez = rs.getString("id_juez");
        out.print("<OPTION value='"+sJuez+"'>"+sJuez+". "+rs.getString("nombre")+"</OPTION>");
    }
    rs.close();
    st.close();
    con.close();
%>                
</SELECT>
<br>
<INPUT TYPE="submit" VALUE="Select Judge" style="font-size: 80px;">
</FORM>
</body>
</html>
