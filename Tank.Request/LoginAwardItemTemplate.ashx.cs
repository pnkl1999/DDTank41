using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for LoginAwardItemTemplate
    /// </summary>
    public class LoginAwardItemTemplate : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
            {
                context.Response.Write(Bulid(context));
            }
            else
            {
                context.Response.Write("IP is not valid!");
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

		public static string Bulid(HttpContext context)
		{
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");

            try
            {
                using (ProduceBussiness db = new ProduceBussiness())
                {
                    SqlDataProvider.Data.AccumulAtiveLoginAwardInfo[] infos = db.GetAccumulAtiveLoginAwardInfos();
                    foreach (SqlDataProvider.Data.AccumulAtiveLoginAwardInfo info in infos)
                    {
                        result.Add(FlashUtils.CreateAccumulAtiveLoginAwards(info));
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("Load loginawarditemtemplate is fail!", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            //csFunction.CreateCompressXml(context, result, "loginawarditemtemplate_out", isCompress: false);
			return csFunction.CreateCompressXml(context, result, "loginawarditemtemplate", true);
		}
	}
}