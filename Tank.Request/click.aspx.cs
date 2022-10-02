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
using System.Collections.Generic;
using Bussiness;

namespace Count
{
    public partial class click : System.Web.UI.Page
    {

        //IContent AddCount = new IContent();
        protected void Page_Load(object sender, EventArgs e)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(click));
 
        }

        /// <summary>
        /// 得到用户信息
        /// </summary>
        /// <param name="p">操作系统</param>
        /// <param name="v">浏览器</param>
        /// <param name="c">颜色深度</param>
        /// <param name="s">分辨率</param>
        /// <param name="t">被访问页面标题</param>
        /// <param name="l">被访问页面地址</param>
        /// <param name="f">来源页面</param>
        /// <param name="a">判断Alexa工具条</param>
        /// <returns>返回结果</returns>
        [Ajax.AjaxMethod()]
        public string Logoff(string App_Id, string Direct_Url, string Referry_Url, string Begin_time, string ScreenW, string ScreenH, string Color, string Flash)
        {
            HttpContext current = HttpContext.Current;
            Dictionary<string, string> clientInfos = new Dictionary<string, string>();
            try
            {
                clientInfos.Add("Application_Id", App_Id);

                string ip = current.Request.UserHostAddress;                                                    //IP地址
                string userAgent = current.Request.UserAgent == null ? "无" : current.Request.UserAgent;
                if (current.Request.ServerVariables["HTTP_UA_CPU"] == null)                                     //CPU类型
                    clientInfos.Add("CPU", "未知");
                else
                    clientInfos.Add("CPU", current.Request.ServerVariables["HTTP_UA_CPU"]);
                clientInfos.Add("OperSystem", GetOSNameByUserAgent(userAgent));                                 //操作系统

                //???重复2次IP的目的？？
                clientInfos.Add("IP", ip);                                                               //IP地址
                clientInfos.Add("IPAddress", ip);                                                               //IP地址
                if (current.Request.Browser.ClrVersion == null)
                    clientInfos.Add(".NETCLR", "不支持");
                else
                    clientInfos.Add("NETCLR", current.Request.Browser.ClrVersion.ToString());                   //CLR版本
                clientInfos.Add("Browser", current.Request.Browser.Browser + current.Request.Browser.Version);   //浏览器版本
                clientInfos.Add("ActiveX", current.Request.Browser.ActiveXControls ? "True" : "False");         //ActiveX
                clientInfos.Add("Cookies", current.Request.Browser.Cookies ? "True" : "False");                 //支持Cookies
                clientInfos.Add("CSS", current.Request.Browser.SupportsCss ? "True" : "False");                 //支持CSS
                clientInfos.Add("Language", current.Request.UserLanguages[0]);                                   //语言

                string httpAccept = current.Request.ServerVariables["HTTP_ACCEPT"];                              //来访类型
                if (httpAccept == null)
                    clientInfos.Add("Computer", "False");
                else if (httpAccept.IndexOf("wap") > -1)
                    clientInfos.Add("Computer", "False");
                else
                    clientInfos.Add("Computer", "True");
                clientInfos.Add("Platform", current.Request.Browser.Platform);                                    //平台
                clientInfos.Add("Win16", current.Request.Browser.Win16 ? "True" : "False");                          //16位操作系统
                clientInfos.Add("Win32", current.Request.Browser.Win32 ? "True" : "False");                          //32位操作系统

                if (current.Request.ServerVariables["HTTP_ACCEPT_ENCODING"] == null)                              //访问代码
                    clientInfos.Add("AcceptEncoding", "无");
                else
                    clientInfos.Add("AcceptEncoding", current.Request.ServerVariables["HTTP_ACCEPT_ENCODING"]);
                clientInfos.Add("UserAgent", userAgent);

                clientInfos.Add("Referry", Referry_Url);                                                         //来源页面
                clientInfos.Add("Redirect", Direct_Url);                                                         //当前面页
                clientInfos.Add("TimeSpan", Begin_time.ToString());                                              //停留时间

                clientInfos.Add("ScreenWidth", ScreenW);                                                         //宽
                clientInfos.Add("ScreenHeight", ScreenH);                                                        //高
                clientInfos.Add("Color", Color);                                                                 //Color
                clientInfos.Add("Flash", Flash);                                                                 //Flash版本           
                //AddCount.Add_Content(clientInfos);
                CountBussiness.InsertContentCount(clientInfos);

            }
            catch (Exception ex)
            {
                return ex.ToString();

            }
            return "ok";
            // 根据 Dictionary 中的内容在 Table 中显示客户端信息
            //System.Text.StringBuilder str = new System.Text.StringBuilder(); //创建字符串
            //foreach (string key in clientInfos.Keys)
            //{
            //    str.Append(key + "：" + clientInfos[key].ToString() + " \r");
            //}
            //return str.ToString();

        }
        /// <summary>
        /// 根据 User Agent 获取操作系统名称
        /// </summary>
        private static string GetOSNameByUserAgent(string userAgent)
        {
            string osVersion = "未知";


            if (userAgent.Contains("NT 6.0"))
            {
                osVersion = "Windows Vista/Server 2008";
            }
            else if (userAgent.Contains("NT 5.2"))
            {
                osVersion = "Windows Server 2003";
            }
            else if (userAgent.Contains("NT 5.1"))
            {
                osVersion = "Windows XP";
            }
            else if (userAgent.Contains("NT 5"))
            {
                osVersion = "Windows 2000";
            }
            else if (userAgent.Contains("NT 4"))
            {
                osVersion = "Windows NT4";
            }
            else if (userAgent.Contains("Me"))
            {
                osVersion = "Windows Me";
            }
            else if (userAgent.Contains("98"))
            {
                osVersion = "Windows 98";
            }
            else if (userAgent.Contains("95"))
            {
                osVersion = "Windows 95";
            }
            else if (userAgent.Contains("Mac"))
            {
                osVersion = "Mac";
            }
            else if (userAgent.Contains("Unix"))
            {
                osVersion = "UNIX";
            }
            else if (userAgent.Contains("Linux"))
            {
                osVersion = "Linux";
            }
            else if (userAgent.Contains("SunOS"))
            {
                osVersion = "SunOS";
            }
            return osVersion;

        }

 
 
    }
}
