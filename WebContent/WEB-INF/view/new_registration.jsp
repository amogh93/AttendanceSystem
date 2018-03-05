<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.attendance.model.Department"%>
<%@page import="org.hibernate.criterion.DetachedCriteria"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.cfg.Configuration"%>
<%@page import="org.hibernate.SessionFactory"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style type="text/css">
span.errorMessage{
color:red;
}

body{
font-size:16px;
font-family:Segoe UI;
}

td{
    text-align: left;
    padding: 8px;
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
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://raw.githubusercontent.com/phstc/jquery-dateFormat/master/dist/jquery-dateFormat.min.js"></script>
<script src="Datepicker.js"></script>
<link href="https://fonts.googleapis.com/css?family=Raleway" rel="stylesheet">
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
<title>Employee Registration</title>
</head>
<body>
<jsp:include page="../view/admin_menu.jsp"></jsp:include>
<div class="jumbotron vertical-center text-center">
<div class="container">
<h1><small>New employee registration</small></h1>
</div>
</div>
<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<strong>Please fill the following details</strong>
<br/><br/>
<form action="register_employee" method="post">
<table>
<tr><td>Employee ID*</td><td><input type="text" name="id"></td></tr>
<tr><td>Name*:</td><td><input type="text" name="name"></td></tr>
<tr><td>Gender*:</td>
<td>
<input type="radio" name="gender" value="m" checked>Male
<input type="radio" name="gender" value="f">Female
</td></tr>
<tr><td>Date of Birth*:</td><td><input type="text" name="date_of_birth" id="datepicker1"></td></tr>
<tr><td>Contact Number*:</td><td><input type="text" name="contact"></td></tr>
<tr><td>Email ID*:</td><td><input type="text" name="email"></td></tr>
<tr><td>Joining Date*:</td><td><input type="text" name="joining_date" id="datepicker2" ></td></tr>
<tr><td>Department*:</td><td>
<select name="department">
<option value="NA">---Select---</option>
<%
try(SessionFactory factory=new Configuration().configure().buildSessionFactory();
		Session hSession=factory.openSession())
{
	DetachedCriteria criteria=DetachedCriteria.forClass(Department.class);
	List al=criteria.getExecutableCriteria(hSession).list();
	Iterator itr=al.iterator();
	while(itr.hasNext())
	{
		Department dept=(Department)itr.next();
		out.print("<option value='"+dept.getDepartment_name()+"'>"+dept.getDepartment_name()+"</option>");
	}
}
%>
</select>
</td></tr>
<tr><td>Employee type*:</td><td>
<select name="employee_type">
<option value="NA">---Select---</option>
<option value="permanent">PERMANENT</option>
<option value="probationary">PROBATIONARY</option>
</select>
</td></tr>
<tr><td>Username*:</td><td><input type="text" name="user_id" ></td></tr>
<tr><td>Password*:</td><td><input type="password" name="password"></td></tr>
<tr><td></td><td><input type="submit" value="Register"></td></tr>
<tr><td></td><td></td></tr>
</table>
</form>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>