<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
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
<link rel="stylesheet" href="AppStyle.css">
<script>
$(document).ready(function() 
{
	$("#datepicker1").datepicker();
});
$(document).ready(function() 
{
	$("#datepicker2").datepicker();
});
</script>
<title>Leave Application</title>
</head>
<body>
<jsp:include page="../view/welcome_header.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Leave application</small></h1>
</div>
</div>
<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<form action="leave_request" method="post">
<table>
<tr><td>From date*:</td><td><input type="text" id="datepicker1" onchange="change();" name="from_date" placeholder="yyyy-mm-dd"></td></tr>
<tr><td>To date*:</td><td><input type="text" id="datepicker2" name="to_date" placeholder="yyyy-mm-dd"></td></tr>
<tr><td>Leave type*:</td>
<td>
<select name="leave_type">
<option value="none">---Select---</option>
<option value="cl">CL</option>
<option value="pl">PL</option>
<option value="sl">SL</option>
</select>
</td></tr>
<tr><td>Description*:</td><td><input type="text" name="description" placeholder="short description"></td></tr>
<tr><td></td><td><input type="submit" value="Submit"></td></tr>
</table>
</form>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>