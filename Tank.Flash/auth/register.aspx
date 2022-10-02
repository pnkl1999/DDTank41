<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="Tank.Flash.auth._register" %>

<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <title>Đăng ký tài khoản</title>
    <script src="../script/jquery-1.7.2.min.js" type="text/javascript"></script>    
    <script type="text/javascript">
        function href() {
            var randomnum = Math.random();
            var getimagecode = document.getElementById("ImageCode");
            getimagecode.src = "validatecode.ashx? " + randomnum;
        }
        function IsEmail(email) {
            var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            if (!regex.test(email)) {
                return false;
            } else {
                return true;
            }
        }
        
        function checkForm() {
            var err = 0;            
            if ($("#username").val() == '') {
                $("#lbError").html('Vui lòng nhập tên tài khoản!');
                err++;
            }  
            else if ($("#password").val() == '') {
                $("#lbError").html('Vui lòng nhập mật khẩu!');
                err++;
            }  
            else if ($("#repassword").val() == '') {
                $("#lbError").html('Vui lòng nhập xác nhận mật khẩu!');
                err++;
            }
            else if ($("#repassword").val() != $("#password").val()) {
                $("#lbError").html('Mật khuẩu không trùng nhau!');
                err++;
            }
            else if ($("#email").val() == '') {
                $("#lbError").html('Vui lòng nhập Email!');
               err++;
            }
            else if (!IsEmail($("#email").val())) {
                $("#lbError").html('Email không hợp lệ!');
                err++;
            }
            else if ($("#code").val() == '') {
                $("#lbError").html('Vui lòng nhập mã bảo mật!');
                err++;
            }
            if (err == 0)
                xmlhttpPost();

            return false;
        }
        function xmlhttpPost() {
            //$("#titleTag").html('<img alt="" id="loading_img" src="images/loading.gif" />');
            $.ajax({
                type: 'GET',
                url: 'register.ashx',
                data: getquerystring(),
                success: function (data_revert) {
                    updatepage(data_revert);
                }
            });
        }

        function getquerystring() {
            var username = $("#username").val();
            var password = $("#password").val();
            var repassword = $("#repassword").val();
            var email = $("#email").val();
            var code = $("#code").val();
            qstr = 'username=' + escape(username) + '&password=' + escape(password)
            + '&repassword=' + escape(repassword) + '&email=' + escape(email)
            + '&code=' + escape(code);
            return qstr;
        }

        function updatepage(str) {
            if (str == "ok") {
                $("#lbError").html('<span style="color:Green;" >Đăng ký không thành công!</span>');
                $("#username").val('');
                $("#password").val('');
                $("#repassword").val('');
                $("#email").val('');
                $("#code").val('');
                href();
            }
            else
                $("#lbError").html(str);
        }     
    </script>

    <style type="text/css">
        .style1
        {
            text-align: center;
        }
        .style3
        {
            text-align: right;
            height: 71px;
            width: 161px;
        }
        .style4
        {
            text-align: left;
            height: 71px;
        }
        .style5
        {
            text-align: center;
            height: 40px;
        }
        .w0
        {
            width: 60px;
        }
        .user_input
        {
            width: 150px;
        }
        .style8
        {
            text-align: right;
            height: 30px;
            width: 161px;
        }
        .style9
        {
            text-align: left;
            height: 30px;
        }
        #ReLoad{height:23px;width:25px;background:url(../images/iconRe.gif) no-repeat;text-indent:-9999px;display:block;overflow:hidden;}

        .style10
        {
            width: 127px;
        }

        .style11
        {
            text-align: right;
            height: 40px;
            width: 161px;
        }
        .style12
        {
            text-align: left;
            height: 40px;
        }
        
        #Select1
        {
            width: 54px;
        }
        #gende
        {
            width: 54px;
        }
        
        .top
        {
            width: 372px;
        }
        
        .auto-style1
        {
            color: #808080;
        }
        .auto-style2
        {
            text-align: right;
            height: 30px;
            width: 161px;
            font-size: 14px;
            font-weight: bold;
            color: #808080;
        }
        
    </style>

</head>
<body style="background: url(../images/popup.png) no-repeat scroll 0pt 0pt transparent;">
    <form name="f1" id="f1">
   
   <table style="width: 100%;">
                                    <tr>
                                        <td class="style3">
                                        </td>
                                        <td class="style4">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="style1" colspan="2">
                                           <div class="top">
                             <span id="lbError" style="color:Red;" ></span><br />
                            </div>
                            </td>
                                    </tr>
                                    <tr>
                                        <td class="style8">
                                           <span  style="font-size: 14px; font-weight: bold;" class="auto-style1">Tài khoản：</span>
                                        </td>
                                        <td class="style9">
                                          <input type="text" class="user_input" placeholder="Username" name="username" id="username"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="style8">
                                           <span  style="font-size: 14px; font-weight: bold;" class="auto-style1">Mật khẩu：</span>
                                        </td>
                                        <td class="style9">
                                          <input type="password" class="user_input" placeholder="Password" name="password" id="password"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style2">
                                            Xác nhận mật khẩu：</td>
                                        <td class="style9">
                                           <input type="password" class="user_input" placeholder="Confirm password" name="repassword" id="repassword"/></td>
                                    </tr>
                                    <tr>
                                        <td class="style8">
                                           <span  style="font-size: 14px; font-weight: bold;" class="auto-style1">Email：</span>
                                        </td>
                                        <td class="style9">
                                           <input type="text" class="user_input" placeholder="Your email" name="email" id="email"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="style8">
                                            <span  style="font-size: 14px; font-weight: bold;" class="auto-style1">Mã bảo vệ:&nbsp;</span><span  style="font-size: 14px; color: #F60; font-weight: bold;">&nbsp;&nbsp; </span>
                                            </td>
                                        <td class="style9">
                                             <table style="width: 27%;">
                                                 <tr>
                                                     <td class="style10">
                                                         <img id="ImageCode" src="validatecode.ashx" height="32" width ="127" alt="" />                                                         
                                  </td>
                                                     <td>
                                                        <a id="ReLoad" title="" href="javascript:href()" style="font-size: 12px; color: blue">Tải lại</a> </td>
                                                 </tr>
                                             </table>
                                             </td>
                                    </tr>
                                    <tr>
                                        <td class="style11">
                                           <span  style="font-size: 14px; font-weight: bold;" class="auto-style1">Nhập mã bảo vệ：</span>
                                           </td>
                                        <td class="style12">
                                         <input type="text" class="user_input" name="code" placeholder="Code" id="code" size="4" style="width: 150px" />&nbsp; 
                                         
                                         <span  style="font-size: 14px; color: #F60; font-weight: bold;">
                                         
                                            </td>
                                    </tr>
                                    <tr>
                                        <td class="style5" colspan="2">
                                            <!--
                                             type="button" type="submit"
                                             -->
                                            <input type="submit" value="Đăng ký"
                                                onclick="return checkForm();" 
                                                style="width: 100px; height: 30px; color: #808080; font-weight: bold; font-size: large; cursor: pointer" />
                              
                              </td>
                                    </tr>
                                </table>
    </form>
   
</body>
</html>
