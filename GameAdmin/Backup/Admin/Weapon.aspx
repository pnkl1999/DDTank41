<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Weapon.aspx.cs" Inherits="AdminGunny.Admin.Weapon" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <asp:Panel ID="SearchPanel" runat="server">
    <fieldset>
        <legend>Account Search</legend>
        <p>
            Enter User Name:
            <asp:TextBox ID="UserName_tbx" runat="server" ></asp:TextBox>           
        </p>
        <p>
        <asp:Label ID="error_lbl" runat="server" Text="Label" CssClass="failureNotification"></asp:Label>
                 <br/>
         <asp:Button ID="Search" runat="server" Text="Search" OnClick="Search_Click" 
                CssClass="button" /> &nbsp;&nbsp; 
         <asp:Button ID="Active_btn" runat="server" onclick="Active_btn_Click" 
                Text="Active" CssClass="button" />     
         </p>
         
         
    </fieldset>
   
    </asp:Panel>
     <br />
    <asp:Panel ID="UserViewPanel" runat="server">
    <fieldset>
        <legend>Account Information</legend>
        <p>
           ID:
                        <asp:Label ID="IDLabel" runat="server" Text="" />
                        <br />
                        UserName:
                        <asp:Label ID="UserNameLabel" runat="server" Text="" />
                        <br />
                        NickName:
                        <asp:Label ID="NickNameLabel" runat="server" Text="" />
                        <br />
                        Gender:
                        <asp:Label ID="GenderLabel" runat="server" Text="" />
                        <br />
                        Gold:
                        <asp:Label ID="GoldLabel" runat="server" Text="" />
                        <br />
                        Money:
                        <asp:Label ID="MoneyLabel" runat="server" Text="" />
                        <br />
                        GiftToken:
                        <asp:Label ID="GiftTokenLabel" runat="server" Text="" />
                        <br />
                        GP:
                        <asp:Label ID="GPLabel" runat="server" Text="" />
                        <br />
                        PvePermission:
                        <asp:Label ID="PvePermissionLabel" runat="server" Text=""/>
                          <br />
                         </p>
        <p>
         <asp:Button ID="Edit" runat="server" Text="Edit" onclick="Edit_Click" 
                CssClass="button" />       
            &nbsp;&nbsp;
            <asp:Button ID="Button1" runat="server" onclick="Button1_Click" Text="Change User" 
                CssClass="button" />
            &nbsp;&nbsp;
            <asp:Button ID="DeActive_btn" runat="server" onclick="DeActive_btn_Click" 
                Text="DeActive" CssClass="button" />
          
         </p>
         </fieldset>
    </asp:Panel>
    <br />
    <asp:Panel ID="UserEditPanel" runat="server">
    <fieldset>
        <legend>Account Edit</legend>
        <p>
						UserName:
                        <asp:Label ID="UserNameLabel1" runat="server" Text="" />
                        <br />
                        NickName:
                        <asp:Label ID="NickNameLabel1" runat="server" Text="" />
                        <br />
                        Gold:
                        <asp:Textbox ID="GoldTextbox" runat="server" Text="" />
                        <br />
                        Money:
                        <asp:Textbox ID="MoneyTextbox" runat="server" Text="" />
                        <br />
                        GiftToken:
                        <asp:Textbox ID="GiftTokenTextbox" runat="server" Text="" />
                        <br />
                        GP:
                        <asp:Textbox ID="GPTextbox" runat="server" Text="" />
                        <br />
                        PvePermission:
                        <asp:Textbox ID="PvePermissionTextbox" runat="server" Text=""/>
                          <br />
                         </p>
        <p>
         <asp:Button ID="Update" runat="server" Text="Update" onclick="Update_Click" 
                CssClass="button" />       
            &nbsp;&nbsp;
            <asp:Button ID="Button2" runat="server" onclick="Button2_Click" Text="Cancel" 
                CssClass="button" />
        </p>
         </fieldset>
    </asp:Panel>
                
</asp:Content>
