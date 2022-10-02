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
    /// Summary description for fightlabdropitemlist
    /// </summary>
    public class fightlabdropitemlist : IHttpHandler
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
                int[] copyids = new int[] { 10000, 10001, 10002, 10010, 10011, 10012, 10020, 10021, 10022, 10030, 10031, 10032, 10040, 10041, 10042 };
                using (ProduceBussiness db = new ProduceBussiness())
                {
                    DropItem[] infos = db.GetAllDropItems();
                    foreach (DropItem info in infos)
                    {
                        if (copyids.Contains(info.DropId))
                        {
                            result.Add(new XElement("Item",
                                   new XAttribute("ID", info.DropId.ToString().Substring(0, 4)),
                                   new XAttribute("Easy", info.DropId.ToString().Substring(4, 1)),
                                   new XAttribute("AwardItem", info.ItemId),
                                   new XAttribute("Count", info.BeginData)
                               ));
                        }
                    }
                }
                
                value = true;
                message = "Success!";
            }
            catch (Exception ex)
            {
                log.Error("fightlabdropitemlist", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            //return result.ToString(false);
            return csFunction.CreateCompressXml(context, result, "fightlabdropitemlist_out", false);
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