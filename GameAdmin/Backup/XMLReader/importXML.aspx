<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="importXML.aspx.cs" Inherits="AdminGunny.XMLReader.importXML" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:Button ID="ButtonBallList" runat="server" Text="ImportBallList" 
            onclick="ButtonBallList_Click" />
    
        &nbsp;
    
        <asp:Button ID="ButtonBombConfig" runat="server" Text="ImportBombConfig" onclick="ButtonBombConfig_Click" 
             />
    
        &nbsp;
    
        <asp:Button ID="ButtonTemplateAlllist" runat="server" 
            Text="ImportTemplateAlllist" onclick="ButtonTemplateAlllist_Click" 
             />
    
        &nbsp;
    
        <asp:Button ID="ButtonShopItemList" runat="server" Text="ImportShopItemList" onclick="ButtonShopItemList_Click" 
             />
    
        <br />
    
        <asp:Button ID="ButtonLoadBoxTemp" runat="server" Text="ImportLoadBoxTemp" onclick="ButtonLoadBoxTemp_Click" 
            />
    
        &nbsp;
    
        <asp:Button ID="ButtonLoadMap" runat="server" Text="ImportLoadMap" onclick="ButtonLoadMap_Click" 
            />
    
        &nbsp;
    
        <asp:Button ID="ButtonLoadPVE" runat="server" Text="ImportLoadPVE" onclick="ButtonLoadPVE_Click" 
            />
    
        &nbsp;
    
        <asp:Button ID="ButtonNPCInfo" runat="server" Text="ImportNPCInfo" onclick="ButtonNPCInfo_Click" 
            />
    
        <br />
    
        <br />
    
        <asp:Button ID="ButtonCheckResource" runat="server" Text="Check Resource" onclick="ButtonCheckResource_Click" 
             />
    
        <br />
        <br />
    
        <br />
        <asp:Label ID="LabelResult" runat="server"></asp:Label>
    
    </div>
    </form>
</body>
</html>
