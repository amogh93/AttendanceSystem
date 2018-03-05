<%@page import="com.attendance.model.Employee"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.cfg.Configuration"%>
<%@page import="org.hibernate.SessionFactory"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<style>
@import url(https://fonts.googleapis.com/css?family=Lato:700);
*,
*:before,
*:after {
  box-sizing: border-box;
}
html,
body {
  background: #ecf0f1;
  color: #444;
  font-family: 'Lato', Tahoma, Geneva, sans-serif;
  font-size: 16px;
}
.set-size {
  font-size: 7em;
}
.charts-container:after {
  clear: both;
  content: "";
  display: table;
}
.pie-wrapper {
  height: 1em;
  width: 1em;
  float: left;
  margin: 15px;
  position: relative;
}
.pie-wrapper:nth-child(3n+1) {
  clear: both;
}
.pie-wrapper .pie {
  height: 100%;
  width: 100%;
  clip: rect(0, 1em, 1em, 0.5em);
  left: 0;
  position: absolute;
  top: 0;
}
.pie-wrapper .pie .half-circle {
  height: 100%;
  width: 100%;
  border: 0.1em solid #3498db;
  border-radius: 50%;
  clip: rect(0, 0.5em, 1em, 0);
  left: 0;
  position: absolute;
  top: 0;
}
.pie-wrapper .label {
  background: #34495e;
  border-radius: 50%;
  bottom: 0.4em;
  color: #ecf0f1;
  cursor: default;
  display: block;
  font-size: 0.25em;
  left: 0.4em;
  line-height: 2.6em;
  position: absolute;
  right: 0.4em;
  text-align: center;
  top: 0.4em;
}
.pie-wrapper .label .smaller {
  color: #bdc3c7;
  font-size: .45em;
  padding-bottom: 20px;
  vertical-align: super;
}
.pie-wrapper .shadow {
  height: 100%;
  width: 100%;
  border: 0.1em solid #bdc3c7;
  border-radius: 50%;
}
.pie-wrapper.style-2 .label {
  background: none;
  color: #7f8c8d;
}
.pie-wrapper.style-2 .label .smaller {
  color: #bdc3c7;
}
.pie-wrapper.progress-30 .pie .right-side {
  display: none;
}
.pie-wrapper.progress-30 .pie .half-circle {
  border-color: #3498db;
}
.pie-wrapper.progress-30 .pie .left-side {
  -webkit-transform: rotate(108deg);
          transform: rotate(108deg);
}
.pie-wrapper.progress-60 .pie {
  clip: rect(auto, auto, auto, auto);
}
.pie-wrapper.progress-60 .pie .right-side {
  -webkit-transform: rotate(180deg);
          transform: rotate(180deg);
}
.pie-wrapper.progress-60 .pie .half-circle {
  border-color: #9b59b6;
}
.pie-wrapper.progress-60 .pie .left-side {
  -webkit-transform: rotate(216deg);
          transform: rotate(216deg);
}
.pie-wrapper.progress-90 .pie {
  clip: rect(auto, auto, auto, auto);
}
.pie-wrapper.progress-90 .pie .right-side {
  -webkit-transform: rotate(180deg);
          transform: rotate(180deg);
}
.pie-wrapper.progress-90 .pie .half-circle {
  border-color: #e67e22;
}
.pie-wrapper.progress-90 .pie .left-side {
  -webkit-transform: rotate(324deg);
          transform: rotate(324deg);
}
.pie-wrapper.progress-45 .pie .right-side {
  display: none;
}
.pie-wrapper.progress-45 .pie .half-circle {
  border-color: #1abc9c;
}
.pie-wrapper.progress-45 .pie .left-side {
  -webkit-transform: rotate(162deg);
          transform: rotate(162deg);
}
.pie-wrapper.progress-75 .pie {
  clip: rect(auto, auto, auto, auto);
}
.pie-wrapper.progress-75 .pie .right-side {
  -webkit-transform: rotate(180deg);
          transform: rotate(180deg);
}
.pie-wrapper.progress-75 .pie .half-circle {
  border-color: #8e44ad;
}
.pie-wrapper.progress-75 .pie .left-side {
  -webkit-transform: rotate(270deg);
          transform: rotate(270deg);
}
.pie-wrapper.progress-95 .pie {
  clip: rect(auto, auto, auto, auto);
}
.pie-wrapper.progress-95 .pie .right-side {
  -webkit-transform: rotate(180deg);
          transform: rotate(180deg);
}
.pie-wrapper.progress-95 .pie .half-circle {
  border-color: #e74c3c;
}
.pie-wrapper.progress-95 .pie .left-side {
  -webkit-transform: rotate(342deg);
          transform: rotate(342deg);
}

.pie-wrapper.progress-100 .pie {
  clip: rect(auto, auto, auto, auto);
}
.pie-wrapper.progress-100 .pie .right-side {
  -webkit-transform: rotate(180deg);
          transform: rotate(180deg);
}
.pie-wrapper.progress-100 .pie .half-circle {
  border-color: #e74c3c;
}
.pie-wrapper.progress-100 .pie .left-side {
  -webkit-transform: rotate(360deg);
          transform: rotate(360deg);
}
.pie-wrapper--solid {
  border-radius: 50%;
  overflow: hidden;
}
.pie-wrapper--solid:before {
  border-radius: 0 100% 100% 0%;
  content: '';
  display: block;
  height: 100%;
  margin-left: 50%;
  -webkit-transform-origin: left;
          transform-origin: left;
}
.pie-wrapper--solid .label {
  background: transparent;
}
.pie-wrapper--solid.progress-65 {
  background: -webkit-linear-gradient(left, #e67e22 50%, #34495e 50%);
  background: linear-gradient(to right, #e67e22 50%, #34495e 50%);
}
.pie-wrapper--solid.progress-65:before {
  background: #e67e22;
  -webkit-transform: rotate(126deg);
          transform: rotate(126deg);
}
.pie-wrapper--solid.progress-25 {
  background: -webkit-linear-gradient(left, #9b59b6 50%, #34495e 50%);
  background: linear-gradient(to right, #9b59b6 50%, #34495e 50%);
}
.pie-wrapper--solid.progress-25:before {
  background: #34495e;
  -webkit-transform: rotate(-270deg);
          transform: rotate(-270deg);
}
.pie-wrapper--solid.progress-88 {
  background: -webkit-linear-gradient(left, #3498db 50%, #34495e 50%);
  background: linear-gradient(to right, #3498db 50%, #34495e 50%);
}
.pie-wrapper--solid.progress-88:before {
  background: #3498db;
  -webkit-transform: rotate(43.2deg);
          transform: rotate(43.2deg);
}
table {
    width: 60%;
    margin-left:330px;
    
}
td, th {
    border: 0px solid #dddddd;
    padding:8px;
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
<title>Remaining Leaves</title>
</head>
<body>
<jsp:include page="../view/welcome_header.jsp"></jsp:include>
<div class="jumbotron text-center">
<div class="container">
<!--  <h1><small>Welcome, ${sessionScope.empName}</small></h1>-->
<h1><small>Leave status</small></h1>
</div>
</div>
<%!
long cl=0;
long pl=0;
long sl=0;
%>
<%
try(SessionFactory factory=new Configuration().configure().buildSessionFactory();
		Session hSession=factory.openSession())
{
	Employee employee=(Employee)hSession.load(Employee.class, session.getAttribute("id").toString());
	cl=employee.getLeave_count().getCl_count();
	pl=employee.getLeave_count().getPl_count();
	sl=employee.getLeave_count().getSl_count();
}
%>
<div class="set-size charts-container">
<table>
<th>CL</th><th>PL</th><th>SL</th>
<% 
out.print("<tr><td>");
if(cl==14)
{
	out.print("<div class='pie-wrapper progress-100'>");
	out.print("<span class='label'>"+cl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(cl<14 && cl>=12)
{
	out.print("<div class='pie-wrapper progress-90'>");
	out.print("<span class='label'>"+cl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(cl<=11 && cl>=8)
{
	out.print("<div class='pie-wrapper progress-75'>");
	out.print("<span class='label'>"+cl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(cl<=7 && cl>=5)
{
	out.print("<div class='pie-wrapper progress-45'>");
	out.print("<span class='label'>"+cl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(cl<=4 && cl>=2)
{
	out.print("<div class='pie-wrapper progress-30'>");
	out.print("<span class='label'>"+cl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else
{
	out.print("<div class='pie-wrapper progress-50'>");
	out.print("<span class='label'>"+cl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
out.print("</td>");
%>

<% 
out.print("<td>");
if(pl==40)
{
	out.print("<div class='pie-wrapper progress-100'>");
	out.print("<span class='label'>"+pl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(pl<40 && pl>=35)
{
	out.print("<div class='pie-wrapper progress-90'>");
	out.print("<span class='label'>"+pl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(pl<=34 && pl>=25)
{
	out.print("<div class='pie-wrapper progress-75'>");
	out.print("<span class='label'>"+pl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(pl<=24 && pl>=15)
{
	out.print("<div class='pie-wrapper progress-65'>");
	out.print("<span class='label'>"+pl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(pl<=14 && pl>=8)
{
	out.print("<div class='pie-wrapper progress-45'>");
	out.print("<span class='label'>"+pl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(pl<=7 && pl>=4)
{
	out.print("<div class='pie-wrapper progress-30'>");
	out.print("<span class='label'>"+pl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(pl<=3 && pl>=1)
{
	out.print("<div class='pie-wrapper progress-25'>");
	out.print("<span class='label'>"+pl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else
{
	out.print("<div class='pie-wrapper progress-50'>");
	out.print("<span class='label'>"+pl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
out.print("</td>");
%>
<% 
out.print("<td>");
if(sl==25)
{
	out.print("<div class='pie-wrapper progress-100'>");
	out.print("<span class='label'>"+sl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(sl<25 && sl>=22)
{
	out.print("<div class='pie-wrapper progress-90'>");
	out.print("<span class='label'>"+sl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(sl<=21 && sl>=18)
{
	out.print("<div class='pie-wrapper progress-75'>");
	out.print("<span class='label'>"+sl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(sl<=17 && sl>=13)
{
	out.print("<div class='pie-wrapper progress-65'>");
	out.print("<span class='label'>"+sl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(sl<=12 && sl>=8)
{
	out.print("<div class='pie-wrapper progress-45'>");
	out.print("<span class='label'>"+pl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(sl<=7 && sl>=4)
{
	out.print("<div class='pie-wrapper progress-30'>");
	out.print("<span class='label'>"+sl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else if(sl<=3 && sl>=1)
{
	out.print("<div class='pie-wrapper progress-25'>");
	out.print("<span class='label'>"+sl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
else
{
	out.print("<div class='pie-wrapper progress-50'>");
	out.print("<span class='label'>"+sl+"<span class='smaller'></span></span>");
	out.print("<div class='pie'>");
	out.print("<div class='left-side half-circle'></div>");
	out.print("<div class='right-side half-circle'></div>");
	out.print("</div></div>");
}
out.print("</td></tr>");
%>
</div>
</table>

</body>
</html>