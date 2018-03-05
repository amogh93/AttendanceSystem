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
<title>Change Password</title>
</head>
<body>
<jsp:include page="../view/welcome_header.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Change Password</small></h1>
</div>
</div>
<div align="center">
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<form action="update_password" method="post">
<table>
<tr><td>Existing password:</td><td><input type="password" name="current_password"></td></tr>
<tr><td>New password:</td><td><input type="password" name="new_password"></td></tr>
<tr><td>Re-enter password:</td><td><input type="password" name="re_entered_password"></td></tr>
</table>
<input type="submit" value="Change"/>
</form>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>