<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ShopItem.aspx.cs" Inherits="AdminGunny.Admin.AddItem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<asp:Panel ID="SearchPanel" runat="server">
        <div class="formPanel">
            <fieldset>
                <legend>Add Item</legend>
                <p>
                    <asp:Label ID="Label1" runat="server" Text="UserName" AssociatedControlID="UserName_tbx"></asp:Label>
                    <asp:TextBox ID="UserName_tbx" runat="server" CssClass="textEntry"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="UserName_tbx" ErrorMessage="RequiredFieldValidator"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:Label ID="Label2" runat="server" Text="Item Template Id" AssociatedControlID="Template_tbx"></asp:Label>
                    <asp:TextBox ID="Template_tbx" runat="server" CssClass="textEntry"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ControlToValidate="UserName_tbx" ErrorMessage="RequiredFieldValidator"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:Label ID="Label3" runat="server" Text="Level" AssociatedControlID="Level_tbx"></asp:Label>
                    <asp:TextBox ID="Level_tbx" runat="server" CssClass="textEntry">0</asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" 
                        ControlToValidate="Level_tbx" ErrorMessage="RegularExpressionValidator" 
                        ValidationExpression="[0-9]*"></asp:RegularExpressionValidator>
                </p>
                <p>
                    <asp:Label ID="Label4" runat="server" Text="Attack" 
                        AssociatedControlID="Attack_tbx"></asp:Label>
                    <asp:TextBox ID="Attack_tbx" runat="server" CssClass="textEntry">0</asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                        ControlToValidate="Attack_tbx" ErrorMessage="RegularExpressionValidator" 
                        ValidationExpression="[0-9]*"></asp:RegularExpressionValidator>
                </p>
                <p>
                    <asp:Label ID="Label5" runat="server" Text="Defence" 
                        AssociatedControlID="Defence_tbx"></asp:Label>
                    <asp:TextBox ID="Defence_tbx" runat="server" CssClass="textEntry">0</asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                        ControlToValidate="Defence_tbx" ErrorMessage="RegularExpressionValidator" 
                        ValidationExpression="[0-9]*"></asp:RegularExpressionValidator>
                </p>
                <p>
                    <asp:Label ID="Label6" runat="server" Text="Agility" 
                        AssociatedControlID="Agility_tbx"></asp:Label>
                    <asp:TextBox ID="Agility_tbx" runat="server" CssClass="textEntry">0</asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                        ControlToValidate="Agility_tbx" ErrorMessage="RegularExpressionValidator" 
                        ValidationExpression="[0-9]*"></asp:RegularExpressionValidator>
                </p>
                <p>
                    <asp:Label ID="Luck" runat="server" Text="Luck" AssociatedControlID="Luck_tbx"></asp:Label>
                    <asp:TextBox ID="Luck_tbx" runat="server" CssClass="textEntry">0</asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" 
                        ControlToValidate="Luck_tbx" ErrorMessage="RegularExpressionValidator" 
                        ValidationExpression="[0-9]*"></asp:RegularExpressionValidator>
                </p>
                <p>
                    <asp:Label ID="Error_lbl" runat="server" Text="Label"></asp:Label>
                </p>
                <p>
                    <asp:Button ID="Edit" runat="server" Text="Add Item" OnClick="Edit_Click" />
                </p>
            </fieldset>
        </div>
    </asp:Panel>
</asp:Content>
