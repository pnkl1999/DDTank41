using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Collections.Specialized;
using System.Collections.Generic;
using SqlDataProvider.Data;
using Bussiness;
using Road.Flash;
using System.IO;

namespace Tank.Request
{
    //http://192.168.0.4:828/TemplateAlllist.ashx
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class TemplateAllList : IHttpHandler
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
                    XElement template = new XElement("ItemTemplate");
                    ItemTemplateInfo[] items = db.GetAllGoods();
                    foreach (ItemTemplateInfo g in items)
                    {
                        template.Add(FlashUtils.CreateItemInfo(g));
                    }
                    result.Add(template);                    
                    value = true;
                    message = "Success!";
                }
            }
            catch
            { }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            //csFunction.CreateCompressXml(context, result, "TemplateAlllist1", false);
            return csFunction.CreateCompressXml(context, result, "TemplateAlllist", true);

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
