<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Welcome header</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="sessionTimeOut.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://raw.githubusercontent.com/phstc/jquery-dateFormat/master/dist/jquery-dateFormat.min.js"></script>
<script src="Datepicker.js"></script>
<link href="https://fonts.googleapis.com/css?family=Raleway" rel="stylesheet">
<link rel="stylesheet" href="AppStyle.css">
</head>

<body>
<nav class="navbar navbar-default">
<div class="navbar-header"><img src="SIL logo.jpg"></div>
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="/AttendanceSystem">&nbspAttendanceSystem</a>
    </div>
    
    <ul class="nav navbar-nav navbar-right">
      <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href=""><span class="glyphicon glyphicon-user"></span>&nbsp;${sessionScope.empName}&nbsp;<span></span><span class="caret"></span></a>
      <ul class="dropdown-menu">
          <li><a href="change_password">Change password</a></li>
          <li><a href="logout.do">Logout</a></li>
          </ul>
      </li>
      </ul>
  </div>
</nav>
<div align="right">Dept [ ${sessionScope.department} ]</div>

</body>
</html>