<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="forgotpass.aspx.cs" Inherits="Tank.Flash.auth.forgotpass" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script src="../script/jquery.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        function href() {
            var randomnum = Math.random();
            var getimagecode = document.getElementById("ImageCode");
            getimagecode.src = "ValidateCode.aspx? " + randomnum;
        }
        function xmlhttpPost(strURL) {
            var xmlHttpReq = false;
            var self = this;
            // Mozilla/Safari
            if (window.XMLHttpRequest) {
                self.xmlHttpReq = new XMLHttpRequest();
            }
            // IE
            else if (window.ActiveXObject) {
                self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
            }
            self.xmlHttpReq.open('POST', strURL, true);
            self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            self.xmlHttpReq.onreadystatechange = function () {
                if (self.xmlHttpReq.readyState == 4) {
                    updatepage(self.xmlHttpReq.responseText);
                }
            }
            self.xmlHttpReq.send(getquerystring());
        }

        function getquerystring() {
            var form = document.forms['f1'];
            var username = form.username.value;
            var password = form.password.value;
            var repassword = form.repassword.value;
            var email = form.email.value;
            //var sex = form.sex.value;
            var code = form.code.value;
            qstr = 'username=' + escape(username)
            + '&password=' + escape(password)
            + '&repassword=' + escape(repassword)
            + '&email=' + escape(email)
            //+ '&sex=' + escape(sex)
            + '&code=' + escape(code);  // NOTE: no '?' before querystring
            return qstr;
        }

        function updatepage(str) {
            if (str == "ok") {
                //alert("Reg Success。");
                //location.replace("login.aspx")
                $("#lbError").html('<span id="lbError" style="color:Green;" >Registration Succeed!</span>');
                var form = document.forms['f1'];
                form.username.value = '';
                form.password.value = '';
                form.repassword.value = '';
                form.email.value = '';
                form.code.value = '';
                href();
            }
            else
                $("#lbError").html(str);
        }     
    </script>

    <style>		
			#errorSummary {
				text-align: center;
				font-size: 18px;
				color:green;
				padding-top: 150px;
						}
		</style>

</head>
<body style="background: url(../images/forgot.png) no-repeat scroll 0pt 0pt transparent;">
    <div id="errorSummary" >
      Đang tải, vui lòng chờ trong giây lát!
	  <br/><br/>
	  <img alt=""  src="../images/loading.gif" />
     </div>       		
</body>
</html>
