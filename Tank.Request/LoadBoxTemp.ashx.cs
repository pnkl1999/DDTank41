using Bussiness;
using Road.Flash;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for LoadBoxTemp
    /// </summary>
    public class LoadBoxTemp : IHttpHandler
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
                    ItemBoxInfo[] itemBox = db.GetItemBoxInfos();
                    foreach (ItemBoxInfo s in itemBox)
                    {
                        result.Add(FlashUtils.CreateItemBoxInfo(s));
                    }
                    value = true;
                    message = "Success!";
                }
            }
            catch
            { }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            return csFunction.CreateCompressXml(context, result, "LoadBoxTemp", true);
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