<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="customItem.aspx.cs" Inherits="AdminGunny.Admin.customItem" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style301
        {
            width: 98%;
        }
        .style302
        {
            width: 79px;
            color: #FF9900;
        }
        .style303
        {
            width: 91px;
            text-align: center;
        }
        .style305
        {
            text-align: left;
            color: #000080;
        }
        .style306
        {
            min-height: 9px;
            display:none;
        }
        .style307
        {
            width: 15px;
        }
        .style309
        {
            min-height:0px;
            width: 60px;
        }
        .style310
        {
            min-height:0px;
            font-weight: bold;
            width: 90px;
        }
        .style311
        {
            text-align: left;
            color: #000080;
            height: 25px;
        }
        .style312
        {
            height: 26px;
        }
        .style313
        {
            width: 200px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        function call_option() {
            var Compose = $("#SelectComp option:selected").val();
        if (Compose == "orther") {
                $("#Div_orther").css({ display: "block" });
            }
            else {
                $("#Div_orther").css({ display: "none" });
                //$("#HiddenAttack" + s);
            }
        }

        function set_customitems(slotIDs, GoodIDs) {
            //tb_showMiniPanel();
            //$('#miniPanelContent').html("Set custom item slot " + slotIDs + " complete!" + btn_close);
            ///*
             msgbox = $("#td_item"+ slotIDs);
            var HiddenValid = $("#HiddenValid" + slotIDs);
            var HiddenStreng = $("#HiddenStreng" + slotIDs);
            var HiddenAttack = $("#HiddenAttack" + slotIDs);
            var HiddenDefend = $("#HiddenDefend" + slotIDs);
            var HiddenAgility = $("#HiddenAgility" + slotIDs);
            var HiddenLuck = $("#HiddenLuck" + slotIDs);
            //========================================================
            var SelectValid = $("#SelectValid option:selected").val();
            var SelectStr = $("#SelectStr option:selected").val();
            var SelectComp = $("#SelectComp option:selected").val();
            var txt_att = $("#Txt_att").val();
            var txt_def = $("#Txt_def").val();
            var txt_agi = $("#Txt_agi").val();
            var txt_luc = $("#Txt_luc").val();
            //========================================================
            HiddenValid.val(SelectValid);
            HiddenStreng.val(SelectStr);
            if (SelectComp == "orther") {
                if (txt_att == "" || txt_def == "" || txt_agi == "" || txt_luc == "") {
                    $("#miniPanelContent").html("Tấn Công, Phòng Thủ, Nhanh nhẹn và May mắn không được rổng!");
                    tb_showMiniPanel();
                    return false;
                }
                var digits = "0123456789";
                var temp;
                for (var i = 0; i < txt_att.length; i++) {
                    temp = txt_att.substring(i, i + 1);
                    if (digits.indexOf(temp) == -1) {
                        $("#miniPanelContent").html("Tấn Công phải là số!");
                        tb_showMiniPanel();
                        $("#Txt_att").focus();
                        $("#Txt_att").val("");
                        return false;
                    }
                }
                for (var i = 0; i < txt_def.length; i++) {
                    temp = txt_def.substring(i, i + 1);
                    if (digits.indexOf(temp) == -1) {
                        $("#miniPanelContent").html("Phòng thủ phải là số!");
                        tb_showMiniPanel();
                        $("#Txt_def").focus();
                        $("#Txt_def").val("");
                        return false;
                    }
                }
                for (var i = 0; i < txt_agi.length; i++) {
                    temp = txt_agi.substring(i, i + 1);
                    if (digits.indexOf(temp) == -1) {
                        $("#miniPanelContent").html("Nhanh nhẹn phải là số!");
                        tb_showMiniPanel();
                        $("#Txt_agi").focus();
                        $("#Txt_agi").val("");
                        return false;
                    }
                }
                for (var i = 0; i < txt_luc.length; i++) {
                    temp = txt_luc.substring(i, i + 1);
                    if (digits.indexOf(temp) == -1) {
                        $("#miniPanelContent").html("May mắn phải là số!");
                        tb_showMiniPanel();
                        $("#Txt_luc").focus();
                        $("#Txt_luc").val("");
                        return false;
                    }
                }
            HiddenAttack.val(txt_att);
            HiddenDefend.val(txt_def);
            HiddenAgility.val(txt_agi);
            HiddenLuck.val(txt_luc);
            }
            else {
            HiddenAttack.val(SelectComp);
            HiddenDefend.val(SelectComp);
            HiddenAgility.val(SelectComp);
            HiddenLuck.val(SelectComp);
            }
        //*/
        var Keys = SelectValid + "." + SelectStr + "." + HiddenAttack.val() + "." + HiddenDefend.val() + "." + HiddenAgility.val() + "." + HiddenLuck.val();
         msgbox.html('<img src="../Images/uber-loading.gif"/>');
                    //request data
                    var $j = jQuery;
                    $j.ajax({
                        type: "POST",
                        url: "mainRequest.ashx/AddItemsMail",
                        data: "{GoodIDs:" + GoodIDs + ",Keys:'" + Keys + "',isPopup:1}",
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

                    hide_customitem();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">

    <div id="Div_main" class="style313">
     
        <table class="style301">
            
            <tr>
                <td class="style310" >
                    Thời hạn</td>
                <td class="style131">
                    <select id="SelectValid" class="style303" name="D1" >
                        <option value="7">7 Ngày</option>
                        <option value="15">15 Ngày</option>
                        <option value="30">30 Ngày</option>
                        <option value="365">365 Ngày</option>
                        <option value="0">Vĩnh cửu</option>
                    </select></td>
            </tr>
            <tr>
                <td class="style310" >
                <span id="sp_lbStr">   Cường Hoá</span>
                </td>
                <td >
                <span id="sp_SelectStr">   
                    <select id="SelectStr" class="style303" name="D2" >
                        <option value="0">Không</option>
                        <option value="1">Level 1</option>
                        <option value="2">Level 2</option>
                        <option value="3">Level 3</option>
                        <option value="4">Level 4</option>
                        <option value="5">Level 5</option>
                        <option value="6">Level 6</option>
                        <option value="7">Level 7</option>
                        <option value="8">Level 8</option>
                        <option value="9">Level 9</option>
                        <option value="10">Level 10</option>
                        <option value="11">Level 11</option>
                        <option value="12">Level 12</option>
                        <option value="13">Level 13</option>
                        <option value="14">Level 14</option>
                        <option value="15">Level 15</option>
                    </select></span></td>
            </tr>
            <tr>
                <td class="style310">
                  <span id="sp_lbComp">  Hợp thành</span></td>
                <td><span id="sp_SelectComp">
                    <select id="SelectComp"  onchange="call_option();" class="style303" name="D3" >
                        <option value="0">Không</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                        <option value="30">30</option>
                        <option value="40">40</option>
                        <option value="50">50</option>
                        <option value="orther">Khác</option>
                    </select></span>
                    </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div id="Div_orther" class="style306">
                        <table style="width:100%;">
                            <tr>
                                <td class="style307">
                                    &nbsp;</td>
                                <td class="style302">
                                    Tấn công</td>
                                <td>
                                    <input  maxlength="8" id="Txt_att" class="style309" type="text" /></td>
                            </tr>
                            <tr>
                                <td class="style307">
                                    &nbsp;</td>
                                <td class="style302">
                                    Phòng Thủ</td>
                                <td>
                                    <input  maxlength="8" id="Txt_def" class="style309" type="text" /></td>
                            </tr>
                            <tr>
                                <td class="style307">
                                    &nbsp;</td>
                                <td class="style302">
                                    Nhanh nhẹn</td>
                                <td>
                                    <input  maxlength="8" id="Txt_agi" class="style309" type="text" /></td>
                            </tr>
                            <tr>
                                <td class="style307">
                                    &nbsp;</td>
                                <td class="style302">
                                    May mắn</td>
                                <td>
                                    <input  maxlength="8" id="Txt_luc" class="style309" type="text" /></td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
     <asp:Label ID="Btn" runat="server"></asp:Label>
    </div>
    </form>
</body>
</html>
