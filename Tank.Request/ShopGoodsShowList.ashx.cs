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
    /// Summary description for ShopGoodsShowList
    /// </summary>
    public class ShopGoodsShowList : IHttpHandler
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
                    XElement Store = new XElement("Store");
                    ShopGoodsShowListInfo[] shop = db.GetAllShopGoodsShowList();
                    foreach (ShopGoodsShowListInfo s in shop)
                    {
                        Store.Add(FlashUtils.CreateShopShowInfo(s));
                    }
                    result.Add(Store);
                    value = true;
                    message = "Success!";
                }
            }
            catch
            { }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            return csFunction.CreateCompressXml(context, result, "ShopGoodsShowList", true);
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