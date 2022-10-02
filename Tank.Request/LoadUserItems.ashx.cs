using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using log4net;
using SqlDataProvider.Data;
using Bussiness;
using System.Reflection;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class LoadUserItems : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";

            XElement result = new XElement("Result");
            try
            {
                int userid = int.Parse(context.Request.Params["ID"]);
                
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    ItemInfo[] items = db.GetUserItem(userid);

                    foreach (ItemInfo item in items)
                    {
                        result.Add(Road.Flash.FlashUtils.CreateGoodsInfo(item));
                    }

                }
                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("LoadUserItems", ex);
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
