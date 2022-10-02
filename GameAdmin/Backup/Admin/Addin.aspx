<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Addin.aspx.cs" Inherits="AdminGunny.Admin.Addin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .style1451
        {
            text-align: left;
            width: 150px;
            height: 30px;
            color: #003366;
        }
        .style1452
        {
            text-align: center;
            height: 30px;
            width: 90px;
        }
        .style1453
        {
            text-align: left;
            height: 30px;
        }
        .style1454
        {
            color: #006600;
        }
        .style1456
        {
            height: 30px;
            width: 163px;
            color: #003366;
        }
        .style1457
        {
            height: 30px;
            width: 80px;
        }
        .style1458
        {
            height: 30px;
            width: 100px;
        }
        .style1459
        {
            height: 30px;
            width: 100px;
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <table style="width:100%;">
          <tr>
            <td class="style11"  valign="top" align="left">
            
         <asp:Label ID="ShowLoadMenu" runat="server" Text="" />
              </td>
            <td class="style12"  valign="top" align="left">
               <div id="DivImport">
                <table style="width:100%;">
                    <tr>
                        <td class="style1451">
                            <strong>TemplateAlllist.xml</strong></td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonTemp" runat="server" onclick="ButtonTemp_Click" 
                                Text="Import!" />
                            </strong>
                        </td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonTemp0" runat="server" onclick="ButtonTemp_Click" 
                                Text="Export!" />
                            </strong>
                        </td>
                        <td class="style1453">
                            <asp:Label ID="LabelTemp" runat="server" CssClass="style1454"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1451">
                            <strong>BallList.xml</strong></td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonBall" runat="server" onclick="ButtonBall_Click" 
                                Text="Import!" />
                            </strong>
                        </td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonBall0" runat="server" onclick="ButtonBall_Click" 
                                Text="Export!" />
                            </strong>
                        </td>
                        <td class="style1453">
                            <asp:Label ID="LabelBall" runat="server" CssClass="style1454"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1451">
                            <strong>bombconfig.xml</strong></td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonBomb" runat="server" onclick="ButtonBomb_Click" 
                                Text="Import!" />
                            </strong>
                        </td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonBomb0" runat="server" onclick="ButtonBomb_Click" 
                                Text="Export!" />
                            </strong>
                        </td>
                        <td class="style1453">
                            <asp:Label ID="LabelBomb" runat="server" CssClass="style1454"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1451">
                            <strong>LoadBoxTemp.xml</strong></td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonBoxTemp" runat="server" onclick="ButtonBoxTemp_Click" 
                                Text="Import!" />
                            </strong>
                        </td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonBoxTemp0" runat="server" onclick="ButtonBoxTemp_Click" 
                                Text="Export!" />
                            </strong>
                        </td>
                        <td class="style1453">
                            <asp:Label ID="LabelBoxtemp" runat="server" CssClass="style1454"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1451">
                            <strong>ShopItemList.xml</strong></td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonShopItem" runat="server" onclick="ButtonShopItem_Click" 
                                Text="Import!" />
                            </strong>
                        </td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonShopItem0" runat="server" onclick="ButtonShopItem_Click" 
                                Text="Export!" />
                            </strong>
                        </td>
                        <td class="style1453">
                            <asp:Label ID="LabelShopItem" runat="server" CssClass="style1454"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1451">
                            <strong>LoadMapsItems.xml</strong></td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonMap" runat="server" onclick="ButtonMap_Click" 
                                Text="Import!" />
                            </strong>
                        </td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonMap0" runat="server" onclick="ButtonMap_Click" 
                                Text="Export!" />
                            </strong>
                        </td>
                        <td class="style1453">
                            <asp:Label ID="LabelMap" runat="server" CssClass="style1454"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1451">
                            <strong>LoadPVEItems.xml</strong></td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonPVE" runat="server" onclick="ButtonPVE_Click" 
                                Text="Import!" />
                            </strong>
                        </td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonPVE0" runat="server" onclick="ButtonPVE_Click" 
                                Text="Export!" />
                            </strong>
                        </td>
                        <td class="style1453">
                            <asp:Label ID="LabelPVE" runat="server" CssClass="style1454"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1451">
                            <strong>NPCInfoList.xml</strong></td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonNPC" runat="server" onclick="ButtonNPC_Click" 
                                Text="Import!" />
                            </strong>
                        </td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonNPC0" runat="server" onclick="ButtonNPC_Click" 
                                Text="Export!" />
                            </strong>
                        </td>
                        <td class="style1453">
                            <asp:Label ID="LabelNPC" runat="server" CssClass="style1454"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1451">
                            <strong>QuestList.xml</strong></td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonQuest" runat="server" onclick="ButtonQuest_Click" 
                                Text="Import!" />
                            </strong>
                        </td>
                        <td class="style1452">
                            <strong>
                            <asp:Button ID="ButtonQuest0" runat="server" onclick="ButtonQuest_Click" 
                                Text="Export!" />
                            </strong>
                        </td>
                        <td class="style1453">
                            <asp:Label ID="LabelQuest" runat="server" CssClass="style1454"></asp:Label>
                        </td>
                    </tr>
                </table>
               
   </div>
    <div id="DivResource">
   <table style="width: 100%;">
    <tr>
        <td class="style1456">
            <strong>&nbsp;
            Kiểm tra Resource</strong></td>
        <td class="style1457">
            &nbsp;
            <asp:DropDownList ID="DropDownList1" runat="server">
                <asp:ListItem Value="0">Select</asp:ListItem>
                <asp:ListItem Value="1">Items</asp:ListItem>
                <asp:ListItem Value="2">Ball</asp:ListItem>
                <asp:ListItem Value="3">Map</asp:ListItem>
                <asp:ListItem Value="4">NPC</asp:ListItem>
                <asp:ListItem Value="5">Sound</asp:ListItem>
            </asp:DropDownList>
        </td>
        <td class="style1459">
                            <strong>
                            <asp:Button ID="BtCheckResource" runat="server"
                                Text="Kiểm Tra" onclick="BtCheckResource_Click" />
                            </strong>
        </td>
        <td class="style15" rowspan="2">
                            <asp:Label ID="LbResourceResult" runat="server" 
                CssClass="style1454"></asp:Label>
        </td>
    </tr>
    <tr>
        <td class="style1456">
            <strong>&nbsp;
        </strong>
        </td>
        <td class="style1457">
            &nbsp;
        </td>
        <td class="style1458">
            &nbsp;</td>
    </tr>
    </table>
   </div>
   
                </td>
        </tr>
        
    </table>
</asp:Content>

