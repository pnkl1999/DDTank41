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

namespace Tank.Request
{
    /// <summary>
    /// Summary description for shopcheapitemlist
    /// </summary>
    public class shopcheapitemlist : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";

            XElement result = new XElement("Result");
            try
            {
                using (ProduceBussiness db = new ProduceBussiness())
                {
                    ShopItemInfo[] shop = db.GetALllShop();
                    foreach (ShopItemInfo s in shop)
                    {
                        if(s.IsCheap && s.EndDate > DateTime.Now && s.Label == 4)
                            result.Add(FlashUtils.CreateShopCheapItems(s));
                    }
                    value = true;
                    message = "Success!";
                }
            }
            catch
            { }

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