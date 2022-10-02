<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Item.aspx.cs" Inherits="AdminGunny.Admin.Item" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" >
        //some function here
        function loading_Data(CategoryID, page_number, show_smartpaginator) {
            //start function
            var msgbox = $("#<%=ShowAllItem.ClientID%>");
            //show loading....
            msgbox.html(loadingIMG);
            //request data
            var $j = jQuery;
            $j.ajax({
                type: "POST",
                url: "Item.aspx/SelectLoadData",
                data: "{CategoryID:" + CategoryID + ", page_number:" + page_number + ", show_smartpaginator:" + show_smartpaginator + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (message) {
                    //show data
                    msgbox.html(message.d);
                    tb_showsearchPanel();
                },
                error: function (errormessage) {
                    //show error
                    msgbox.html(errormessage.responseText);
                }

            });
            //end function  
        }
        function call_CSharp(request, requestID) {
            //start function
            tb_showMiniPanel();
            var msgbox = $("#insertScript");
            //show loading....
            msgbox.html(loadingIMG);
            //request data
            var $j = jQuery;
            $j.ajax({
                type: "POST",
                url: "mainRequest.ashx/SelectFunc",
                data: "{request:" + request + ", requestID:" + requestID + "}",
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
                
</script>
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <table style="width:100%;">
          <tr>
            <td class="style11"  valign="top" align="left">
            
         <asp:Label ID="ShowLoadMenu" runat="server" Text="" />
              </td>
            <td class="style12"  valign="top" align="left">
                <div id="show_smartpaginator" style=" margin:2;"></div>
                <asp:Label ID="ShowAllItem" runat="server" />
                
                
            </td>
        </tr>
        
    </table>
    
    <br />
    <script type="text/javascript">
        loading_Data(0, 1, true);
        
    </script>

</asp:Content>
