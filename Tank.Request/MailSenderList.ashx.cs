using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using log4net;
using System.Reflection;
using SqlDataProvider.Data;
using Bussiness;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class MailSenderList : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";

            XElement result = new XElement("Result");
            try
            {
                int id = int.Parse(context.Request.QueryString["selfID"]);
                if (id != 0)
                {
                    using (PlayerBussiness db = new PlayerBussiness())
                    {
                        MailInfo[] sInfos = db.GetMailBySenderID(id);
                        foreach (MailInfo info in sInfos)
                        {
                            result.Add(Road.Flash.FlashUtils.CreateMailInfo(info, "Item"));
                        }
                    }

                    value = true;
                    message = "Success!";
                }

            }
            catch (Exception ex)
            {
                log.Error("MailSenderList", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            context.Response.ContentType = "text/plain";
            //context.Response.Write(result.ToString(false));
            context.Response.BinaryWrite(StaticFunction.Compress(result.ToString(false)));
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
