<%@page import="com.attendance.model.Department"%>
<%@page import="com.attendance.model.LeaveSchedule"%>
<%@page import="org.hibernate.criterion.Projections"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="org.hibernate.criterion.DetachedCriteria"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.hibernate.Session,org.hibernate.SessionFactory,org.hibernate.cfg.Configuration,
    org.hibernate.query.Query,com.attendance.model.Attendance,com.attendance.model.Employee,java.util.Set,java.util.Iterator,java.util.Date,java.text.*,java.util.List" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style>
body{
	font-size:16px;
}
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
<title>Pnding requests</title>
</head>
<body>
<jsp:include page="welcome_header.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Pending Leave Approvals</small></h1>
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
	if(session.getAttribute("access").toString().equalsIgnoreCase("full"))
	{
		DetachedCriteria criteria=DetachedCriteria.forClass(LeaveSchedule.class);
		criteria.add(Restrictions.eq("approval_status", "PENDING"));
		List<LeaveSchedule> leave_list=criteria.getExecutableCriteria(hSession).list();
		if(leave_list.size()>0)
		{
			Iterator itr=leave_list.iterator();
			out.print("<table>");
			out.print("<th>Employee Name</th><th>From Date</th><th>To Date</th><th>Type</th><th>Desc</th><th>Time of request</th><th>Status</th>");
			while(itr.hasNext())
			{
				LeaveSchedule schedule=(LeaveSchedule)itr.next();
				Employee employee=(Employee)schedule.getEmployee();
				out.print("<tr><td >"+employee.getName()+"</td>");
				out.print("<td >"+schedule.getFrom_date().toString()+"</td>");
				out.print("<td>"+schedule.getTo_date().toString()+"</td>");
				out.print("<td>"+schedule.getLeave_type()+"</td>");
				out.print("<td>"+schedule.getDescription()+"</td>");
				out.print("<td>"+schedule.getTime_of_request().toString()+"</td>");
				out.print("<td>"+schedule.getApproval_status()+"</td>");
				out.print("<td><form action='admin_approval' method='post'>");
				out.print("<input type='hidden' value='"+schedule.getId()+"' name='id'>");
				out.print("<input type='submit' value='Approve'>");
				out.print("</form></td>");
				out.print("<td><form action='admin_rejection' method='post'>");
				out.print("<input type='hidden' value='"+schedule.getId()+"' name='id'>");
				out.print("<input type='submit' value='Reject'>");
				out.print("</form></td></tr>");
			}
			out.print("</table>");
		}
	}
	else if(session.getAttribute("access").toString().equalsIgnoreCase("partial"))
	{
		Boolean header=true;
		DetachedCriteria criteria=DetachedCriteria.forClass(Department.class);
		criteria.add(Restrictions.eq("department_name",session.getAttribute("department").toString()));
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
						if(!employee.getAccessLevel().getAccessLevel().equalsIgnoreCase("partial"))
						{
							Set <LeaveSchedule> leave_list=employee.getSchedule();
							if(leave_list.size()>0)
							{
								Iterator leave_itr=leave_list.iterator();
								while(leave_itr.hasNext())
								{
									LeaveSchedule schedule=(LeaveSchedule)leave_itr.next();
									if(schedule.getApproval_status().equalsIgnoreCase("pending"))
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
										out.print("<td><form action='approve' method='post'>");
										out.print("<input type='hidden' value='"+schedule.getId()+"' name='id'>");
										out.print("<input type='submit' value='Approve'>");
										out.print("</form></td>");
										out.print("<td><form action='reject' method='post'>");
										out.print("<input type='hidden' value='"+schedule.getId()+"' name='id'>");
										out.print("<input type='submit' value='Reject'>");
										out.print("</form></td></tr>");
									}
								}
							}
						}
					}
					out.print("</table>");
				}
				
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