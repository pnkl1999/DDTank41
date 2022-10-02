<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Tank.Flash.index" %>

<html>
<head>
<title>弹弹堂</title>
<script type="text/jscript">
     function killErrors() //杀掉所有的出错信息
  { 
	return true; 
  } 
  window.onerror = killErrors; 
</script>
<script type="text/javascript">
<!--
	window.onbeforeunload = function(){
	window.event.returnValue = '当前操作将退出弹弹堂游戏，是否继续？';
}
// -->
</script>
<script type="text/javascript" src="scripts/rightClick.js"></script>
<style>
body{
	margin:0px auto;
	padding:0px;
	background-image:url(images/bg.jpg);
}
</style>
</head>
<body scroll="no">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="middle"><table border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center">         
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" name="Main"  width="1008" height="608" align="middle" id="Main">
      <param name="allowScriptAccess" value="always" />
      <param name="movie" value='Loading.swf' />
      <param name="quality" value="high" />
      <param name="menu" value="false">
      <param name="bgcolor" value="#000000" />
      <embed src='Loading.swf' width="1008" height="608" align="middle" quality="high" name="Main" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
    </object>
        </td>
      </tr>
    </table></td>
  </tr>
</table>
<Script language="javascript" src="http://192.168.0.4:828/default.aspx?App_Id=1"></Script>
</body>
</html>
