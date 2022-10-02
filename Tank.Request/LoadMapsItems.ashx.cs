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
using Bussiness;
using SqlDataProvider.Data;

namespace Tank.Request
{
    //http://192.168.0.4:828/LoadMapsItems.ashx
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class LoadMapsItems : IHttpHandler
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
            string message = "Fail";

            XElement result = new XElement("Result");

            try
            {
                //TankDBDataContext db = new TankDBDataContext();
                //var query = from m in db.Game_Maps
                //            where m.PosX != null && m.PosX != ""
                //            select m;
                //foreach (var m in query)
                //{
                //    result.Add(Road.Flash.FlashUtils.CreateMapInfo(m));
                //}

                using (MapBussiness db = new MapBussiness())
                {
                    MapInfo[] infos = db.GetAllMap();
                    foreach (MapInfo info in infos)
                    {
                        result.Add(Road.Flash.FlashUtils.CreateMapInfo(info));
                    }
                }

                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("LoadMapsItems", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            return csFunction.CreateCompressXml(context, result, "LoadMapsItems", true);

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
