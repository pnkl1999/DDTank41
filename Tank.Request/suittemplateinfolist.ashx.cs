using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using Bussiness;
using SqlDataProvider.Data;
using Road.Flash;
using log4net;
using System.Reflection;

namespace Tank.Request
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class suittemplateinfolist : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
            {
                context.Response.Write(Build(context));
            }
            else
            {
                context.Response.Write("IP is not valid!");
            }

        }

        public static string Build(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");

            try
            {

                using (ProduceBussiness db = new ProduceBussiness())
                {
                    Suit_TemplateInfo[] infos = db.Load_Suit_TemplateInfo();
                    foreach (Suit_TemplateInfo info in infos)
                    {
                        result.Add(FlashUtils.CreateSuit_TemplateInfo(info));
                    }
                }

                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("BallList", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            //return result.ToString(false);
            return csFunction.CreateCompressXml(context, result, "suittemplateinfolist", true);
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