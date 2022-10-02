<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="popup.aspx.cs" Inherits="AdminGunny.Admin.popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style201
        {
            width: 185px;
            min-height: 100px;
        }
        .style202
        {
            text-align: left;
            height: 25px;
            font-weight: bold;
            font-size: 17px;
        }
        .span_style205
        {
            color: #FF0000;
        }
         .style207
        {
            min-height: 0px;
            color: #008000;
            font-size: 13px;
            text-align: justify;
        }
        .style208
        {
            height: 15px;
            color: #999999;
            font-size: 10px;
        }
     
         .style211
        {
            text-align: left;
            min-height: 0px;
            color: #000080;
            font-weight: bold;
            font-size: 14px;
        }
       
        .style212
        {
            min-height: 0px;
            color: #000080;
        }
        .style213
        {
            min-height: 1px;
            color: #008000;
            font-weight: bold;
        }
         .style214
        {
            text-align: left;
            min-height: 0px;
            color: #0000FF;
            font-weight: bold;
            font-size: 14px;
        }
        .style215
        {
            height: 20px;
            font-weight: bold;
            color: #000080;
        }
    </style>
</head>
<body>
    
    <form id="form1" runat="server">
    
    <div class="style201">
        <table style="width:100%; color:#006600; " cellpadding="1" cellspacing="0" >
            <tr>
                <td colspan="2" class="style202">
                    <asp:Label ID="ShowTitles" runat="server" /></td>
            </tr>
            <tr>
                <td colspan="2" class="style211">
                    <asp:Label ID="ShowTitles0" runat="server" /></td>
            </tr>
            <tr>
                <td colspan="2" class="style214">
                    <asp:Label ID="Type" runat="server" /></td>
            </tr>
            <tr>
                <td colspan="2" class="style215">
                    <asp:Label ID="Quality" runat="server" /></td>
            </tr>
            <tr>
                <td class="style212" colspan="2">
                    
                    <asp:Label ID="ShowAttack" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style212" colspan="2">
                     
                    <asp:Label ID="ShowDefence" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style212" colspan="2">
                     
                    <asp:Label ID="ShowAgility" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style212" colspan="2">
                    
                    <asp:Label ID="ShowLuck" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style213" colspan="2">
                   <asp:Label ID="LbSex" runat="server" /> </td>
            </tr>
            <tr>
                <td class="style213" colspan="2">
                   <asp:Label ID="LbCan" runat="server" /> </td>
            </tr>
            <tr>
                <td class="style207" colspan="2">
                    <asp:Label ID="ShowDescription" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style208" >
                    <asp:Label ID="ShowCategoryID" runat="server" />
                    </td>

                <td class="style208" >
                    <asp:Label ID="ShowTemplateID" runat="server" />
                    </td>

            </tr>
        </table>
    </div>
    </form>
           
</body>
</html>
