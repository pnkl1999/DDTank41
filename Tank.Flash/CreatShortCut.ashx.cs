using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Bussiness;
namespace Tank.Flash
{
    /// <summary>
    /// Summary description for CreatShortCut
    /// </summary>
    public class CreatShortCut : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //CreatShortCut.ashx?gameurl=http%3A//127.0.0.1/gunnyii/
            try
            {
                string str = context.Request.QueryString["gameurl"];
                string str2 = context.Request.UserAgent.ToUpper();
                string str3 = LanguageMgr.GetTranslation("Game.ProductionName") + ".url";
                if (str2.Contains("MS") && str2.Contains("IE"))
                {
                    str3 = HttpUtility.UrlEncode(str3);
                }
                else if (str2.Contains("FIREFOX"))
                {
                    str3 = "\"" + str3 + "\"";
                }
                else
                {
                    str3 = HttpUtility.UrlEncode(str3);
                }
                context.Response.ContentType = "application/octet-stream;";
                context.Response.AddHeader("Content-Disposition", "attachment;filename=" + str3);
                context.Response.Write("[InternetShortcut]\n");
                context.Response.Write("URL=" + str + "\n");
                context.Response.Write("IDList=\n");
                context.Response.Write("IconFile=\n");
                context.Response.Write("IconIndex=1\n");
                context.Response.Write("[{000214A0-0000-0000-C000-000000000046}]\n");
                context.Response.Write("Prop3=19,2\n");
                context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception exception)
            {
                context.Response.Write("Error:" + exception);
            }

        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}