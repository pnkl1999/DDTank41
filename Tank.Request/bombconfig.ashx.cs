using Bussiness;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;

namespace Tank.Request
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    /// <summary>
    /// Summary description for bombconfig
    /// </summary>
    public class bombconfig : IHttpHandler
    {
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
                    BallConfigInfo[] infos = db.GetAllBallConfig();
                    foreach (BallConfigInfo info in infos)
                    {
                        result.Add(Road.Flash.FlashUtils.CreateBallConfigInfo(info));
                    }
                }

                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                //log.Error("BallList", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            //return result.ToString(false);
            return csFunction.CreateCompressXml(context, result, "bombconfig", true);
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