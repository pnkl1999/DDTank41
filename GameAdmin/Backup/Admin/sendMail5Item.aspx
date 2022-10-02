<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="sendMail5Item.aspx.cs" Inherits="AdminGunny.Admin.sendMail5Item" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        
        .style1445
        {
            min-height: 271px;
            
        }
        .style1448
        {
            background: #C4C4C4;
            text-align: center;
            height: 25px;
            width: 895px;
        }
        .style1450
        {
             display:none;
        }
        .style1451
        {
            background: #15222E;
            width: 80px;
            text-align: center;
            height: 25px;
            cursor:pointer;
            color: #B0D551;
        }
        
        .style1453
        {
            width: 200px;
            text-align: center;
            height: 25px;
            background: #15222E;
             cursor:pointer;
             color: #B0D551;
        }
        .style1454
        {
            border: thin #000080;
            width: 503px;
        }
        .style1455
        {
            width: 503px;
            color: #003366;
            font-size: medium;
        }
        .style1457
        {
            width: 170px;
        }
        .style1458
        {
            width: 493px;
            height: 180px;
        }
        .style1462
        {
            width: 100%;
        }
        .style1463
        {
            width: 165px;
            height: 110px;
        }
        .style1464
        {
            height: 110px;
        }
        .style1465
        {
            color: #003366;
        }
        .style1466
        {
            border: thin #000080 solid;
            width: 100%;
            height: 110px;
        }
        .style1468
        {
            text-align: center;
            height: 30px;
            color: #B0D551;
            background-color: #15222E;
            cursor: pointer;
        }
        .style1469
        {
            height: 473px;
            border: thin #000080 solid;
            width: 410px;
            padding-left: 7px;
            padding-right: 6px;
        text-align: left;
    }
        .style1470
        {
            height: 110px;
            text-align: center;
            font-size: large;
            color: #000080;
        }
        .style1471
        {
            border: thin #000080 solid;
            width: 30%;
        }
        .style1473
        {
            text-align: center;
            height: 40px;
            font-size: large;
        }
        .style1474
        {
            text-align: right;
            height: 25px;
        }
        .style1475
        {
            text-align: right;
            height: 25px;
            width: 121px;
        }
        .style1476
        {
            height: 537px;
            width: 1057px;
            margin-bottom: 10px;
        }
        .style1477
        {
            width: 71px;
            height: 31px;
            font-size: medium;
            font-weight: bold;
            color: #003366;
        }
        .style1478
        {
            height: 25px;
            width: 539px;
            margin-top: 2px;
            margin-left: 0px;
            padding-left: 0px;
        }
        
        
        .style1479
        {
            min-width: 194px;
            background-color: #006699;
            color: #FFFFFF;
            padding:10px 10px 10px 10px;
            display:none;
            position:absolute;
            top:40%;
            left:40%;
            z-index:455;
        }
        
        
        .style1480
        {
            height: 28px;
            width: 72px;
            color: #E71C18;
        }
        
        
        .style1481
        {
            border: thin #000080;
            width: 503px;
            height: 30px;
            color: #003366;
        }
        .style1482
        {
            width: 373px;
        }
        
        
        .style1483
        {
            width: 100px;
            height: 20px;
        }
        
        
        .style1484
        {
            width: 110px;
            background-image: url('../Images/default.png');
            background-repeat: no-repeat;
            background-position: center;
            text-align: center;
        }
        
        
        .style1485
        {
            background: #15222E;
            width: 90px;
            text-align: center;
            height: 25px;
            cursor: pointer;
            color: #B0D551;
        }
        
        
        .style1486
        {
            font-size: x-small;
            color: #FF0000;
        }
        .style1487
        {
            font-size: x-small;
            color: #800000;
        }
        
        
        </style>
        <script type="text/javascript">
            var btn_close = '<p style="width: 100%; height:18px; text-align:center;"><a style="font-size: 15px; font-weight: bold;" href="javascript:void(0);" onclick="hide_customitem();">[Đóng]</a></p>';
            
            //some function here
                       
            function custom_Items(slotIDs, keys) {
                var HiddenItem = $("#HiddenItem" + slotIDs);
                var msgbox = $("#custom_ItemsContent");
                //show loading....
                msgbox.html('<img src="../Images/uber-loading.gif"/>');
                if (HiddenItem.val() != "") {
                    $.ajax({
                        type: 'GET',
                        url: 'customItem.aspx',
                        data: 'IDs=' + HiddenItem.val() + '&keys=' + keys + ',' + slotIDs,
                        success: function (data) {
                            show_customitem();
                            $('#custom_ItemsContent').html(data);

                        }
                    });
                }
                else {
                    show_customitem();
                    $('#custom_ItemsContent').html("Slot " + slotIDs + " không có item không thể tuỳ chọn!" + btn_close);
                }
            }
            
            function call_checkcount(count, getIDs) {
                var maxmincount = parseInt($("#TxtCount").val());
                var HiddenCount = $("#HiddenCount" + getIDs);
                if (maxmincount < 1) {
                    $("#miniPanelContent").html("Nhỏ nhất là 1.");
                    tb_showMiniPanel();
                } else if (maxmincount > count) {
                    $("#miniPanelContent").html("Lớn nhất là " + count + ".");
                    tb_showMiniPanel();
                }
                else {
                    if ($("#TxtCount").val() != '') {
                        var digits = "0123456789";
                        var temp;
                        for (var i = 0; i < $("#TxtCount").val().length; i++) {
                            temp = $("#TxtCount").val().substring(i, i + 1);
                            if (digits.indexOf(temp) == -1) {
                                //alert("Please enter correct zip code");
                                $("#miniPanelContent").html("Bạn phải nhập vào một số từ 0-9! ");
                                tb_showMiniPanel();
                                $("#TxtCount").focus();
                                $("#TxtCount").val("");
                                return false;
                            }
                        }
                        hide_printTBCount();
                        HiddenCount.val(maxmincount);
                    } else { $("#miniPanelContent").html("Bạn chưa nhập số lượng!"); tb_showMiniPanel(); return false; }


                }

            }
            function printTBCount(count, getIDs) {
                var container = '<div id="get_count" style=" width: 147px; height: 72px; background-color: #006699;">';
                container += '<table style="width: 145px; height: 70px;"><tr>';
                container += '<td style="width: 79px; height: 30px; color: #FFFFFF;">';
                container += 'Số Lượng:</td><td style="height: 30px; text-align: center;">';
                container += '<input id="TxtCount" style="width: 50px; text-align: center;" value="1" type="text" /></td>';
                container += '</tr><tr><td class="style15" colspan="2">';
                container += '<input id="Bt_checkcount" onclick="call_checkcount(' + count + ', ' + getIDs + ');" type="button" value="Xác nhận" /></td>';
                container += '</tr></table></div>';
                $("#printTBCount").html(container);
                show_printTBCount();
            }
            function call_addItems(GoodIDs, count) {
                //start function

                var msgbox;
                var errors = 0;
                var HiddenItem1 = $("#HiddenItem1");
                var HiddenItem2 = $("#HiddenItem2");
                var HiddenItem3 = $("#HiddenItem3");
                var HiddenItem4 = $("#HiddenItem4");
                var HiddenItem5 = $("#HiddenItem5");
              
                if (HiddenItem1.val() == "") {
                    HiddenItem1.val(GoodIDs)
                    msgbox = $("#td_item1");
                    if (count > 1) {
                      printTBCount(count, 1);
                   } else {$("#HiddenCount1").val("1"); }
              }

                else if (HiddenItem2.val() == "") {
                    HiddenItem2.val(GoodIDs)
                    msgbox = $("#td_item2");
                    if (count > 1) {
                        printTBCount(count, 2);
                    } else { $("#HiddenCount2").val("1"); }
                }
                else if (HiddenItem3.val() == "") {
                    HiddenItem3.val(GoodIDs)
                    msgbox = $("#td_item3");
                    if (count > 1) {
                        printTBCount(count, 3);
                    } else { $("#HiddenCount3").val("1"); }
                }
                else if (HiddenItem4.val() == "") {
                    HiddenItem4.val(GoodIDs)
                    msgbox = $("#td_item4");
                    if (count > 1) {
                        printTBCount(count, 4);
                    } else { $("#HiddenCount4").val("1"); }
                }
                else if (HiddenItem5.val() == "") {
                    HiddenItem5.val(GoodIDs)
                    msgbox = $("#td_item5");
                    if (count > 1) {
                        printTBCount(count, 5);
                    } else { $("#HiddenCount5").val("1"); }
                }
                else {
                    errors = 1;
                    msgbox = $("#miniPanelContent");
                    msgbox.html("Item đính kèm tối đa là 5 Item! Bạn đã đạt gới hạn.")
                    //msgbox.html(HiddenItem1.val() + "|" + HiddenItem2.val() + "|" + HiddenItem3.val() + "|" + HiddenItem4.val() + "|" + HiddenItem5.val())
                    tb_showMiniPanel();

                }
                //show loading....
                if (errors == 0) {
                    msgbox.html('<img src="../Images/uber-loading.gif"/>');
                    //request data
                    var $j = jQuery;
                    $j.ajax({
                        type: "POST",
                        url: "mainRequest.ashx/AddItemsMail",
                        data: "{GoodIDs:" + GoodIDs + ",Keys:'7.0.0.0.0.0',isPopup:1}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (message) {
                            //show data
                            msgbox.html(message.d);
                            //tb_showsearchPanel();
                        },
                        error: function (errormessage) {
                            //show error
                            msgbox.html(errormessage.responseText);
                        }

                    });
                    //end function  
                }
            }
            function clearForm() {
                $('#mainForm').resetForm();
                $("#TextArea1").val("");
                $("#TxtUserName").val("");
                $("#TxtTitle").val("");
                var getParam;
                for (var s = 1; s < 6; s++) {
                    getParam = $("#HiddenCount" + s);
                    getParam.val("1");
                    getParam = $("#HiddenValid" + s);
                    getParam.val("7");
                    getParam = $("#HiddenStreng" + s);
                    getParam.val("0");
                    getParam = $("#HiddenAttack" + s);
                    getParam.val("0");
                    getParam = $("#HiddenDefend" + s);
                    getParam.val("0");
                    getParam = $("#HiddenAgility" + s);
                    getParam.val("0");
                    getParam = $("#HiddenLuck" + s);
                    getParam.val("0");
                    del_ItemsAtt(s);
                }
            }
            function call_SendMail() {
                //start function
                var selectedBind = $("#SelectBind option:selected").val();
                var TxtContent = $("#TextArea1").val();
                var TxtUserName = $("#TxtUserName").val();
                var TxtTitle = $("#TxtTitle").val();
                var getParam;
                var MainParam = "";
                for (var s = 1; s < 6; s++) {
                    getParam = $("#HiddenItem" + s);
                    MainParam += getParam.val() + ",";
                    getParam = $("#HiddenCount" + s);
                    MainParam += getParam.val() + ",";
                    getParam = $("#HiddenValid" + s);
                    MainParam += getParam.val() + ",";
                    getParam = $("#HiddenStreng" + s);
                    MainParam += getParam.val() + ",";
                    getParam = $("#HiddenAttack" + s);
                    MainParam += getParam.val() + ",";
                    getParam = $("#HiddenDefend" + s);
                    MainParam += getParam.val() + ",";
                    getParam = $("#HiddenAgility" + s);
                    MainParam += getParam.val() + ",";
                    getParam = $("#HiddenLuck" + s);
                    MainParam += getParam.val() + ",";
                    MainParam += selectedBind + "|";
                }
                if ($("#HiddenItem1").val()=="" && $("#HiddenItem2").val()=="" && $("#HiddenItem3").val()=="" && $("#HiddenItem4").val()=="" && $("#HiddenItem5").val()=="") {
                MainParam = "";
                }
                
                tb_showMiniPanel();
                var msgbox = $("#miniPanelContent");
                //show loading....
                if (TxtUserName == "") {
                    msgbox.html('Bạn chưa nhập Tài khoản nhận!');
                }
                else {
                    msgbox.html('<img src="../Images/uber-loading.gif"/>');

                    //request data
                    var $j = jQuery;
                    $j.ajax({
                        type: "POST",
                        url: "mainRequest.ashx/SendMailByAdmin",
                        data: "{title:'" + TxtTitle + "', content:'" + TxtContent + "', UserName:'" + TxtUserName + "', param:'" + MainParam + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (message) {
                            clearForm();
                            //show data
                            msgbox.html(message.d);

                        },
                        error: function (errormessage) {
                            //show error
                            msgbox.html(errormessage.responseText);
                        }

                    });
                } //end function
            }
            

            function call_sendMoney() {
                //start function
                tb_showMiniPanel();
                var msgbox = $("#miniPanelContent");
                var UserName = String($("#TxtUserMoney").val());
                var Gold = parseInt($("#TxtGold").val());
                var Money = parseInt($("#TxtMoney").val());
                var GiftToken = parseInt($("#TxtGiftToken").val());
                //show loading....
                msgbox.html('<img src="../Images/uber-loading.gif"/>');
                //request data
                if (UserName == "") {
                    msgbox.html("Bạn chưa nhập tài khoản");

                }

                else if (Gold == "") {
                    msgbox.html("Bạn chưa nhập Vàng");

                }
                else if (Money == "") {
                    msgbox.html("Bạn chưa nhập Xu");

                }
                else if (GiftToken == "") {
                    msgbox.html("Bạn chưa nhập Lễ kim");

                }
                else {
                    //msgbox.html(UserName + Gold + Money + GiftToken)

                    var $j = jQuery;
                    $j.ajax({
                        type: "POST",
                        url: "mainRequest.ashx/SendMoney",
                        data: "{UserName:'" + UserName + "', Gold:" + Gold + ", Money:" + Money + ", GiftToken:" + GiftToken + "}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (message) {
                            //show data
                            $("#TxtUserMoney").val("");
                            $("#TxtGold").val("");
                            $("#TxtMoney").val("");
                            $("#TxtGiftToken").val("");

                            msgbox.html(message.d);
                        },
                        error: function (errormessage) {
                            //show errorerrormessage.responseText
                            msgbox.html("Xu, Vàng, Lễ kim phải là số từ 0-9");
                        }

                    });
                    //end function  
                }
            }
            function show_Sendmail() {
                $("#divSendMail").css({ display: "block" });
                $("#divSendMoney").css({ display: "none" });
                $("#divMailBox").css({ display: "none" });

            }
            function show_SendMoney() {
                $("#divSendMail").css({ display: "none" });
                $("#divSendMoney").css({ display: "block" });
                $("#divMailBox").css({ display: "none" });
                $("#TxtUserMoney").focus();
            }
            function show_MailBox() {
                $("#divSendMail").css({ display: "none" });
                $("#divSendMoney").css({ display: "none" });
                $("#divMailBox").css({ display: "block" });
            }
            function show_MailBox() {
                $("#divSendMail").css({ display: "none" });
                $("#divSendMoney").css({ display: "none" });
                $("#divMailBox").css({ display: "block" });
            }
            
        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="custom_ItemsContent" class="style1479" >

</div>
    <div class="style1445">
    <table  style="width:100%;">
        <tr>
            <td class="style1485" 
            onclick="show_Sendmail();"
            onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
            onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
             Gửi Items
                </td>
                <td class="style1451" 
            onclick="show_SendMoney();"
            onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
            onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
             Gửi Xu
                </td>
            <td class="style1453" 
            onclick="show_MailBox()"
            onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
            onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                
                Quản lý User Messages</td>
            <td class="style1448">
                &nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td colspan="4">
                <div id="divSendMail" class="style1476">
                    <table style="border: medium #000080 solid; width: 100%;">
                        <tr>
                            <td class="style1454">
                                <span class="style1465">Tài khoản nhận:&nbsp;</span>&nbsp;&nbsp;
                                <input id="TxtUserName" class="style1457" type="text" /></td>
                            <td rowspan="6">
                            <table style="width: 537px;">
                    <tr>
                        <td style="width: 414px;">
                                <div id="list_Items" class="style1469">
                                
                                </div>
                                </td>
                        <td valign="top">
                            <asp:Label ID="ShowLoadMenu" runat="server" Text="" />
                            </td>
                            </tr>
                </table>
                                <div id="show_smartpaginator" class="style1478" ></div>

                            </td>
                        </tr>
                        <tr>
                            <td class="style1481">
                                Tiêu đề:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input id="TxtTitle" class="style1482" type="text" /></td>
                        </tr>
                        <tr>
                            <td class="style1454">
                                <span class="style1465">Nội dung:&nbsp;&nbsp; --------------------------</span><span 
                                    class="style1486">Bạn có thể bỏ qua phần nội dung-</span><span class="style1465">------------------------</span></td>
                        </tr>
                        <tr>
                            <td class="style1454">
                                <textarea cols="" id="TextArea1" class="style1458" name="S1"></textarea></td>
                        </tr>
                        <tr>
                            <td class="style1455">
                                Item đính kèm:<strong> </strong>
                                <select id="SelectBind" class="style1483" name="D1">
                                    <option value="true">Khoá</option>
                                    <option value="false">Không Khoá</option>
                                </select>&nbsp;&nbsp;&nbsp; <span class="style1486">Click&nbsp; &quot;</span><span 
                                    class="style1487">Tuỳ chọn</span><span class="style1486">&quot; để cường hoá, hợp 
                                thành, gia hạn .</span></td></tr>
                        <tr>
                            <td class="style1454">
                                <table cellpadding="0" cellspacing="0" class="style1462">
                                    <tr>
                                        <td class="style1463">
                                            <table class="style1466">
                                                <tr>
                                                    <td id="td_item1" class="style1484" rowspan="2">
                                                        Item 1</td>
                                                    <td class="style1468"
                                                    onclick="del_ItemsAtt(1);"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Xóa</td>
                                                </tr>
                                                <tr>
                                                    <td class="style1468"
                                                    onclick="custom_Items(1, 'customItems');"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Tùy chọn</td>
                                                </tr>
                                                </table>
                                        </td>
                                        <td class="style1463">
                                            <table class="style1466">
                                                <tr>
                                                    <td id="td_item2" class="style1484" rowspan="2">
                                                        Item 2</td>
                                                    <td class="style1468"
                                                    onclick="del_ItemsAtt(2);"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Xóa</td>
                                                </tr>
                                                <tr>
                                                    <td class="style1468"
                                                    onclick="custom_Items(2, 'customItems');"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Tùy chọn</td>
                                                </tr>
                                                </table>
                                        </td>
                                        <td class="style1464">
                                            <table class="style1466">
                                                <tr>
                                                    <td id="td_item3" class="style1484" rowspan="2">
                                                        Item 3</td>
                                                    <td class="style1468"
                                                    onclick="del_ItemsAtt(3);"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Xóa</td>
                                                </tr>
                                                <tr>
                                                    <td class="style1468"
                                                    onclick="custom_Items(3, 'customItems');"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Tùy chọn</td>
                                                </tr>
                                                </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="style1463">
                                            <table class="style1466">
                                                <tr>
                                                    <td id="td_item4" class="style1484" rowspan="2">
                                                        Item 4</td>
                                                    <td class="style1468"
                                                    onclick="del_ItemsAtt(4);"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Xóa</td>
                                                </tr>
                                                <tr>
                                                    <td class="style1468"
                                                    onclick="custom_Items(4, 'customItems');"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Tùy chọn</td>
                                                </tr>
                                                </table>
                                        </td>
                                        <td class="style1463">
                                            <table class="style1466">
                                                <tr>
                                                    <td id="td_item5" class="style1484" rowspan="2">
                                                        Item 5</td>
                                                    <td class="style1468"
                                                    onclick="del_ItemsAtt(5);"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Xóa</td>
                                                </tr>
                                                <tr>
                                                    <td class="style1468"
                                                    onclick="custom_Items(5, 'customItems');"
                                                    onmouseout="$(this).css({ background: '#15222E', color: '#B0D551'});" 
                                                    onmouseover="$(this).css({ background: '#2C2c2B', color: '#FFFFFF'});">
                                                        Tùy chọn</td>
                                                </tr>
                                                </table>
                                        </td>
                                        <td class="style1470">
                                            <input onclick="call_SendMail();" id="Button1" type="button" value="Gửi Mail" class="style1480" /></td>
                                    </tr>
                                    </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divSendMoney" class="style1450">
                    <table class="style1471">
                        <tr>
                            <td class="style1475">
                                <span class="style1465">Tài khoản nhận:</span></td>
                            <td class="style1474">
                            <input id="TxtUserMoney" class="style1457" type="text" /></td>
                        </tr>
                        <tr>
                            <td class="style1475">
                            <span class="style1465">Xu (Money):</span></td>
                            <td class="style1474">
                            <input id="TxtMoney" value="" class="style1457" type="text" /></td>
                        </tr>
                        <tr>
                            <td class="style1475">
                            <span class="style1465">Vàng (Gold):</span></td>
                            <td class="style1474">
                            <input id="TxtGold" value="" class="style1457" type="text" /></td>
                        </tr>
                        <tr>
                            <td class="style1475">
                            <span class="style1465">Lễ Kim (GifToken):</span></td>
                            <td class="style1474">
                            <input id="TxtGiftToken" value="" class="style1457" type="text" /></td>
                        </tr>
                        <tr>
                            <td class="style1473" colspan="2">
                                <strong>
                                <input id="TxtSend" onclick="call_sendMoney();" class="style1477" value="Send" type="button" /></strong></td>
                        </tr>
                    </table>
                                   
                </div>
                <div id="divMailBox" class="style1450">
                Quản lý User Messages
                </div>
                            
            </td>
        </tr>
    </table>
</div>   

<script type="text/javascript">
    loading_ItemIcon(1, 1, true);
          
    </script>
</asp:Content>
