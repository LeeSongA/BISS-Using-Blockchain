/*
* 혈액 등록 버튼 클릭시 호출 1
*/
function registBlood()
{
	var type = document.getElementById("bloodtype").value;
	if(type =="") alert("Please enter type");
	else{
		type = parseInt(type) - 10;
		$.get("/registBlood?bloodType="+type, function(data){
			if(data=="Error") $("#message").text("An error occured.");
			else $("#message").html("Transaction hash : "+data);
		});
	}
}

/*
* my 혈액 메뉴 또는 전체 혈액 메뉴에서 혈액 클릭시 호출 1
*/
function getInfo(index) 
{
	var datas = "bloodinfo"+index.toString();
	var settings = 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, width=1200, height=500';
	window.open("/getInfo?index="+index+"&datas="+datas,"title" ,settings);
}

/*
* my 혈액 메뉴에서 검사1 버튼 클릭시 호출 1
*/
function check1(owner)
{
	var testdata = new ArrayBuffer(1);
	var result = Math.floor(Math.random() * 100); //0~99 랜덤 값
	
	testdata = 0x00;
	if(result > 80){
		result = Math.floor(Math.random() * 127)+1;
		testdata = testdata + result;
	}	
	alert("검사결과 : ",testdata);

	$.get("/check1?result="+testdata+"&index="+owner, function(data){
		if(data!="Error") alert("test successed");
		else alert("test failed!");
	});
}

/*
* my 혈액 메뉴에서 검사2 버튼 클릭시 호출 1
*/
function checkAlt(owner) //4~36이 정상
{
	var testdata = Math.floor(Math.random() * 32)+4;
	var result = Math.floor(Math.random() * 100); //0~99 랜덤 값
	
	if(result > 80){
		result = Math.floor(Math.random() * 50)+5;
		testdata = testdata + result;
	}	
	alert("검사결과 : ",testdata);

	$.get("/checkAlt?result="+testdata+"&index="+owner, function(data){
		if(data!="Error") alert("test successed");
		else alert("test failed!");
	});
}

/*
* my 혈액 메뉴에서 검사3 버튼 클릭시 호출 1
*/
function checkProtein(owner) //6~8이 정상 (결과 값으로는 2~15로 설정)
{
	var testdata;
	var result = Math.floor(Math.random() * 100); //0~99 랜덤 값
	
	if(result<80) testdata = Math.floor(Math.random() * 3)+6;
	else if(result<90) testdata += Math.floor(Math.random()*7)+1;
	else testdata =Math.floor(Math.random()*4)+2;
	alert("검사결과 : ",testdata);

	$.get("/checkProtein?result="+testdata+"&index="+owner, function(data){
		if(data!="Error") alert("test successed");
		else alert("test failed!");
	});
}

/*
* my 혈액 메뉴에서 이동 등록 버튼 클릭시 호출 1
*/
function sendBlood(bloodId,receiver)
{
	$.get("/sendBlood?newAgency="+receiver+"&index="+bloodId, function(data){
		if(data =="Error") hash="An error occured..";
		else hash="Transaction hash : "+data;
	});
}

/*
* my 혈액 메뉴에서 수혈자 등록 버튼 클릭시 호출 1
*/
function setReceiver()
{
	var bloodId = document.getElementById("bloodId").value;
	var receiver = document.getElementById("receiver").value;
	
	$.get("/setReceiver?receiver="+receiver+"&index="+bloodId, function(data){
		if(data=="Error") alert("An error occured..");
		else alert("Transaction hash : "+ data);
	});
}

/*
* my 혈액 메뉴에서 폐기 버튼 클릭시 호출 1
*/
function discard(bloodid)
{
	$.get("/discard?index="+bloodid, function(data){
		if(data=="Error") alert("error ! "); 
		else alert("discard successed");
	});
}
