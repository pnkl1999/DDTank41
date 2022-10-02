<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="AdminGunny.Admin.test" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" >
    //some function here
    function loading_All_Data() {
        //start function
        var msgbox = $("#<%=ShowAllItem.ClientID%>");
        //show loading....
        msgbox.html("<img style='margin: 250px 0px 0px 370px; ' src='../Images/uber-loading.gif'/>");
        //request data
        var $j = jQuery;
        $j.ajax({
            type: "POST",
            url: "Item.aspx/Load_AllItem",
            data: "{}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (message) {
                //show data
                msgbox.html(message.d);
            },
            error: function (errormessage) {
                //show error
                msgbox.html(errormessage.responseText);
            }

        });
        //end function  
    }
    function loading_Data(CategoryID) {
        //start function
        var msgbox = $("#<%=ShowAllItem.ClientID%>");
        //show loading....
        msgbox.html("<img style='margin: 100px 0px 0px 400px; ' src='../Images/uber-loading.gif'/>");
        //request data
        var $j = jQuery;
        $j.ajax({
            type: "POST",
            url: "Item.aspx/Show_SingleCategory",
            data: "{CategoryID:" + CategoryID + "}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (message) {
                //show data
                msgbox.html(message.d);
            },
            error: function (errormessage) {
                //show error
                msgbox.html(errormessage.responseText);
            }

        });
        //end function  
    }
</script>
    
    <style type="text/css">
        .style1444
        {
           
            width: 505px;
            height: 390px;
        }
        .style1445
        {
            position: absolute;
            width: 505px;
            height: 390px;
            margin-left: 0px;
            margin-top: 0px;
            padding-top: 0px;
        }
        
        #DivImage
        {
            background: url('../Images/default.png');
            background-position: center;
            position: absolute;
            top: 40px;
            left: 3px;
            height: 105px;
            width: 105px;
            text-align: center;
            vertical-align: middle;
            padding-top: 4px;
            padding-right: 5px;
            padding-left: 1px;
            background-repeat: no-repeat;
        }
       #DivContainer
        {
            background: #15222E;
            position: absolute;
            width: 220px;
            height: 163px;
            border: 1px #000000 solid;
        }
        #DivTitle
        {
            background: #FFFFFF;
            border-left: 1px #000000 solid;
            border-right: 1px #000000 solid;
            border-top: 1px #000000 solid;
            border-bottom: 1px #000000 solid;
            position: absolute;
            height: 22px;
            width: 218px;
            text-align: center;
            vertical-align: middle;
            margin-top: 5px;
            padding-top: 4px;
            left: 0px;
            top: 2px;
            font-size: 18px;
            font-family: "Times New Roman", Times, serif;
        }
        #DivBody
        {
            background: #FFFFFF;
            border-left: 1px #000000 solid;
            border-right: 1px #000000 solid;
            border-top: 1px #000000 solid;
            border-bottom: 1px #000000 solid;
            position: absolute;
            height: 141px;
            width: 218px;
            text-align: center;
            vertical-align: middle;
            margin-top: 5px;
            padding-top: 5px;
            left: 0px;
            top: 3px;
        }
        #ImgIcon
        {
            
            position: relative;
            left: 2px;
            top: 6px;
        }
        #DivAdd 
        {
            height: 25px;
            width: 95px;
            position: absolute;
            cursor: pointer;
            top: 43px;
            left: 116px;
            text-align: center;
            padding-top: 7px;
            background: url(../Images/bg3.jpg) repeat 0 0;
            background-position: 0px 0px;
        }
        #DivDelete 
        {
            height: 25px;
            width: 95px;
            position: absolute;
            cursor: pointer;
            top: 78px;
            left: 116px;
            text-align: center;
            padding-top: 7px;
            background: url(../Images/bg3.jpg) repeat 0 0;
            background-position: 0px 0px;
        }
        #DivEdit 
        {
            height: 25px;
            width: 95px;
            position: absolute;
            cursor: pointer;
            top: 113px;
            left: 116px;
            text-align: center;
            padding-top: 7px;
            background: url(../Images/bg3.jpg) repeat 0 0;
            background-position: 0px 0px;
        }
        /*begin div_ripresource*/
        .lb_rip
        {
            width: 79px;
            height: 30px;
            color: #FFFFFF;
        }
        .tb_main
        {
            width: 186px;
            height: 70px;
        }
        .bt_Maxcount
        {
            width: 50px;
            text-align: center;
        }
                
        .div_ripresource
        {
            padding: 5px;
            border: medium #F9F9F9 double;
            width: 189px;
            height: 151px;
            background-color: #006699;
        }
        
        .lb_Maxcount
        {
            height: 30px;
            text-align: center;
            width: 9px;
        }
        .lb_item
        {
            height: 30px;
            text-align: center;
            color: #FFFFFF;
        }
        
        .lb_SelectSource
        {
            height: 30px;
            text-align: center;
        }
        .SelectSource
        {
            width: 88px;
        }
        
        .lb_TimeRip
        {
            text-align: left;
            color: #FFFFFF;
        }
        .lb_ButtonRS
        {
            text-align:center;
        }
        /*end div_ripresource*/
    </style>
    <script language="javascript" type="text/javascript">
        function callBackRipRes() {
            // 1. Make request to server
            var currentCount = parseInt($("#currentCount").val());
            var maxCount = parseInt($("#maxCount").val());
            var urlrip = $("#SelectSource option:selected").val();
            var msgbox = $("#result");
            $("#timerip").html(Math.round(((maxCount - currentCount) / 60)) + " phút");
            if (currentCount < maxCount) {
               
                var $j = jQuery;
                $j.ajax({
                    type: "POST",
                    url: "RipResource.ashx/ProcessRequest",
                    data: "{urlrip:'" + urlrip + "',countUp:" + currentCount + "}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (message) {
                        msgbox.html(message.d);
                        $("#currentCount").val(currentCount + 1);
                       

                    },
                    error: function (errormessage) {
                        msgbox.html(errormessage.responseText);
                    }

                });
            }
            else {
                msgbox.html("Rip xong hình ảnh của: " + $("#maxCount").val() + " item!");
                clear_Interval();
            }
        }
        
        function getMaxCount() {
            // 1. Make request to server
            var $j = jQuery;
            $j.ajax({
                type: "POST",
                url: "RipResource.ashx/returnMaxCount",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (message) {
                    $("#maxCount").val(message.d);
                    set_Interval();
                },
                error: function (errormessage) {
                    msgbox.html(errormessage.responseText);
                }

            });
        }

        function set_Interval() {
            interval = setInterval(callBackRipRes, 1000);
            $("#Bt_rip").attr('disabled', 'disabled');
            $("#Bt_rip").val("Rip Images");
            $("#Bt_stop").removeAttr("disabled");
        }

        function clear_Interval() {
            clearInterval(interval);
            $("#Bt_stop").attr('disabled', 'disabled');
            $("#Bt_rip").val("Tiếp tục");
            $("#Bt_rip").removeAttr("disabled");
        }

        function clearForm() {
            $("#currentCount").val("0");
            $("#maxCount").val("0");
            $("#Bt_rip").val("Rip Images");
            $("#result").html("");
            $("#timerip").html("");

        }

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <table style="width:100%;">

        <tr >
            <td class="style11">
                &nbsp;</td>
            <td class="style12" >
                 
                </td>
        </tr>
        <tr>
            <td class="style11" valign="top" align="left">
            
         <asp:Label ID="ShowLoadMenu" runat="server" Text="" />
              </td>
            <td class="style12"  valign="top" align="left">
                
                <div id="div_ripresource" class="div_ripresource">
                <table id="tb_main" class="tb_main">
                    <tr>
                        <td class="lb_rip">
                            Nguồn Rip:</td>
                        <td class="lb_SelectSource" colspan="2">
                            <select onchange="clearForm();" id="SelectSource" class="SelectSource" name="D1">
                                <option value="http://127.0.0.1/Resource/">VNG</option>
                                <option value="http://rescdn.ddt.game.yy.com/">China</option>
                            </select></td>
                    </tr>
                    <tr>
                        <td class="lb_rip">
                            Tổng cộng:</td>
                        <td class="lb_Maxcount">
                            <input disabled="disabled" id="maxCount" class="bt_Maxcount" value="0" type="text" /></td>
                        <td class="lb_item">
                            Items</td>
                    </tr>
                    <tr>
                        <td class="lb_rip">
                            Rip xong:</td>
                        <td class="lb_Maxcount">
                            <input disabled="disabled" id="currentCount" class="bt_Maxcount" value="0" type="text" /></td>
                        <td class="lb_item">
                            Items</td>
                    </tr>
                    <tr>
                        <td class="lb_TimeRip" colspan="3">
                            Thời gian rip: <span id="timerip"></span></td>
                    </tr>
                    <tr>
                        <td class="lb_ButtonRS" colspan="3">
                            <input id="Bt_rip" onclick="getMaxCount();" type="button" value="Rip Images" />&nbsp;
                            <input disabled="disabled" id="Bt_stop" onclick="clear_Interval();" type="button" 
                                value="Stop" /></td>
                    </tr>
                </table>
                 <div id="result"></div>
                </div>
                

               

                <asp:Label ID="ShowAllItem" runat="server" Text="" />
                <br />
                
            </td>
        </tr>
        
    </table>

 
    <br />
    <script type="text/javascript">        new Sys.WebForms.Menu({ element: 'NavigationMenu2', disappearAfter: 500, orientation: 'vertical', tabIndex: 0, disabled: false });</script>
    
    <div class="style1444">
    <div class="style1445">

    <script type="text/javascript">
        $('#DivContainer').corner("keep");
        $('#ImgIcon').corner("keep");
        $('#DivAdd').corner("keep");
        $('#DivDelete').corner("keep");
        $('#DivEdit').corner("keep");
    </script>
        <table style="width:100%;">
            <tr>
                <td colspan="2">
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>

    </div>
    </div>
    <script type="text/javascript">

        $(function () {

            $('#DivAdd')
		.css({ backgroundPosition: "0 0" })
		.mouseover(function () {
            $(this).stop().animate({ backgroundPosition: "(0 -250px)" }, { duration: 500 })
		})
		.mouseout(function () {
		    $(this).stop().animate({ backgroundPosition: "(0 0)" }, { duration: 500 })
		})
		$('#DivDelete')
		.css({ backgroundPosition: "0 0" })
		.mouseover(function () {
		    $(this).stop().animate({ backgroundPosition: "(0 -250px)" }, { duration: 500 })
		})
		.mouseout(function () {
		    $(this).stop().animate({ backgroundPosition: "(0 0)" }, { duration: 500 })
		})
		$('#DivEdit')
		.css({ backgroundPosition: "0 0" })
		.mouseover(function () {
		    $(this).stop().animate({ backgroundPosition: "(0 -250px)" }, { duration: 500 })
		})
		.mouseout(function () {
		    $(this).stop().animate({ backgroundPosition: "(0 0)" }, { duration: 500 })
		})
            
        });
</script>
</asp:Content>
