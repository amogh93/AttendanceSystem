<%@page import="java.util.Set"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="com.attendance.model.Department"%>
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
<h1><small>View Employee Attendance</small></h1>
</div>
</div>
<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<form action="generate" target="_blank">
<table>
<tr><td>From:</td><td><input type="text" id="datepicker1" name="from_date" onchange="change();" placeholder="yyyy-mm-dd"/></td></tr>
<tr><td>To:</td><td><input type="text" id="datepicker2" name="to_date" placeholder="yyyy-mm-dd"/></td></tr>
<tr><td>Type:</td><td><input type="radio" name="report_type" value="summarized" checked="checked">Summarized&nbsp;<input type="radio" name="report_type" value="detailed">Detailed</td></tr>
<tr><td></td><td><input type="checkbox" id="empBox" value="true" name="emp_box" onchange="enableSelect();"> Generate for particular employee.</td></tr>
<%
try(SessionFactory factory=new Configuration().configure().buildSessionFactory();
		Session sessionH=factory.openSession())
{
	DetachedCriteria criteria=DetachedCriteria.forClass(Department.class);
	criteria.add(Restrictions.eq("department_name", session.getAttribute("department").toString()));
	List list=criteria.getExecutableCriteria(sessionH).list();
	
	out.print("<tr>");
	out.print("<td>Employee:</td>");
	out.print("<td><select id='emp_select' name='particular_emp_id' disabled='disabled'>");
	if(list.size()>0)
	{
		Iterator itr=list.iterator();
		while(itr.hasNext())
		{
			Department dept=(Department)itr.next();
			Set<Employee> emp_set=dept.getEmployee();
			if(emp_set.size()>0)
			{
				Iterator emp_itr=emp_set.iterator();
				while(emp_itr.hasNext())
				{
					Employee emp=(Employee)emp_itr.next();
					if(!emp.getId().equalsIgnoreCase(session.getAttribute("id").toString()))
					{
						out.print("<option value='"+emp.getId()+"'>"+emp.getId()+"-"+emp.getName()+"</option>");
					}
					
				}
			}
			
		}
	}
}
out.print("</select></td>");
out.print("</tr>");
%>
<tr><td></td><td><input type="submit" value="Generate"/></td></tr>
</table>
</form>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>