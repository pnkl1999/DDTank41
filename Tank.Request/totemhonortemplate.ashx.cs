using System;
using System.Web;
using System.Xml.Linq;
using SqlDataProvider.Data;
using Bussiness;
using Road.Flash;
using log4net;
using System.Reflection;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for totemhonortemplate
    /// </summary>
    public class totemhonortemplate : IHttpHandler
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

        public static string Bulid(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");

            try
            {
                using (ProduceBussiness db = new ProduceBussiness())
                {
                    TotemHonorTemplateInfo[] infos = db.GetAllTotemHonorTemplate();
                    foreach (TotemHonorTemplateInfo info in infos)
                    {
                        result.Add(FlashUtils.CreateTotemHonorTemplate(info));
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("Load totemhonortemplate is fail!", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            return csFunction.CreateCompressXml(context, result, "totemhonortemplate", false);
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