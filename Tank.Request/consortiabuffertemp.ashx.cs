using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Xml.Linq;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for consortiabuffertemp
    /// </summary>
    public class consortiabuffertemp : IHttpHandler
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
                    ConsortiaBuffTempInfo[] infos = db.GetAllConsortiaBuffTemp();
                    foreach (ConsortiaBuffTempInfo info in infos)
                    {
                        result.Add(Road.Flash.FlashUtils.CreateConsortiaBuffer(info));
                    }
                }

                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("consortiabuffertemp", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            //return result.ToString(false);
            csFunction.CreateCompressXml(context, result, "consortiabuffertemp_out", false);
            return csFunction.CreateCompressXml(context, result, "consortiabuffertemp", true);
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