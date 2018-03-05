<%@page import="com.attendance.model.Department"%>
<%@page import="org.hibernate.criterion.Projections"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.cfg.Configuration"%>
<%@page import="org.hibernate.SessionFactory"%>
<%@page import="com.attendance.model.Employee"%>
<%@page import="org.hibernate.criterion.Restrictions"%>
<%@page import="org.hibernate.criterion.DetachedCriteria"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style type="text/css">
table{
	width:70%;
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
<title>Employee master</title>
</head>
<body>
<jsp:include page="admin_menu.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Add employee</small></h1>
</div>
</div>
<div>
<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<%
try(SessionFactory factory=new Configuration().configure().buildSessionFactory();
		Session session2=factory.openSession())
{
	DetachedCriteria criteria=DetachedCriteria.forClass(Employee.class);
	List emp_list=criteria.getExecutableCriteria(session2).list();
	if(emp_list.size() > 0)
	{
		out.print("<table>");
		out.print("<th>Name</th><th>E-mail ID</th><th>Contact No.</th><th>Department</th>");
		Iterator emp_itr=emp_list.iterator();
		while(emp_itr.hasNext())
		{
			Employee e=(Employee)emp_itr.next();
			out.print("<form action='delete_employee'>");
			
			out.print("<input type='hidden' value='"+e.getId()+"' name='emp_id'/>");
			out.print("<tr>");
			out.print("<td>"+e.getName()+"</td>");
			out.print("<td>"+e.getEmail()+"</td>");
			out.print("<td>"+e.getContactNumber()+"</td>");
			out.print("<td>"+e.getDepartment().getDepartment_name()+"</td>");
			out.print("<td><input type='submit' value='Delete'/></td>");
			out.print("<td><button type='button' data-toggle='modal' data-target='#"+e.getId()+"'>Edit</button></td>");
			out.print("</tr>");
			out.print("</form>");
			
			//modal
			out.print("<div class='modal fade' id='"+e.getId()+"' role='dialog'>");
		    out.print("<div class='modal-dialog modal-lg'>");
			out.print("<div class='modal-content'>");
			out.print("<div class='modal-header'>");
	        out.print("<button type='button' class='close' data-dismiss='modal'>&times;</button>");
	        out.print("<h4 class='modal-title'>Edit Employee</h4>");
	        out.print("</div>");
	        out.print("<div class='modal-body'>");
			
	        out.print("<form action='edit_employee' method='post'>");
	        //out.print("<script src='ValidateTextField.js'></script>");
	        
	        out.print("<div class='form-group' align='left'>");
            out.print("<input type='hidden' class='form-control' name='employee_id' id='employee_id' value='"+e.getId()+"'>");
          	out.print("</div>");
	        
	        out.print("<div class='form-group' align='left'>");
            out.print("Name:<input type='text' class='form-control' name='emp_name' id='emp_name' value='"+e.getName()+"'>");
          	out.print("</div>");
          	
          	out.print("<div class='form-group' align='left'>");
            out.print("Mobile number:<input type='text' class='form-control' name='emp_mobile' id='emp_mobile' value='"+e.getContactNumber()+"'>");
          	out.print("</div>");
          	
          	out.print("<div class='form-group' align='left'>");
            out.print("Email:<input type='text' class='form-control' name='emp_mail' id='emp_mail' value='"+e.getEmail()+"'>");
          	out.print("</div>");
          	
          	out.print("<div class='form-group' align='left'>");
            out.print("Department:<select class='form-control' name='emp_department' id='emp_dapartment' value='"+e.getDepartment().getDepartment_name()+"'>");
            
            DetachedCriteria criteria2=DetachedCriteria.forClass(Department.class);
        	List dept=criteria2.getExecutableCriteria(session2).list();
        	Iterator dept_itr=dept.iterator();
        	while(dept_itr.hasNext())
        	{
        		Department department=(Department)dept_itr.next();
        		out.print("<option value='"+department.getDepartment_name()+"'>"+department.getDepartment_name()+"</option>");
        	}
        	out.print("</select>");
            out.print("</div>");
          	
          	out.print("<div class='form-group' align='left'>");
            out.print("Access level: <small>(RESTRICTED, PARTIAL, FULL)</small><input type='text' class='form-control' name='emp_access_level' id='emp_access_level' value='"+e.getAccessLevel().getAccessLevel()+"'>");
          	out.print("</div>");
          	
          	out.print("<input type='submit' class='update_button' value='Update'/>");
          	
	        out.print("</form>");
	        
			out.print("</div>");
	        out.print("<div class='modal-footer'>");
	        out.print("<button type='button' class='btn btn-default' data-dismiss='modal'>Close</button>");
	        out.print("</div></div></div></div>");
		}
		out.print("</table>");
	}
}
%>
</div>
</div>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>