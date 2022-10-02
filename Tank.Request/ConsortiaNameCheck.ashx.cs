using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using SqlDataProvider.Data;
using Bussiness;
using log4net;
using System.Reflection;
using System.Configuration;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for ConsortiaNameCheck
    /// </summary>
    public class ConsortiaNameCheck : IHttpHandler
    {

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            string path = HttpContext.Current.Server.MapPath(".");
            //LanguageMgr.Setup(ConfigurationManager.AppSettings["ReqPath"]);
            path += "\\";
            LanguageMgr.Setup(path);
            bool value = false;
            string message = LanguageMgr.GetTranslation("Tank.Request.ConsortiaCheck.Exist");
            XElement result = new XElement("Result");

            try
            {
                string ConsortiaName = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["NickName"]));
                if (System.Text.Encoding.Default.GetByteCount(ConsortiaName) <= 14)
                {
                    if (!string.IsNullOrEmpty(ConsortiaName))
                    {
                        using (ConsortiaBussiness db = new ConsortiaBussiness())
                        {
                            if (db.GetConsortiaSingleByName(ConsortiaName) == null)
                            {
                                value = true;
                                message = LanguageMgr.GetTranslation("Tank.Request.ConsortiaCheck.Right");

                            }
                        }
                    }
                }
                else
                {
                    message = LanguageMgr.GetTranslation("Tank.Request.ConsortiaCheck.Long");
                }
            }
            catch (Exception ex)
            {
                log.Error("ConsortiaCheck", ex);
                value = false;
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
    }
}