<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css?family=Raleway" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style type="text/css">

.login_form{
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}

body{
	font-size:17px;
	font-family: 'Raleway', sans-serif;
}

td{
    border: 1px solid #dddddd;
    text-align: center;
    padding: 20px;
}

.modal-header, h4{
    background-color: #5cb85c;
    color:white !important;
    text-align: center;
    font-size: 30px;
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
<title>Login Page</title>
</head>
<body>
<%
response.setHeader("Cache-Control", "no-cache,no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
session=request.getSession(false);
try
{
	session=request.getSession(false);
	if(session.getAttribute("id")!=null)
	{
		if(session.getAttribute("access").toString().equalsIgnoreCase("full"))
		{
			response.sendRedirect("admin.action");
		}
		response.sendRedirect("welcome.action");
	}
}
catch(Exception e)
{
	
}
%>
<div class="login_form" align="center">
<div class="modal-header">
<h4><span class="glyphicon glyphicon-lock"></span> Sign-In</h4>
</div>
<form action="login" method="post">
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<table>
<tr><td><span class="glyphicon glyphicon-user"></span> Username:</td><td><input type="text" name="userId" placeholder="Username"></td></tr>
<tr><td><span class="glyphicon glyphicon-eye-open"></span> Password:</td><td><input type="password" name="password" placeholder="Password"></td></tr>
</table>
<br/>
<Button type="submit" class="btn btn-success btn-block"><span class="glyphicon glyphicon-off"></span> Login</Button>
</form>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>