<%@page import="org.hibernate.criterion.Projections"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="org.hibernate.criterion.DetachedCriteria"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.hibernate.Session,org.hibernate.SessionFactory,org.hibernate.cfg.Configuration,
    org.hibernate.query.Query,com.attendance.model.Attendance,com.attendance.model.Employee,java.util.Set,java.util.Iterator,java.util.Date,java.text.*,java.util.List" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style>
table {
    width: 70%;
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
<title>View Attendance</title>
</head>
<body>
<jsp:include page="welcome_header.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Attendance Logs</small></h1>
</div>
</div>
<div align="center">
<%
try(SessionFactory sessionFactory=new Configuration().configure().buildSessionFactory();
		Session hSession=sessionFactory.openSession();)
{
	hSession.beginTransaction();
	String hql="from Attendance where employee_id=:emp_id order by id desc";
	Query query=hSession.createQuery(hql);
	query.setParameter("emp_id", session.getAttribute("id").toString());
	List result=query.getResultList();
	Iterator itr=result.iterator();
	Attendance attendance;
	out.print("<table>");
	out.print("<th>Date</th><th>In-Time</th><th>Mode</th><th>Out-time</th><th>Mode</th>");
	while(itr.hasNext())
	{
		attendance=(Attendance)itr.next();
		out.print("<tr><td >"+attendance.getDate()+"</td>");
		out.print("<td>"+attendance.getIn_time()+"</td>");
		out.print("<td>"+attendance.getIn_logging_mode()+"</td>");
		out.print("<td>"+attendance.getOut_time()+"</td>");
		out.print("<td>"+attendance.getOut_logging_mode()+"</td></tr>");
	}
	out.print("</table>");
}
%>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>