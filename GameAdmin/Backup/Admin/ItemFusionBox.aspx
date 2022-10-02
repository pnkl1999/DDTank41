<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ItemFusionBox.aspx.cs" Inherits="AdminGunny.Admin.ItemFusionBox" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .style1446
        {
            min-height: 350px;
        }
        .style1447
        {
            border: medium #000000 double;
            width: 100%;
            margin-bottom: 10px;
        }
        .style1448
        {
            width: 480px;
        }
        .Astyle1449
        {
            width: 100%;
        }
        .Astyle1450
        {
            width: 100px;
            text-align: center;
            color: #003366;
        }
        .Astyle1451
        {
            width: 100px;
            text-align: center;
            color: #003366;
        }
        .style1452
        {
            width: 490px;
            color: #FF3300;
            font-size: large;
            height: 25px;
        }
        .style1453
        {
            height: 25px;
        }
        .style1456
        {
            background-position: center;
            height: 110px;
            width: 220px;
            background-image: url('../Images/default.png');
            background-repeat: no-repeat;
            
        }
        .style1457
        {
            background-position: center;
            text-align: center;
            height: 110px;
            width: 110px;
            background-image: url('../Images/default.png');
            background-repeat: no-repeat;
            cursor:pointer;
        }
        .style1458
        {
            border: thin #003399 solid;
            width: 100%;
        }
        .style1460
        {
            width: 110px;
            text-align: center;
            vertical-align: middle;
            margin-left:15px;
        }
        .style1461
        {
            width: 85px;
            color: #000080;
            font-weight: bold;
        }
        .style1462
        {
            color: #FF0000;
            font-size:12px;
            
        }
         .style1478
        {
            height: 25px;
            width: 519px;
            margin-top: 2px;
            margin-left: 0px;
            padding-left: 0px;
        }
         .style1478a
        {
            height: 25px;
            width: 509px;
            margin-top: 2px;
            margin-left: 0px;
            padding-left: 0px;
        }
         .style1479
        {
            width: 525px;
            background-color: #C4C4C4;
            color: #FFFFFF;
            padding:3px 3px 3px 3px;
            display:none;
            position:absolute;
            top:100px;
            left:10%;
            z-index:455;
        }
        .style1480
        {
            color: #003366;
        }
        .style1481
        {
            height: 25px;
            color: #003366;
            font-size: large;
        }
        .img_loading
        {
            margin-left: 200px; 
            margin-top: 160px;
        }
        .style1482
        {
            width: 509px;
        }
        
        .style1488
        {
            border: thin #000080 solid;
            width: 87px;
            text-align: center;
        }
        .style1489
        {
            border: thin #000080 solid;
            width: 86px;
            text-align: center;
        }
        .style1490
        {
            color: #0000FF;
        }
        .style1491
        {
            color: #FF3300;
        }
        .style1492
        {
            width: 77px;
        }
        .style1493
        {
            color: #CC0066;
        }
        .style1494
        {
            width: 75px;
            color: #000080;
            font-weight: bold;
        }
        .style1496
        {
            border: thin #000080 solid;
            width: 75px;
            text-align: center;
            height: 75px;
            cursor:pointer;
        }
        .style1498
        {
            width: 305px;
        }
        .iconFusion
        {
            background: #C0C0C0;
            display: none;
            height: 175px;
            width: 315px;
            text-align: center;
            padding-top: 10px;
            padding-left:10px;
            position: fixed;
            z-index: 1102;
            border: none;
            top: 43%;
            left: 40%;
        }
        .style1499
        {
            color: #FF0000;
        }
        .style1500
        {
            width: 100%;
            height: 106px;
        }
        .style1501
        {
            width: 47px;
        }
        .style1502
        {
            width: 102px;
            cursor:pointer;
            text-align: center;
        }
        </style>
    
     <script type="text/javascript">

         var LoadingJIMG = '<img src="../Images/uber-loading.gif"/>';
         function show_iconFusion() {
             $("#miniPanel_overlay2").css({ display: "block" });
             $("#iconFusion").css({ display: "block" });
         }
         function hide_iconFusion() {
             $("#miniPanel_overlay2").css({ display: "none" });
             $("#iconFusion").css({ display: "none" });
         }
        function del_ItemsFu(slotIDs) {
            var HiddenItem = $("#HiddenItem" + slotIDs);
            var msgbox = $("#td_item" + slotIDs);
        if (slotIDs == 1 || slotIDs == 2 || slotIDs == 3 || slotIDs == 4) {
                    loading_ItemIcon2(1234, 1, true);
                    show_customitem();
                }
                else if (slotIDs == 5) {
                    loading_ItemIcon2(5, 1, true);
                    show_customitem();
                }
                else if (slotIDs == 6) {
                   show_iconFusion();
                }
              
        }
        function call_addItems(GoodIDs, Slot) {
            //start function
            if (Slot == 1234) {
                for (var s = 1; s < 5; s++) {
                    getParam = $("#td_item" + s);
                    getParam.html('');
                }
            }
            else if (Slot == 5) {
                getParam = $("#td_item" + Slot);
                getParam.html(LoadingJIMG);
            }
            else if (Slot == 6) {
                getParam = $("#td_item" + Slot);
                getParam.html(LoadingJIMG);
            }
             //request data
                var $j = jQuery;
                $j.ajax({
                    type: "POST",
                    url: "mainRequest.ashx/AddItemsMail",
                    data: "{GoodIDs:" + GoodIDs + ",Keys:'7.0.0.0.0.0',isPopup:0}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (message) {
                        //show data
                        if (Slot == 1234) {
                            call_add4slot(GoodIDs, message.d);
                        }
                        else if (Slot == 5) {
                            call_add1slot(Slot, GoodIDs, message.d);
                        }
                        else if (Slot == 6) {
                            call_add1slot(Slot, GoodIDs, message.d);
                            hide_iconFusion(); 
                        }
                        hide_customitem();

                    },
                    error: function (errormessage) {
                        //show error
                        msgbox.html(errormessage.responseText);
                    }

                });
                //end function  

            }
            function addFusion() {
                //start function
                //request data
                var HiddenItem1 = $("#HiddenItem1").val();
                var HiddenItem2 = $("#HiddenItem2").val();
                var HiddenItem3 = $("#HiddenItem3").val();
                var HiddenItem4 = $("#HiddenItem4").val();
                var HiddenItem5 = $("#HiddenItem5").val();
                var HiddenItem6 = $("#HiddenItem6").val();
                var msgbox = $("#miniPanelContent");
                tb_showMiniPanel();
                msgbox.html(LoadingJIMG);
                var $j = jQuery;
                $j.ajax({
                    type: "POST",
                    url: "mainRequest.ashx/AddItemFusion",
                    data: "{GoodID1234:" + HiddenItem1 + ",GoodID6:" + HiddenItem6 + ",GoodID5:" + HiddenItem5 + "}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (message) {
                        //show data

                        msgbox.html(message.d);
                        call_resetAllSlot();
                        loadAllFusion(1, true);
                    },
                    error: function (errormessage) {
                        //show error
                        msgbox.html(errormessage.responseText);
                    }

                });
                //end function  
            }

            function UpdateFusion() {
                //start function
                //request data
                var HiddenItem1 = $("#HiddenItem1").val();
                var HiddenItem2 = $("#HiddenItem2").val();
                var HiddenItem3 = $("#HiddenItem3").val();
                var HiddenItem4 = $("#HiddenItem4").val();
                var HiddenItem5 = $("#HiddenItem5").val();
                var HiddenItem6 = $("#HiddenItem6").val();
                var FusionID = $("#FusionID").val();
                var msgbox = $("#miniPanelContent");
                tb_showMiniPanel();
                msgbox.html(LoadingJIMG);
                var $j = jQuery;
                $j.ajax({
                    type: "POST",
                    url: "mainRequest.ashx/UpdateItemFusion",
                    data: "{GoodID1234:" + HiddenItem1 + ",GoodID6:" + HiddenItem6 + ",GoodID5:" + HiddenItem5 + ",FuID:" + FusionID + "}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (message) {
                        //show data

                        msgbox.html(message.d);
                        call_resetAllSlot2();
                        loadAllFusion(1, true);
                    },
                    error: function (errormessage) {
                        //show error
                        msgbox.html(errormessage.responseText);
                    }

                });
                //end function  
            }

            function call_add4slot(id, item) {
                //start function
                for (var s = 1; s < 5; s++) {
                    getParam = $("#td_item" + s);
                    getParam.html(item);
                    getParam = $("#HiddenItem" + s);
                    getParam.val(id);

                }

            }
            function call_add1slot(Slot, id, item) {
                //start function
                    getParam = $("#td_item" + Slot);
                    getParam.html(item);
                    getParam = $("#HiddenItem" + Slot);
                    getParam.val(id);
                    }

            function DeleteFusion() {
                //start function
                //request data
                
                var FusionID = $("#FusionID").val();
                var msgbox = $("#miniPanelContent");
                tb_showMiniPanel();
                msgbox.html(LoadingJIMG);
                var $j = jQuery;
                $j.ajax({
                    type: "POST",
                    url: "mainRequest.ashx/DeleteItemFusion",
                    data: "{FuID:" + FusionID + "}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (message) {
                        //show data

                        msgbox.html(message.d);
                        call_resetAllSlot2();
                        hide_customDl();
                        loadAllFusion(1, true);
                    },
                    error: function (errormessage) {
                        //show error
                        msgbox.html(errormessage.responseText);
                    }

                });
                //end function  
            }

            function call_add4slot(id, item) {
                //start function
                for (var s = 1; s < 5; s++) {
                    getParam = $("#td_item" + s);
                    getParam.html(item);
                    getParam = $("#HiddenItem" + s);
                    getParam.val(id);

                }

            }

            function call_RaddItems(GoodIDs, slot) {
                //start function
                //var HiddenItem = $("#HiddenItem" + slotIDs);
                var msgbox = $("#td_item" + slot);
                msgbox.html("Item " + slot);
                //HiddenItem.val("");
                //show loading....

                msgbox.html(LoadingJIMG);
                //request data
                var $j = jQuery;
                $j.ajax({
                    type: "POST",
                    url: "mainRequest.ashx/AddItemsMail",
                    data: "{GoodIDs:" + GoodIDs + ",Keys:'7.0.0.0.0.0',isPopup:0}",
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
            function editFusion(item1, item2, item3, item4, Formula, reward, FuId) {
                //start function
                call_RaddItems(item1, 1);
                call_RaddItems(item2, 2);
                call_RaddItems(item3, 3);
                call_RaddItems(item4, 4);
                call_RaddItems(Formula, 6);
                call_RaddItems(reward, 5);
                $("#HiddenItem1").val(item1);
                $("#HiddenItem2").val(item2);
                $("#HiddenItem3").val(item3);
                $("#HiddenItem4").val(item4);
                $("#HiddenItem6").val(Formula);
                $("#HiddenItem5").val(reward);
                $("#FusionID").val(FuId);

                $("#bt_Add").css({ display: "none" });
                $("#bt_test0").css({ display: "none" });
                $("#showTestFu").css({ display: "block" });

            }
            function call_resetAllSlot2() {
                //start function

                $("#bt_Add").css({ display: "block" });
                $("#bt_test0").css({ display: "block" });
                $("#showTestFu").css({ display: "none" });
                call_resetAllSlot();

            }
            
            function call_resetAllSlot() {
                //start function
                for (var s = 1; s < 7; s++) {
                    getParam = $("#td_item" + s);
                    if (s == 5) {
                        getParam.html("Reward");
                    }
                    else if (s == 6) {
                        getParam.html("Formula");
                    }
                    else {
                        getParam.html("Slot " + s);
                    }
                    getParam = $("#HiddenItem" + s);
                    getParam.val("");
                    $("#FusionID").val("0")
                }
                //$("#td_item5").val("Reward");
                //$("#HiddenItem5").val("");
            }
           
            function checkFu5() {
                //start function
                if ($("#HiddenItem1").val() == "" || $("#HiddenItem2").val() == "" || $("#HiddenItem3").val() == "" || $("#HiddenItem4").val() == "") {
                    tb_showMiniPanel();
                    $("#miniPanelContent").html("Bạn cần thêm đủ slot trước khi chọn Reward!");
                }
                else {
                    del_ItemsFu(5);
                }
            }
            function validate(type) {
                //start function
                var checked = type;
                var confirm = '<p style="text-align:center;"><a style="font-size: 15px; font-weight: bold;" href="javascript:void(0);" onclick="DeleteFusion();">[Xác nhận]</a>'+
                '&nbsp;&nbsp;&nbsp;<a style="font-size: 15px; font-weight: bold;" href="javascript:void(0);" onclick="hide_customDl();">[Close]</a></p>';

                if ($("#HiddenItem1").val() == "" || $("#HiddenItem2").val() == "" || $("#HiddenItem3").val() == "" || $("#HiddenItem4").val() == "" || $("#HiddenItem5").val() == "" || $("#HiddenItem6").val() == "") {
                        tb_showMiniPanel();
                        $("#miniPanelContent").html("Bạn chưa thêm đủ item!");
                    }
                    else {
                    if (checked == 0) {
                        addFusion();
                        }
                        else if (checked == 1) {
                        UpdateFusion();
                        }
                    }
                
                
                if (checked == 2) {
                    show_customDl();
                    $("#miniPanelContent1").html("Bạn chắc là muốn xoá item này không!" + confirm);
                }
            }
            function loadAllFusion(page, show) {
                //start function
                //request data

                var msgbox = $("#Lb_ItemResult");

                msgbox.html('<img class="img_loading" src="../Images/uber-loading.gif"/>');
                var $j = jQuery;
                $j.ajax({
                    type: "POST",
                    url: "ItemFusionBox.aspx/getAllFusion",
                    data: "{page_number:" + page + ",show_smartpaginator:" + show + "}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (message) {
                        //show data

                        msgbox.html(message.d);
                        call_resetAllSlot();
                        //tb_showsearchPanel();
                    },
                    error: function (errormessage) {
                        //show error
                        msgbox.html(errormessage.responseText);
                    }

                });
                //end function  
            }
        function callTestFution() {
                
                var getParam;
                var MainParam = "";
                for (var s = 1; s < 5; s++) {
                    getParam = $("#HiddenItem" + s);
                    MainParam += getParam.val() + ",";
                    MainParam += "1,";
                    MainParam += "7,";
                    MainParam += "0,";
                    MainParam += "10,";
                    MainParam += "10,";
                    MainParam += "10,";
                    MainParam += "10,";
                    MainParam += "true|";
                }
                if ($("#HiddenItem1").val()=="" && $("#HiddenItem2").val()=="" && $("#HiddenItem3").val()=="" && $("#HiddenItem4").val()=="") {
                MainParam = "";
                }
                
                tb_showMiniPanel();
                var msgbox = $("#miniPanelContent");
                //show loading....
                if ($("#txtusername").val() == "") {
                    msgbox.html('Bạn chưa nhập Tài khoản nhận!');
                }
                else {
                    msgbox.html(LoadingJIMG);

                    //request data
                    var $j = jQuery;
                    $j.ajax({
                        type: "POST",
                        url: "mainRequest.ashx/SendMailByAdmin",
                        data: "{title:'Kiểm tra Fusion', content:'Kiểm tra Fusion', UserName:'" + $("#txtusername").val() + "', param:'" + MainParam + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (message) {
                          msgbox.html(message.d);

                        },
                        error: function (errormessage) {
                            //show error
                            msgbox.html(errormessage.responseText);
                        }

                    });
                } //end function

            }
            function call_AddOrtherFution() {
                alert("Làm biếng quá chưa làm ^o^!");
            }
            $(document).ready(function () {
                loadAllFusion(1,true);
               $("#showTestFu").css({ display: "none" });
                });
            
            
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<input id="FusionID" type="hidden" value="0" />
    <div id="custom_ItemsContent" class="style1479" >
    <table style="width:100%;">
     <tr>
                <td colspan="2">
                <a style="margin-left:470px; color:#000000; " href="javascript:void(0);" onclick="hide_customitem();">[Close]</a>
                   <div id="show_smartpaginator" class="style1478" ></div></td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="ShowLoadMenu" runat="server" Text="" /></td>
                <td>
                    
                    <div id="list_Items" class="style1469"></div>
                
                </td>
            </tr>
        </table>
    
    
    </div>
    <div class="style1446">
        <table class="style1447">
            <tr>
                <td class="style1452">
                    <strong>Danh sách ItemFusion</strong></td>
                <td class="style1481">
                    <strong>Thêm / Sửa / Xoá ItemFusion</strong></td>
                <td class="style1453">
                    </td>
            </tr>
            <tr>
                <td class="style1448" valign="top">
                <div id="show_smartpaginator1" class="style1478a" ></div>
              <table class="style1482">
                        <tr class="style1480">
                            <td class="style1489">
                                <strong>Item 1</strong></td>
                            <td class="style1489">
                                <strong>Item 2</strong></td>
                            <td class="style1489">
                                <strong>Item 3</strong></td>
                            <td class="style1489">
                                <strong>Item 5</strong></td>
                            <td class="style1489">
                                <strong>Formula</strong></td>
                            <td class="style1488">
                                <strong>Reward</strong></td>
                        </tr>
                        </table>
                         <span id="Lb_ItemResult"></span>
                        
                </td>
                <td valign="top" colspan="2">
                    <table class="style1458">
                        <tr>
                            <td id="td_item1" class="style1457"
                            onclick="del_ItemsFu(1);">
                                Slot 1</td>
                            <td id="td_item2" class="style1457"
                            onclick="del_ItemsFu(2);">
                                Slot 2</td>
                            <td id="td_item3" class="style1457"
                            onclick="del_ItemsFu(3);">
                                Slot 3</td>
                            <td id="td_item4" class="style1457"
                            onclick="del_ItemsFu(4);">
                                Slot 4</td>
                            <td class="style1460" rowspan="2">
                                <input id="bt_test0" onclick="call_resetAllSlot();" class="style1461" type="button" value="Reset" />
                                <input id="bt_Add" onclick="validate(0);" class="style1461" type="button" value="Thêm mới" />
                                <span id="showTestFu">
                                <input id="bt_Update" onclick="validate(1);" class="style1461" type="button" value="Cập nhật" />
                                <input id="bt_Delete" onclick="validate(2);" class="style1461" type="button" value="Xoá Item" />
                                <input id="bt_Cancel" onclick="call_resetAllSlot2();" class="style1461" type="button" value="Huỷ bỏ" />
                                <span class="style1493">Tài khoản:</span>
                                <input id="txtusername" type="text" class="style1492" />
                                <input id="bt_test" onclick="callTestFution();" class="style1461" type="button" value="Gửi Item" />
                                </span>
                                </td>
                        </tr>
                        <tr>
                            <td class="style1460">
                                <span id="showTestFu0">
                                
                                    <input id="bt_AddOrtherFusion" onclick="call_AddOrtherFution();" class="style1494" 
                                    type="button" value="Khác" />
                                    </span></td>
                            <td  class="style1456" colspan="2">
                                <table class="style1500">
            <tr>
                <td class="style1501">
                    &nbsp;</td>
                <td id="td_item5" onclick="checkFu5();" class="style1502">
                   Reward</td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
</td>
                            <td id="td_item6" class="style1457"
                            onclick="del_ItemsFu(6);">
                                Formula</td>
                        </tr>
                        <tr>
                            <td colspan="5" class="style1462">
                                Tips: Click vào Slot để chọn Item cần thêm vào. Click&nbsp; vào Slot một lần nửa 
                                để xoá item đã thêm. </td>
                        </tr>
                    </table>
                    <span class="style1491"><strong>Lưu ý: </strong>
                    <br />
&nbsp;&nbsp;&nbsp;&nbsp; Ở đây chỉ hổ trợ thêm&nbsp; trực quan những item có FusionType bằng Item ID. 
                    Bạn muốn thêm vào những item có FusionType khác&nbsp;Item ID thì chọn &quot;</span><span 
                        class="style1480"><strong>Khác</strong></span><span class="style1491">&quot;.
                    <br />
&nbsp;&nbsp;&nbsp;&nbsp; Những Item có chữ FuType:</span><span class="style1499">x</span><span class="style1491"> 
                    ( x là 1 số ) có nghĩa là có rất nhiều Item có FusionType là </span>
                    <span class="style1499">x</span><span class="style1491"> .<br />
                    </span><br />
                    <span class="style1490">&lt;== Click vào một item bất kỳ trên cột </span>
                    <span class="style1491"><em>Reward</em></span><span class="style1490"> để chuyển 
                    item đó vào chế độ chỉnh sửa,&nbsp; xoá hoặc chuyển vào game kiểm tra.</span></td>
            </tr>
            </table>
    </div>
                    <div id="iconFusion" class="iconFusion">
                    <table class="style1498">
                        <tr>
                            <td class="style1496">
                                <img class="personPopupTrigger" onclick="call_addItems(11204,6);" 
                                    alt="11204,ItemsInfo,popup" src="../Images/gunny/formula/other2/icon.png" /></td>
                            <td class="style1496">
                                <img alt="11203,ItemsInfo,popup" class="personPopupTrigger" onclick="call_addItems(11203,6);" 
                                    src="../Images/gunny/formula/other3/icon.png" /></td>
                            <td class="style1496">
                                <img alt="11202,ItemsInfo,popup" class="personPopupTrigger" onclick="call_addItems(11202,6);""
                                    src="../Images/gunny/formula/other4/icon.png" /></td>
                            <td class="style1496">
                                <img alt="11201,ItemsInfo,popup" class="personPopupTrigger" onclick="call_addItems(11201,6);" 
                                    src="../Images/gunny/formula/other5/icon.png" /></td>
                        </tr>
                        <tr>
                            <td class="style1496">
                                <img alt="11301,ItemsInfo,popup" class="personPopupTrigger" onclick="call_addItems(11301,6);" 
                                    src="../Images/gunny/formula/other6/icon.png" /></td>
                            <td class="style1496">
                                <img alt="11304,ItemsInfo,popup" class="personPopupTrigger" onclick="call_addItems(11304,6);" 
                                    src="../Images/gunny/formula/other7/icon.png" /></td>
                            <td class="style1496">
                                <img alt="11302,ItemsInfo,popup" class="personPopupTrigger" onclick="call_addItems(11302,6);" 
                                    src="../Images/gunny/formula/other9/icon.png" /></td>
                            <td class="style1496">
                                <img alt="11303,ItemsInfo,popup" class="personPopupTrigger" onclick="call_addItems(11303,6);""
                                    src="../Images/gunny/formula/other10/icon.png" /></td>
                        </tr>
                        </table>
                        </div>
                        
</asp:Content>
