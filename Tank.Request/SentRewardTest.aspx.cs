using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Bussiness.Interface;

namespace Tank.Request
{


    public partial class SentRewardTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string mailTitle = "大幅度是";
            string mailContent = "大幅度是";
            string username = "watson";
            string gold = "6666";
            string money = "99999";
            //param格式：//int templateID, int count, int validDate, int StrengthenLevel, int AttackCompose, int DefendCompose, int AgilityCompose, int LuckCompose, bool isBinds
            string param = "11020,4,0,0,0,0,0,0,1|7014,2,9,400,400,400,400,400,0";


            string content = mailTitle + "#" + mailContent + "#" + username + "#" + gold + "#" + money + "#" + param + "#";

            DateTime time = DateTime.Now;
           
            string key = "asdfgh";
            string v = BaseInterface.md5(username+gold+money+param+BaseInterface.ConvertDateTimeInt(time)+key);

            content = content + BaseInterface.ConvertDateTimeInt(time) + "#" + v;

            Response.Redirect("http://192.168.0.4:828/SentReward.ashx?content="+Server.UrlEncode(content));

        }
    }
}
