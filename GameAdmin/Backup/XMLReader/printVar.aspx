<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="printVar.aspx.cs" Inherits="AdminGunny.XMLReader.printVar" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="TextBox1" Text="LoadPVEItems.xml" runat="server"></asp:TextBox>
        <br />

    <asp:Label id="view_var" runat="server"></asp:Label>
    </div>
    </form>
</body>
</html>
