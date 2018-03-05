<%@page import="java.util.TimerTask"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Date,java.text.*" %>
<%@ taglib prefix="s" uri="/struts-tags" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css">
table {
    width: 50%;
}
ul {
  list-style-type: none;
}
td, th {
    border: 1px solid #dddddd;
    padding: 8px;
    text-align: left;
}
div.footer
{
    clear: both;
    border: 0px groove #aaaaaa;
    padding: 0;
    text-align: center;
    vertical-align: middle;
    line-height: normal;
    margin: 0;
    position: fixed;
    bottom: 0px;
    width: 100%;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Mark attendance</title>
</head>
<body>
<jsp:include page="../view/welcome_header.jsp"></jsp:include>
<%!
String current_time;
String current_date;
%>
<%
try
{
	session=request.getSession(false);
	if(session.getAttribute("id")!=null)
	{
		SimpleDateFormat sdf=new SimpleDateFormat("kk:mm:ss");
		Date date=new Date();
		current_time=sdf.format(date);
		sdf=new SimpleDateFormat("dd/MM/yyyy");
		current_date=sdf.format(date);
	}
	else
	{
		response.sendRedirect("/AttendanceSystem");
	}
}
catch(Exception e)
{
	
}
%>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Manual Punch</small></h1>
</div>
</div>
<div align="center" style="">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<form action="log_attendance" method="post">
<table>
<tr>
	<td>Date:</td>
	<td><input id="date" type="text" name="date" value="<%=current_date%>" disabled/></td>
</tr>
<tr>
	<td>Entry-type:</td>
	<td><input type="radio" name="entryType" value="inTime" checked>In-Time&nbsp;<input type="radio" name="entryType" value="outTime">Out-Time</td>
</tr>
</table>
<br/>
<input type="submit" value="Mark"/>
</form>
</div>
<br/>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>