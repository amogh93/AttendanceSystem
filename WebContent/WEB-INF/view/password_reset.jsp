<%@page import="com.attendance.model.EmployeeLogin"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.hibernate.criterion.Order"%>
<%@page import="com.attendance.model.Employee"%>
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
<title>Reset Password</title>
<style>
table {
    width: 80%;
}
td, th {
    border: 0px solid #dddddd;
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
</head>
<body>
<jsp:include page="welcome_header.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Employee password reset</small></h1>
</div>
</div>
<div align="center" style="">
<table>
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<%
try(SessionFactory sessionFactory=new Configuration().configure().buildSessionFactory();
		Session hSession=sessionFactory.openSession();)
{
	hSession.beginTransaction();
	DetachedCriteria criteria=DetachedCriteria.forClass(Employee.class);
	criteria.addOrder(Order.asc("id"));
	List emp_list=criteria.getExecutableCriteria(hSession).list();
	if(emp_list.size()>0)
	{
		out.print("<th>Employee name</th><th>Username</th><th>Last login</th>");
		Iterator emp_itr=emp_list.iterator();
		while(emp_itr.hasNext())
		{
			Employee employee=(Employee)emp_itr.next();
			EmployeeLogin login=(EmployeeLogin)employee.getEmployeeLogin();
			out.print("<tr>");
			out.print("<td>"+employee.getName()+"</td>");
			out.print("<td>"+login.getUserName()+"</td>");
			out.print("<td>"+login.getLast_login().toString()+"</td>");
			out.print("<td><form action='reset_employee_password' method='post'>");
			out.print("<input type='hidden' value='"+employee.getId()+"' name='id'>");
			out.print("<input type='submit' value='Reset'>");
			out.print("</form></td>");
			out.print("</tr>");
		}
	}
}

%>
</table>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>