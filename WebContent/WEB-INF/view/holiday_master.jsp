<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add Holiday</title>
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
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script>
$( function() {
	  $( "#datepicker1" ).datepicker({
		dateFormat: "yy-mm-dd"
	  });
	});
</script>
</head>
<body>
<jsp:include page="admin_menu.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<h1><small>Add holiday</small></h1>
</div>
</div>

<div align="center">
<s:if test="hasActionMessages()"><s:actionmessage style="color:green;"/></s:if>
<s:fielderror name="errorField" style="color:red;"></s:fielderror>
<form action="add_holiday" method="post">
<strong>Please fill the following details</strong><br/><br/>
<table>
<tr><td>Date*:</td><td><input type="text" id="datepicker1" name="holiday_date" placeholder="yyyy-mm-dd"/></td></tr>
<tr><td>Description*:</td><td><input type="text" name="holiday_description" placeholder="short description"/></td></tr>
<tr><td>Type*:</td><td>
<select name="holiday_type">
<option value="none">---Select---</option>
<option value="PUBLIC_HOLIDAY">PUBLIC HOLIDAY</option>
<option value="STATE_HOLIDAY">STATE HOLIDAY</option>
<option value="NATIONAL_HOLIDAY">NATIONAL HOLIDAY</option>
</select>
</td></tr>
<tr><td></td><td><input type="submit" value="Add"/></td></tr>
</table>
</form>
</div>

<div class="footer">
<center>© Copyright 2017. Saraswat Infotech Ltd</center>
</div>
</body>
</html>