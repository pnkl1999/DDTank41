<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="popupInfo.aspx.cs" Inherits="AdminGunny.Admin.popupInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style201
        {
            width: 350px;
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
            color: #FF6600;
            font-weight: bold;
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
            color: #000000;
            font-weight: bold;
            font-size: 14px;
        }
        .style215
        {
            min-height: 0px;
            font-weight: bold;
            color: #000080;
        }
        .style216
        {
            position: absolute;
            top: 45px;
            left: 200px;
            width: 160px;
            height: 110px;
            text-align: center;
        }
        .style217
        {
            height: 25px;
            font-weight: bold;
            color: #008000;
        }
        .style218
        {
            height: 10px;
        }
        </style>
</head>
<body>
    
    <form id="form1" runat="server">
    
    <div class="style201">
        <table style="color:#006600; " cellpadding="1" cellspacing="0" >
            <tr>
                <td class="style202">
                    <asp:Label ID="ShowTitles" runat="server" /></td>
            </tr>
            <tr>
                <td class="style211">
                   <asp:Label ID="Quality" runat="server" />
                   
                    </td>
            </tr>
            <tr>
                <td class="style214">
                    <asp:Label ID="Type" runat="server" /></td>
            </tr>
            <tr>
                <td class="style215">
                 <asp:Label ID="ShowTitles0" runat="server" />   </td>
            </tr>
            <tr>
                <td class="style218" >
                    </td>
            </tr>
            <tr>
                <td class="style212">
                    
                    <asp:Label ID="ShowAttack" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style212">
                     
                    <asp:Label ID="ShowDefence" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style212">
                     
                    <asp:Label ID="ShowAgility" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style212">
                    
                    <asp:Label ID="ShowLuck" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style218" >
                    
                    </td>
            </tr>
            <tr>
                <td class="style213">
                   <asp:Label ID="LbSex" runat="server" /> </td>
            </tr>
            <tr>
                <td class="style213">
                   <asp:Label ID="LbCan" runat="server" /> </td>
            </tr>
            <tr>
                <td class="style207">
                    <asp:Label ID="ShowDescription" runat="server" />
                    </td>
            </tr>
            <tr>
                <td class="style217" >
                    <asp:Label ID="Lb_valid" runat="server" /></td>
            </tr>
            </table>
                <div class="style216">
                <asp:Label ID="Lb_str" runat="server" />
            
            </div>

    </div>
    </form>
           
</body>
</html>
