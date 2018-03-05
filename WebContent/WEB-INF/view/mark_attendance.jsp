<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.ProjectionList"%>
<%@page import="org.hibernate.criterion.Projections"%>
<%@page import="org.hibernate.criterion.Projection"%>
<%@page import="com.attendance.model.Employee"%>
<%@page import="org.hibernate.criterion.DetachedCriteria"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.cfg.Configuration"%>
<%@page import="org.hibernate.SessionFactory"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Backdated Punch</title>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://raw.githubusercontent.com/phstc/jquery-dateFormat/master/dist/jquery-dateFormat.min.js"></script>
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
<script>
$( function() {
  $( "#datepicker" ).datepicker({
	dateFormat: "yy-mm-dd",
	maxDate:"d"
  });
  


  $('.timepicker').timepicker({
      timeFormat: 'HH:mm:ss',
      interval: 60,
      defaultTime: 'now',
      startTime: '10:00:00',
      dynamic: true,
      dropdown: true,
      scrollbar: false
  });


});
</script>
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
</head>
<body>
<%!
String current_time;
String current_date;
%>
<%
try
{
	session=request.getSession(false);
	if(session.getAttribute("id")!=null)
	{
		SimpleDateFormat sdf=new SimpleDateFormat("kk:mm:ss");
		Date date=new Date();
		current_time=sdf.format(date);
		sdf=new SimpleDateFormat("yyyy-MM-dd");
		current_date=sdf.format(date);
	}
	else
	{
		response.sendRedirect("/AttendanceSystem");
	}
}
catch(Exception e)
{
	
}
%>
<c:if test="${sessionScope.id=='Admin_0'}">
<jsp:include page="../view/admin_menu.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Backdated Marking</small></h1>
</div>
</div>
<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<form action="back_dated_attendance" method="post">
<table>
<%
try(SessionFactory factory=new Configuration().configure().buildSessionFactory();
		Session sessionH=factory.openSession())
{
	DetachedCriteria criteria=DetachedCriteria.forClass(Employee.class);
	Projection projection1 = Projections.property("id");
    Projection projection2 = Projections.property("name");
    ProjectionList pList=Projections.projectionList();
    pList.add(projection1);
    pList.add(projection2);
    criteria.setProjection(pList);
	List list=criteria.getExecutableCriteria(sessionH).list();
	out.print("<tr>");
	out.print("<td>Employee:</td>");
	out.print("<td><select name='particular_emp_id'>");
	if(list.size()>0)
	{
		Iterator itr=list.iterator();
		while(itr.hasNext())
		{
			Object[] emp_data=(Object[])itr.next();
			out.print("<option value='"+emp_data[0]+"'>"+emp_data[0]+"-"+emp_data[1]+"</option>");
		}
	}
}
out.print("</select></td>");
out.print("</tr>");
%>

<tr>
	<td>Date:</td>
	<td><input id="datepicker" type="text" name="date" value="<%=current_date%>"/></td>
</tr>
<tr>
	<td>Time:</td>
	<td><input class="timepicker" type="text" name="time" /></td>
</tr>
<tr>
	<td>Entry-type:</td>
	<td><input type="radio" name="entryType" value="inTime" checked>In-Time&nbsp;<input type="radio" name="entryType" value="outTime">Out-Time</td>
</tr>
<tr>
	<td></td>
	<td><input type="checkbox" name="override_attendance" value="true"> Override existing attendance.</td>
</tr>
</table>
<input type="submit" value="Mark"/>
</form>
</div>
</c:if>
<c:if test="${sessionScope.id!='Admin_0'}">
Forbidden!!!
</c:if>
<script src="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>