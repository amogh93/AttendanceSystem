/**
 * 
 */
$(document).ready(function(){
    $('.update_button').attr('disabled',true);
    
    $('#emp_name').keyup(function(){
        if($(this).val().length !=0){
            $('.update_button').attr('disabled', false);
        }
        else
        {
            $('.update_button').attr('disabled', true);        
        }
    })
    
    $('#emp_mail').keyup(function(){
        if($(this).val().length !=0){
            $('.update_button').attr('disabled', false);
        }
        else
        {
            $('.update_button').attr('disabled', true);        
        }
    })
    
    $('#emp_mobile').keyup(function(){
        if($(this).val().length !=0){
            $('.update_button').attr('disabled', false);
        }
        else
        {
            $('.update_button').attr('disabled', true);        
        }
    })
    
    $('#emp_access_level').keyup(function(){
        if($(this).val().length !=0){
            $('.update_button').attr('disabled', false);
        }
        else
        {
            $('.update_button').attr('disabled', true);        
        }
    })
});