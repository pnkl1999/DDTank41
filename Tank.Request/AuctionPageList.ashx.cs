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
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class AuctionPageList : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";
            int total = 0;
            XElement result = new XElement("Result");

            try
            {
                int page = int.Parse(context.Request["page"]);
                string name = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["name"]));
                int type = int.Parse(context.Request["type"]);
                int pay = int.Parse(context.Request["pay"]);
                int userID = int.Parse(context.Request["userID"]);
                int buyID = int.Parse(context.Request["buyID"]);
                int order = int.Parse(context.Request["order"]);
                bool sort = bool.Parse(context.Request["sort"]);
                string AuctionIDs = csFunction.ConvertSql(HttpUtility.UrlDecode(context.Request["Auctions"]));
                AuctionIDs = string.IsNullOrEmpty(AuctionIDs) ? "0" : AuctionIDs;
                int size = 50;//int.Parse(context.Request["size"]);

                using (PlayerBussiness db = new PlayerBussiness())
                {

                    AuctionInfo[] infos = db.GetAuctionPage(page, name, type, pay, ref total, userID, buyID, order, sort, size, AuctionIDs);
                    foreach (AuctionInfo info in infos)
                    {
                        XElement temp = FlashUtils.CreateAuctionInfo(info);
                        using (PlayerBussiness pb = new PlayerBussiness())
                        {
                            ItemInfo item = pb.GetUserItemSingle(info.ItemID);
                            if (item != null)
                            {
                                temp.Add(Road.Flash.FlashUtils.CreateGoodsInfo(item));
                            }
                            result.Add(temp);
                        }
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("AuctionPageList", ex);
            }

            result.Add(new XAttribute("total", total));
            result.Add(new XAttribute("value", value)); 
            result.Add(new XAttribute("message", message));

            context.Response.ContentType = "text/plain";
            context.Response.Write(result.ToString(false));
            //context.Response.BinaryWrite(StaticFunction.Compress(result.ToString()));
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
