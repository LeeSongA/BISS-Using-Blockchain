$(document).ready(function() {
	checkMobile();
	$('#div_logoHolder').animate({top: $(window).height()/2-100},1000);
	setTimeout(function(){ 
		$('#div_logoHolder img').css('cursor','pointer');
		aniHeart();
		$('#div_logoHolder img').click(function() {
			$('#div_logoHolder img').stop();
			$('#div_logoHolder').css('width',$(window).width());
			$('#div_logoHolder').css('height',$(window).height());
			$('#div_logoHolder img').animate({width: 100, margin: 200}, 1000, function(){
		$('#div_logoHolder img').animate({margin: 0, opacity: 1},1000);
		$('#div_logoHolder').animate({width: 100, height: 100, left: -20, top: -15, margin: 0},1000, function(){
			$('#div_logoHolder').animate({left: $(window).width() -20},1000);
			$('body').animate({left: -$(window).width()},1000, function(){$(location).attr('href','main');});
		});
			});
		});
	}, 3000);
	

	$("#canvas").attr("width", $(window).width()).attr("height", $(window).height());
	drawCircles();
	
});

function checkMobile(){
	var filter = "win16|win32|win64|mac";
	if(navigator.platform){
		if(filter.indexOf(navigator.platform.toLowerCase())<0)
			location.href="mobile";
	}

}
		
function aniHeart(){	
	$('#div_logoHolder img').animate({width: 450, margin: -25, opacity: 0.5},1500,function(){
		$('#div_logoHolder img').animate({width: 380, margin: 10, opacity: 1},1500,function(){
			aniHeart();
		});	
	});
}

function drawCircles(){
	var canvas = $("#canvas");
	clearCanvas();
	for(var i=0;i<20;i++)
		draw();
	canvas.animate({opacity: 1},2000,function(){
		canvas.animate({opacity: 0},2000, function(){drawCircles();});		
	});
}

function clearCanvas(){
	var canvas = document.getElementById("canvas");
	if (canvas.getContext) {
    		var ctx = canvas.getContext('2d');
 		ctx.clearRect(0, 0, canvas.width, canvas.height);
	}
}

function draw(){
	var r = Math.random()*100;
	var a = Math.random()/10;
	var x = Math.random()*$(window).width();
	var y = Math.random()*$(window).height();
	var canvas = document.getElementById("canvas");
	if (canvas.getContext) {
    		var ctx = canvas.getContext('2d');
 		ctx.beginPath();
            	ctx.arc(x, y, r, 0,(Math.PI/180) *360,false);
            	ctx.fillStyle = "rgba(255, 255, 255, "+a+")";
          	ctx.fill();
	}
}