<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.attendance.model.Employee"%>
<%@page import="org.hibernate.criterion.ProjectionList"%>
<%@page import="org.hibernate.criterion.Projections"%>
<%@page import="org.hibernate.criterion.Projection"%>
<%@page import="org.hibernate.criterion.DetachedCriteria"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.cfg.Configuration"%>
<%@page import="org.hibernate.SessionFactory"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css">
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
<title>Attendance report</title>
<script type="text/javascript">
function enableSelect()
{
	if(document.getElementById('empBox').checked)
	{
		$("#emp_select").prop("disabled", false);
	}
	else if(!document.getElementById('empBox').checked)
	{
		$("#emp_select").prop("disabled", true);
	}
}
</script>
</head>
<body>
<jsp:include page="admin_menu.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Leave Report</small></h1>
</div>
</div>
<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<form action="manager_leave_report" method="post" target="_blank">
<table>
<tr><td>From:</td><td><input type="text" id="datepicker1" name="from_date" onchange="change();" placeholder="yyyy-mm-dd"/></td></tr>
<tr><td>To:</td><td><input type="text" id="datepicker2" name="to_date" placeholder="yyyy-mm-dd"/></td></tr>
<tr><td></td><td><div style="display:none"><input type="checkbox" id="empBox" value="true" name="emp_box" checked="checked"> Generate for particular employee.</div></td></tr>
<tr><td><input type="hidden" name="particular_emp_id" value="${sessionScope.id}"></td></tr>
<tr><td></td><td><input type="submit" value="Generate"/></td></tr>
</table>
</form>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>