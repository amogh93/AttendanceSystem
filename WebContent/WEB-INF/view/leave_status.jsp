<%@page import="java.util.Date"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="com.attendance.model.LeaveSchedule"%>
<%@page import="com.attendance.model.Employee"%>
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
<title>Leave Status</title>
<style>
table {
    width: 100%;
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
<h1><small>Leave status</small></h1>
</div>
</div>
<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<%
try(SessionFactory sessionFactory=new Configuration().configure().buildSessionFactory();
		Session hSession=sessionFactory.openSession();)
{
	hSession.beginTransaction();
	Employee e=(Employee)hSession.get(Employee.class, session.getAttribute("id").toString());
	Set <LeaveSchedule> schedule=e.getSchedule();
	if(schedule.size()>0)
	{
		out.print("<table>");
		out.print("<th>Employee Name</th><th>From Date</th><th>To Date</th><th>Type</th><th>Desc</th><th>Time of request</th><th>Status</th>");
		Iterator itr=schedule.iterator();
		while(itr.hasNext())
		{
			LeaveSchedule leaveSchedule=(LeaveSchedule)itr.next();
			out.print("<tr><td >"+e.getName()+"</td>");
			out.print("<td >"+leaveSchedule.getFrom_date().toString()+"</td>");
			out.print("<td>"+leaveSchedule.getTo_date().toString()+"</td>");
			out.print("<td>"+leaveSchedule.getLeave_type()+"</td>");
			out.print("<td>"+leaveSchedule.getDescription()+"</td>");
			out.print("<td>"+leaveSchedule.getTime_of_request().toString()+"</td>");
			if(leaveSchedule.getApproval_status().equalsIgnoreCase("pending"))
			{
				out.print("<td>"+leaveSchedule.getApproval_status()+"</td></tr>");
			}
			else if(leaveSchedule.getApproval_status().equalsIgnoreCase("cancelled"))
			{
				out.print("<td>"+leaveSchedule.getApproval_status()+" BY "+leaveSchedule.getApproved_by()+" ON "+leaveSchedule.getTime_of_approval().toString()+"</td></tr>");
			}
			else if(leaveSchedule.getApproval_status().equalsIgnoreCase("rejected"))
			{
				out.print("<td>"+leaveSchedule.getApproval_status()+" BY "+leaveSchedule.getApproved_by()+" ON "+leaveSchedule.getTime_of_approval().toString()+"</td></tr>");
			}
			else
			{
				out.print("<td>"+leaveSchedule.getApproval_status()+" BY "+leaveSchedule.getApproved_by()+" ON "+leaveSchedule.getTime_of_approval().toString()+"</td>");
				if(leaveSchedule.getFrom_date().compareTo(new Date())>0)
				{
					out.print("<td><form action='cancel_leave' method='post'>");
					out.print("<input type='hidden' value='"+leaveSchedule.getId()+"' name='id'>");
					out.print("<input type='submit' value='Cancel'>");
					out.print("</form></td>");
				}
				out.print("</tr>");
			}
		}
	}
}
%>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>