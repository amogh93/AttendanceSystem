<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style type="text/css">

.vertical-center {
  min-height: 84vh; /* These two lines are counted as one :-)       */
  display: flex;
  align-items: center;
}
table{
	width:80%;
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
.card{
	border:1px solid rgba(0,0,0,.125);
	border-radius:.50rem;
	
}
</style>
<title>AttendanceSystem Home</title>
</head>
<body>
<jsp:include page="../view/welcome_header.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<!--  <h1><small>Welcome, ${sessionScope.empName}</small></h1>-->
<h1><small>Employee dashboard</small></h1>
</div>
</div>

<div class="row">
  <div class="col-sm-4">
    <div class="card text-center">
      <div class="card-block">
        <h3 class="card-title">Leaves</h3>
        <br/>
        <a href="apply_leave" >&#x27A4;Apply for leaves</a><br/><br/>
        <a href="leave_status" >&#x27A4;Check leave status</a><br/><br/>
        <a href="check_leave_count" >&#x27A4;Check remaining leaves</a>
      </div>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="card text-center">
      <div class="card-block">
        <h3 class="card-title">Attendance</h3><br/>
        <a href="attendance_logging">&#x27A4;Mark attendance</a><br/><br/>
        <a href="view_attendance">&#x27A4;View attendance</a><br/><br/>
        <%
		if(session.getAttribute("access").toString().equalsIgnoreCase("partial"))
		{
        	out.print("<a href='view_dept_attendance'>&#x27A4;View Employee Attendance</a>");
		}
		else
		{
			out.print("<br/>");
			out.print("<a href='#'></a>");
		}
        %>
      </div>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="card text-center">
      <div class="card-block">
        <h3 class="card-title">Profile</h3><br/>
        <a href="employee_profile">&#x27A4;Edit profile</a><br/><br/><br/><br/><br/>
      </div>
    </div>
  </div>
</div>

<br/><br/>

<div class="row">
  <div class="col-sm-4">
    <div class="card text-center">
      <div class="card-block">
        <h3 class="card-title">Holidays</h3>
        <br/>
        <a href="view_holidays">&#x27A4;View holidays</a><br/><br/><br/><br/><br/>
      </div>
    </div>
  </div>
  

<%
if(session.getAttribute("access").toString().equalsIgnoreCase("partial"))
{
	out.print("<div class='col-sm-4'>");
	out.print("<div class='card text-center'>");
	out.print("<div class='card-block'>");
	out.print("<h3 class='card-title'>Approvals</h3>");
	out.print("<br/>");
	out.print("<a href='pending_leave_approvals' >&#x27A4;Pending leave requests</a><br/><br/>");
	out.print("<a href='leaves_approved' >&#x27A4;Leaves approved by you</a><br/><br/>");
	out.print("<a href='view_manager_leave_report'>&#x27A4;Employee leave report</a>");
	out.print("</div></div></div>");
}

	out.print("<div class='col-sm-4'>");
	out.print("<div class='card text-center'>");
	out.print("<div class='card-block'>");
	out.print("<h3 class='card-title'>Leave report</h3>");
	out.print("<br/>");
	out.print("<a href='view_employee_leave_report'>&#x27A4;Your leave report</a>");
	out.print("</a><br/><br/><br/><br/><br/>");
	out.print("</div></div></div>");

%>
</div>

<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>