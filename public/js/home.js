var string_name = "B.U.B";
var int_index = 0;
var timer_type = null;

$(document).ready(function() {
   $('#div_home').click(function(){
      location.href = "main";
   });
   setTimeout(function(){ 
      $("#img_login").parent().attr("href", "javascript:login();");
      $("#img_logout").parent().attr("href", "javascript:logout();");
      $("#div_registAuth").parent().attr("href", "javascript:sendRegAuth();");
      $("#div_shortcutList a:nth-of-type(2)").attr("href", "https://github.com/LeeSongA/Project");
      $("#div_shortcutList a:nth-of-type(2)").attr("target", "_blank");
      $("#div_contents").css("height", $(window).height()-$("#div_menu").height()-10);
      for(var i=1;i<=5;i++)
         $("#div_menuList a:nth-of-type("+i+")").attr("href", "javascript:selectMenu("+i+");");
      typeString();
   }, 3000);
});
function typeString(){ 
   $('#div_hello span:nth-of-type(2)').html(string_name.substring(0, int_index) + "_");
   int_index++;
   timer_type = setTimeout('typeString()', 100);

   if(string_name.length < int_index){
      $('#div_hello span:nth-of-type(2)').html(string_name);
      clearTimeout(timer_type);
   }
}
function hideMain(number){
   $("#div_background img").css("display","none");
   $("#div_hello").css("display","none");
   $("#div_contents").css("display","block");
   $("#div_menuList a").css("color", "#fff");
   $("#div_menuList a:nth-of-type("+number+")").css("color", "#ffff00");
}
function login(){
   $('#div_login').css('display','block');
   $('#div_mask').css('display','block');
}
function logout(){
   location.href = "main?id=out";
}
function join(){
   $('#div_join').css('display','block');
}
function close(i){
   if(i == 1){
      $('#div_mask').css('display','none');
      $('#div_login').css('display','none');
   }
   else{
      $('#div_join').css('display','none');
   }
}
function checkLogin(){
   if($('#ID').val() == "")
      alert('Check your ID!');
   else{
      if($('#PWD').val() == "") alert('Check your PASSWORD!');
      else{
		 $.post("login?id="+$('#ID').val()+"&pwd="+$('#PWD').val(), function(data) { 
            alert(data);
            if(data.indexOf("Welcome") > -1){
               window.location.reload();
               close(1);
            }
         });
      }
   }
}
function sendRegAuth(){
   if($('#div_join input:nth-of-type(1)').val()=='') alert('Check your Account!');
   else if($('#div_join center:nth-of-type(2) input').val()=='') alert('Check your PASSWORD!');
   else{
		$.post("registAuth?id="+$('#div_join input:nth-of-type(1)').val()+"&pwd="+$('#div_join center:nth-of-type(2) input').val()+"&hid="+$(':input[name=HID]:radio:checked').val(), function(data) { 
                
		alert(data);
         if(data.indexOf("OK") > -1)
            close(2);
      });
   }
}