/**
 * 
 */
$( function() {
  $( "#datepicker1" ).datepicker({
	dateFormat: "yy-mm-dd"
  });
});
$( function() {
   $( "#datepicker2" ).datepicker({
   	dateFormat: "yy-mm-dd",
  });
});


function change()
{
	var myDate = $.datepicker.formatDate('yy-mm-dd', new Date($('#datepicker1').val()));
	var new_date=myDate.split('-');
    var year=new_date[0];
    var month=new_date[1];
    var day=new_date[2];
    var minDate = $( "#datepicker2" ).datepicker( "option", "minDate" );
    $( "#datepicker2" ).datepicker( "option", "minDate", new Date(year, month - 1, day) );
}
