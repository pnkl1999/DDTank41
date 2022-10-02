using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using System.Web;
using System.Web.Services;
using log4net;
using System.Reflection;
using System.Xml.Linq;
using System.Data;
using System.Collections;
using Bussiness;
using SqlDataProvider.Data;
using System.Globalization;
using System.Configuration;

namespace Tank.Request
{
    /// <summary>
    ///1、	弹弹堂客户端请求”IIS”，传入参数:登陆帐号”。
    ///2、	IIS收到当前用户的“登陆帐号“参数。
    ///3、	IIS请求社区中的接口，获取社区中当前帐号的“好友信息”，包括照片、个人主页、登陆帐号。
    ///4、	传入“好友帐号”,请求数据库，返回当前用户的昵称、帐号。
    ///5、	返回信息给游戏：<Result value="true" message="Success!"><item username=wei9931 webpage=“http://www.good.com”  photo=”http://www.baidu.com/1.jpg“  isplay=true ></Result>
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class IMFriendsBbs : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public void ProcessRequest(HttpContext context)
        {
            /*第一步：请求代理商接口*/
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");
            IAgentFriends friendsClass = new Normal();
            StringBuilder friendUserName = new StringBuilder();
            HttpContext current = HttpContext.Current;
            string getFriendsBbsXml = friendsClass.FriendsString(current.Request.Params["Uid"]);  //从代理商获取返回来的XML文档
            DataSet Ds = new DataSet();   
            if (getFriendsBbsXml != "")
            {
                try
                {                                  
                    Ds.ReadXml(new System.IO.StringReader(getFriendsBbsXml));                    
                    for (int i = 0; i < Ds.Tables["item"].DefaultView.Count; i++)
                    {
                        friendUserName.Append(Ds.Tables["item"].DefaultView[i]["UserName"].ToString() + ",");
                    }
                }
                catch (Exception ex)
                {
                    if (log.IsErrorEnabled)
                        log.Error("Get Table Item ", ex);
                }
            }
            if ((friendUserName.Length <= 1)||(getFriendsBbsXml==""))
            {
                result.Add(new XAttribute("value", value));
                result.Add(new XAttribute("message", message));
                context.Response.ContentType = "text/plain";
                context.Response.Write(result.ToString(false));
                return;
            }
 
            /*第二步：将好友以4000为一个段落，切割成查询条件*/
            string[] friends = friendUserName.ToString().Split(',');                          //将当前的全部用户全部切割成数组
            ArrayList condictArray = new ArrayList();
            StringBuilder tempString = new StringBuilder(4000);
            for (int i = 0; i < friends.Count(); i++)
            {
                if (friends[i] == "")
                {
                    break;
                }
                if (tempString.Length + friends[i].Length < 4000)                             //以4000个长度为一个查询条件
                {
                    tempString.Append(friends[i] + ',');
                }
                else
                {
                    condictArray.Add(tempString.ToString());                                  //查询条件
                    tempString.Remove(0, tempString.Length);
                }
            }
            condictArray.Add(tempString.ToString());                                          //最尾部补上剩余的


            /*第三步：查询数据库中的数据*/
            try
            {
                for (int i = 0; i < condictArray.Count; i++)
                {
                    string temp = condictArray[i].ToString();
                    using (PlayerBussiness db = new PlayerBussiness())
                    {
                        FriendInfo[] friendsResult = db.GetFriendsBbs(temp);
                        for (int j = 0; j < friendsResult.Count(); j++)
                        {
                            DataRow[] dr = Ds.Tables["item"].Select("UserName='"+friendsResult[j].UserName+"'");
                            XElement node = new XElement("Item",                                    
                                    new XAttribute("NickName", friendsResult[j].NickName),
                                    new XAttribute("UserName", friendsResult[j].UserName),
                                    new XAttribute("UserId", friendsResult[j].UserID),
                                    new XAttribute("Photo", dr[0]["Photo"] == null ? "" : dr[0]["Photo"].ToString()),
                                    new XAttribute("PersonWeb", dr[0]["PersonWeb"] == null ? "" : dr[0]["PersonWeb"].ToString()),
                                    new XAttribute("IsExist", friendsResult[j].IsExist),
                                    new XAttribute("OtherName", dr[0]["OtherName"] == null ? "" : dr[0]["OtherName"].ToString())
                                    );
                            result.Add(node);
                        }
                    }
                }
                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("IMFriendsGood", ex);
            }
            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            context.Response.ContentType = "text/plain";
            context.Response.Write(result.ToString(false));
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        /// <summary>
        /// 查询用户好友接口
        /// </summary>
        public interface IAgentFriends
        {
            string FriendsString(string uid);
        }
        /// <summary>
        /// 实现用户好友接口
        /// </summary>
        public class Normal : IAgentFriends
        {
            private string Url;

            #region IAgentFriends Members
            public string FriendsString(string uid)
            {

                try
                {
                    if (FriendInterface == "")
                        return string.Empty;
                    string ok = "";
                    Url = String.Format(CultureInfo.InvariantCulture, FriendInterface, uid); //获取代理商开放的请求好友接口
                    string webAccept = WebsResponse.GetPage(Url, "", "utf-8", out ok);                          //外部提交，获取返回值XML结构信息
                    if (ok == "")
                    {
                        return webAccept;
                    }
                    else
                    {
                        throw new Exception(ok);
                    }
                }
                catch (Exception ex)
                {                    
                    if (log.IsErrorEnabled)
                        log.Error("Normal：", ex);
                }
                return string.Empty;
            }
            #endregion

            public static string FriendInterface
            {
                get
                {
                    return ConfigurationSettings.AppSettings["FriendInterface"];
                }
            }
        }


    }
}
