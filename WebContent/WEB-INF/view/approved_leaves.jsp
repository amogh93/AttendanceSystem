<%@page import="java.util.Date"%>
<%@page import="org.hibernate.criterion.Order"%>
<%@page import="org.hibernate.criterion.Projections"%>
<%@page import="com.attendance.model.LeaveSchedule"%>
<%@page import="com.attendance.model.Employee"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="com.attendance.model.Department"%>
<%@page import="org.hibernate.criterion.DetachedCriteria"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.cfg.Configuration"%>
<%@page import="org.hibernate.SessionFactory"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Approved Leaves</title>
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
<%
if(session.getAttribute("access").toString().equalsIgnoreCase("partial"))
{
	out.print("<div class='jumbotron text-center'>");
	out.print("<div class='container'>");
	out.print("<h1><small>Leaves approved by you</small></h1>");
	out.print("</div></div>");
}
else if(session.getAttribute("access").toString().equalsIgnoreCase("full"))
{
	out.print("<div class='jumbotron text-center'>");
	out.print("<div class='container'>");
	out.print("<h1><small>Approved leaves</small></h1>");
	out.print("</div></div>");
}
%>
<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<%
try(SessionFactory sessionFactory=new Configuration().configure().buildSessionFactory();
		Session hSession=sessionFactory.openSession();)
{
	boolean header=true;
	hSession.beginTransaction();
	if(session.getAttribute("access").toString().equalsIgnoreCase("partial"))
	{
		DetachedCriteria criteria=DetachedCriteria.forClass(Department.class);
		criteria.add(Restrictions.eq("department_name", session.getAttribute("department").toString()));
		List<Department> dept_list=criteria.getExecutableCriteria(hSession).list();
		if(dept_list.size()>0)
		{
			Iterator itr=dept_list.iterator();
			while(itr.hasNext())
			{
				Department department=(Department)itr.next();
				Set <Employee> emp_set=department.getEmployee();
				if(emp_set.size()>0)
				{
					Iterator emp_itr=emp_set.iterator();
					while(emp_itr.hasNext())
					{
						Employee employee=(Employee)emp_itr.next();
						Set <LeaveSchedule> leave_list=employee.getSchedule();
						if(leave_list.size()>0)
						{
							Iterator leave_itr=leave_list.iterator();
							while(leave_itr.hasNext())
							{
								LeaveSchedule schedule=(LeaveSchedule)leave_itr.next();
								if(schedule.getApproval_status().equalsIgnoreCase("approved") && schedule.getApproved_by().equalsIgnoreCase(session.getAttribute("empName").toString()))
								{
									if(header)
									{
										out.print("<table>");
										out.print("<th>Employee Name</th><th>Department</th><th>From Date</th><th>To Date</th><th>Type</th><th>Desc</th><th>Time of request</th><th>Status</th>");
										header=false;
									}
									out.print("<tr><td >"+employee.getName()+"</td>");
									out.print("<td >"+department.getDepartment_name()+"</td>");
									out.print("<td >"+schedule.getFrom_date().toString()+"</td>");
									out.print("<td>"+schedule.getTo_date().toString()+"</td>");
									out.print("<td>"+schedule.getLeave_type()+"</td>");
									out.print("<td>"+schedule.getDescription()+"</td>");
									out.print("<td>"+schedule.getTime_of_request().toString()+"</td>");
									out.print("<td>"+schedule.getApproval_status()+"</td>");
									if(schedule.getFrom_date().compareTo(new Date())>0)
									{
										out.print("<td><form action='admin_cancel_leave' method='post'>");
										out.print("<input type='hidden' value='"+schedule.getId()+"' name='id'>");
										out.print("<input type='submit' value='Cancel'>");
										out.print("</form></td>");
									}
									out.print("</tr>");
								}
							}
						}
					}
					out.print("</table>");
				}
			}
		}
	}
	
	else if(session.getAttribute("access").toString().equalsIgnoreCase("full"))
	{
		DetachedCriteria criteria=DetachedCriteria.forClass(Employee.class);
		criteria.addOrder(Order.asc("id"));
		List<Employee> empl=criteria.getExecutableCriteria(hSession).list();
		if(empl.size()>0)
		{
			Iterator emp_itr=empl.iterator();
			while(emp_itr.hasNext())
			{
				Employee employee=(Employee)emp_itr.next();
				Set<LeaveSchedule> leave_set=employee.getSchedule();
				if(leave_set.size()>0)
				{
					Iterator leave_itr=leave_set.iterator();
					while(leave_itr.hasNext())
					{
						LeaveSchedule schedule=(LeaveSchedule)leave_itr.next();
						if(schedule.getApproval_status().equalsIgnoreCase("approved"))
						{
							if(header)
							{
								out.print("<table>");
								out.print("<th>Employee Name</th><th>Department</th><th>From Date</th><th>To Date</th><th>Type</th><th>Desc</th><th>Time of request</th><th>Status</th>");
								header=false;
							}
							out.print("<tr><td >"+employee.getName()+"</td>");
							out.print("<td >"+employee.getDepartment().getDepartment_name()+"</td>");
							out.print("<td >"+schedule.getFrom_date().toString()+"</td>");
							out.print("<td>"+schedule.getTo_date().toString()+"</td>");
							out.print("<td>"+schedule.getLeave_type()+"</td>");
							out.print("<td>"+schedule.getDescription()+"</td>");
							out.print("<td>"+schedule.getTime_of_request().toString()+"</td>");
							out.print("<td>"+schedule.getApproval_status()+" BY "+schedule.getApproved_by()+" ON "+schedule.getTime_of_approval().toString()+"</td>");
							if(schedule.getFrom_date().compareTo(new Date())>0)
							{
								out.print("<td><form action='admin_cancel_leave' method='post'>");
								out.print("<input type='hidden' value='"+schedule.getId()+"' name='id'>");
								out.print("<input type='submit' value='Cancel'>");
								out.print("</form></td>");
							}
							out.print("</tr>");
						}
					}
				}
			}
			out.print("</table>");
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