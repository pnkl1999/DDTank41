//some function here
function loading_Data(CategoryID) {
    //start function
    var msgbox = $("#<%=ShowAllItem.ClientID%>");
    //show loading....
    msgbox.html("<img style='margin: 100px 0px 0px 400px; ' src='../Images/uber-loading.gif'/>");
    //request data
    var $j = jQuery;
    $j.ajax({
        type: "POST",
        url: "../Item.aspx/Show_SingleCategory",
        data: "{CategoryID:" + CategoryID + "}",
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