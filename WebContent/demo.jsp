<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<link href="https://fonts.googleapis.com/css?family=Raleway" rel="stylesheet">

<script type="text/javascript">
function showData(str) {
	  var xhttp;    
	  if (str == "") {
	    document.getElementById("datalist").innerHTML = "";
	    return;
	  }
	  xhttp = new XMLHttpRequest();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	      document.getElementById("datalist").innerHTML = this.responseText;
	    }
	  };
	  xhttp.open("GET", "getData?q="+str, true);
	  xhttp.send();
	}
</script>
</head>
<body>
<div class="container-fluid">
	<div class="row content">
		<div class="col-md-12 col-xs-6 col-sm-6">
			<form>
				<input type="text" id="query" onkeyup="showData();">
				<button>Search</button>
			</form>
		</div>
	</div>
</div>
</body>
</html>