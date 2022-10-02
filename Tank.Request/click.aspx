<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="click.aspx.cs" Inherits="Count.click" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server"> 
<script language="javascript">
<!--
 var Begin_time=new Date();
 function leave() 
 { 
    var url=location.search;
    var Request = new Object();
    if(url.indexOf("?")!=-1)
    {
      var str = url.substr(1)  //去掉?号
      strs = str.split("&");
      for(var i=0;i<strs.length;i++)
      {
          Request[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);
      }
    }    
    var App_Id=Request["App_Id"];
    var Direct_Url=Request["Direct_Url"];
    var Referr_Url=Request["Referr_Url"];
    var End_time=new Date();
    var Span_Time=End_time-Begin_time;
    var x=screen.width;
    var y=screen.height;
    
    var v = navigator.appName;//浏览器
    var c=null;
    if(v != "Netscape")//颜色深度 
      { 
        c = screen.colorDepth; 
      }
    else 
      { 
        c = screen.pixelDepth; 
      }
    var flash=_uFlash();
    click.Logoff(App_Id,Direct_Url,Referr_Url,Span_Time/1000,x,y,c,flash).value; 
 }
   function _uFlash() 
  {
    var f = "-", n = navigator;
    if (n.plugins && n.plugins.length) 
    {
      for (var ii = 0; ii < n.plugins.length; ii++) 
      {
        if (n.plugins[ii].name.indexOf('Shockwave Flash') != -1) 
        {
          f = n.plugins[ii].description.split('Shockwave Flash ')[1];
          break;
        }
      }
    }
    else if (window.ActiveXObject) 
    {
       for (var ii = 10; ii >= 2; ii--) {
       try
       {
          var fl = eval("new ActiveXObject('ShockwaveFlash.ShockwaveFlash." + ii + "');");
          if (fl) 
          {
             f = ii + '.0';
             break;
          }
       } 
       catch (e) 
       {
       }    
    }
  }
  return f;
  }
 </script>
</head>
<body  onunload="leave()"> 
    <form id="form1" runat="server"> 
    </form>
</body>
</html>
