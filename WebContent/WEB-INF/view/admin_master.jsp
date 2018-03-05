<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!--<script type="text/javascript" src="sessionTimeOut.js"></script>-->
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
<title>Web Master</title>
<body>
<jsp:include page="../view/admin_menu.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Admin dashboard</small></h1>
</div>
</div>
<div class="row">
  <div class="col-sm-4">
    <div class="card text-center">
      <div class="card-block">
        <h3 class="card-title">Employee data</h3>
        <br/>
        <a href="new_employee">&#x27A4;Create new employee</a><br/><br/>
        <a href="employee_master">&#x27A4;Edit / Delete employee</a><br/><br/><br/>
        <a href="#"></a>
        </div>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="card text-center">
      <div class="card-block">
        <h3 class="card-title">Attendance</h3><br/>
        <a href="back_dated_attendance">&#x27A4;Mark backdated attendance</a><br/><br/>
        <a href="report">&#x27A4;Generate attendance report</a><br/><br/><br/>
        <a href="#"></a>
      </div>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="card text-center">
      <div class="card-block">
        <h3 class="card-title">Profile</h3><br/>
        <a href="change_admin_password">&#x27A4;Change admin password</a><br/><br/>
        <a href="password_reset">&#x27A4;Reset employee password</a><br/><br/><br/>
        <a href="#"></a>
      </div>
    </div>
  </div>
</div>

<br/><br/>

<div class="row">
  <div class="col-sm-4">
    <div class="card text-center">
      <div class="card-block">
        <h3 class="card-title">Approvals</h3>
        <br/>
        <a href="pending_leave_approvals">&#x27A4;Pending leave approvals</a><br/><br/>
        <a href="leaves_approved">&#x27A4;Approved leaves</a><br/><br/>
        <a href="view_admin_leave_report">&#x27A4;Leave report</a>
        </div>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="card text-center">
      <div class="card-block">
        <h3 class="card-title">Holiday</h3>
        <br/>
        <a href="holiday_master">&#x27A4;Add holiday</a><br/><br/>
        <a href="view_holidays">&#x27A4;View holidays</a><br/><br/><br/>
        <a href="#"></a>
        </div>
    </div>
  </div>
  </div>
<br/><br/>
<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>