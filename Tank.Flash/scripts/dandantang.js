var isGuest=false;
var isPay=false;
window["MzBrowser"]=
{
};
(function()
{
  if(MzBrowser.platform) return;
  var ua = window.navigator.userAgent;
  MzBrowser.platform = window.navigator.platform;
  MzBrowser.firefox = ua.indexOf("Firefox")>0;
  MzBrowser.opera = typeof(window.opera)=="object";
  MzBrowser.ie = !MzBrowser.opera && ua.indexOf("MSIE")>0;
  MzBrowser.mozilla = window.navigator.product == "Gecko";
  MzBrowser.netscape= window.navigator.vendor=="Netscape";
  MzBrowser.safari= ua.indexOf("Safari")>-1;
  if(MzBrowser.firefox) var re = /Firefox(\s|\/)(\d+(\.\d+)?)/;
  else if(MzBrowser.ie) var re = /MSIE( )(\d+(\.\d+)?)/;
  else if(MzBrowser.opera) var re = /Opera(\s|\/)(\d+(\.\d+)?)/;
  else if(MzBrowser.netscape) var re = /Netscape(\s|\/)(\d+(\.\d+)?)/;
  else if(MzBrowser.safari) var re = /Version(\/)(\d+(\.\d+)?)/;
  else if(MzBrowser.mozilla) var re = /rv(\:)(\d+(\.\d+)?)/;
  if("undefined"!=typeof(re)&&re.test(ua))
  MzBrowser.version = parseFloat(RegExp.$2);
}
)();
function checkScreen()
{
  s=700;
  if(MzBrowser.ie)
  {
    s=document.body.offsetHeight;
  }
  if(MzBrowser.firefox)
  {
    s=window.innerHeight;
  }
  if(MzBrowser.opera)
  {
    s=document.body.clientHeight;
  }
  if(s<630)
  {
    window.moveTo(14,14);   
    window.resizeTo(screen.width-28,screen.height-28);   
  }
  if(MzBrowser.ie)
  {
    s=document.body.offsetHeight;
  }
  if(MzBrowser.firefox)
  {
    s=window.innerHeight;
  }
  if(MzBrowser.opera)
  {
    s=document.body.clientHeight;
  }
  if (s<630)
  {
    alert('您的游戏画面显示不全，建议您使用全屏显示（按F11）');
  }
}

function addfavorite(www,name)
{
  window.external.addFavorite(www,name);
}

function askUserLeave( e )
{
	if(allowLeave==1)
	{
	}

	if(allowLeave==2||allowLeave==3)
	{
		if(!flashCall)
		{      
		 //这里是flash的Id
			var message='';
			if(dailyTask != -1 && !isGuest)
			{
			message+=dailyTask>0?'Nhiệm vụ hằng ngày còn'+dailyTask+'chưa hoàn thành\n':'Nhiệm vụ hằng ngày：Đã hoàn thành hết\n';
			message+=dailyActivity>0?'Nhiệm vụ sự kiện còn'+dailyActivity+'chưa hoàn thành\n':'Nhiệm vụ ự kiện：Đã hoàn thành hết\n';
			//message+=dailyEmail>0?'还有'+dailyEmail+'封未读邮件\n':'邮件：全部读取\n';		
			}else if ( isGuest ) {
				message="还没有注册,你确定离开吗?"	
			}
		
			var browser = navigator.appName;
			if (browser == "Netscape") {
				e.preventDefault();
				return message;
			} else {
				window.event.returnValue =message; 
			}	  
		} 
		flashCall=false;
	} 
}

function setUserID($userID) {
	//userID = $userID;
	isGuest = true;		
} 

function setUserRegisterOK() { 
	isGuest = false;
} 	

/*注册帐号*/
function user_register(groupid,userid,key){
	/* No Close Button
	var centerIframe = document.createElement("iframe");
	centerIframe.setAttribute("ID","quickregister");
	centerIframe.setAttribute("NAME","quickregister");
	centerIframe.setAttribute("frameborder","0",0);
	centerIframe.setAttribute("scrolling","no");
	centerIframe.setAttribute("width","407");
	centerIframe.setAttribute("height","402");
	centerIframe.style.position = "absolute";
	centerIframe.style.top = (document.body.clientHeight - 407) / 2 + "px";
	centerIframe.style.left = (document.body.clientWidth - 402) / 2 + "px";
	centerIframe.src = "https://id.zing.vn/quickregister/game/index.49.63.104.154." +groupid +"."+ userid+"."+ key + ".html";
	document.body.appendChild(centerIframe);
	centerIframe.setAttribute("allowtransparency","true",0);
	centerIframe.onload = function () {jQuery("#quickregister").allowtransparency=true}	*/	
	hideGame();
	var HomeDivRegister= document.createElement("div");
	HomeDivRegister.setAttribute("id","HomeDivRegister");
	HomeDivRegister.setAttribute("name","HomeDivRegister");
	HomeDivRegister.style.width = "407px";
	HomeDivRegister.style.height = "402px";
	HomeDivRegister.style.position = "absolute";
	HomeDivRegister.style.left = (jQuery(window).width() - 407) / 2 + "px";
	HomeDivRegister.style.top = (jQuery(window).height() - 402) / 2 + "px";
	
	var CloseLinkRegister = document.createElement("div");
	CloseLinkRegister.setAttribute("id","CloseLinkRegister");
	CloseLinkRegister.setAttribute("name","CloseLinkRegister");
	CloseLinkRegister.setAttribute("href","#");	
	CloseLinkRegister.style.background = "url(images/ZingRegisterClose.png) no-repeat";
	CloseLinkRegister.style.display = "block";
	CloseLinkRegister.style.width = "73px";
	CloseLinkRegister.style.height = "25px";
	CloseLinkRegister.style.float = "right";
	CloseLinkRegister.style.cursor = "hand";
	CloseLinkRegister.style.right = "5px";
	CloseLinkRegister.style.top = "-21px";
	CloseLinkRegister.style.position = "absolute"; 
	HomeDivRegister.appendChild(CloseLinkRegister);
	
	var centerIframeRegister = document.createElement("iframe");
	centerIframeRegister.setAttribute("frameBorder","0");
	centerIframeRegister.setAttribute("border","0");
	centerIframeRegister.setAttribute("marginwidth","0");
	centerIframeRegister.setAttribute("marginheight","0");
	centerIframeRegister.setAttribute("scrolling","no");
	centerIframeRegister.setAttribute("allowTransparency","true");
	centerIframeRegister.style.width = "407px";
	centerIframeRegister.style.height = "395px"; 
	centerIframeRegister.src = "https://id.zing.vn/quickregister/game/index.49.63.104.154." +groupid +"."+ userid+"."+ key + ".html"; 
	
	var centerDiv = document.createElement("div");
	centerDiv.style.width = "407px";
	centerDiv.style.height = "395px"; 
	centerDiv.appendChild(centerIframeRegister); 
	HomeDivRegister.appendChild(centerDiv);	
	document.body.appendChild(HomeDivRegister);
	
	jQuery('#CloseLinkRegister').bind('click',function(){jQuery('#HomeDivRegister').remove();});	
	jQuery('#CloseLinkRegister').bind('mouseover',function(){jQuery('#CloseLinkRegister').css("background","url(images/ZingRegisterClose_Hover.png)");});	
	jQuery('#CloseLinkRegister').bind('mouseout',function(){jQuery('#CloseLinkRegister').css("background","url(images/ZingRegisterClose.png)");});		 	
}		
/*游戏内充值*/
function user_ZingPay(ProductID,AccountName,ServerID,UserID){
	if ( isPay ) return;
	isPay = true;
	hideGame();
	var HomeDiv = document.createElement("div");
	HomeDiv.setAttribute("id","HomeDiv");
	HomeDiv.setAttribute("name","HomeDiv");
	HomeDiv.style.width = "735px";
	HomeDiv.style.height = "402px";
	HomeDiv.style.position = "absolute";
	HomeDiv.style.left = (jQuery(window).width() - 735) / 2 + "px";
	HomeDiv.style.top = (jQuery(window).height() - 402) / 2 + "px";
	
	var CloseLink = document.createElement("div");
	CloseLink.setAttribute("id","CloseLink");
	CloseLink.setAttribute("name","CloseLink");
	CloseLink.setAttribute("href","#");
	
	CloseLink.style.background = "url(images/ZingPayClose.png) no-repeat";
	CloseLink.style.display = "block";
	CloseLink.style.width = "43px";
	CloseLink.style.height = "29px";
	CloseLink.style.float = "right";
	CloseLink.style.cursor = "hand";
	CloseLink.style.right = "5px";
	CloseLink.style.position = "absolute";

	var HeadDiv = document.createElement("div");
	HeadDiv.style.width = "735px";
	HeadDiv.style.height = "32px";
	HeadDiv.style.top = "0px";
	HeadDiv.style.left = "0px";
	HeadDiv.style.textAlign = "right";
	HeadDiv.style.background = "url(images/ZingPayHead.png)";
	HeadDiv.appendChild(CloseLink);
	HomeDiv.appendChild(HeadDiv);
	
	var centerIframePay = document.createElement("iframe");
	centerIframePay.setAttribute("frameBorder","0");
	centerIframePay.setAttribute("border","0");
	centerIframePay.setAttribute("marginwidth","0");
	centerIframePay.setAttribute("marginheight","0");
	centerIframePay.setAttribute("scrolling","no");
	centerIframePay.setAttribute("allowTransparency","true");
	centerIframePay.style.width = "735px";
	centerIframePay.style.height = "370px";
	//centerIframePay.style.position = "absolute";
	centerIframePay.src = "https://quickpay.zing.vn/client/napthe.html?pid=" +ProductID +"&acc="+ AccountName+"&serid="+ ServerID+"&uin="+UserID;
	//https://quickpay.zing.vn/client/napthe.html?pid=[ProductID]&acc=[AccountName]&serid=[ServerID]
	
	var centerDiv = document.createElement("div");
	centerDiv.style.width = "735px";
	centerDiv.style.height = "370px";
	//centerDiv.style.position = "absolute";
	centerDiv.appendChild(centerIframePay); 
	HomeDiv.appendChild(centerDiv);	
	document.body.appendChild(HomeDiv);
	jQuery('#CloseLink').bind('click',function(){jQuery('#HomeDiv').remove();isPay = false});
}
function hideGame(){
	document.getElementById("gameContainer").style.height = '0px';
	//alert("hide");
	return;
}

function showGame(){
	if (isGuest) {
		jQuery('#HomeDivRegister').remove();
	}
	if (isPay) {
		jQuery('#HomeDiv').remove();
		isPay = false
	}	
	document.getElementById("gameContainer").style.height = '600px';
	//alert("show");
	return;
}
