<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Order"%>
<%@page import="com.attendance.model.HolidayMaster"%>
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
<title>View Holidays</title>
<style type="text/css">
table {
    width: 60%;
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
<jsp:include page="admin_menu.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>View holidays</small></h1>
</div>
</div>
<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<table>
<%
try(SessionFactory factory=new Configuration().configure().buildSessionFactory();
		Session hSession=factory.openSession())
{
	hSession.beginTransaction();
	DetachedCriteria criteria=DetachedCriteria.forClass(HolidayMaster.class);
	criteria.addOrder(Order.asc("date"));
	List holiday_list=criteria.getExecutableCriteria(hSession).list();
	if(holiday_list.size()>0)
	{
		out.print("<th>Holiday</th><th>Date</th><th>Type</th>");
		Iterator holiday_itr=holiday_list.iterator();
		while(holiday_itr.hasNext())
		{
			HolidayMaster holidayMaster=(HolidayMaster)holiday_itr.next();
			out.print("<tr>");
			out.print("<td>"+holidayMaster.getDescription()+"</td>");
			out.print("<td>"+holidayMaster.getDate().toString()+"</td>");
			out.print("<td>"+holidayMaster.getType()+"</td>");
			if(session.getAttribute("access").toString().equalsIgnoreCase("full"))
			{
				out.print("<td><form action='remove_holiday' method='post'>");
				out.print("<input type='hidden' value='"+holidayMaster.getId()+"' name='id'>");
				out.print("<input type='submit' value='Remove'>");
				out.print("</form></td>");
			}
			out.print("</tr>");
		}
	}
	else
	{
		out.print("<center>No records to fetch.</center>");
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